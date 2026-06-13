# C-2 K3s + MQTT Edge Simulation

This add-on implements the course frontier topic: a K3s edge sensor publishes MQTT messages to a cloud-side Kubernetes broker, and a subscriber stores messages in Redis.

## Components

- `publisher.py`: runs on K3s and publishes simulated temperature/humidity data.
- `subscriber.py`: runs on CCE, subscribes to `edge/sensor`, and writes messages to Redis.
- `cce-mosquitto.yaml`: deploys Mosquitto inside CCE and exposes it through a LoadBalancer.
- `cce-subscriber.yaml`: deploys the Redis-writing subscriber in CCE.
- `k3s-publisher.yaml`: deploys the edge publisher in K3s.

## Build And Push

```bash
SWR=swr.cn-east-3.myhuaweicloud.com/cloud-ljh-ys
docker build --provenance=false -t ${SWR}/mqtt-edge:v1 scaffold/addon-c2-mqtt
docker push ${SWR}/mqtt-edge:v1
```

Set the pushed image to public in SWR, or add an image pull secret in both CCE and K3s.

## CCE Side

```bash
kubectl apply -f scaffold/addon-c2-mqtt/cce-mosquitto.yaml
kubectl apply -f scaffold/addon-c2-mqtt/cce-subscriber.yaml
kubectl get pods,svc -o wide
```

Copy the external IP of `mosquitto-lb` into `<MOSQUITTO_ELB_IP>` in `k3s-publisher.yaml`.

## K3s Side

```bash
sudo KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl apply -f k3s-publisher.yaml
sudo KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl logs -f mqtt-publisher
```

## Verification

```bash
kubectl logs deployment/mqtt-subscriber
kubectl exec deployment/redis -- redis-cli LRANGE mqtt_messages 0 5
```

Report screenshots should show the Mosquitto LoadBalancer IP, K3s publisher logs, CCE subscriber logs, and Redis messages.
