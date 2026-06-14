#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  SWR_ORG=your-org scripts/build_and_push_images.sh app
  SWR_ORG=your-org scripts/build_and_push_images.sh spark-analysis
  SWR_ORG=your-org scripts/build_and_push_images.sh mqtt

Login first:
  docker login -u cn-east-3@<AK> -p <SWR临时Token> swr.cn-east-3.myhuaweicloud.com
USAGE
}

if [[ $# -ne 1 || -z "${SWR_ORG:-}" ]]; then
  usage >&2
  exit 1
fi

SWR="swr.cn-east-3.myhuaweicloud.com/${SWR_ORG}"
target="$1"

push_app() {
  docker build --provenance=false -t "${SWR}/backend:v1" scaffold/part1-app/backend
  docker build --provenance=false -t "${SWR}/frontend:v1" scaffold/part1-app/frontend
  docker push "${SWR}/backend:v1"
  docker push "${SWR}/frontend:v1"
}

push_spark() {
  docker build --provenance=false -t "${SWR}/pyspark-analysis:v3" -f scaffold/part2-spark/Dockerfile .
  docker push "${SWR}/pyspark-analysis:v3"
}

push_mqtt() {
  docker build --provenance=false -t "${SWR}/mqtt-edge:v1" scaffold/addon-c2-mqtt
  docker push "${SWR}/mqtt-edge:v1"
}

case "${target}" in
  app) push_app ;;
  spark-analysis) push_spark ;;
  mqtt) push_mqtt ;;
  *) usage >&2; exit 1 ;;
esac
