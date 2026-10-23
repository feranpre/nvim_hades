#!/usr/bin/env python3

# Dependencias:
#   npm install -g @mermaid-js/mermaid-cli
#   npm install -g mermaid-filter
#   pandoc >= 3.8 (usa --syntax-highlighting)

import subprocess
import sys
from pathlib import Path

# Plantillas junto al script: <config nvim>/scripts/templates/latex
TEMPLATES_DIR = Path(__file__).resolve().parent / "templates" / "latex"

# Parche para pandoc >= 3.8: las tablas sin caption usan \LTcaptype{none}
# y necesitan que exista el contador 'none'.
TABLE_FIX_TEX = r"""\makeatletter
\@ifundefined{c@none}{\newcounter{none}}{}
\makeatother
"""


def ensure_table_fix():
    fix_file = TEMPLATES_DIR / "pandoc38_table_fix.tex"
    if not fix_file.exists():
        fix_file.write_text(TABLE_FIX_TEX)
    return fix_file


def markdown_to_pdf(input_file, output_file=None):
    input_path = Path(input_file)

    if not input_path.exists():
        print(f"Error: El archivo {input_file} no existe.")
        sys.exit(1)

    output_path = (
        input_path.with_suffix(".pdf") if output_file is None else Path(output_file)
    )

    highlight_theme = TEMPLATES_DIR / "custom_tango.theme"
    default_yaml = TEMPLATES_DIR / "defaults.yaml"
    template = TEMPLATES_DIR / "eisvogel.latex"
    table_fix = ensure_table_fix()

    cmd = [
        "pandoc",
        str(input_path),
        "-o",
        str(output_path),
        "--from=markdown+yaml_metadata_block+raw_tex",
        "--pdf-engine=xelatex",
        "--variable",
        "mainfont=DejaVu Sans",
        "--variable",
        "mathfont=DejaVu Math TeX Gyre",
        "--variable",
        "monofont=Source Code Pro",
        "--variable",
        "fontsize=8pt",
        "--variable",
        "code-block-font-size=\\scriptsize",
        f"--defaults={default_yaml}",
        # Tras --defaults para sobreescribir 'template: eisvogel' (que se
        # buscaría en el directorio de datos de pandoc)
        f"--template={template}",
        f"--syntax-highlighting={highlight_theme}",
        f"--include-in-header={table_fix}",
        "--filter",
        "mermaid-filter",
    ]

    try:
        subprocess.run(cmd, check=True)
        print(f"PDF generado correctamente: {output_path}")
    except subprocess.CalledProcessError as e:
        print("Error al generar el PDF con Pandoc")
        print(e)
        sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: md_to_pdf.py <archivo_origen> [archivo_salida]")
        sys.exit(1)

    markdown_to_pdf(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else None)
