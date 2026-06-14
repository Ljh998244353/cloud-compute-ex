FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY cloud_subscriber.py mqtt_broker.py sensor_publisher.py ./
COPY publisher.py subscriber.py ./

CMD ["python", "cloud_subscriber.py"]
