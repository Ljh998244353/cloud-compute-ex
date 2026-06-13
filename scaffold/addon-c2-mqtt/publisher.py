import json
import os
import random
import time

import paho.mqtt.client as mqtt


BROKER_HOST = os.environ.get("BROKER_HOST", "mosquitto-lb")
BROKER_PORT = int(os.environ.get("BROKER_PORT", "1883"))
TOPIC = os.environ.get("MQTT_TOPIC", "edge/sensor")
INTERVAL_SECONDS = float(os.environ.get("INTERVAL_SECONDS", "2"))
DEVICE_ID = os.environ.get("DEVICE_ID", "k3s-edge-01")


def build_payload():
    return {
        "device_id": DEVICE_ID,
        "temperature": round(random.uniform(18.0, 32.0), 2),
        "humidity": round(random.uniform(35.0, 80.0), 2),
        "ts": int(time.time()),
    }


def main():
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.connect(BROKER_HOST, BROKER_PORT, keepalive=60)
    client.loop_start()
    while True:
        payload = json.dumps(build_payload(), ensure_ascii=False)
        client.publish(TOPIC, payload, qos=1)
        print(f"[Publisher] {TOPIC} {payload}", flush=True)
        time.sleep(INTERVAL_SECONDS)


if __name__ == "__main__":
    main()
