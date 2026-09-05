#!/usr/bin/env python3

import json
import os
import sqlite3
import subprocess
from pathlib import Path


def get_doctor_stale_count() -> int:
    result = subprocess.run(
        ["codex", "doctor", "--json"],
        capture_output=True,
        encoding="utf-8",
        check=False,
    )
    report = json.loads(result.stdout)
    thread_check = next(
        check
        for check in report["checks"].values()
        if check["category"] == "threads"
    )
    return int(thread_check["details"].get("rollout DB stale rows", 0))


def confirm(message: str) -> bool:
    return input(f"{message} [y/N] ").strip().lower() in {"y", "yes"}


def main() -> None:
    codex_home = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex"))
    database = Path(os.environ.get("DB", codex_home / "state_5.sqlite"))
    doctor_stale_count = get_doctor_stale_count()

    with sqlite3.connect(database) as connection:
        connection.execute("PRAGMA foreign_keys = ON")
        threads = connection.execute(
            "SELECT id, rollout_path FROM threads"
        ).fetchall()
        missing_threads = [
            (thread_id, rollout_path)
            for thread_id, rollout_path in threads
            if not Path(rollout_path).is_file()
        ]

        print(f"codex doctor reported stale rows: {doctor_stale_count}")
        print(f"Missing rollout files found: {len(missing_threads)}")

        if not missing_threads:
            return

        print()
        for _, rollout_path in missing_threads:
            print(rollout_path)
        print()

        if not confirm(
            f"Delete these {len(missing_threads)} stale thread rows from the state DB?"
        ):
            print("No changes made.")
            return

        placeholders = ",".join("?" for _ in missing_threads)
        connection.execute("BEGIN IMMEDIATE")
        cursor = connection.execute(
            f"DELETE FROM threads WHERE id IN ({placeholders})",
            [thread_id for thread_id, _ in missing_threads],
        )
        connection.commit()

    print(f"Deleted {cursor.rowcount} stale thread rows.")


if __name__ == "__main__":
    main()
