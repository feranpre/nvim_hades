#!/usr/bin/env python3
"""
utamed_pdf.py
=============
Convierte un archivo Markdown de la asignatura "Análisis de Datos en
Psicología I" a PDF usando pandoc + XeLaTeX con la plantilla
"UTAMED-style" (template.tex).

UBICACIÓN DE ESTE KIT
----------------------
Este script vive en la configuración de Neovim:
    ~/.config/nvim/scripts/utamed_pdf.py
y el resto de archivos de soporte (template.tex, cajas.lua, apa.csl,
referencias.bib) junto a él, en:
    ~/.config/nvim/scripts/templates/utamed/

Puedes cambiar esa segunda carpeta sin tocar el código exportando la
variable de entorno UTAMED_PSICOLOGIA_DIR, o con --support-dir en cada llamada.

Pensado para Arch Linux. Requiere:
    sudo pacman -S pandoc texlive-basic texlive-latexextra texlive-fontsextra \
                   texlive-science texlive-langspanish

    # Tipografías recomendadas (idénticas al estilo de las unidades):
    sudo pacman -S ttf-fira-sans ttf-fira-mono ttf-lato
    # Si no están en los repos oficiales, instálalas desde el AUR, p. ej.:
    #   paru -S ttf-fira-sans ttf-lato
    # El script funciona igualmente sin ellas: usará una alternativa
    # (Carlito / Liberation Sans) definida en template.tex.

Desde Neovim se lanza con <localleader>ku en un buffer markdown. Desde la
terminal:
    python3 ~/.config/nvim/scripts/utamed_pdf.py unidad_1.md

USO BÁSICO
----------
    utamed_pdf.py unidad_1.md

    # Indicando explícitamente la carpeta de salida:
    utamed_pdf.py unidad_1.md -o salida/unidad_1.pdf

    # Procesando varios archivos de una vez:
    utamed_pdf.py unidad_1.md unidad_2.md unidad_3.md

    # Sin bibliografía (aunque el .md tenga citas @clave, se ignoran):
    utamed_pdf.py unidad_1.md --sin-bibliografia

    # Modo "vigilancia": recompila automáticamente cada vez que guardas el .md
    utamed_pdf.py unidad_1.md --watch

    # Si moviste la carpeta de soporte a otro sitio:
    utamed_pdf.py unidad_1.md --support-dir /ruta/a/utamed_psicologia

EL ARCHIVO MARKDOWN
--------------------
Debe incluir una cabecera YAML con, como mínimo:

    ---
    title: "Título de la unidad"
    unidad-numero: "1"
    unidad-titulo: "Título de la unidad"
    bibliography: referencias.bib
    csl: apa.csl
    reference-section-title: "Bibliografía"
    ---

Consulta ejemplo_unidad.md para un ejemplo completo (fórmulas LaTeX,
cajas de resumen/ejemplo/definición/nota, tablas y citas).
"""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent

# Carpeta con los archivos de soporte (template.tex, cajas.lua, apa.csl,
# referencias.bib). Por defecto templates/utamed junto a este script, salvo que
# se indique otra cosa con la variable de entorno UTAMED_PSICOLOGIA_DIR o con
# --support-dir. Se resuelve de verdad en main() para poder sobreescribirla
# desde la línea de comandos.
DEFAULT_SUPPORT_DIR = Path(
    os.environ.get("UTAMED_PSICOLOGIA_DIR", str(SCRIPT_DIR / "templates" / "utamed"))
)

REQUIRED_BINARIES = ["pandoc", "xelatex"]

# Se rellenan en main() una vez resuelta la carpeta de soporte real
# (por defecto DEFAULT_SUPPORT_DIR, o lo que indique --support-dir).
TEMPLATE: Path
CAJAS_LUA: Path
DEFAULT_CSL: Path


# ----------------------------------------------------------------------
# Comprobaciones del entorno
# ----------------------------------------------------------------------
def comprobar_binarios() -> None:
    faltantes = [b for b in REQUIRED_BINARIES if shutil.which(b) is None]
    if faltantes:
        print("✗ Faltan programas necesarios en el PATH:", ", ".join(faltantes))
        print()
        print("  Instálalos en Arch Linux con:")
        print("    sudo pacman -S pandoc texlive-basic texlive-latexextra \\")
        print("                   texlive-fontsextra texlive-science texlive-langspanish")
        sys.exit(1)


def comprobar_plantilla(support_dir: Path) -> None:
    faltan = [p for p in (TEMPLATE, CAJAS_LUA) if not p.exists()]
    if faltan:
        print("✗ Faltan archivos del kit de plantilla en:", support_dir)
        for p in faltan:
            print(f"   - {p}")
        print()
        print("  Coloca allí template.tex, cajas.lua, apa.csl y referencias.bib,")
        print("  o indica la carpeta correcta con --support-dir /ruta/a/utamed_psicologia")
        print("  (o exportando UTAMED_PSICOLOGIA_DIR).")
        sys.exit(1)


def comprobar_pandoc_version() -> None:
    """pandoc >= 2.11 integra citeproc de forma nativa (--citeproc)."""
    try:
        salida = subprocess.run(
            ["pandoc", "--version"], capture_output=True, text=True, check=True
        ).stdout
        primera_linea = salida.splitlines()[0]
        version = primera_linea.split()[-1]
        partes = [int(p) for p in version.split(".")[:2]]
        if partes < [2, 11]:
            print(f"⚠ Se detectó pandoc {version}. Se recomienda pandoc >= 2.11")
            print("  para citeproc integrado (sudo pacman -Syu pandoc).")
    except Exception:
        # No es crítico: si falla la detección, simplemente continuamos.
        pass


# ----------------------------------------------------------------------
# Construcción del comando pandoc
# ----------------------------------------------------------------------
def construir_comando(
    md_path: Path,
    pdf_path: Path,
    usar_bibliografia: bool,
    csl_path: Path,
    extra_pandoc_args: list[str],
) -> list[str]:
    cmd = [
        "pandoc",
        str(md_path),
        "-o", str(pdf_path),
        "--pdf-engine=xelatex",
        f"--template={TEMPLATE}",
        f"--lua-filter={CAJAS_LUA}",
        "--from=markdown+tex_math_dollars+fenced_divs+yaml_metadata_block",
        "--table-of-contents",
        "--number-sections",
        "--highlight-style=tango",
        "--standalone",
    ]

    if usar_bibliografia:
        cmd.append("--citeproc")
        # Si el .md no define ya "csl:" en su YAML, usamos el apa.csl del
        # propio kit como valor por defecto sin sobreescribir el YAML.
        cmd += ["--metadata", f"csl-default={csl_path}"]
        # csl y bibliography se leen preferentemente del YAML del propio
        # .md (recomendado); si no están definidos allí, se puede forzar
        # aquí con --csl / --bibliography (ver --csl / --bib más abajo).

    cmd += extra_pandoc_args
    return cmd


# ----------------------------------------------------------------------
# Conversión de un archivo
# ----------------------------------------------------------------------
def convertir(
    md_path: Path,
    salida: Path | None,
    usar_bibliografia: bool,
    csl_path: Path,
    bib_path: Path | None,
    extra_pandoc_args: list[str],
) -> bool:
    if not md_path.exists():
        print(f"✗ No existe el archivo: {md_path}")
        return False

    pdf_path = salida if salida else md_path.with_suffix(".pdf")
    pdf_path.parent.mkdir(parents=True, exist_ok=True)

    cmd = construir_comando(md_path, pdf_path, usar_bibliografia, csl_path, extra_pandoc_args)

    if bib_path is not None:
        cmd += ["--metadata", f"bibliography={bib_path}"]
    if usar_bibliografia:
        cmd += ["--metadata", f"csl={csl_path}"]

    print(f"→ Compilando {md_path.name}  →  {pdf_path.name}")
    entorno = dict(**os.environ)
    # Evita que kpathsea intente generar fuentes bitmap (mktextfm/METAFONT)
    # cuando fontspec comprueba si existe una fuente del sistema (p. ej.
    # "Lato" o "Carlito"). Sin esto, la comprobación es inofensiva pero muy
    # ruidosa y más lenta; con esto, falla en silencio y usa el siguiente
    # fallback definido en template.tex.
    entorno["MKTEXTFM"] = "0"
    entorno["MKTEXPK"] = "0"
    entorno["MKTEXMF"] = "0"
    resultado = subprocess.run(
        cmd, cwd=md_path.parent, capture_output=True, text=True, env=entorno
    )

    if resultado.returncode != 0:
        print(f"✗ Error al convertir {md_path.name}\n")
        # Pandoc/LaTeX vuelcan mucho ruido; mostramos las últimas líneas,
        # que suelen contener el mensaje de error relevante.
        salida_err = (resultado.stderr or resultado.stdout).strip().splitlines()
        for linea in salida_err[-40:]:
            print("   ", linea)
        return False

    print(f"✓ PDF generado: {pdf_path}")
    return True


# ----------------------------------------------------------------------
# Modo vigilancia (recompila al detectar cambios)
# ----------------------------------------------------------------------
def modo_vigilancia(md_path: Path, salida: Path | None, **kwargs) -> None:
    print(f"👀 Vigilando cambios en {md_path.name} (Ctrl+C para salir)...")
    ultima_mtime = 0.0
    try:
        while True:
            try:
                mtime = md_path.stat().st_mtime
            except FileNotFoundError:
                time.sleep(1)
                continue
            if mtime != ultima_mtime:
                ultima_mtime = mtime
                convertir(md_path, salida, **kwargs)
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nVigilancia detenida.")


# ----------------------------------------------------------------------
# CLI
# ----------------------------------------------------------------------
def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convierte Markdown de Análisis de Datos en Psicología I a PDF "
        "con el formato de las unidades (pandoc + XeLaTeX).",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument("archivos", nargs="+", type=Path, help="Archivo(s) .md a convertir")
    parser.add_argument(
        "-o", "--output", type=Path, default=None,
        help="Ruta del PDF de salida (solo válido con un único archivo de entrada)",
    )
    parser.add_argument(
        "--sin-bibliografia", action="store_true",
        help="Desactiva citeproc: no formatea citas ni bibliografía",
    )
    parser.add_argument(
        "--support-dir", type=Path, default=DEFAULT_SUPPORT_DIR,
        help="Carpeta con template.tex, cajas.lua, apa.csl y referencias.bib "
        f"(por defecto: {DEFAULT_SUPPORT_DIR})",
    )
    parser.add_argument(
        "--csl", type=Path, default=None,
        help="Archivo de estilo CSL a usar (por defecto: apa.csl dentro de --support-dir)",
    )
    parser.add_argument(
        "--bib", type=Path, default=None,
        help="Archivo .bib a usar si no se especifica 'bibliography:' en el YAML del .md",
    )
    parser.add_argument(
        "--watch", action="store_true",
        help="Recompila automáticamente cada vez que se guarda el archivo (solo 1 archivo)",
    )
    parser.add_argument(
        "pandoc_args", nargs=argparse.REMAINDER,
        help="Argumentos adicionales pasados directamente a pandoc tras '--'",
    )
    args = parser.parse_args()

    extra_pandoc_args = args.pandoc_args
    if extra_pandoc_args and extra_pandoc_args[0] == "--":
        extra_pandoc_args = extra_pandoc_args[1:]

    if args.output and len(args.archivos) > 1:
        print("✗ --output solo puede usarse con un único archivo de entrada.")
        sys.exit(1)
    if args.watch and len(args.archivos) > 1:
        print("✗ --watch solo puede usarse con un único archivo de entrada.")
        sys.exit(1)

    # Resuelve la carpeta de soporte (template.tex, cajas.lua, apa.csl,
    # referencias.bib) y fija las rutas globales usadas por el resto del
    # script.
    global TEMPLATE, CAJAS_LUA, DEFAULT_CSL
    support_dir = args.support_dir.expanduser().resolve()
    TEMPLATE = support_dir / "template.tex"
    CAJAS_LUA = support_dir / "cajas.lua"
    DEFAULT_CSL = support_dir / "apa.csl"
    csl_path = args.csl if args.csl is not None else DEFAULT_CSL

    comprobar_binarios()
    comprobar_plantilla(support_dir)
    comprobar_pandoc_version()

    kwargs = dict(
        usar_bibliografia=not args.sin_bibliografia,
        csl_path=csl_path,
        bib_path=args.bib,
        extra_pandoc_args=extra_pandoc_args,
    )

    if args.watch:
        modo_vigilancia(args.archivos[0], args.output, **kwargs)
        return

    exitos = 0
    for md_path in args.archivos:
        ok = convertir(md_path, args.output, **kwargs)
        exitos += int(ok)

    total = len(args.archivos)
    print(f"\n{exitos}/{total} archivo(s) convertido(s) correctamente.")
    if exitos != total:
        sys.exit(1)


if __name__ == "__main__":
    main()
