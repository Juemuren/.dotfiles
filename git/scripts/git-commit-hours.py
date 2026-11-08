#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["matplotlib>=3.10,<4"]
# ///

import argparse
import subprocess
from collections import Counter
from pathlib import Path

import matplotlib.pyplot as plt  # ty: ignore[unresolved-import]

# YYYY-MM-DDTHH:MM:SS+08:00
COMMAND = [
    "git",
    "log",
    "--all",
    "--format=%ad",
    "--date=iso-strict",
]
H_BEGIN = 11
H_END = 13
HOURS = range(24)

FIGURE_SIZE = (12, 5)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Plot Git commit counts by hour.")
    parser.add_argument(
        "--png",
        type=Path,
        metavar="PATH",
        help="Save the chart as a PNG file",
    )
    return parser.parse_args()


def get_data() -> list[int]:
    hours = [
        int(line[H_BEGIN:H_END])
        for line in subprocess.check_output(
            COMMAND,
            text=True,
        ).splitlines()
        if line
    ]
    counts = Counter(hours)
    return [counts.get(hour, 0) for hour in HOURS]


def plot(counts: list[int], png: Path | None) -> None:
    hours = list(HOURS)
    plt.figure(figsize=FIGURE_SIZE)
    plt.bar(hours, counts, width=0.85)

    plt.xticks(hours, [f"{hour:02d}" for hour in hours])
    plt.xlabel("Hour of day")
    plt.ylabel("Number of commits")
    plt.title("Git Commit Time Distribution")

    plt.tight_layout()
    if png is not None:
        plt.savefig(png, dpi=180, format="png")
    plt.show()


if __name__ == "__main__":
    args = parse_args()
    plot(get_data(), args.png)
