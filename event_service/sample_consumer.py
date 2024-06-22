# import json
# from typing import Any
#
# from confluent_kafka import Consumer, Message
# from sqlalchemy.orm import Session
#
# from database import engine
# from event_services.config import read_ccloud_config
# from event_services.tasks import create_order_and_publish_message
#
# props: dict[str, Any] = read_ccloud_config()
# props["group.id"] = "python-group-1"
# props["auto.offset.reset"] = "earliest"
#
# consumer: Consumer = Consumer(props)
# consumer.subscribe(["order-request"])
#
#
# def polling_start() -> None:
#     try:
#         while True:
#             msg: Message | None = consumer.poll(1.0)
#             if msg is None:
#                 continue
#             if msg.error():
#                 print("Consumer error: {}".format(msg.error()))
#                 continue
#
#             if msg.topic() == "order-request":
#                 print(
#                     f"key: {msg.key().decode('utf-8')} | value: {msg.value().decode('utf-8')}"
#                 )
#                 product_value: dict[str, Any] = json.loads(msg.value().decode("utf-8"))
#                 product_id: str = product_value.get("product_id")
#                 with Session(engine) as db:
#                     create_order_and_publish_message(db, product_id=product_id)
#     except KeyboardInterrupt:
#         pass
#     finally:
#         consumer.close()
#
