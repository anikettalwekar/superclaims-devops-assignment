from celery import Celery
import os
import time
import logging

logging.basicConfig(level=logging.INFO)

REDIS_URL = os.getenv("REDIS_URL", "redis://redis:6379/0")

celery = Celery(
    "worker",
    broker=REDIS_URL,
    backend=REDIS_URL,
)

@celery.task
def write_log_celery(message: str):
    time.sleep(5)
    logging.info(message)
    return f"Task completed: {message}"
