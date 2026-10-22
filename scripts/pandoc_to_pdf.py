#!/usr/bin/env python3
import subprocess
import os
import sys
import re
import yaml


def extract_yaml_metadata(file_path):
    """
    Extract YAML metadata from a Markdown file.

    Args:
        file_path (str): Path to the Markdown file.

    Returns:
        dict: A dictionary of YAML metadata.
    """
    try:
        with open(file_path, "r", encoding="utf-8") as file:
            content = file.read()
        yaml_match = re.match(r"---\n(.*?)\n---", content, re.DOTALL)
        if yaml_match:
            yaml_content = yaml_match.group(1)
            return yaml.safe_load(yaml_content)
    except Exception as e:
        print(f"Error extracting YAML metadata: {e}")
    return {}


def convert_markdown_to_pdf(markdown_file, output_file=None):
    """
    Convert a Markdown file to PDF using Pandoc, respecting YAML header options.

    Args:
        markdown_file (str): Path to the input Markdown file.
        output_file (str, optional): Path to the output PDF file. If not provided,
                                     the PDF will be saved with the same name as
                                     the Markdown file, but with a .pdf extension.

    Returns:
        None
    """
    # Check if the input file exists
    if not os.path.exists(markdown_file):
        print(f"Error: File '{markdown_file}' not found.")
        sys.exit(1)

    # Set the default output file name if not provided
    if output_file is None:
        output_file = os.path.splitext(markdown_file)[0] + ".pdf"

    # Path to the default Pandoc LaTeX template
    # Plantilla junto al script: <config nvim>/scripts/templates/latex
    default_template = os.path.join(
        os.path.dirname(os.path.realpath(__file__)), "templates", "latex", "eisvogel.latex"
    )

    if not os.path.exists(default_template):
        print(f"Error: Default template '{default_template}' not found.")
        sys.exit(1)

    # Extract YAML metadata to check for number-offset
    metadata = extract_yaml_metadata(markdown_file)
    number_offset = metadata.get("number-offset", None)

    # Build the Pandoc command
    pandoc_command = [
        "pandoc",
        markdown_file,
        "--from",
        "markdown",
        "--to",
        "pdf",
        # "--wrap=preserve",
        "--output",
        output_file,
        # "--template", default_template
        # "-V classoption=article"
    ]

    # Add number-offset if specified in the YAML metadata
    if number_offset:
        if isinstance(number_offset, list) and all(
            isinstance(x, int) for x in number_offset
        ):
            pandoc_command.extend(["--number-offset"] + [str(x) for x in number_offset])
        else:
            print(
                f"Error: Invalid number-offset value '{number_offset}' in YAML metadata. It must be a list of integers."
            )
            sys.exit(1)

    try:
        # Run the Pandoc command
        subprocess.run(pandoc_command, check=True)
        print(f"Successfully converted '{markdown_file}' to '{output_file}'.")
    except subprocess.CalledProcessError as e:
        print(f"Error: Pandoc command failed with exit code {e.returncode}.")
        print(e)
        sys.exit(1)
    except FileNotFoundError:
        print("Error: Pandoc is not installed or not found in PATH.")
        sys.exit(1)


if __name__ == "__main__":
    import argparse

    # Set up command-line argument parsing
    parser = argparse.ArgumentParser(
        description="Convert Markdown to PDF using Pandoc and the eisvogel template."
    )
    parser.add_argument("markdown_file", help="Path to the input Markdown file.")
    parser.add_argument(
        "--output", "-o", help="Path to the output PDF file (optional)."
    )

    args = parser.parse_args()

    # Call the conversion function
    convert_markdown_to_pdf(args.markdown_file, args.output)
