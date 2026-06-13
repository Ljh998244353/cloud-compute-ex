FROM swr.cn-east-3.myhuaweicloud.com/cloud-ljh-ys/pyspark:v9

WORKDIR /opt/spark/work
COPY analysis.py wordcount.py ./

USER root
RUN mkdir -p /tmp/douban-analysis-results && chmod 777 /tmp/douban-analysis-results
USER 185
