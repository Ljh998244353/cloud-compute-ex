#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  STUDENT_ID=... STUDENT_NAME=... SWR_ORG=... REDIS_PASSWORD=... OBS_BUCKET=... scripts/fill_placeholders.sh

Optional:
  MOSQUITTO_ELB_IP=1.2.3.4 scripts/fill_placeholders.sh
USAGE
}

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "Missing required environment variable: ${name}" >&2
    usage >&2
    exit 1
  fi
}

require_env STUDENT_ID
require_env STUDENT_NAME
require_env SWR_ORG
require_env REDIS_PASSWORD
require_env OBS_BUCKET

encoded_password="$(printf '%s' "${REDIS_PASSWORD}" | base64 | tr -d '\n')"
mosquitto_elb_ip="${MOSQUITTO_ELB_IP:-<MOSQUITTO_ELB_IP>}"

files=(
  docs/report.md
  scaffold/part1-app/frontend/static/index.html
  scaffold/part1-k8s/backend-deployment.yaml
  scaffold/part1-k8s/configmap-secret.yaml
  scaffold/part1-k8s/frontend-deployment.yaml
  scaffold/part2-spark/Dockerfile
  scaffold/part2-spark/analysis.py
  scaffold/part2-spark/sparkapplication.yaml
  scaffold/part2-spark/wordcount.py
  scaffold/part2-mpi/mpijob.yaml
  scaffold/addon-c2-mqtt/cce-subscriber.yaml
  scaffold/addon-c2-mqtt/k3s-publisher.yaml
  scaffold/addon-c2-mqtt/README.md
  docs/execution-checklist.md
)

for file in "${files[@]}"; do
  [[ -f "${file}" ]] || continue
  sed -i \
    -e "s#<YOUR_STUDENT_ID>#${STUDENT_ID}#g" \
    -e "s#<YOUR_NAME>#${STUDENT_NAME}#g" \
    -e "s#<YOUR_ORG>#${SWR_ORG}#g" \
    -e "s#<YOUR_BASE64_ENCODED_PASSWORD>#${encoded_password}#g" \
    -e "s#<BUCKET>#${OBS_BUCKET}#g" \
    -e "s#<MOSQUITTO_ELB_IP>#${mosquitto_elb_ip}#g" \
    "${file}"
done

echo "Placeholders replaced. Redis password was written only as base64 in Kubernetes Secret."
