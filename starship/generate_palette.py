"""Generate Catppuccin Mocha prompt colors by varying base lightness."""

import argparse
import colorsys
import sys
from collections.abc import Sequence

MODULES = ("os", "dir", "git", "tech", "env", "cmd", "time")
BASE_HUE = 240
BASE_SATURATION = 21
PaletteRow = tuple[str, float, tuple[int, int, int]]


def rgb_for_lightness(
    lightness: float, hue: float, saturation: float
) -> tuple[int, int, int]:
    """Convert HLS percentages and hue degrees to 8-bit RGB."""
    red, green, blue = colorsys.hls_to_rgb(hue / 360, lightness / 100, saturation / 100)
    return round(red * 255), round(green * 255), round(blue * 255)


def palette(
    start: float, end: float, hue: float, saturation: float, modules: Sequence[str]
) -> list[PaletteRow]:
    """Return evenly spaced lightness levels and their RGB colors."""
    step = (start - end) / (len(modules) - 1) if len(modules) > 1 else 0
    rows = []
    for index, name in enumerate(modules):
        lightness = start - index * step
        rows.append((name, lightness, rgb_for_lightness(lightness, hue, saturation)))
    return rows


class Args(argparse.Namespace):
    start: float
    end: float
    toml: bool
    suffix: str
    modules: Sequence[str]
    hue: float
    saturation: float


def parse_args() -> Args:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "start",
        type=float,
        nargs="?",
        default=30,
        help="first lightness percentage",
    )
    parser.add_argument(
        "end",
        type=float,
        nargs="?",
        default=18,
        help="last lightness percentage",
    )
    parser.add_argument(
        "--toml",
        action="store_true",
        help="print pasteable Starship palette entries",
    )
    parser.add_argument(
        "--suffix",
        choices=("bg", "fg"),
        default="bg",
        help="palette key suffix",
    )
    parser.add_argument(
        "--modules",
        nargs="+",
        default=MODULES,
        metavar="NAME",
        help="module names in palette order",
    )
    parser.add_argument(
        "--hue",
        type=float,
        default=BASE_HUE,
        help="base hue in degrees",
    )
    parser.add_argument(
        "--saturation",
        type=float,
        default=BASE_SATURATION,
        help="base saturation percentage",
    )
    args = parser.parse_args(namespace=Args())
    if not 0 <= args.end <= args.start <= 100:
        parser.error("lightness must satisfy 0 <= end <= start <= 100")
    if not 0 <= args.hue <= 360:
        parser.error("hue must satisfy 0 <= hue <= 360")
    if not 0 <= args.saturation <= 100:
        parser.error("saturation must satisfy 0 <= saturation <= 100")
    if any(not name for name in args.modules):
        parser.error("module names must not be empty")
    return args


def print_toml(rows: list[PaletteRow], suffix: str, name_width: int) -> None:
    for name, _, rgb in rows:
        color_name = f"{name}_{suffix}"
        print(f'{color_name:<{name_width}} = "#{rgb[0]:02x}{rgb[1]:02x}{rgb[2]:02x}"')


def print_table(rows: list[PaletteRow], suffix: str, name_width: int) -> None:
    show_preview = sys.stdout.isatty()
    lightness_width = len("lightness")
    hex_width = len("#ffffff")
    rgb_width = len("(255, 255, 255)")
    preview_width = len("preview")
    header = "  ".join(
        [
            f"{'color':<{name_width}}",
            f"{'lightness':>{lightness_width}}",
            f"{'hex':<{hex_width}}",
            f"{'rgb':<{rgb_width}}" if show_preview else "rgb",
            *(["preview"] if show_preview else []),
        ]
    )
    print(header)
    for name, lightness, rgb in rows:
        color_name = f"{name}_{suffix}"
        hex_color = f"#{rgb[0]:02x}{rgb[1]:02x}{rgb[2]:02x}"
        lightness_text = f"{lightness:.2f}%"
        rgb_text = f"{rgb!s:<{rgb_width}}" if show_preview else str(rgb)
        row = "  ".join(
            [
                f"{color_name:<{name_width}}",
                f"{lightness_text:>{lightness_width}}",
                f"{hex_color}",
                f"{rgb_text}",
                *(
                    [
                        f"\x1b[48;2;{rgb[0]};{rgb[1]};{rgb[2]}m{'':{preview_width}}\x1b[0m"
                    ]
                    if show_preview
                    else []
                ),
            ]
        )
        print(row)


def main() -> None:
    args = parse_args()
    rows = palette(args.start, args.end, args.hue, args.saturation, args.modules)
    name_width = max(len(name) for name in args.modules) + len(args.suffix) + 1
    if args.toml:
        print_toml(rows, args.suffix, name_width)
    else:
        print_table(rows, args.suffix, name_width)


if __name__ == "__main__":
    main()
