#!/usr/bin/python3
import requests
import json
import sys
import os
import datetime

os.system('./usr/lib/zabbix/alertscripts/curl.sh') #调用@人员脚本，可调整位置，放在末尾即可实现末尾@人员
url = "https://open.feishu.cn/open-apis/bot/v2/hook/XXXXXXXXXX" #你复制的webhook地址粘贴进url内


def send_message(message):
    payload_message = {
        "msg_type": "text",
        "content": {
            "text": message
        }
    }
    headers = {
        'Content-Type': 'application/json'
    }

    response = requests.request("POST", url, headers=headers, data=json.dumps(payload_message))
    return response


if __name__ == '__main__':
    text = sys.argv[1]
    send_message(text)

