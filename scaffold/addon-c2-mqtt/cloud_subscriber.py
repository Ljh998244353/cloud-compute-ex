import json
import os
import time

import paho.mqtt.client as mqtt
import redis


BROKER = os.environ.get("BROKER_HOST", os.environ.get("BROKER", "localhost"))
PORT = int(os.environ.get("BROKER_PORT", os.environ.get("PORT", "1883")))
TOPIC = os.environ.get("MQTT_TOPIC", "sensor/temperature")
REDIS_HOST = os.environ.get("REDIS_HOST")
REDIS_PORT = int(os.environ.get("REDIS_PORT", "6379"))
REDIS_PASSWORD = os.environ.get("REDIS_PASSWORD") or None

messages = []
redis_client = None

if REDIS_HOST:
    redis_client = redis.Redis(
        host=REDIS_HOST,
        port=REDIS_PORT,
        password=REDIS_PASSWORD,
        decode_responses=True,
    )


def on_connect(client, userdata, flags, reason_code, properties):
    print(f"Connected to MQTT broker: {reason_code}", flush=True)
    client.subscribe(TOPIC, qos=1)
    print(f"Subscribed to {TOPIC}. Waiting for messages...", flush=True)


def on_message(client, userdata, msg):
    payload = msg.payload.decode()
    data = json.loads(payload)
    messages.append(data)

    if len(messages) > 100:
        messages.pop(0)

    if redis_client is not None:
        key = f"mqtt:{int(time.time())}"
        redis_client.set(key, payload)
        redis_client.lpush("mqtt_messages", payload)
        redis_client.ltrim("mqtt_messages", 0, 99)
        print(f"Stored in Redis as {key}", flush=True)

    print(f"Received: {data}", flush=True)
    print(f"Total messages: {len(messages)}", flush=True)


def main():
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(BROKER, PORT, 60)
    client.loop_forever()


if __name__ == "__main__":
    main()
