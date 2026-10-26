#!/usr/bin/env python3
"""Convert an image to a Chafa logo."""

import argparse
import subprocess
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=("braille", "block"))
    parser.add_argument("input", type=Path)
    parser.add_argument("output", help="Output path, or - to print to the terminal")
    args = parser.parse_args()

    command = [
        "chafa",
        "--format",
        "symbols",
        "--symbols",
        args.mode,
        "--colors",
        "none" if args.mode == "braille" else "full",
        "--size",
        "48x24",
        "--polite",
        "on",
        str(args.input),
    ]
    if args.output == "-":
        subprocess.run(command, check=True)
    else:
        with Path(args.output).open("xb") as output:
            subprocess.run(command, stdout=output, check=True)


if __name__ == "__main__":
    main()
