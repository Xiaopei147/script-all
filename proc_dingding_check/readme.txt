#create user github:Xiaopei147
#create date 2023/3/9 16:00:00(CST)
#add to github date  2023/3/9 16:00:00(CST)
#!/bin/bash
这是一个监控进程是否存在的脚本，只需要在脚本中定义proc_name,即进程名称，注意，进程是根据ps进行的grep过滤，所以一定要注意过滤条件，以免筛选模糊，造成告警 不准确。告警信息可发送到钉钉群，企业微信群。

####执行频率问题

目前没有使用sleep，可交给contab进行计划任务执行，也可在脚本的最末尾、最前端添加sleep！
