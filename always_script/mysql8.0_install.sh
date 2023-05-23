#!/bin/bash
read -p "生产环境安装数据库需要谨慎操作，开始执行该脚本前，一定要做现有数据库的备份！请再次确定是否要执行该脚本(Y/N)" is
if [ $is == y ] || [ $is == Y ]
then
        continue >>/dev/null 2>&1
        

ps -ef |grep mysqld |grep -v grep

if [ $? -eq 0 ]
then
    echo "mysql进程已经启动，退出脚本"
    exit
fi






echo "-----------mysql二进制包开始安装------------"

echo "----卸载已安装mysql----"
rpm -qa |grep mysql   &&   yum remove *mysql* -y
rpm -qa |grep mariadb &&   yum remove *mariadb* -y

echo "----创建mysql----用户"
useradd mysql -s /sbin/nologin >/dev/null 2>&1

echo "-----下载mysql包----"

mkdir -pv  /data/software
cd /data/software
ls -l /data/software   |grep "mysql-8.0.31"


if [ $? -ne 0 ]
then
    wget https://cdn.mysql.com/archives/mysql-8.0/mysql-8.0.31-linux-glibc2.12-x86_64.tar.xz -P /data/software
else
    echo "mysql 已存在,正在进行解压操作！"
    continue >> /dev/null 2>&1
fi

if [ ! -d /usr/local/mysql ]
then
    cd /data/software
    tar -xvf mysql-8.0.31-linux-glibc2.12-x86_64.tar.xz
    mv /data/software/mysql-8.0.31-linux-glibc2.12-x86_64  /usr/local/mysql
fi


mkdir -pv  /data/mysql/{data,logs,binlogs}
mkdir -pv  /usr/local/mysql/{etc,run}


echo "---建立软连接---"

ln -snf /data/mysql/binlogs   /usr/local/mysql/binlogs
ln -snf /data/mysql/data   /usr/local/mysql/data
ln -snf /data/mysql/logs   /usr/local/mysql/logs

echo "-----更改权限-----"
chown -R mysql.mysql /usr/local/mysql/
chown -R mysql.mysql /data/mysql

grep mysql /etc/profile

if [ $? -ne 0 ]
then
    echo "export PATH=$PATH:/usr/local/mysql/bin" >> /etc/profile
fi
source /etc/profile


cat > /etc/my.cnf << EOF
[client]
port = 3306
socket = /usr/local/mysql/run/mysql.sock
[mysqld]
port = 3306
socket = /usr/local/mysql/run/mysql.sock
pid_file = /usr/local/mysql/run/mysql.pid
datadir = /usr/local/mysql/data
default_storage_engine = InnoDB
max_allowed_packet = 512M
max_connections = 2048
open_files_limit = 65535
explicit_defaults_for_timestamp=true
skip-name-resolve
lower_case_table_names=1
innodb_buffer_pool_size = 1024M
innodb_log_file_size = 2048M
innodb_file_per_table = 1
innodb_flush_log_at_trx_commit = 0
key_buffer_size = 64M
log-error = /usr/local/mysql/logs/mysql_error.log
log-bin = /usr/local/mysql/binlogs/mysql-bin
slow_query_log = 1
slow_query_log_file = /usr/local/mysql/logs/mysql_slow_query.log
long_query_time = 5
tmp_table_size = 32M
max_heap_table_size = 32M
server-id=1
binlog_format=mixed
EOF

echo "----初始化数据库----"

###清空数据目录
rm /data/mysql/data/* -rf

mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data

mysql_ssl_rsa_setup --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data


cat > /usr/lib/systemd/system/mysqld.service << EOF
# Copyright (c) 2015, 2016, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
#
# systemd service file for MySQL forking server
#
 
[Unit]
Description=MySQL Server
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target
 
[Install]
WantedBy=multi-user.target
 
[Service]
User=mysql
Group=mysql
 
Type=forking
 
PIDFile=/usr/local/mysql/run/mysqld.pid
 
# Disable service start and stop timeout logic of systemd for mysqld service.
TimeoutSec=0
 
# Execute pre and post scripts as root
PermissionsStartOnly=true
 
# Needed to create system tables
#ExecStartPre=/usr/bin/mysqld_pre_systemd
 
# Start main service
ExecStart=/usr/local/mysql/bin/mysqld --daemonize --pid-file=/usr/local/mysql/run/mysqld.pid $MYSQLD_OPTS
 
# Use this to switch malloc implementation
EnvironmentFile=-/etc/sysconfig/mysql
 
# Sets open_files_limit
LimitNOFILE = 65535
 
Restart=on-failure
 
RestartPreventExitStatus=1
 
PrivateTmp=false

EOF

systemctl daemon-reload
systemctl enable mysqld
#systemctl start mysqld
echo "下面是初始化数据库的密码："
grep passw /data/mysql/logs/mysql_error.log  |awk -F 'root' '{print $2}'

echo "mysqld服务暂未启动，请手动拉起服务"

echo "默认是禁止使用任何命令的，需要使用上面的密码登录数据库后，使用：ALTER USER USER() IDENTIFIED BY 'New_password'; 修改密码"
else 
	exit -1
fi
