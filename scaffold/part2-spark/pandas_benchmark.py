import argparse
import json
import time
from pathlib import Path

import pandas as pd


def parse_args():
    parser = argparse.ArgumentParser(description="Pandas benchmark for Douban movies")
    parser.add_argument("--input", default="../../asst/douban_movies.csv")
    parser.add_argument("--output", default="/tmp/douban-analysis-results")
    return parser.parse_args()


def main():
    args = parse_args()
    start = time.perf_counter()

    df = pd.read_csv(args.input)
    for column in ["year", "rating_score", "rating_count", "collect_count"]:
        df[column] = pd.to_numeric(df[column], errors="coerce")
    df = df.dropna(subset=["year", "rating_score"]).fillna(
        {
            "genres": "未知",
            "countries": "未知",
            "directors": "未知",
            "summary": "暂无简介",
            "rating_count": 0,
            "collect_count": 0,
        }
    )
    genre_stats = (
        df.assign(genre=df["genres"].str.split("/"))
        .explode("genre")
        .groupby("genre", as_index=False)
        .agg(
            movie_count=("movie_id", "count"),
            avg_rating=("rating_score", "mean"),
            avg_rating_count=("rating_count", "mean"),
        )
        .sort_values(["movie_count", "avg_rating"], ascending=[False, False])
    )

    duration = time.perf_counter() - start
    print(genre_stats.head(20).to_string(index=False))
    print(f"Pandas benchmark duration: {duration:.3f}s")

    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)
    with (output_dir / "pandas_timing.json").open("w", encoding="utf-8") as fp:
        json.dump(
            {"name": "PANDAS_Q1_GROUP_BY_genre", "duration_seconds": round(duration, 3)},
            fp,
            ensure_ascii=False,
            indent=2,
        )


if __name__ == "__main__":
    main()
