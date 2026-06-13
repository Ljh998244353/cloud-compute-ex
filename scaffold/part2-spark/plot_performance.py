import argparse
import json
from pathlib import Path

import matplotlib.pyplot as plt


def parse_args():
    parser = argparse.ArgumentParser(description="Plot Pandas and Spark timing results")
    parser.add_argument("--pandas", required=True, help="Path to pandas_timing.json")
    parser.add_argument("--spark1", required=True, help="Path to spark timings for executor=1")
    parser.add_argument("--spark2", required=True, help="Path to spark timings for executor=2")
    parser.add_argument("--output", default="performance.png")
    return parser.parse_args()


def load_duration(path, query_name=None):
    data = json.loads(Path(path).read_text(encoding="utf-8"))
    if isinstance(data, dict):
        return float(data["duration_seconds"])
    for item in data:
        if query_name is None or item["name"] == query_name:
            return float(item["duration_seconds"])
    raise ValueError(f"Query {query_name!r} not found in {path}")


def main():
    args = parse_args()
    labels = ["Pandas", "PySpark x1", "PySpark x2"]
    durations = [
        load_duration(args.pandas),
        load_duration(args.spark1, "Q1_GROUP_BY_genre"),
        load_duration(args.spark2, "Q1_GROUP_BY_genre"),
    ]
    speedups = [durations[0] / value for value in durations]

    fig, ax = plt.subplots(figsize=(8, 4.8))
    bars = ax.bar(labels, durations, color=["#4b5563", "#2563eb", "#16a34a"])
    ax.set_ylabel("Duration (s)")
    ax.set_title("Pandas vs PySpark Query Performance")
    ax.bar_label(bars, labels=[f"{v:.2f}s\nS={s:.2f}" for v, s in zip(durations, speedups)])
    fig.tight_layout()
    fig.savefig(args.output, dpi=160)
    print(f"Wrote {args.output}")


if __name__ == "__main__":
    main()
