#!/usr/bin/env python3
"""Generate ImageMagick logo variants and preview them with Chafa."""

import argparse
import itertools
import re
import subprocess
import sys
from pathlib import Path


def expand_range(spec: str) -> list[int]:
    if re.fullmatch(r"[0-9]+", spec):
        return [int(spec)]
    if match := re.fullmatch(r"([0-9]+):([0-9]+):([0-9]+)", spec):
        start, end, step = map(int, match.groups())
        if step > 0 and start <= end:
            return list(range(start, end + 1, step))
    raise argparse.ArgumentTypeError(f"Invalid range: {spec}")


def percent(value: str) -> int:
    if not re.fullmatch(r"[0-9]+", value):
        raise argparse.ArgumentTypeError(f"Expected a nonnegative integer: {value}")
    return int(value)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=__doc__,
        epilog="Pick a PNG, then run convert-logo.py to save the chosen logo. "
        "Ranges accept N or START:END:STEP (inclusive).",
    )
    parser.add_argument("input", type=Path)
    parser.add_argument("output_dir", type=Path)
    parser.add_argument("--contrast", type=expand_range, default=[4])
    parser.add_argument("--saturation", type=expand_range, default=[125])
    parser.add_argument("--line-strength", type=expand_range, default=[25])
    parser.add_argument("--line-width", type=expand_range, default=[1])
    parser.add_argument("--crop", help="ImageMagick crop, e.g. 1350x1350+260+180")
    parser.add_argument("--midpoint", type=percent, default=72)
    parser.add_argument("--edge-scale", type=percent, default=30)
    parser.add_argument("--canny-low", type=percent, default=10)
    parser.add_argument("--canny-high", type=percent, default=30)
    parser.add_argument(
        "--preview", choices=("braille", "block", "both", "none"), default="block"
    )
    args = parser.parse_args()

    if any(strength > 100 for strength in args.line_strength):
        parser.error("Line strength must be 0-100")
    if (
        args.midpoint > 100
        or args.edge_scale == 0
        or args.canny_low > 100
        or args.canny_high > 100
        or args.canny_low >= args.canny_high
    ):
        parser.error("Invalid midpoint, edge scale, or Canny thresholds")
    if args.crop and not re.fullmatch(r"[0-9]+x[0-9]+[+-][0-9]+[+-][0-9]+", args.crop):
        parser.error(f"Crop must be WIDTHxHEIGHT+X+Y: {args.crop}")
    return args


def create_candidate(
    source: Path,
    output: Path,
    crop_args: list[str],
    image_size: str,
    contrast: int,
    saturation: int,
    line_strength: int,
    line_width: int,
    midpoint: int,
    edge_scale: int,
    canny_low: int,
    canny_high: int,
) -> None:
    command = ["magick", str(source), *crop_args]
    if line_strength:
        edge_args = [
            "-resize",
            f"{edge_scale}%",
            "-colorspace",
            "Gray",
            "-canny",
            f"0x1+{canny_low}%+{canny_high}%",
        ]
        if line_width:
            edge_args += ["-morphology", "Dilate", f"Disk:{line_width}"]
        command += [
            "(",
            "+clone",
            *edge_args,
            "-resize",
            f"{image_size}!",
            "-fx",
            f"1-({line_strength}/100)*u",
            ")",
            "-compose",
            "Multiply",
            "-composite",
        ]
    if contrast:
        command += ["-sigmoidal-contrast", f"{contrast}x{midpoint}%"]
    if saturation != 100:
        command += ["-modulate", f"100,{saturation},100"]
    subprocess.run([*command, str(output)], check=True)


def main() -> None:
    args = parse_args()
    crop_args = ["-crop", args.crop, "+repage"] if args.crop else []
    image_size = subprocess.run(
        ["magick", str(args.input), *crop_args, "-format", "%wx%h", "info:"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout

    args.output_dir.mkdir(parents=True, exist_ok=False)
    converter = Path(__file__).with_name("convert-logo.py")
    with (args.output_dir / "candidates.tsv").open(
        "w", encoding="utf-8", newline=""
    ) as manifest:
        manifest.write("file\tcontrast\tsaturation\tline_strength\tline_width\n")
        combinations = itertools.product(
            args.contrast, args.saturation, args.line_strength, args.line_width
        )
        for index, (contrast, saturation, strength, width) in enumerate(
            combinations, 1
        ):
            filename = f"candidate-{index:04d}.png"
            output = args.output_dir / filename
            create_candidate(
                args.input,
                output,
                crop_args,
                image_size,
                contrast,
                saturation,
                strength,
                width,
                args.midpoint,
                args.edge_scale,
                args.canny_low,
                args.canny_high,
            )
            manifest.write(
                f"{filename}\t{contrast}\t{saturation}\t{strength}\t{width}\n"
            )
            manifest.flush()
            print(
                f"{output}  contrast={contrast} saturation={saturation} "
                f"line={strength} width={width}",
                flush=True,
            )
            for mode in ("braille", "block"):
                if args.preview in (mode, "both"):
                    subprocess.run(
                        [sys.executable, str(converter), mode, str(output), "-"],
                        check=True,
                    )


if __name__ == "__main__":
    main()
