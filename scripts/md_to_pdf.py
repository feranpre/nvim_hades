#!/usr/bin/env python3
"""
Exporta documentos Markdown, Quarto y R Markdown a PDF o HTML con pandoc,
usando las plantillas de ./templates/hades.

Uso:
    md_to_pdf.py <entrada> [salida] [-t pdf|html] [--open]

    md_to_pdf.py notas.md                 -> notas.pdf
    md_to_pdf.py notas.md -t html         -> notas.html
    md_to_pdf.py informe.qmd salida.pdf   -> salida.pdf
    md_to_pdf.py informe.Rmd -thtml       -> informe.html

Formatos de entrada:
    .md / .markdown   se convierten directamente con pandoc.
    .qmd / .Rmd       se renderizan con quarto (ejecuta el código R/Python,
                      resuelve referencias cruzadas y callouts) inyectando
                      las mismas plantillas (templates/hades/quarto.yaml).
                      Si no hay quarto, un .Rmd se ejecuta con rmarkdown y
                      el markdown resultante se convierte con pandoc.
    .R                script con comentarios #' (knitr::spin): igual que un
                      .Rmd (los #' son el texto, el resto el código).

Dependencias:
    - pandoc
    - PDF: xelatex (o lualatex) con los paquetes de template.tex
      (Arch: texlive-basic texlive-latexextra texlive-fontsextra
       texlive-langspanish; ver templates/hades/README.md)
    - .qmd/.Rmd: quarto, o R con el paquete rmarkdown para .Rmd
    - opcional: mermaid-filter (npm install -g mermaid-filter)

La carpeta de plantillas se puede cambiar con la variable de entorno
HADES_PANDOC_TEMPLATES.
"""

import argparse
import json
import os
import re
import shutil
import signal
import subprocess
import sys
import tempfile
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
TEMPLATES_DIR = Path(
    os.environ.get("HADES_PANDOC_TEMPLATES", SCRIPT_DIR / "templates" / "hades")
).expanduser()

FORMATS = ("pdf", "html")
MARKDOWN_EXT = {".md", ".markdown"}
QUARTO_EXT = {".qmd"}
# .R con comentarios #' (knitr::spin): quarto también los renderiza
RMARKDOWN_EXT = {".rmd", ".r"}
# template.tex usa fontspec/polyglossia: necesita xelatex o lualatex
PDF_ENGINES = ("xelatex", "lualatex")


class ExportError(Exception):
    pass


def log(msg):
    print(msg, file=sys.stderr, flush=True)


# Perfil de R que informa del progreso (bloque en curso, pasos de feR) con
# líneas "@@hades ..." por stderr; las lee config/utils/export.lua
PROGRESS_PROFILE = SCRIPT_DIR / "hades_progress.R"


def r_env():
    """Entorno para los procesos de R: carga hades_progress.R como perfil."""
    env = dict(os.environ)
    if PROGRESS_PROFILE.is_file() and os.environ.get("HADES_PROGRESS", "1") != "0":
        # hades_progress.R carga después el perfil que habría usado R
        env["HADES_R_PROFILE_USER"] = os.environ.get("R_PROFILE_USER", "")
        env["R_PROFILE_USER"] = str(PROGRESS_PROFILE)
    return env


def phase(name):
    """Fase de la exportación, para la ventana de progreso de Neovim."""
    log("@@hades phase " + name)


def run(cmd, cwd, env=None):
    log("$ " + " ".join(str(c) for c in cmd))
    # stdout del proceso hijo a stderr: stdout queda solo para la ruta final
    result = subprocess.run([str(c) for c in cmd], cwd=cwd, stdout=sys.stderr, env=env)
    if result.returncode != 0:
        raise ExportError(f"'{cmd[0]}' terminó con código {result.returncode}")


def front_matter(path):
    """Devuelve el bloque YAML inicial (sin los ---) o None. En un .R el YAML
    va en comentarios #' (knitr::spin) y se devuelve sin ese prefijo."""
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    if path.suffix.lower() == ".r":
        lines = [re.sub(r"^#' ?", "", l) for l in lines if l.startswith("#'")]
    if not lines or lines[0].strip() != "---":
        return None
    for i, line in enumerate(lines[1:], start=1):
        if line.strip() in ("---", "..."):
            return "\n".join(lines[1:i])
    return None


TRUE_VALUES = ("true", "yes", "on")


def toc_options(yaml_text):
    """
    Índice y numeración del YAML, tanto al estilo quarto (toc, toc-depth,
    number-sections, arriba del todo) como al de rmarkdown (dentro de
    output: html_document: toc, toc_depth, number_sections), que quarto y
    pandoc ignoran. Devuelve {"toc": bool, "toc-depth": int,
    "number-sections": bool} solo con lo que aparezca.
    """
    opts = {}
    if not yaml_text:
        return opts
    for line in yaml_text.splitlines():
        m = re.match(r"^\s*(toc|toc[-_]depth|number[-_]sections)\s*:\s*([^#]+?)\s*(#.*)?$", line)
        if not m:
            continue
        key = m.group(1).replace("_", "-")
        value = m.group(2).strip().strip("\"'").lower()
        if key == "toc-depth":
            if value.isdigit():
                opts[key] = int(value)
        else:
            opts[key] = value in TRUE_VALUES
    return opts


def has_title(yaml_text):
    if not yaml_text:
        return False
    return any(line.startswith(("title:", "pagetitle:")) for line in yaml_text.splitlines())


def modern_citeproc(pandoc_cmd):
    """
    True si esta versión de pandoc escribe las citas en LaTeX con
    \\citeproc / \\bibitem (pandoc >= 3.1.8). template.tex define las macros
    de uno u otro formato según la variable csl-modern.
    """
    probe = (
        "---\nreferences:\n- id: x\n  type: book\n  title: T\n"
        "  author: [{family: A}]\n  issued: {date-parts: [[2000]]}\n"
        "link-citations: true\n---\n[@x]\n"
    )
    try:
        out = subprocess.run(
            pandoc_cmd + ["--from", "markdown", "--to", "latex", "--citeproc"],
            input=probe,
            capture_output=True,
            text=True,
            timeout=60,
        ).stdout
    except (OSError, subprocess.SubprocessError):
        return True
    return "\\bibitem" in out or "\\citeproc{" in out


def pdf_engine():
    for engine in PDF_ENGINES:
        if shutil.which(engine):
            return engine
    raise ExportError("No se encuentra xelatex ni lualatex")


# ---------------------------------------------------------------------------
# .qmd / .Rmd
# ---------------------------------------------------------------------------


def quarto_metadata(tmp, workdir, extra=None):
    """quarto.yaml con ${.} y ${rel} sustituidos por la carpeta de plantillas,
    más las opciones de `extra` (p. ej. el índice de una cabecera rmarkdown)."""
    template = TEMPLATES_DIR / "quarto.yaml"
    if not template.is_file():
        raise ExportError(f"No se encuentra la plantilla {template}")
    text = template.read_text(encoding="utf-8")
    text = text.replace("${rel}", os.path.relpath(TEMPLATES_DIR, workdir))
    text = text.replace("${.}", str(TEMPLATES_DIR))
    for key, value in (extra or {}).items():
        if isinstance(value, bool):
            value = "true" if value else "false"
        text += f"\n{key}: {value}\n"
    meta = Path(tmp) / "quarto-metadata.yaml"
    meta.write_text(text, encoding="utf-8")
    return meta


# Valores de `date` que quarto sabe interpretar como fecha
DATE_RE = re.compile(
    r"^(\d{4}-\d{1,2}(-\d{1,2})?([ T].*)?|\d{1,2}/\d{1,2}/\d{2,4}|today|now|last-modified)$"
)


def literal_date_copy(input_file):
    """
    Quarto intenta convertir `date` en una fecha y, si es un texto como
    "Curso 2025-2026", escribe "Invalid Date". En ese caso se crea una copia
    temporal del documento (en la misma carpeta, para que las rutas relativas
    sigan funcionando) con ese campo renombrado a `date-text`, que las
    plantillas muestran tal cual. Devuelve (copia, texto) o (None, None).
    """
    text = input_file.read_text(encoding="utf-8")
    lines = text.splitlines(keepends=True)
    # En un .R el YAML va en comentarios #' (knitr::spin)
    prefix = "#' " if input_file.suffix.lower() == ".r" else ""

    def strip(line):
        return line[len(prefix):] if prefix and line.startswith(prefix) else line

    if not lines or strip(lines[0]).strip() not in ("---", "#'---"):
        return None, None

    for i, line in enumerate(lines[1:], start=1):
        if strip(line).strip() in ("---", "..."):
            return None, None
        m = re.match(r"^date:\s*(.+?)\s*$", strip(line))
        if m:
            value = m.group(1).strip().strip("\"'")
            if not value or DATE_RE.match(value):
                return None, None
            lines[i] = prefix + "date-text: " + m.group(1).strip() + "\n"
            # sin punto inicial: TeX no escribe archivos ocultos
            copy = input_file.with_name(f"{input_file.stem}-hades-export{input_file.suffix}")
            copy.write_text("".join(lines), encoding="utf-8")
            return copy, value
    return None, None


def quarto_render(input_file, output_file, output_format):
    """Renderiza con quarto aplicando las plantillas de Hades."""
    workdir = input_file.parent
    source, date_text = literal_date_copy(input_file)
    cleanup = [source] if source else []
    source = source or input_file
    # Intermedios de quarto que quedan si se interrumpe (o falla) la
    # exportación; solo se borran si no existían antes
    leftovers = [workdir / f"{source.stem}{ext}" for ext in ("_files", ".tex", ".log", ".rmarkdown", ".knit.md")]
    cleanup += [p for p in leftovers if not p.exists()]

    try:
        with tempfile.TemporaryDirectory(prefix="hades-export-") as tmp:
            cmd = [
                "quarto",
                "render",
                source.name,
                "--to",
                output_format,
                "--output",
                output_file.name,
                "--metadata-file",
                quarto_metadata(tmp, workdir, toc_options(front_matter(input_file))),
                # para encontrar apa.csl / referencias.bib de la plantilla
                "--resource-path",
                os.pathsep.join([str(workdir), str(TEMPLATES_DIR)]),
            ]
            if output_format == "pdf" and modern_citeproc(["quarto", "pandoc"]):
                cmd += ["-M", "csl-modern:true"]
            if output_format == "html" and date_text:
                # el bloque de título de quarto no conoce date-text
                css = Path(tmp) / "date-text.html"
                css.write_text(
                    "<style>#title-block-header .quarto-title-meta::after{"
                    f"content:{json.dumps('·   ' + date_text, ensure_ascii=False)};"
                    "white-space:pre;color:#6b6577}</style>\n",
                    encoding="utf-8",
                )
                cmd += ["--include-in-header", css]
            # Si no hay LaTeX en el PATH, quarto puede usar su propio TinyTeX
            if output_format == "pdf" and any(shutil.which(e) for e in PDF_ENGINES):
                cmd += ["--pdf-engine", pdf_engine()]
            phase("render")
            run(cmd, cwd=workdir, env=r_env())
    finally:
        remove(cleanup)

    # quarto solo acepta un nombre de archivo en --output
    rendered = workdir / output_file.name
    if rendered != output_file:
        output_file.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(rendered), str(output_file))


def knit_rmd(input_file):
    """
    Sin quarto: ejecuta un .Rmd con rmarkdown y devuelve
    (markdown_intermedio, rutas_a_borrar). El markdown se genera junto al
    original para que las rutas relativas (datos, figuras) sigan funcionando.
    """
    stem = input_file.stem
    tmp_name = f".{stem}.hades-export.md"
    tmp_md = input_file.parent / tmp_name

    # Carpetas de figuras de knitr: solo se borran si no existían antes
    figure_dirs = [
        input_file.parent / f"{stem}_files",
        input_file.parent / f".{stem}.hades-export_files",
    ]
    cleanup = [tmp_md] + [d for d in figure_dirs if not d.exists()]

    r_code = (
        "rmarkdown::render("
        f"{r_string(input_file.name)}, "
        "output_format = rmarkdown::md_document("
        'variant = "markdown", preserve_yaml = TRUE), '
        f"output_file = {r_string(tmp_name)}, quiet = TRUE)"
    )
    try:
        phase("render")
        run(["Rscript", "-e", r_code], cwd=input_file.parent, env=r_env())
    except ExportError:
        remove(cleanup)
        raise

    if not tmp_md.exists():
        remove(cleanup)
        raise ExportError(f"No se generó el markdown intermedio {tmp_md}")

    return tmp_md, cleanup


def remove(paths):
    for path in paths:
        if path.is_dir():
            shutil.rmtree(path, ignore_errors=True)
        elif path.exists():
            path.unlink()


def r_string(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


# ---------------------------------------------------------------------------
# Conversión
# ---------------------------------------------------------------------------


def convert(input_file, output_file=None, output_format="pdf"):
    input_file = Path(input_file).expanduser().resolve()
    if not input_file.is_file():
        raise ExportError(f"No existe el archivo {input_file}")

    # LaTeX deja missfont.log junto al documento cuando busca una fuente que
    # no está instalada (template.tex prueba Fira Sans/Lato antes de usar
    # alternativas): se borra si no existía antes.
    missfont = input_file.parent / "missfont.log"
    missfont_existed = missfont.exists()
    try:
        return _convert(input_file, output_file, output_format)
    finally:
        if not missfont_existed and missfont.exists():
            missfont.unlink()


def _convert(input_file, output_file, output_format):
    if output_format not in FORMATS:
        raise ExportError(f"Formato no soportado: {output_format} (usa pdf o html)")

    if not shutil.which("pandoc"):
        raise ExportError("No se encuentra pandoc en el PATH")

    defaults = TEMPLATES_DIR / f"{output_format}.yaml"
    if not defaults.is_file():
        raise ExportError(f"No se encuentra la plantilla {defaults}")

    if output_file:
        output_file = Path(output_file).expanduser().resolve()
    else:
        output_file = input_file.with_suffix("." + output_format)

    workdir = input_file.parent
    ext = input_file.suffix.lower()
    source_yaml = front_matter(input_file)
    cleanup = []

    knit = False
    if ext in QUARTO_EXT | RMARKDOWN_EXT:
        if shutil.which("quarto"):
            quarto_render(input_file, output_file, output_format)
            return output_file
        knit = ext in RMARKDOWN_EXT and shutil.which("Rscript") is not None
        if knit:
            log("AVISO: no se encuentra quarto; se ejecuta el .Rmd con rmarkdown.")
        else:
            log("AVISO: no se encuentra quarto; se exporta sin ejecutar el código.")

    try:
        source = input_file
        if knit:
            source, cleanup = knit_rmd(input_file)

        with tempfile.TemporaryDirectory(prefix="hades-export-") as tmp:
            cmd = [
                "pandoc",
                source,
                "--from",
                "markdown",
                "--defaults",
                defaults,
                "--resource-path",
                os.pathsep.join([str(workdir), ".", str(TEMPLATES_DIR)]),
                "--output",
                output_file,
            ]

            # El YAML original (título, autor, toc...) se pasa aparte por si
            # el markdown intermedio no lo conserva.
            if source != input_file and source_yaml:
                meta = Path(tmp) / "metadata.yaml"
                meta.write_text(source_yaml + "\n", encoding="utf-8")
                cmd += ["--metadata-file", meta]

            # Opciones que pandoc no lee del YAML del documento (sí quarto),
            # también si vienen en una cabecera de rmarkdown (output: ...)
            toc = toc_options(source_yaml)
            if toc.get("number-sections"):
                cmd += ["--number-sections"]
            if toc.get("toc"):
                cmd += ["--toc"]
            if "toc-depth" in toc:
                cmd += ["--toc-depth", str(toc["toc-depth"])]

            if output_format == "pdf":
                # --verbose: "[makePDF] Run #N" en cada pasada de LaTeX (progreso)
                cmd += ["--pdf-engine", pdf_engine(), "--verbose"]
                if modern_citeproc(["pandoc"]):
                    cmd += ["--variable", "csl-modern=true"]
            elif not has_title(source_yaml):
                cmd += ["--metadata", f"pagetitle={input_file.stem}"]

            if shutil.which("mermaid-filter"):
                cmd += ["--filter", "mermaid-filter"]

            phase("pandoc")
            run(cmd, cwd=workdir)
    finally:
        remove(cleanup)
        # mermaid-filter deja este log en el directorio de trabajo
        mermaid_log = workdir / "mermaid-filter.err"
        if mermaid_log.exists() and mermaid_log.stat().st_size == 0:
            mermaid_log.unlink()

    return output_file


def open_file(path):
    opener = "open" if sys.platform == "darwin" else "xdg-open"
    if shutil.which(opener):
        subprocess.Popen(
            [opener, str(path)],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )


def parse_args(argv):
    parser = argparse.ArgumentParser(
        description="Exporta .md/.qmd/.Rmd a PDF o HTML con las plantillas de Hades."
    )
    parser.add_argument("input", help="archivo de entrada (.md, .qmd, .Rmd)")
    parser.add_argument("output", nargs="?", help="archivo de salida (opcional)")
    parser.add_argument(
        "-t",
        "--to",
        choices=FORMATS,
        default=None,
        help="formato de salida (por defecto, el de la extensión de salida o pdf)",
    )
    parser.add_argument("--open", action="store_true", help="abrir el resultado al terminar")
    args = parser.parse_args(argv)

    if args.to is None:
        suffix = Path(args.output).suffix.lower().lstrip(".") if args.output else ""
        args.to = suffix if suffix in FORMATS else "pdf"

    return args


def main(argv=None):
    # Cancelar desde Neovim envía SIGTERM: convertirlo en una excepción para
    # que se ejecuten los finally (limpieza de intermedios)
    signal.signal(signal.SIGTERM, lambda *_: (_ for _ in ()).throw(KeyboardInterrupt()))
    args = parse_args(argv)
    try:
        output = convert(args.input, args.output, args.to)
    except ExportError as e:
        log(f"ERROR: {e}")
        return 1
    except KeyboardInterrupt:
        log("Exportación cancelada")
        return 130

    print(output)
    log(f"Conversión correcta: {output}")
    if args.open:
        open_file(output)
    return 0


if __name__ == "__main__":
    sys.exit(main())
