#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SWR_ORG:-}" ]]; then
  echo "Usage: SWR_ORG=your-org scripts/install_spark_operator.sh" >&2
  exit 1
fi

SWR="swr.cn-east-3.myhuaweicloud.com/${SWR_ORG}"

resources/helm-v4.2.0/linux-amd64/helm upgrade --install spark-op resources/离线包/spark/spark-operator \
  -n spark-operator --create-namespace \
  --set controller.image.repository="${SWR}/spark-operator" \
  --set controller.image.tag=2.5.0 \
  --set webhook.image.repository="${SWR}/spark-operator" \
  --set webhook.image.tag=2.5.0

kubectl get pods -n spark-operator -o wide
