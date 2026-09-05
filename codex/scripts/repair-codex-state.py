#!/usr/bin/env python3

import argparse
import json
import os
import sqlite3
import subprocess
import sys
from pathlib import Path
from typing import NamedTuple


class Thread(NamedTuple):
    id: str
    rollout_path: Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Remove Codex state DB rows whose rollout files are missing."
    )
    parser.add_argument(
        "--doctor",
        action="store_true",
        help="run codex doctor and include its stale-row count",
    )
    return parser.parse_args()


def get_database_path() -> Path:
    codex_home = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex"))
    return Path(codex_home, "state_5.sqlite")


def get_doctor_stale_count() -> int:
    result = subprocess.run(
        ["codex", "doctor", "--json"],
        capture_output=True,
        encoding="utf-8",
        check=False,
    )
    report = json.loads(result.stdout)
    thread_check = next(
        check for check in report["checks"].values() if check["category"] == "threads"
    )
    return int(thread_check["details"].get("rollout DB stale rows", 0))


def find_missing_threads(database: Path) -> list[Thread]:
    with sqlite3.connect(database) as connection:
        rows = connection.execute("SELECT id, rollout_path FROM threads").fetchall()

    missing_threads = []
    for thread_id, rollout_path in rows:
        thread = Thread(thread_id, Path(rollout_path))
        if not thread.rollout_path.is_file():
            missing_threads.append(thread)

    return missing_threads


def print_missing_threads(
    missing_threads: list[Thread],
    doctor_stale_count: int | None,
) -> None:
    if doctor_stale_count is not None:
        print(f"codex doctor reported stale rows: {doctor_stale_count}")
    print(f"missing rollout files found: {len(missing_threads)}")

    if missing_threads:
        print()
        for thread in missing_threads:
            print(thread.rollout_path)
        print()


def confirm_deletion(count: int) -> bool:
    answer = input(f"Delete these {count} stale thread rows from the state DB? [y/N] ")
    return answer.strip().lower() in {"y", "yes"}


def delete_threads(database: Path, threads: list[Thread]) -> int:
    placeholders = ",".join("?" for _ in threads)

    with sqlite3.connect(database) as connection:
        connection.execute("PRAGMA foreign_keys = ON")
        connection.execute("BEGIN IMMEDIATE")
        cursor = connection.execute(
            f"DELETE FROM threads WHERE id IN ({placeholders})",
            [thread.id for thread in threads],
        )

    return cursor.rowcount


def main() -> None:
    args = parse_args()
    database = get_database_path()
    doctor_stale_count = get_doctor_stale_count() if args.doctor else None
    missing_threads = find_missing_threads(database)

    print_missing_threads(missing_threads, doctor_stale_count)

    if not missing_threads:
        return

    if not confirm_deletion(len(missing_threads)):
        print("No changes made.")
        return

    deleted_count = delete_threads(database, missing_threads)
    print(f"Deleted {deleted_count} stale thread rows.")


if __name__ == "__main__":
    try:
        main()
    except (KeyboardInterrupt, EOFError):
        print("\nCancelled.", file=sys.stderr)
        raise SystemExit(130) from None
