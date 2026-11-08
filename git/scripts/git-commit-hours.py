#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["matplotlib>=3.10,<4"]
# ///

import subprocess
from collections import Counter

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

FIGURE_SIZE = (12, 5)

hours = [
    int(line[H_BEGIN:H_END])
    for line in subprocess.check_output(
        COMMAND,
        text=True,
    ).splitlines()
    if line
]
counts = Counter(hours)

x = list(range(24))
y = [counts.get(h, 0) for h in x]

plt.figure(figsize=FIGURE_SIZE)
plt.bar(x, y, width=0.85)

plt.xticks(x, [f"{h:02d}" for h in x])
plt.xlabel("Hour of day")
plt.ylabel("Number of commits")
plt.title("Git Commit Time Distribution")

plt.tight_layout()
plt.savefig("git_commit_hours.png", dpi=180)
plt.show()
