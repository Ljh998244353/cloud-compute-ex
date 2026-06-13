# 课设执行检查清单

默认参数：

- Region：华东-上海一，`cn-east-3`
- SWR Registry：`swr.cn-east-3.myhuaweicloud.com`
- 镜像权限：推送后设为公开
- 第二部分：Spark
- 附加题3：C-2 K3s + MQTT

## 1. 个人参数

先收集并替换所有占位符：

- `2023112456`：学号
- `刘俊豪`：姓名
- `cloud-ljh-ys`：SWR 组织名
- `Q2xvdWRSZWRpc0AyMDI2`：`echo -n "Redis密码" | base64`
- `cloud-ljh-ys-data`：OBS Bucket 或 `s3a://` 数据路径
- `<MOSQUITTO_ELB_IP>`：`kubectl get svc mosquitto-lb` 得到的公网 IP

可用脚本批量替换：

```bash
STUDENT_ID=你的学号 \
STUDENT_NAME=你的姓名 \
SWR_ORG=你的SWR组织 \
REDIS_PASSWORD=你的Redis密码 \
OBS_BUCKET=你的OBS桶名 \
scripts/fill_placeholders.sh
```

## 2. 本地容器化

```bash
cd scaffold/part1-app
docker compose up --build
curl http://localhost:5000/api/ping
curl http://localhost:5000/api/redis
```

截图：compose 输出、后端日志、curl 结果。

## 3. 镜像推送

```bash
SWR=swr.cn-east-3.myhuaweicloud.com/cloud-ljh-ys
docker login -u cn-east-3@<AK> -p <SWR临时Token> swr.cn-east-3.myhuaweicloud.com
SWR_ORG=cloud-ljh-ys scripts/build_and_push_images.sh app
```

## 4. CCE 部署

```bash
scripts/deploy_part1.sh
```

截图：Pod Running、PVC Bound、Service 外网 IP、`curl http://<ELB_IP>/api/ping`。

## 5. HPA

```bash
kubectl apply -f scaffold/part1-k8s/hpa.yaml
kubectl top nodes
kubectl get hpa
ab -n 10000 -c 200 http://<ELB_IP>/api/ping
kubectl get pods -w
```

截图：扩容和停压后缩容。

## 6. Spark

```bash
SWR_ORG=cloud-ljh-ys scripts/build_and_push_images.sh spark
SWR_ORG=cloud-ljh-ys scripts/install_spark_operator.sh
```

提交 Spark 作业：

```bash
kubectl apply -f scaffold/part2-spark/sparkapplication.yaml
kubectl get pods -w
```

## 7. 附加题

- 监控：`SWR_ORG=cloud-ljh-ys scripts/build_and_push_images.sh monitoring`，替换 `monitoring-values.yaml`，执行 `scripts/install_monitoring.sh`。
- CI/CD：GitHub Secrets 需配置 `SWR_AK`、`SWR_SK`、`SWR_ORG`、`KUBE_CONFIG`。
- C-2：先部署 `cce-mosquitto.yaml` 和 `cce-subscriber.yaml`，再在 K3s 中部署 `k3s-publisher.yaml`。
