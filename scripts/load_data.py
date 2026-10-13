#!/usr/bin/env python3
"""Load the raw ant-interaction text file into a SQLite database.

Usage:
    python3 scripts/load_data.py [data/<file>.txt] [ant_interactions.db]
"""
import sqlite3
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_DATA = ROOT / "data" / "interactions_filtered_col8_rep1_angpara120_timethresh10.txt"
DEFAULT_DB = ROOT / "ant_interactions.db"


def load(data_path: Path, db_path: Path) -> int:
    conn = sqlite3.connect(db_path)
    conn.executescript((ROOT / "schema.sql").read_text())

    rows = []
    with open(data_path, encoding="utf-8") as f:
        next(f)  # header line
        for line in f:
            line = line.strip()
            if not line:
                continue
            fields = line.split()
            if len(fields) != 12:
                raise ValueError(f"Expected 12 fields, got {len(fields)}: {line!r}")
            tag1, tag2, start_frame, stop_frame = map(int, fields[0:4])
            start_time, stop_time = map(float, fields[4:6])
            x1, y1, angle1 = map(float, fields[6:9])
            x2, y2, angle2 = map(float, fields[9:12])
            rows.append((tag1, tag2, start_frame, stop_frame, start_time, stop_time,
                         x1, y1, angle1, x2, y2, angle2))

    conn.executemany(
        """INSERT INTO interactions
           (tag1, tag2, start_frame, stop_frame, start_time, stop_time,
            x1, y1, angle1, x2, y2, angle2)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
        rows,
    )
    conn.commit()
    conn.close()
    return len(rows)


if __name__ == "__main__":
    data_path = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_DATA
    db_path = Path(sys.argv[2]) if len(sys.argv) > 2 else DEFAULT_DB
    n = load(data_path, db_path)
    print(f"Loaded {n} interactions into {db_path}")
