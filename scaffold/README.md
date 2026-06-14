# 云计算课程设计代码脚手架

本目录保存课程报告实际用到的应用代码、Kubernetes 清单、Spark 分析代码和附加题代码。

## 目录

- `part1-app/`：Flask 后端、Nginx 前端和 Docker Compose 本地联调。
- `part1-k8s/`：CCE 部署、PVC、ConfigMap、Secret、Service 和 HPA 清单。
- `part2-spark/`：SparkApplication、PySpark 分析脚本和 Pandas 性能对比脚本。
- `addon-c2-mqtt/`：K3s + MQTT 边缘计算附加题代码。

## 必须替换的占位符

- `<YOUR_ORG>`：你的华为云 SWR 组织名。
- `<YOUR_BASE64_ENCODED_PASSWORD>`：Redis 密码的 base64 编码。如清单已替换为实际实验值，提交前确认不含明文密码。

## 提交说明

离线镜像包、原始任务书附件和截图暂存目录不放入 GitHub。正式报告工程位于仓库根目录的 `swjtu-course-report/`。
