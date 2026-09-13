#!/usr/bin/env python3
"""List extension directories grouped by the name before the first -digit."""

import argparse
import re
import sys
from collections import defaultdict
from pathlib import Path

COLOR = "\033[36m"  # cyan
RESET = "\033[0m"


def extension_name(directory_name: str) -> str:
    match = re.match(r"^(.+?)-\d", directory_name)
    return match[1] if match else directory_name


def find_duplicates(extensions_path: Path) -> list[list[str]]:
    groups: dict[str, list[str]] = defaultdict(list)
    for path in extensions_path.iterdir():
        if path.name.startswith(".") or not path.is_dir():
            continue
        key = extension_name(path.name).casefold()
        groups[key].append(path.name)
    return [
        sorted(groups[key], key=str.casefold)
        for key in sorted(groups)
        if len(groups[key]) > 1
    ]


def main() -> int:
    parser = argparse.ArgumentParser(
        description="List duplicate VS Code extension directories without modifying them.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "extensions_path",
        nargs="?",
        default="~/.vscode/extensions",
        help="extensions directory",
    )
    args = parser.parse_args()
    try:
        groups = find_duplicates(Path(args.extensions_path).expanduser())
    except OSError as error:
        print(f"{parser.prog}: {error}", file=sys.stderr)
        return 1

    for names in groups:
        heading = f"[{len(names)}] {extension_name(names[0])}"
        if sys.stdout.isatty():
            heading = f"{COLOR}{heading}{RESET}"
        print(heading)
        for name in names:
            print(f"  - {name}")
        print()
    return 0


if __name__ == "__main__":
    sys.exit(main())
