#!/bin/bash
date=`date`
data=`cat /root/tst/url.list`

rm -rf /root/tst/result.log

echo $date >>/root/tst/result.log
for url in $data
do
code=`curl -o /dev/null --retry 3 --retry-max-time 30 -s -w %{http_code} $url`
echo "HTTP Status of $url is $code ">>/root/tst/result.log
done
