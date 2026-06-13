#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  SWR_ORG=your-org scripts/build_and_push_images.sh app
  SWR_ORG=your-org scripts/build_and_push_images.sh spark
  SWR_ORG=your-org scripts/build_and_push_images.sh monitoring
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
  docker load -i resources/离线包/spark/spark-operator-2.5.0.tar
  docker load -i resources/离线包/spark/pyspark-v9.tar
  docker tag ghcr.io/kubeflow/spark-operator/controller:2.5.0 "${SWR}/spark-operator:2.5.0"
  docker tag swr.cn-east-3.myhuaweicloud.com/cloud-course-2025212245/pyspark:v9 "${SWR}/pyspark:v9"
  docker build --provenance=false -t "${SWR}/pyspark-analysis:v1" scaffold/part2-spark
  docker push "${SWR}/spark-operator:2.5.0"
  docker push "${SWR}/pyspark:v9"
  docker push "${SWR}/pyspark-analysis:v1"
}

push_monitoring() {
  docker load -i resources/离线包/monitoring/monitoring-all.tar
  local old="swr.cn-east-3.myhuaweicloud.com/cloud-course-2025212245"
  local images=(
    grafana:12.4.3
    k8s-sidecar:2.6.0
    prometheus:v3.11.2
    alertmanager:v0.32.0
    prometheus-operator:v0.90.1
    kube-webhook-certgen:1.8.1
    prometheus-config-reloader:v0.90.1
    node-exporter:v1.11.1
  )
  for image in "${images[@]}"; do
    docker tag "${old}/${image}" "${SWR}/${image}"
    docker push "${SWR}/${image}"
  done
}

push_mqtt() {
  docker build --provenance=false -t "${SWR}/mqtt-edge:v1" scaffold/addon-c2-mqtt
  docker push "${SWR}/mqtt-edge:v1"
}

case "${target}" in
  app) push_app ;;
  spark) push_spark ;;
  monitoring) push_monitoring ;;
  mqtt) push_mqtt ;;
  *) usage >&2; exit 1 ;;
esac
