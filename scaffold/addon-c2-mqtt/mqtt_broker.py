import asyncio

from amqtt.broker import Broker


config = {
    "listeners": {
        "default": {
            "type": "tcp",
            "bind": "0.0.0.0:1883",
        },
    },
}


async def main():
    broker = Broker(config)
    await broker.start()
    print("MQTT Broker started on port 1883", flush=True)
    await asyncio.sleep(float("inf"))


if __name__ == "__main__":
    asyncio.run(main())
