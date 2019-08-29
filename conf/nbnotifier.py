# https://reiyw.com/post/sending-notification-to-slack-from-jupyter-notebook/
import json
import os
import socket

from IPython.core.magic import register_line_magic
import requests


@register_line_magic
def slack(line):
    assert 'SLACK_WEBHOOKS_URL' in os.environ
    webhooks_url = os.environ['SLACK_WEBHOOKS_URL']
    sender = os.environ.get('SLACK_SENDER', socket.gethostname())
    payload = {
        'text':
        line
        if line else 'A cell that was running on *{}* has finished.'.format(
            sender)
    }
    r = requests.post(webhooks_url, data=json.dumps(payload))
