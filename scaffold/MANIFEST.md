# 脚手架文件索引

## 第一部分：应用容器化

| 文件 | 对应任务 | 后续需要补全 |
| --- | --- | --- |
| `part1-app/backend/Dockerfile` | 任务1 Dockerfile.backend | 通常无需改；构建 SWR 镜像时建议加 `--provenance=false` |
| `part1-app/backend/requirements.txt` | 任务1 自选 Python 包 | 已加入 `requests` 示例，可按需替换或保留 |
| `part1-app/backend/app.py` | 任务1 后端 API | 可继续补 Redis 访问日志，便于截图证明通信 |
| `part1-app/frontend/Dockerfile` | 任务1 Dockerfile.frontend | 通常无需改 |
| `part1-app/frontend/nginx.conf` | 任务1 本地前端反代 | 本地 compose 使用 `backend:5000` |
| `part1-app/frontend/static/index.html` | 任务1 前端首页 | 必须替换 `<YOUR_STUDENT_ID>` 和 `<YOUR_NAME>` |
| `part1-app/docker-compose.yml` | 任务1 本地联调 | 可按本机端口占用情况改 `8080:80` |

## 第一部分：CCE/K8s 部署

| 文件 | 对应任务 | 后续需要补全 |
| --- | --- | --- |
| `part1-k8s/configmap-secret.yaml` | 任务3 ConfigMap + Secret | 替换 `<YOUR_BASE64_ENCODED_PASSWORD>` |
| `part1-k8s/backend-deployment.yaml` | 任务3 后端 Deployment | 替换 SWR 镜像地址；保持副本数 2 |
| `part1-k8s/redis-deployment.yaml` | 任务3/4 Redis Deployment | 依赖 `redis-data-pvc`；若先做任务3可临时移除 PVC 挂载 |
| `part1-k8s/service.yaml` | 任务3 Service | 根据华为云 ELB 要求确认 annotation |
| `part1-k8s/redis-pvc.yaml` | 任务4 PVC | 确认 CCE StorageClass 是否为 `csi-disk` |
| `part1-k8s/frontend-nginx-configmap.yaml` | 任务5 ConfigMap Volume | 修改后记得截图 Pod 内配置文件 |
| `part1-k8s/frontend-deployment.yaml` | 任务5 前端 Deployment | 替换前端 SWR 镜像地址 |
| `part1-k8s/hpa.yaml` | 任务6 HPA | 压测前确认 metrics-server 可用 |

## 第二部分：Spark 方向

| 文件 | 对应任务 | 后续需要补全 |
| --- | --- | --- |
| `part2-spark/sparkapplication.yaml` | A-0 SparkApplication | 替换 PySpark SWR 镜像地址；按资源情况调 executor |
| `part2-spark/wordcount.py` | A-0 示例作业 | 替换 `<BUCKET>` |
| `part2-spark/analysis.py` | A-1/A-2/A-3 分析入口 | 补全清洗、4 个查询、性能计时 |

## 第二部分：MPI 方向

| 文件 | 对应任务 | 后续需要补全 |
| --- | --- | --- |
| `part2-mpi/mpijob.yaml` | B-0 MPIJob | 替换 mpi4py SWR 镜像地址；离线 CRD 默认用 `kubeflow.org/v2beta1` |
| `part2-mpi/pi_mpi.py` | B-0 示例作业 | 可作为 MPI 镜像内 `/opt/mpi/pi_mpi.py` |

## 验证结果

- YAML 基础解析已通过。
- Python 脚本语法编译已通过。
- 仍包含占位符，不能直接提交到集群，需要先按实际华为云信息替换。
