BOT_TOKEN = 'token'
GATEWAY_URL = 'https://example.com'
RETRANSMISSION_URL = GATEWAY_URL + '/retransmit/' + BOT_TOKEN
CELERY_BROCKER_URL = 'amqp://worker:w@localhost/vhost'
CELERY_RESULT_BACKEND = 'rpc://'

#from config import *
