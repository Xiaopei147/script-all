#!/bin/bash
#create user pgs; add time 2023/4/7

#下面的export要根据自己的变量调整（通常再/etc/profile）下，为了避免提示done命令找不到！
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/usr/local/mysql/bin:/usr/local/php/bin:/usr/local/redis/bin/:$PATH
BACKUP=/opt/backup/db
hostname=`hostname`
DATETIME=$(date +%Y_%m_%d_%H%M%S)
echo "==========开始备份==========="
echo "备份的路径是 $BACKUP/$DATETIME.tar.gz"
DB_USER=root
DB_PWD=123
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
   #删除7天前的备份文件
   find $BACKUP -mtime +7 -name  "*.tar.gz" -exec rm -rf {} \;
   #把备份文件传输到备份文件服务器
   sshpass -p 'abcdefg' scp $hostname-$DATETIME.tar.gz root@192.168.10.102:/data/mysql_backup
   if [ $? -eq 0 ]
   then
   curl -X POST -H "Content-Type: application/json" -d '{"msg_type":"text","content": " {\"text\":\" '$hostname-$DATETIME.tar.gz传输成功'\"}"}' https://open.feishu.cn/open-apis/bot/v2/hook/
   else
   curl -X POST -H "Content-Type: application/json" -d '{"msg_type":"text","content": " {\"text\":\" '$hostname-$DATETIME.tar.gz传输失败请注意查看'\"}"}' https://open.feishu.cn/open-apis/bot/v2/hook/
   fi

else
   echo "==========备份失败==========="
   /bin/bash /root/backup.sh
fi
