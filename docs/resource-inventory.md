# 资源清单

生成时间：2026-06-13

## 原始资料

- `asst/douban_movies.csv`：37.3 MiB
- `asst/helm-v4.2.0-linux-amd64(2).tar.gz`：18.8 MiB
- `asst/云计算课程设计_离线资源包_SparkOperator+MPI+Monitoring.7z`：2669.1 MiB
- `asst/课程设计任务书.docx`：0.1 MiB
- `asst/课设问题合集.pdf`：0.4 MiB

## 已解压资源

| 路径 | 大小 | 用途 |
| --- | ---: | --- |
| `resources/离线包/README.md` | 0.0 MiB | 离线镜像与 Chart 使用说明 |
| `resources/离线包/spark/spark-operator-2.5.0.tar` | 769.5 MiB | Spark Operator 控制器镜像，需 docker load 后推送到个人 SWR |
| `resources/离线包/spark/pyspark-v9.tar` | 1085.4 MiB | PySpark 作业运行时镜像，方向A使用 |
| `resources/离线包/spark/spark-operator/` | 1.7 MiB | Spark Operator Helm Chart，离线 helm install |
| `resources/离线包/mpi/mpi4py-latest.tar` | 334.8 MiB | mpi4py 运行时镜像，方向B使用，包含 openssh-server |
| `resources/离线包/mpi/mpi-operator.yaml` | 0.6 MiB | MPI Operator CRD/RBAC/Deployment 一体化部署文件 |
| `resources/离线包/monitoring/monitoring-all.tar` | 507.0 MiB | Prometheus/Grafana 监控镜像包，附加题1使用 |
| `resources/离线包/monitoring/kube-prometheus-stack-83.7.0.tgz` | 0.8 MiB | kube-prometheus-stack Helm Chart，附加题1使用 |
| `resources/离线包/monitoring/monitoring-values.yaml` | 0.0 MiB | 监控 Helm values，占位符需替换为个人 SWR 地址 |
| `resources/helm-v4.2.0/linux-amd64/helm` | 61.1 MiB | Helm v4.2.0 二进制 |

## 注意事项

- 原始 `asst/` 不修改；后续实验代码、YAML、报告记录放在仓库工作目录中。
- CCE 节点通常不能直连 Docker Hub、GHCR、Quay，离线镜像应先 `docker load`、重打 tag、推送到与你 CCE 同 Region 的 SWR。
- SWR 私有镜像需要 `imagePullSecret`；为降低部署复杂度，可在课程允许范围内将实验镜像设为公开。
