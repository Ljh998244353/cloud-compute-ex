import os
import time

import paho.mqtt.client as mqtt
import redis


BROKER_HOST = os.environ.get("BROKER_HOST", "mosquitto-svc")
BROKER_PORT = int(os.environ.get("BROKER_PORT", "1883"))
TOPIC = os.environ.get("MQTT_TOPIC", "edge/sensor")
REDIS_HOST = os.environ.get("REDIS_HOST", "redis-svc")
REDIS_PORT = int(os.environ.get("REDIS_PORT", "6379"))
REDIS_PASSWORD = os.environ.get("REDIS_PASSWORD") or None


redis_client = redis.Redis(
    host=REDIS_HOST,
    port=REDIS_PORT,
    password=REDIS_PASSWORD,
    decode_responses=True,
)


def on_connect(client, userdata, flags, reason_code, properties):
    print(f"[Subscriber] connected: {reason_code}", flush=True)
    client.subscribe(TOPIC, qos=1)


def on_message(client, userdata, message):
    payload = message.payload.decode("utf-8")
    key = f"mqtt:{int(time.time())}"
    redis_client.set(key, payload)
    redis_client.lpush("mqtt_messages", payload)
    redis_client.ltrim("mqtt_messages", 0, 49)
    print(f"[Subscriber] stored {key}: {payload}", flush=True)


def main():
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(BROKER_HOST, BROKER_PORT, keepalive=60)
    client.loop_forever()


if __name__ == "__main__":
    main()
