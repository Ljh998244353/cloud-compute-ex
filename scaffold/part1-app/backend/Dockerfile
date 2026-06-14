# ── Stage 1: 安装依赖 ─────────────────────────────────
FROM python:3.11-slim AS builder
WORKDIR /build
COPY requirements.txt .
# 将依赖安装到 /build/packages，不污染运行时镜像
RUN pip install --no-cache-dir -r requirements.txt --target /build/packages

# ── Stage 2: 运行时镜像（更小） ──────────────────────
FROM python:3.11-slim
WORKDIR /app
# 只复制依赖包和代码，不包含 pip/编译工具
COPY --from=builder /build/packages /app/packages
COPY . .
ENV PYTHONPATH=/app/packages
EXPOSE 5000
CMD ["python", "app.py"]

# ── requirements.txt 示例（按需添加其他包）─────────────
# flask==3.0.0
# redis==5.0.1
# requests==2.32.3      ← 已加入的自选 Python 包
