#!/usr/bin/env bash
set -euo pipefail

resources/helm-v4.2.0/linux-amd64/helm upgrade --install monitoring \
  resources/离线包/monitoring/kube-prometheus-stack-83.7.0.tgz \
  -n monitoring --create-namespace \
  -f resources/离线包/monitoring/monitoring-values.yaml

kubectl get pods -n monitoring -o wide
