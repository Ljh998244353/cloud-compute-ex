import argparse
import json
import time
from pathlib import Path

from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.window import Window


NUMERIC_COLUMNS = ["year", "rating_score", "rating_count", "collect_count"]


def parse_args():
    parser = argparse.ArgumentParser(description="Douban movie Spark analysis")
    parser.add_argument(
        "--input",
        default="s3a://cloud-ljh-ys-data/douban_movies.csv",
        help="CSV path, for example s3a://bucket/douban_movies.csv",
    )
    parser.add_argument(
        "--output",
        default="/tmp/douban-analysis-results",
        help="Directory for JSON timing output",
    )
    return parser.parse_args()


def load_movies(spark, input_path):
    df = spark.read.option("header", True).option("multiLine", True).csv(input_path)
    for column in NUMERIC_COLUMNS:
        df = df.withColumn(column, F.col(column).cast("double"))
    return df


def print_missing_ratio(df):
    total = df.count()
    exprs = [
        (
            F.count(
                F.when(F.col(column).isNull() | (F.trim(F.col(column).cast("string")) == ""), column)
            )
            / F.lit(total)
        ).alias(column)
        for column in df.columns
    ]
    print("Missing ratio by column:")
    df.select(exprs).show(truncate=False)


def clean_movies(df):
    before = df.count()
    cleaned = df.dropna(subset=["year", "rating_score"])
    cleaned = cleaned.fillna(
        {
            "genres": "未知",
            "countries": "未知",
            "directors": "未知",
            "summary": "暂无简介",
            "rating_count": 0,
            "collect_count": 0,
        }
    )
    after = cleaned.count()
    print(f"Rows before cleaning: {before}")
    print(f"Rows after cleaning: {after}")
    cleaned.select(NUMERIC_COLUMNS).summary("count", "mean", "stddev", "min", "max").show(
        truncate=False
    )
    return cleaned


def run_query(name, func):
    start = time.perf_counter()
    result = func()
    rows = result.collect()
    duration = time.perf_counter() - start
    print(f"\n=== {name} ({duration:.3f}s) ===")
    result.show(20, truncate=False)
    return {"name": name, "duration_seconds": round(duration, 3), "rows": len(rows)}


def run_queries(df):
    df.createOrReplaceTempView("movies")

    timings = []
    timings.append(
        run_query(
            "Q1_GROUP_BY_genre",
            lambda: (
                df.withColumn("genre", F.explode(F.split(F.col("genres"), "/")))
                .groupBy("genre")
                .agg(
                    F.count("*").alias("movie_count"),
                    F.round(F.avg("rating_score"), 2).alias("avg_rating"),
                    F.round(F.avg("rating_count"), 0).alias("avg_rating_count"),
                )
                .orderBy(F.desc("movie_count"), F.desc("avg_rating"))
            ),
        )
    )
    timings.append(
        run_query(
            "Q2_TOP_N_collect_count",
            lambda: df.select("title", "year", "rating_score", "collect_count")
            .orderBy(F.desc("collect_count"))
            .limit(10),
        )
    )
    timings.append(
        run_query(
            "Q3_YEARLY_TREND",
            lambda: df.groupBy(F.col("year").cast("int").alias("year"))
            .agg(
                F.count("*").alias("movie_count"),
                F.round(F.avg("rating_score"), 2).alias("avg_rating"),
                F.round(F.sum("rating_count"), 0).alias("total_rating_count"),
            )
            .orderBy("year"),
        )
    )
    timings.append(
        run_query(
            "Q4_WINDOW_country_rank",
            lambda: (
                df.withColumn("country", F.explode(F.split(F.col("countries"), "/")))
                .withColumn(
                    "rank_in_country",
                    F.row_number().over(
                        Window.partitionBy("country").orderBy(
                            F.desc("rating_score"), F.desc("rating_count")
                        )
                    ),
                )
                .where(F.col("rank_in_country") <= 3)
                .select("country", "rank_in_country", "title", "year", "rating_score")
                .orderBy("country", "rank_in_country")
            ),
        )
    )
    return timings


def main():
    args = parse_args()
    spark = SparkSession.builder.appName("DoubanMovieAnalysis").getOrCreate()

    df = load_movies(spark, args.input)
    print("Schema:")
    df.printSchema()
    print("Sample rows:")
    df.show(5, truncate=False)
    print_missing_ratio(df)

    cleaned = clean_movies(df)
    timings = run_queries(cleaned)

    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)
    with (output_dir / "spark_timings.json").open("w", encoding="utf-8") as fp:
        json.dump(timings, fp, ensure_ascii=False, indent=2)

    spark.stop()


if __name__ == "__main__":
    main()
