#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.13"
# dependencies = ["matplotlib>=3.10,<4"]
# ///

import argparse
import json
import subprocess
from collections import Counter
from collections.abc import Collection
from pathlib import Path
from typing import Literal, TypedDict

import matplotlib.pyplot as plt
from matplotlib import colormaps
from matplotlib.axes import Axes
from matplotlib.figure import Figure
from matplotlib.ticker import StrMethodFormatter

type Metric = Literal["lines", "bytes", "files"]
type Chart = Literal["donut", "bar"]


class Args(argparse.Namespace):
    metric: Metric
    chart: Chart
    output: Path | None
    include_lang: list[str]
    exclude_lang: list[str]
    include_dir: list[str]
    exclude_dir: list[str]
    include_ext: list[str]
    exclude_ext: list[str]


class FileStats(TypedDict):
    Location: str
    Extension: str
    Lines: int
    Bytes: int


class LanguageStats(TypedDict):
    Name: str
    Files: list[FileStats]


def parse_args() -> Args:
    parser = argparse.ArgumentParser(
        description="Plot code statistics by language from the Git working tree.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "--metric",
        choices=("lines", "bytes", "files"),
        default="lines",
        help="Count lines (including comments and blanks), bytes, or files",
    )
    parser.add_argument(
        "--chart",
        choices=("donut", "bar"),
        default="donut",
    )
    parser.add_argument(
        "--output",
        type=Path,
        metavar="PATH",
        help="Save the chart (png or svg)",
    )
    for name, description in (
        ("lang", "language names"),
        ("dir", "repository-relative directories"),
        ("ext", "file extensions"),
    ):
        for action in ("include", "exclude"):
            parser.add_argument(
                f"--{action}-{name}",
                action="extend",
                nargs="+",
                metavar=f"{name.capitalize()}",
                default=[],
                help=f"{action.capitalize()} {description}",
            )
    parser.epilog = (
        "All include filters must match. Any exclude filter takes precedence."
    )
    args = Args()
    parser.parse_args(namespace=args)
    return args


def allowed[T](matches: Collection[T], include: set[T], exclude: set[T]) -> bool:
    if not exclude.isdisjoint(matches):
        return False
    return not include or not include.isdisjoint(matches)


def summarize(languages: list[LanguageStats], args: Args) -> list[tuple[str, int]]:
    include_langs = {name.casefold() for name in args.include_lang}
    exclude_langs = {name.casefold() for name in args.exclude_lang}
    include_dirs = {Path(path.replace("\\", "/")) for path in args.include_dir}
    exclude_dirs = {Path(path.replace("\\", "/")) for path in args.exclude_dir}
    include_exts = {ext.removeprefix(".").casefold() for ext in args.include_ext}
    exclude_exts = {ext.removeprefix(".").casefold() for ext in args.exclude_ext}
    counts: Counter[str] = Counter()
    for language in languages:
        name = language["Name"]
        if not allowed((name.casefold(),), include_langs, exclude_langs):
            continue
        for file in language["Files"]:
            if not allowed(Path(file["Location"]).parents, include_dirs, exclude_dirs):
                continue
            if not allowed((file["Extension"].casefold(),), include_exts, exclude_exts):
                continue
            counts[name] += {
                "lines": file["Lines"],
                "bytes": file["Bytes"],
                "files": 1,
            }[args.metric]
    return sorted(counts.items(), key=lambda item: (-item[1], item[0]))


def plot_donut(
    stats: list[tuple[str, int]],
    metric: Metric,
    colors: dict[str, tuple[float, float, float, float]],
) -> tuple[Figure, Axes]:
    labels, values = zip(*((name, value) for name, value in stats if value))
    fig, ax = plt.subplots(
        figsize=(10, max(5, len(labels) * 0.25)), layout="constrained"
    )
    wedges, _ = ax.pie(
        values,
        colors=[colors[name] for name in labels],
        wedgeprops={"width": 0.4, "edgecolor": "white"},
    )
    total = sum(values)
    ax.text(0, 0, f"{total:,}\n{metric}", ha="center", va="center")
    ax.legend(
        wedges,
        [
            f"{name}  {value:,} ({value / total:.1%})"
            for name, value in zip(labels, values)
        ],
        loc="center left",
        bbox_to_anchor=(1, 0.5),
    )
    return fig, ax


def plot_bar(
    stats: list[tuple[str, int]],
    metric: Metric,
    colors: dict[str, tuple[float, float, float, float]],
) -> tuple[Figure, Axes]:
    labels, values = zip(*stats)
    fig, ax = plt.subplots(
        figsize=(10, max(4, len(labels) * 0.35)), layout="constrained"
    )
    bars = ax.barh(labels, values, color=[colors[name] for name in labels])
    ax.invert_yaxis()
    ax.set_xlabel(metric.capitalize())
    ax.xaxis.set_major_formatter(StrMethodFormatter("{x:,.0f}"))
    ax.bar_label(bars, labels=[f"{value:,}" for value in values], padding=4)
    ax.margins(x=0.2)
    return fig, ax


def plot(
    stats: list[tuple[str, int]], metric: Metric, chart: Chart, output: Path | None
) -> None:
    palette = colormaps["tab20"]
    colors = {name: palette(index % palette.N) for index, (name, _) in enumerate(stats)}
    match chart:
        case "donut":
            fig, ax = plot_donut(stats, metric, colors)
        case "bar":
            fig, ax = plot_bar(stats, metric, colors)
    ax.set_title(f"{metric.capitalize()} by language")
    if output is None:
        plt.show()
    else:
        fig.savefig(output, dpi=180)
    plt.close(fig)


def main() -> None:
    args = parse_args()
    try:
        root = subprocess.check_output(
            [
                "git",
                "rev-parse",
                "--show-toplevel",
            ],
            encoding="utf-8",
        ).rstrip("\r\n")
        data = subprocess.check_output(
            [
                "scc",
                "--by-file",
                "--format",
                "json",
                ".",
            ],
            cwd=root,
            encoding="utf-8",
        )
    except FileNotFoundError as error:
        raise SystemExit(f"Required command unavailable: {error.filename}") from error
    except subprocess.CalledProcessError as error:
        raise SystemExit(
            f"{error.cmd[0]} exited with status {error.returncode}"
        ) from error

    stats = summarize(json.loads(data) or [], args)
    if not stats:
        raise SystemExit("No files matched the filters.")
    if args.chart == "donut" and not any(value for _, value in stats):
        raise SystemExit("A donut chart requires a positive total. Use --chart bar.")
    plot(stats, args.metric, args.chart, args.output)


if __name__ == "__main__":
    main()
