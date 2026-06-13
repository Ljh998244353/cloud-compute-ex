# 满分导向完成计划

生成时间：2026-06-13  
目标：100 分基础分全部覆盖，并尽量完成 15 分附加题。所有实验步骤默认由你亲自执行；我负责准备脚手架、检查命令、记录实验证据、提醒截图、排查问题和维护报告。

## 0. 当前资料状态

- [x] 已读取 `asst/课程设计任务书.docx` 并转换为 `docs/course-design-taskbook.md`。
- [x] 已读取 `asst/课设问题合集.pdf` 并转换为 `docs/course-design-faq.md`。
- [x] 已解压离线资源到 `resources/离线包/`。
- [x] 已解压 Helm 到 `resources/helm-v4.2.0/`。
- [x] 已生成资源清单 `docs/resource-inventory.md`。

## 1. 先决信息收集

你开始实验前，需要把以下信息记录到报告草稿中：

- 学号、姓名、班级、组队成员与分工比例。
- 华为云 Region，建议 CCE、SWR、OBS 全部同 Region。
- SWR 组织名、镜像命名规则、是否公开镜像。
- CCE 集群版本、节点规格、节点数量。
- OBS bucket 路径或数据集上传位置。

必须截图：华为云代金券/资源概览可选，CCE 集群详情、节点列表、SWR 组织或镜像列表、OBS 数据位置。

## 2. 第一部分：云计算平台搭建（50 分）

### 任务1 应用容器化（10 分）

交付目标：后端 Flask + Redis、前端 Nginx 首页、本地 compose 联通、前后端镜像推送 SWR。

证据清单：

- Dockerfile.backend 保留多阶段构建，`requirements.txt` 加至少 1 个额外 Python 包。
- `static/index.html` 显示你的学号和姓名。
- `docker compose up --build` 成功截图，后端日志能看到请求。
- SWR 控制台截图，必须看到 backend/frontend 镜像名与 tag。

注意：若 SWR 报 manifest 错，构建加 `--provenance=false`。

### 任务2 CCE 集群搭建（8 分）

交付目标：K8s >= 1.27，至少 2 个 Worker Ready。

证据清单：

- CCE 集群详情截图，包含版本。
- `kubectl get nodes -o wide` 截图，包含 `STATUS=Ready` 和 `VERSION` 列。

注意：若资源不足，优先补 2 vCPU / 8 GiB 节点，记录原因。

### 任务3 应用部署（12 分）

交付目标：Deployment、Service、ConfigMap、Secret 全部正确，`/api/ping` 公网可访问。

证据清单：

- `kubectl get deployments,svc,cm,secret,pods -o wide` 截图。
- `kubectl get pods` 所有 Pod Running 截图。
- 浏览器或 `curl http://<ELB_IP>/api/ping` 返回 `{"status":"ok"}` 截图。
- YAML 附录包含后端副本=2、Redis 副本=1、resources、LoadBalancer、Redis ClusterIP、ConfigMap、Secret。

### 任务4 持久化存储（10 分）

交付目标：Redis PVC Bound，Pod 删除重建后数据不丢。

证据清单：

- `kubectl get pvc` 截图，`redis-data-pvc` 为 Bound。
- `redis-cli SET testkey "hello"` 截图。
- `kubectl delete pod <redis-pod>` 和新 Pod Running 截图。
- `redis-cli GET testkey` 返回 `hello` 截图。

### 任务5 ConfigMap Volume 挂载（5 分）

交付目标：Nginx 反向代理配置通过 ConfigMap volume 挂载。

证据清单：

- ConfigMap YAML 截图或代码附录，data 中包含完整 `nginx.conf`。
- `kubectl exec <frontend-pod> -- cat /etc/nginx/conf.d/default.conf` 截图。
- 修改 ConfigMap 后重新验证文件内容截图。若使用 `subPath`，记录需要重建 Pod 才更新。
- 报告写清 Volume 挂载与 envFrom 的适用差异。

### 任务6 HPA 弹性伸缩（5 分）

交付目标：backend HPA 1 到 4 副本，压测触发扩容，停压后缩容。

证据清单：

- `kubectl top nodes` 截图。
- `kubectl get hpa` 截图。
- 压测命令截图，例如 `ab -n 10000 -c 200 http://<ELB_IP>/api/ping`。
- `kubectl get pods -w` 扩容到 2 个或更多 Pod 截图。
- 停止压测约 5 分钟后缩回 1 个 Pod 截图。
- 分析 metrics 采集周期、HPA 评估间隔、冷却时间和降本价值。

## 3. 第二部分建议选择：方向 A Spark（40 分）

建议优先选择方向 A，因为仓库已有 `douban_movies.csv`，任务书要求也正好覆盖数据清洗、SQL、性能分析，报告更容易拿满。方向 B 也可做，但 MPI 非阻塞优化和 K8s MPI Operator 故障面更宽。

### A-0 环境部署（10 分）

- `docker load` Spark Operator 与 PySpark 镜像，重打 tag 到个人 SWR 并 push。
- 使用 `resources/离线包/spark/spark-operator/` 离线安装 Spark Operator。
- 提交 WordCount 或最小 PySpark 作业。

截图：Spark Operator Pod Running、SparkApplication YAML、Driver/Executor Pod、Driver Completed 或日志。

### A-1 数据清洗（10 分）

- 使用豆瓣电影数据，加载 DataFrame，打印 Schema 与前 5 行。
- 统计每列缺失值比例。
- 至少两列使用不同策略，例如 `year/rating_score` dropna，`genres/countries/directors/summary` fillna。
- 输出清洗前后行数与基本统计。

截图：Schema、前 5 行、缺失比例、清洗前后统计。

### A-2 Spark SQL 统计分析（15 分）

至少 4 个查询，建议固定为：

- GROUP BY：按类型或国家统计电影数量与平均评分。
- ORDER BY Top-N：评分人数最多或收藏数最高 Top 10。
- 时间趋势：按年份统计电影数量、平均评分、评分人数趋势。
- 窗口函数或 JOIN：按国家/类型内部评分排名，或电影表与类型拆分表 JOIN。

每个查询必须有结果截图和不少于 50 字分析。

### A-3 性能对比与 Amdahl 分析（5 分）

- 同一个查询分别用 Pandas、PySpark executor=1、PySpark executor=2 运行。
- 记录执行时间，绘制柱状图或折线图。
- 用 `S=T1/Tp` 计算加速比，结合 Amdahl 定律解释未线性加速的原因。

## 4. 附加题策略（最高 +15 分）

优先顺序：

1. 附加题1 监控系统（+5）：资源包齐全，和 CCE 环境强相关，性价比最高。
2. 附加题2 CI/CD（+5）：如果 GitHub/Gitee 可用，再做；注意 SWR 临时 Token 与 KubeConfig Secret。
3. 附加题3 前沿专题（+5）：时间充裕再选 C2 K3s + MQTT 或分布式 AI。它要求不少于 1500 字，证据量较大。

## 5. 报告质量保分规则（10 分）

- 每张图都要编号、标题、说明它证明了什么。
- 命令截图要露出命令、输出、关键字段和时间上下文。
- 不贴空白截图、不贴无法辨认的小图。
- 每个任务都写“遇到的问题与解决”，即使没出错，也写“未遇到阻塞，按预期完成”。
- 总结不少于 200 字，要包含量化数据，例如节点规格、Pod 副本变化、查询耗时、加速比。

## 6. 协作方式

- 你每完成一个实验步骤，把命令输出或截图描述发给我；我会帮你判断是否够评分，并更新 `docs/report.md`。
- 遇到报错时，优先提供：执行命令、完整错误、`kubectl describe`、相关 YAML 片段。
- 我不会在报告中编造你没有做过的实验结果；缺失证据会用 `TODO` 标记。
