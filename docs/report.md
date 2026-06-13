# 云计算技术课程设计实验报告

> 维护说明：本文件是实验记录草稿。所有 `TODO` 都需要用你的真实操作、截图编号和结果替换。最终提交前再导出为 PDF。

## 封面信息

- 课程名称：云计算技术
- 学号：TODO
- 姓名：TODO
- 班级：TODO
- 组队情况：TODO（独立 / 2 人组队，写明分工比例）
- 实验日期：TODO

## 华为云环境信息

| 项目 | 记录 |
| --- | --- |
| Region | 华东-上海一（cn-east-3） |
| SWR 组织名 | TODO |
| CCE 集群名称 | cloude-ljh-ys-kube |
| Kubernetes 版本 | v1.35.3-r0-35.0.8 |
| Worker 节点规格 | TODO（控制台节点规格截图待补） |
| Worker 节点数量 | 2 |
| OBS Bucket / 数据路径 | TODO |

截图记录：

- 图 1：CCE 集群详情截图。TODO
- 图 2：`kubectl get nodes -o wide` 输出截图。TODO
- 图 3：SWR 镜像仓库截图。TODO

## 第一部分：云计算平台搭建

### 任务1 应用容器化

操作记录：基于 `scaffold/part1-app` 完成 Flask 后端、Nginx 前端和 Redis 的本地容器编排。执行 `docker compose up --build` 后，backend 和 frontend 镜像构建成功，Redis 输出 `Ready to accept connections tcp`，Nginx 输出 `Configuration complete; ready for start up`，Flask 后端输出 `Running on http://127.0.0.1:5000`，说明三容器已正常启动。

关键修改：

- 后端额外 Python 包：`requests==2.32.3`
- 前端首页学号姓名：2023112456，刘俊豪
- 后端镜像地址：`swr.cn-east-3.myhuaweicloud.com/cloud-ljh-ys/backend:v1`
- 前端镜像地址：`swr.cn-east-3.myhuaweicloud.com/cloud-ljh-ys/frontend:v1`

截图记录：

- 图 4：`docker compose up --build` 运行成功与后端日志。已获得终端输出，需保存截图。
- 图 5：本地后端 API 与 Redis 联通验证。`curl http://localhost:5000/api/ping` 返回 `{"status":"ok"}`，`curl http://localhost:5000/api/redis` 返回 `{"redis":"ok"}`，需保存截图。
- 图 6：本地前端页面显示学号姓名。`curl http://localhost:18080` 返回的 HTML 中包含 `学号：2023112456` 和 `姓名：刘俊豪`，需保存浏览器或终端截图。
- 图 7：backend/frontend 镜像推送到 SWR。终端输出显示 `backend:v1` digest 为 `sha256:5344aeee70b9d1f230b7e9461765115fab08ecdaef88ab398803dcd0606e32ae`，`frontend:v1` digest 为 `sha256:f964948dde26b2ecbe236a96f08780b748e3370bbaa4a9a26f6aef980375f805`。
- 图 8：SWR 控制台 backend/frontend 镜像列表。已确认 `cloud-ljh-ys/backend:v1` 与 `cloud-ljh-ys/frontend:v1` 存在，且镜像已设置为公开，需保存控制台截图。

问题与解决：本地首次启动时，Redis 的宿主机端口 `6379` 已被占用，导致 Compose 无法绑定端口。由于后端和 Redis 处于同一个 Docker Compose 网络，Redis 不需要暴露到宿主机，因此删除 Redis 的 `6379:6379` 端口映射后继续启动。随后 frontend 绑定宿主机 `8080` 时发现端口已被占用，需改用其他宿主机端口后重新验证。

### 任务2 CCE 集群搭建

操作记录：在华为云 CCE 创建 Standard 集群 `cloude-ljh-ys-kube`，Region 与 SWR/OBS 保持一致，均为 `cn-east-3`。集群版本为 v1.35，已创建 2 个 Worker 节点，控制台显示可用节点/总数为 `2 / 2`。在 CloudShell 中执行 `kubectl get nodes -o wide`，两个节点 `192.168.0.124` 和 `192.168.0.204` 均为 Ready，版本为 `v1.35.3-r0-35.0.8`。

截图记录：

- 图 9：CCE 集群概览，显示 `cloude-ljh-ys-kube`、CCE Standard、Kubernetes v1.35、可用节点/总数 `2 / 2`。已获得控制台截图。
- 图 10：`kubectl get nodes -o wide`，显示 2 个 Worker 节点均为 Ready，版本为 `v1.35.3-r0-35.0.8`。已获得终端输出，需保存截图。

问题与解决：TODO

### 任务3 应用部署

操作记录：Kubernetes 清单位于 `scaffold/part1-k8s`。后端 Deployment 副本数为 2，Redis Deployment 副本数为 1；`backend-config` 注入 Redis 地址，`redis-secret` 注入 Redis 密码；后端 Service 使用 LoadBalancer 暴露公网入口，Redis Service 使用 ClusterIP。

核心资源：Deployment、Service、ConfigMap、Secret。

截图记录：

- 图 9：`kubectl get pods` 所有 Pod Running。TODO
- 图 10：`kubectl get svc` 后端 LoadBalancer 与 Redis ClusterIP。TODO
- 图 11：`curl http://<ELB_IP>/api/ping` 返回 `{"status":"ok"}`。TODO

问题与解决：TODO

### 任务4 Redis 持久化存储

操作记录：Redis 使用 `redis-data-pvc` 挂载到 `/data`，StorageClass 默认为华为云 EVS 的 `csi-disk`。实际 Bound 状态、写入、删除 Pod、重建后读取结果待截图补充。

截图记录：

- 图 12：`kubectl get pvc` 显示 Bound。TODO
- 图 13：写入 `SET testkey "hello"`。TODO
- 图 14：删除 Redis Pod 并重建。TODO
- 图 15：重建后 `GET testkey` 返回 `hello`。TODO

问题与解决：TODO

### 任务5 ConfigMap Volume 挂载

操作记录：前端 Nginx 配置由 `frontend-nginx-config` ConfigMap 以 Volume 形式挂载到 `/etc/nginx/conf.d/default.conf`。该挂载使用 `subPath`，修改 ConfigMap 后需要重建 Pod 才能保证文件内容刷新。

截图记录：

- 图 16：ConfigMap 中的 `nginx.conf`。TODO
- 图 17：Pod 内 `/etc/nginx/conf.d/default.conf` 内容。TODO
- 图 18：修改 ConfigMap 后验证配置更新。TODO

Volume 挂载与 envFrom 差异分析：`envFrom` 适合注入少量键值型配置，例如 Redis 主机名、端口等环境变量；ConfigMap Volume 适合注入完整配置文件，例如 Nginx 的 `default.conf`。使用 `subPath` 挂载单文件时，配置更新不会自动热更新到容器内，通常需要删除 Pod 由 Deployment 重建。

问题与解决：TODO

### 任务6 HPA 弹性伸缩

操作记录：后端 HPA 使用 `autoscaling/v2`，目标 Deployment 为 `backend`，`minReplicas=1`、`maxReplicas=4`、CPU 平均利用率目标为 60%。压测和扩缩容结果待截图补充。

截图记录：

- 图 19：`kubectl top nodes`。TODO
- 图 20：`kubectl get hpa`。TODO
- 图 21：压测命令与输出。TODO
- 图 22：扩容过程，Pod 数从 1 增加到 2 或更多。TODO
- 图 23：停压后缩容回 1。TODO

弹性伸缩分析：HPA 扩容不是瞬时发生，主要受 metrics-server 采集周期、HPA 控制器评估间隔和 Pod 启动时间影响。缩容通常更慢，因为需要冷却窗口避免短时间负载波动导致频繁扩缩容。该机制能在低负载时减少副本数、降低资源占用，在高负载时自动增加服务实例保障可用性。

问题与解决：TODO

## 第二部分：Spark 大数据分析

> 默认建议选择方向 A。如果你最终改选 MPI，把本章替换为方向 B 记录。

### A-0 Spark Operator 环境部署

操作记录：使用离线 Spark Operator Helm Chart 和 PySpark 镜像完成 Spark on K8s。`scaffold/part2-spark/analysis.py` 已实现豆瓣电影数据加载、缺失值统计、清洗、4 类查询和查询耗时输出；`pandas_benchmark.py` 用于单机 Pandas 对照；`plot_performance.py` 用于生成性能对比图。

截图记录：

- 图 24：Spark Operator Pod Running。TODO
- 图 25：SparkApplication YAML 关键参数。TODO
- 图 26：Driver/Executor Pod 状态。TODO
- 图 27：Driver 日志或 Completed 状态。TODO

问题与解决：TODO

### A-1 数据清洗

数据集：豆瓣电影数据集。

操作记录：读取豆瓣电影数据集，字段包括 `movie_id`、`title`、`year`、`rating_score`、`rating_count`、`genres`、`countries`、`directors`、`collect_count`、`summary` 等。脚本会打印 Schema、前 5 行、各字段缺失比例、清洗前后行数和数值字段统计信息。

缺失值处理策略：

| 字段 | 缺失比例 | 处理策略 | 原因 |
| --- | ---: | --- | --- |
| `year`、`rating_score` | TODO | `dropna` 删除缺失行 | 年份和评分是后续趋势分析、排序和聚合的核心字段，缺失会影响统计准确性 |
| `genres`、`countries`、`directors`、`summary` | TODO | `fillna` 填充为“未知”或“暂无简介” | 文本类字段缺失不应直接丢弃整行，填充后仍可保留电影记录参与其他统计 |

截图记录：

- 图 28：DataFrame Schema。TODO
- 图 29：前 5 行样例。TODO
- 图 30：各字段缺失值比例。TODO
- 图 31：清洗前后行数与统计信息。TODO

分析：TODO

### A-2 Spark SQL 统计分析

| 编号 | 查询类型 | 查询目标 | 截图 | 分析 |
| --- | --- | --- | --- | --- |
| Q1 | GROUP BY 聚合 | 按电影类型统计数量、平均评分和平均评分人数 | 图 32 | TODO（不少于 50 字） |
| Q2 | ORDER BY Top-N | 按收藏数选出 Top 10 电影 | 图 33 | TODO（不少于 50 字） |
| Q3 | 时间维度趋势 | 按年份统计电影数量、平均评分和总评分人数 | 图 34 | TODO（不少于 50 字） |
| Q4 | 窗口函数 | 按国家/地区分组，选出各组评分排名前三的电影 | 图 35 | TODO（不少于 50 字） |

### A-3 性能对比与 Amdahl 分析

| 实现方式 | Executor 数 | 运行时间 / s | 加速比 |
| --- | ---: | ---: | ---: |
| Pandas | 0 | TODO | 1.00 |
| PySpark | 1 | TODO | TODO |
| PySpark | 2 | TODO | TODO |

截图记录：

- 图 36：Pandas 运行时间。TODO
- 图 37：PySpark executor=1 运行时间。TODO
- 图 38：PySpark executor=2 运行时间。TODO
- 图 39：性能对比图。TODO

Amdahl 分析：根据 Pandas、PySpark 1 executor 和 PySpark 2 executor 的实测耗时计算加速比。若 2 executor 加速比低于线性，主要原因通常包括 Spark 作业启动开销、任务调度开销、数据读取与序列化成本、Shuffle 或跨节点通信成本，以及数据规模相对较小时并行部分占比不足。

## 附加题记录

### 附加题1 监控系统

操作记录：使用离线 `kube-prometheus-stack` Chart 部署 Prometheus、Grafana、Alertmanager、node-exporter 等组件。`resources/离线包/monitoring/monitoring-values.yaml` 需要替换为个人 SWR 镜像地址后安装。

截图记录：

- 图 40：monitoring 命名空间 Pod Running。TODO
- 图 41：Grafana 节点 CPU 利用率折线图。TODO
- 图 42：Grafana Pod 内存使用柱状图。TODO

指标说明：TODO（至少 3 个指标，例如节点 CPU 利用率、Pod 内存使用量、容器重启次数）

Prometheus Pull 原理说明：Prometheus 按配置周期性主动访问各采集目标的 HTTP 指标端点，将时间序列样本拉取到本地存储。相比业务主动推送，Pull 模型便于集中发现目标、判断目标是否存活，并统一控制采集间隔。

### 附加题2 CI/CD 流水线

操作记录：已新增 `.github/workflows/deploy.yml`。流水线在 `main` 分支相关文件变更后触发，构建 backend/frontend 镜像，推送到 SWR，并通过 kubeconfig 执行 `kubectl set image` 更新 CCE 中的 Deployment。

截图记录：

- 图 43：流水线各阶段 Passed。TODO
- 图 44：SWR 镜像 tag 自动更新。TODO
- 图 45：K8s Deployment 镜像 tag 自动更新。TODO

CI/CD 与 GitOps 说明：持续集成关注代码提交后的自动构建、检查和镜像产物生成；持续部署关注通过流水线把验证后的产物发布到运行环境。GitOps 强调以 Git 仓库中的声明式配置作为期望状态，由自动化系统持续对齐集群实际状态与 Git 中的配置。

### 附加题3 前沿专题

选题：C-2 边缘计算模拟：K3s + MQTT

专题内容：已新增 `scaffold/addon-c2-mqtt`。实验链路为 K3s 边缘传感器发布 MQTT 消息，CCE 内 Mosquitto Broker 接收消息，CCE 内 subscriber 订阅后写入 Redis。由于 CCE Pod 出方向访问公网 MQTT Broker 可能受限，本方案在 CCE 内自建 Mosquitto，并通过 LoadBalancer 暴露 MQTT 入口给 K3s 发布者。1500 字专题分析和截图待实验完成后补充。

## 总结与收获

TODO（不少于 200 字，包含量化数据、主要挑战和解决思路）

## 附录

- 附录 A：Dockerfile、docker-compose.yml、核心应用代码。TODO
- 附录 B：Kubernetes YAML。TODO
- 附录 C：Spark 分析代码：`scaffold/part2-spark/analysis.py`、`pandas_benchmark.py`、`plot_performance.py`。TODO
- 附录 D：附加题配置或流水线文件：`.github/workflows/deploy.yml`、`scaffold/addon-c2-mqtt/`、监控 values。TODO
- 代码仓库链接：TODO
