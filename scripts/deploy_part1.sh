#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f scaffold/part1-k8s/configmap-secret.yaml
kubectl apply -f scaffold/part1-k8s/redis-pvc.yaml
kubectl apply -f scaffold/part1-k8s/redis-deployment.yaml
kubectl apply -f scaffold/part1-k8s/backend-deployment.yaml
kubectl apply -f scaffold/part1-k8s/service.yaml
kubectl apply -f scaffold/part1-k8s/frontend-nginx-configmap.yaml
kubectl apply -f scaffold/part1-k8s/frontend-deployment.yaml

kubectl rollout status deployment/redis --timeout=180s
kubectl rollout status deployment/backend --timeout=180s
kubectl rollout status deployment/frontend --timeout=180s
kubectl get pods,svc,pvc -o wide
