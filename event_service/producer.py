import json
from typing import Any

from confluent_kafka import Producer

from event_services.config import read_ccloud_config

producer: Producer = Producer(read_ccloud_config())


def publish(topic: str, key: str, value: dict[str, Any]) -> None:
    key_bytes: bytes = key.encode("utf-8")
    value_bytes: bytes = json.dumps(value).encode("utf-8")
    producer.produce(topic, key=key_bytes, value=value_bytes)

