#!/usr/bin/env python3

"""
- mermaid-filter: sudo npm install mermaid-filter
"""

import os
import re
import subprocess
import sys


def remove_heading_tags(markdown_text):
    headings_pattern = re.compile(r"^(#{1,6}\s.*?)(\{.*?\})$", re.MULTILINE)
    processed_text = headings_pattern.sub(r"\1", markdown_text)
    return processed_text


def convert_md(input_file, output_file=None, output_format="pdf"):
    default_template = os.path.expanduser(
        "~/.config/my_scripts/pandoc_latex_templates/eisvogel.latex"
        # "~/.config/my_scripts/pandoc_latex_templates/caronte_template.tex"
        # "~/.config/my_scripts/pandoc_latex_templates/templates_cleese-assignment_v2.0/teacher_template.tex"
    )
    default_header = os.path.expanduser(
        "~/.config/my_scripts/pandoc_latex_templates/caronte_header.tex"
    )
    default_highlight = os.path.expanduser(
        "~/.config/my_scripts/pandoc_latex_templates/custom_tango.theme"
    )
    code_block_small_font = os.path.expanduser(
        "~/.config/my_scripts/pandoc_latex_templates/caronte_small_code_block_font.tex"
    )
    default_yaml = os.path.expanduser(
        "~/.config/my_scripts/pandoc_latex_templates/defaults.yaml"
    )
    if not output_file:
        base_name = os.path.splitext(input_file)[0]
        output_file = f"{base_name}.{output_format}"

    with open(input_file, "r", encoding="utf-8") as f:
        markdown_text = f.read()

    # Remove tags from headings
    markdown_text = remove_heading_tags(markdown_text)

    temp_input_file = "/tmp/temp_markdown.md"
    with open(temp_input_file, "w", encoding="utf-8") as f:
        f.write(markdown_text)

    command = [
        "pandoc",
        temp_input_file,
        "-o",
        output_file,
        "-t",
        output_format,
        "--template",
        default_template,
        # "--include-in-header=" + default_header, # not used
        "--highlight-style=" + default_highlight,
        # "--include-in-header=" + code_block_small_font, # not used
        "--filter=mermaid-filter",
        # "--lua-filter=admonition.lua",
        "--filter=pandoc-latex-environment",
        "--defaults=" + default_yaml,
        "--pdf-engine=xelatex",
    ]
    print(command)

    try:
        subprocess.run(command, check=True)
        print(f"Conversion successful: {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error during conversion: {e}")

    os.remove(temp_input_file)


def main():
    if len(sys.argv) < 2:
        print("Usage: convert_md.py <input_file> [output_file] -t [pdf|html]")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = None
    output_format = "pdf"

    if len(sys.argv) > 2:
        if sys.argv[2].startswith("-t"):
            output_format = sys.argv[2][2:]
        else:
            output_file = sys.argv[2]
            if len(sys.argv) > 3 and sys.argv[3].startswith("-t"):
                output_format = sys.argv[3][2:]

    convert_md(input_file, output_file, output_format)


if __name__ == "__main__":
    main()
