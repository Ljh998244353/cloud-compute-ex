import os

from flask import Flask, jsonify
import redis


app = Flask(__name__)


def redis_client():
    password = os.getenv("REDIS_PASSWORD") or None
    return redis.Redis(
        host=os.getenv("REDIS_HOST", "redis"),
        port=int(os.getenv("REDIS_PORT", "6379")),
        password=password,
        decode_responses=True,
    )


@app.get("/api/ping")
def ping():
    # TODO: 后续实验可在这里增加 Redis 读写，用于证明前后端和 Redis 联通。
    return jsonify(status="ok")


@app.get("/api/redis")
def redis_check():
    client = redis_client()
    client.set("last_ping", "ok")
    return jsonify(redis=client.get("last_ping"))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
