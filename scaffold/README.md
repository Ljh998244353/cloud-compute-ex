# 云计算课程设计代码脚手架

来源：`asst/课程设计任务书.docx` 附录 A/B。

本目录把任务书后附的 Dockerfile、Compose、K8s YAML、SparkApplication、MPIJob 和示例 Python 代码拆成可编辑文件，方便后续逐步补全。少数 Dockerfile 引用但 Word 未给出的文件已放置占位版本，并在文件内标注 TODO。

## 目录

- `part1-app/`：第一部分容器化 Web 应用脚手架。
- `part1-k8s/`：第一部分 CCE 部署、PVC、HPA 等 YAML 模板。
- `part2-spark/`：第二部分方向 A Spark on K8s 模板。
- `part2-mpi/`：第二部分方向 B MPI on K8s 模板。

## 必须替换的占位符

- `<YOUR_STUDENT_ID>`：你的学号。
- `<YOUR_NAME>`：你的姓名。
- `<YOUR_ORG>`：你的华为云 SWR 组织名。
- `<YOUR_BASE64_ENCODED_PASSWORD>`：Redis 密码的 base64 编码。
- `<BUCKET>`：OBS Bucket 或教师提供的数据路径。

## 后续补全建议

1. 先补 `part1-app/backend/app.py` 和 `part1-app/frontend/static/index.html`。
2. 根据实际 SWR Region 和组织名替换所有镜像地址。
3. Secret 不要写明文密码，使用 `echo -n "your_password" | base64`。
4. 如果使用离线包里的 MPI Operator，`mpijob.yaml` 的 `apiVersion` 建议使用 `kubeflow.org/v2beta1`，问题合集里说明了原任务书的 `kubeflow.org/v1` 可能不匹配。
