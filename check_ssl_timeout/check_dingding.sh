#!/bin/bash

#监控域名证书到期发送钉钉消息通知

PHONE="187213xxxxx"
TOKEN="https://oapi.dingtalk.com/robot/send?access_token="



for yuming in `cat domain_ssl.txt` #读取存储了需要监控的域名文件
do
    END_TIME=$(echo | openssl s_client -servername $yuming  -connect $yuming:443 2>/dev/null | openssl x509 -noout -dates |grep 'After'| awk -F '=' '{print $2}'| awk -F ' +' '{print $1,$2,$4 }')

    #使用openssl获取域名的证书情况，然后获取其中的到期时间
    END_TIME1=$(date +%s -d "$END_TIME") #将日期转化为时间戳
    NOW_TIME=$(date +%s -d "$(date | awk -F ' +'  '{print $2,$3,$6}')") #将目前的日期也转化为时间戳

    NEW_TIME=$(($(($END_TIME1-$NOW_TIME))/(60*60*24))) #到期时间减去目前时间再转化为天数

    if [ $NEW_TIME -lt 7 ];  #当到期时间小于7天时，发钉钉群告警
    then
        curl -H "Content-Type:application/json" -X POST --data '{"msgtype":"text","text":{"content":" zabbix  域名：'$yuming'   ssl证书到期日期，剩余：'$NEW_TIME' 天"} , "at": {"atMobiles": ['${PHONE}'], "isAtAll": false}}' ${TOKEN} > /dev/null 2>&1
    fi
done