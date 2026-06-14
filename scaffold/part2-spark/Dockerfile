FROM swr.cn-east-3.myhuaweicloud.com/cloud-ljh-ys/pyspark:v9

WORKDIR /opt/spark/work
COPY scaffold/part2-spark/analysis.py scaffold/part2-spark/wordcount.py ./
COPY asst/douban_movies.csv ./douban_movies.csv

USER root
RUN mkdir -p /tmp/douban-analysis-results && chmod 777 /tmp/douban-analysis-results
USER 185
