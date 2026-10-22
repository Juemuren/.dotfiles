"""Generate Catppuccin Mocha prompt colors by varying base lightness."""

import argparse
import colorsys
import sys

MODULES = ("os", "dir", "git", "tech", "env", "cmd", "time")
BASE_HUE = 240
BASE_SATURATION = 21


def rgb_for_lightness(
    lightness: float, hue: float, saturation: float
) -> tuple[int, int, int]:
    """Convert HLS percentages and hue degrees to 8-bit RGB."""
    red, green, blue = colorsys.hls_to_rgb(hue / 360, lightness / 100, saturation / 100)
    return round(red * 255), round(green * 255), round(blue * 255)


def palette(
    start: float, end: float, hue: float, saturation: float
) -> list[tuple[str, float, tuple[int, int, int]]]:
    """Return evenly spaced lightness levels and their RGB colors."""
    step = (start - end) / (len(MODULES) - 1)
    rows = []
    for index, name in enumerate(MODULES):
        lightness = start - index * step
        rows.append((name, lightness, rgb_for_lightness(lightness, hue, saturation)))
    return rows


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument(
        "start",
        type=float,
        nargs="?",
        default=39,
        help="first lightness percentage",
    )
    parser.add_argument(
        "end",
        type=float,
        nargs="?",
        default=21,
        help="last lightness percentage",
    )
    parser.add_argument(
        "--toml", action="store_true", help="print pasteable Starship palette entries"
    )
    parser.add_argument(
        "--suffix",
        choices=("bg", "fg"),
        default="bg",
        help="palette key suffix",
    )
    parser.add_argument(
        "--hue", type=float, default=BASE_HUE, help="base hue in degrees"
    )
    parser.add_argument(
        "--saturation",
        type=float,
        default=BASE_SATURATION,
        help="base saturation percentage",
    )
    args = parser.parse_args()
    if not 0 <= args.end <= args.start <= 100:
        parser.error("lightness must satisfy 0 <= end <= start <= 100")
    if not 0 <= args.hue <= 360:
        parser.error("hue must satisfy 0 <= hue <= 360")
    if not 0 <= args.saturation <= 100:
        parser.error("saturation must satisfy 0 <= saturation <= 100")
    return args


def main() -> None:
    args = parse_args()
    rows = palette(args.start, args.end, args.hue, args.saturation)
    name_width = max(len(name) for name in MODULES) + len(args.suffix) + 1
    if args.toml:
        for name, _, rgb in rows:
            color_name = f"{name}_{args.suffix}"
            print(
                f'{color_name:<{name_width}} = "#{rgb[0]:02x}{rgb[1]:02x}{rgb[2]:02x}"'
            )
        return

    show_preview = sys.stdout.isatty()
    rgb_width = len("(255, 255, 255)")
    header = f"{'color':<{name_width}}  {'lightness':>9}  {'hex':<7}  {'rgb':<{rgb_width}}  preview"
    print(header)
    for name, lightness, rgb in rows:
        color_name = f"{name}_{args.suffix}"
        hex_color = f"#{rgb[0]:02x}{rgb[1]:02x}{rgb[2]:02x}"
        lightness_text = f"{lightness:.2f}%"
        rgb_text = f"{rgb!s:<{rgb_width}}" if show_preview else str(rgb)
        row = (
            f"{color_name:<{name_width}}  {lightness_text:>9}  {hex_color}  {rgb_text}"
        )
        if show_preview:
            row += f"  \x1b[48;2;{rgb[0]};{rgb[1]};{rgb[2]}m    \x1b[0m"
        print(row)


if __name__ == "__main__":
    main()
