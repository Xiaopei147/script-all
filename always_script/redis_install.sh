#!/bin/bash
ps -ef |grep redis  |grep -v grep |grep -v install

if [ $? -eq 0 ]
then
    echo "redis进程已经启动，退出脚本"
    exit
fi


echo "---------下载redis5.0---------------"
mkdir -pv /data/software

ls -l /data/software   |grep "redis-5.0"

if [ $? -ne 0 ]
then
    wget  http://download.redis.io/releases/redis-5.0.3.tar.gz  -P /data/software
else
    echo "redis 已存在"
    exit
fi

cd /data/software
tar -xf redis-5.0.3.tar.gz && cd  redis-5.0.3

make && make install PREFIX=/usr/local/redis

cp /data/software/redis-5.0.3/redis.conf /etc/redis.conf

sed -i 's/daemonize no/daemonize yes/g' /etc/redis.conf

cat > /usr/lib/systemd/system/redis.service << EOF
[Unit]
Description=redis-server
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/redis/bin/redis-server /etc/redis.conf
PrivateTmp=true

[Install]
WantedBy=multi-user.target


EOF

systemctl daemon-reload

systemctl enable redis

systemctl start redis

