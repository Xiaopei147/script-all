#!/bin/bash
NUM=$(/bin/bash check.sh |grep -e 200 -e 000 | wc -l)
NUMM=$(cat url.list |wc -l)
if [ $NUM -ne  $NUMM ]
then
mail -s "Service Confirm - Critical" xxx@163.com < result.log 
else
mail -s "Service Confirm - ok" xxx@163.com < result.log 
fi