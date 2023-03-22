#!/bin/bash
#create user github:Xiaopei147
#create date 2022/2/28 08:00:00(CST)
#add to github date 2022/3/2 14:30(CST)
#####################################################
##⚠⚠⚠⚠⚠⚠⚠⚠The copyright of this script is mine##
##⚠⚠⚠⚠⚠⚠⚠⚠      这个脚本的版权是我              ##
#####################################################
ip_c=`/sbin/ip a |grep "scope global eth0" |wc -l`
status=`/sbin/service xxx status |grep "running"|wc -l`
stop=`/sbin/service xxx status |grep "stopped" |wc -l`
date=`/bin/date`
pid=`ps -ef |grep xxx |grep -v grep |awk '{print $2}'`
if [ $ip_c -eq 2 ]
then 
 #/sbin/service xxx status >>/tmp/vip.log
 if [ $status -ne 1 ]
 then
 echo "========" >>/tmp/vip.log
 echo "服务重启" >>/tmp/vip.log
 echo $date >>/tmp/vip.log
 echo "ip数量是:$ip_c" >>/tmp/vip.log 
 echo "服务状态是:$status(1.start 0.no start)" >>/tmp/vip.log
 /bin/kill  $pid >>/tmp/vip.log 2>&1
 rm -rf /var/run/xxx.pid >>/tmp/vip.log
 /sbin/service xxx restart >>/tmp/vip.log
  if [ $status -ne 1 ]
  then
  /bin/bash vip.sh;
  else
  echo "service restart"
  fi
 else
 echo "service is ok" >>/dev/null
 fi
else
 if [ $stop -ne 1 ] 
 then 
  echo "========" >>/tmp/vip.log
  echo "服务关闭" >>/tmp/vip.log
  echo $date >>/tmp/vip.log
  echo "ip数量是:$ip_c" >>/tmp/vip.log
  echo "服务状态是:$status(1.start 0.no start)" >>/tmp/vip.log
  /sbin/service xxx stop >>/tmp/vip.log
 else
  echo "" >/dev/null
fi
fi
