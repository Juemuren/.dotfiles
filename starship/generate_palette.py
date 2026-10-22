"""Generate Catppuccin Mocha prompt colors by varying base lightness."""

import argparse
import colorsys
import sys

MODULES = ("os", "dir", "git", "tech", "env", "cmd", "time")
BASE_HUE = 240 / 360
BASE_SATURATION = 0.21


def rgb_for_lightness(lightness: float) -> tuple[int, int, int]:
    """Convert the fixed base hue and saturation to 8-bit RGB."""
    red, green, blue = colorsys.hls_to_rgb(BASE_HUE, lightness / 100, BASE_SATURATION)
    return round(red * 255), round(green * 255), round(blue * 255)


def palette(start: float, end: float) -> list[tuple[str, float, tuple[int, int, int]]]:
    """Return evenly spaced lightness levels and their RGB colors."""
    step = (start - end) / (len(MODULES) - 1)
    rows = []
    for index, name in enumerate(MODULES):
        lightness = start - index * step
        rows.append((name, lightness, rgb_for_lightness(lightness)))
    return rows


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
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
    args = parser.parse_args()
    if not 0 <= args.end <= args.start <= 100:
        parser.error("lightness must satisfy 0 <= end <= start <= 100")
    return args


def main() -> None:
    args = parse_args()
    rows = palette(args.start, args.end)
    if args.toml:
        for name, _, rgb in rows:
            color_name = f"{name}_{args.suffix}"
            print(f'{color_name:10}= "#{rgb[0]:02x}{rgb[1]:02x}{rgb[2]:02x}"')
        return

    print(f"{'color':<8} {'lightness':>9}  {'hex':<7}  {'rgb':<15} preview")
    for name, lightness, rgb in rows:
        color_name = f"{name}_{args.suffix}"
        hex_color = f"#{rgb[0]:02x}{rgb[1]:02x}{rgb[2]:02x}"
        preview = (
            f"\x1b[48;2;{rgb[0]};{rgb[1]};{rgb[2]}m    \x1b[0m"
            if sys.stdout.isatty()
            else ""
        )
        print(
            f"{color_name:<8} {lightness:>8.2f}%  {hex_color:<7}  {rgb!s:<15} {preview}"
        )


if __name__ == "__main__":
    main()
