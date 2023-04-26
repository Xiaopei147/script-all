#!/bin/bash

# 设置要保留的目录数量
keep=3

# 遍历每个目录
for dir in /root/script/rm_old/*
do
    # 判断目录是否存在
    if [ -d "$dir" ]
    then
        # 切换到目录并列出目录并按时间排序
        cd "$dir"
        directories=$(ls -td */)

        # 计算要删除的目录数量
        count=$(echo $directories | wc -w)
        delete=$(expr $count - $keep)

        # 删除目录
        echo "$directories" | tail -n $delete | xargs rm -rf
    fi
done
