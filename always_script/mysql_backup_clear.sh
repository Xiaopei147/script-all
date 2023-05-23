#!/bin/bash
dir=/data/mysql_backup
date=`date +%Y-%m-%d`
echo "$date 删除的文件是：" >> /var/log/mysql_backup_clear.log
echo "" >> /var/log/mysql_backup_clear.log
find $dir -mtime +7 -name  "*.tar.gz"; >> /var/log/mysql_backup_clear.log
find $dir -mtime +7 -name  "*.tar.gz" -exec rm -rf {} \;
