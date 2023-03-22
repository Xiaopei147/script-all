#!/bin/bash
#-*- coding:utf-8 -*-
hostname=`hostname`
proc_name='docker'
ip=`curl ifconfig.co`
pid=`ps -ef |grep $proc_name |grep -v grep |awk '{print $2}'`
Message="$hostname $ip 服务器$proc_name 进程异常，请留意！"
if [[ $pid = "" ]]
then
#curl ‘*~~钉钉机器人链接~~* ’ \
curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/sen' \
   -H 'Content-Type: application/json' \
   -d "
  {\"msgtype\": \"text\", 
    \"text\": {
        \"content\": \"$Message\"
     }
