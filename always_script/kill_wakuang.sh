#!/bin/bash
#kill掉挖矿进程
ps -aux | grep kinsing |grep -v grep|cut -c 9-15 | xargs kill -9 
ps -aux | grep kdevtmpfsi |grep -v grep|cut -c 9-15 | xargs kill -9 
#进行这一步之前要确认下该用户下是否有其他的计划任务在，该动作会清空www用户下的所有计划任务
crontab -r -u www
#删除挖矿文件
rm -f /tmp/kinsing
rm -f /tmp/kdevtmpfsi
