#!/bin/bash

curl -X POST -H "Content-Type: application/json" \
        -d '{"msg_type":"text","content": " {\"text\":\"<at user_id=\\\"user_id\\\"></at> '$message'\"}"}' \
        https://open.feishu.cn/open-apis/bot/v2/hook/XXXXXXXXXXXXXXX  #飞书webhook地址
