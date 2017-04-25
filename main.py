from celery import Celery
import default_config

celery = Celery('main', backend=default_config.CELERY_RESULT_BACKEND, broker=default_config.CELERY_BROKER_URL, task_acks_late=True)

import tasks
