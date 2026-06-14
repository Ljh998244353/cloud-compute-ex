import json
import os
import random
import time

import paho.mqtt.client as mqtt


BROKER = os.environ.get("BROKER_HOST", os.environ.get("BROKER", "localhost"))
PORT = int(os.environ.get("BROKER_PORT", os.environ.get("PORT", "1883")))
TOPIC = os.environ.get("MQTT_TOPIC", "sensor/temperature")
DEVICE_ID = os.environ.get("DEVICE_ID", "sensor_001")
INTERVAL_SECONDS = float(os.environ.get("INTERVAL_SECONDS", "1"))


def build_payload():
    return {
        "device_id": DEVICE_ID,
        "temperature": 25 + random.uniform(-5, 5),
        "humidity": 60 + random.uniform(-10, 10),
        "timestamp": time.time(),
    }


def main():
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.connect(BROKER, PORT, 60)
    client.loop_start()

    while True:
        data = build_payload()
        client.publish(TOPIC, json.dumps(data), qos=1)
        print(f"Published: {data}", flush=True)
        time.sleep(INTERVAL_SECONDS)


if __name__ == "__main__":
    main()
