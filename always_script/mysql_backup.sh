#!/bin/bash
#create user pgs; add time 2023/4/7
###########################################################################################
#使用该脚本前请修改详细信息(目录，认证，不需要备份的库，传输到哪台服务器哪个目录，备份文件保留天数)#
###########################################################################################

BACKUP=/opt/backup/db
hostname=`hostname`
DATETIME=$(date +%Y_%m_%d_%H%M%S)
echo "==========开始备份==========="
echo "备份的路径是 $BACKUP/$DATETIME.tar.gz"
DB_USER=root
DB_PWD=123456
[ ! -d "$BACKUP/$DATETIME"  ]  && mkdir -p "$BACKUP/$DATETIME" 
for DATABASE in $(mysql -u${DB_USER} -p${DB_PWD} -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)") ; do
    mysqldump -u${DB_USER} -p${DB_PWD} --databases ${DATABASE} > $BACKUP/$DATETIME/${DATABASE}.sql
done
if [ $? -eq 0 ]
then 
   echo "==========备份完成==========="
   #打包备份文件
   cd $BACKUP
   tar -zcvf  $hostname-$DATETIME.tar.gz  $DATETIME
   #删除临时使用的备份目录，为了节省服务器存储空间，可以不使用
   rm -rf  $BACKUP/$DATETIME
   #删除10天前的备份文件
   find $BACKUP -mtime +10 -name  "*.tar.gz" -exec rm -rf {} \;
   #把备份文件传输到备份文件服务器
   sshpass -p '123456' scp $hostname-$DATETIME.tar.gz root@192.168.10.102:/data/backup_mysql/
else
   echo "==========备份失败==========="
   /bin/bash /root/backup.sh
fi

