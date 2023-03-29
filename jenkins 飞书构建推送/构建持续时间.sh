#!/bin/bash
JOB_URL="http://192.168.10.101:18980/job/${JOB_NAME}"
getBuildState(){
  buildNr=$1
  curl -u admin:a07259ae773347e09c494007f8562bab  ${JOB_URL}/${buildNr}/api/json |grep -Po '"result":\s*"\K\w+'
}

getBuildUser(){
  buildNr=$1
  curl -u admin:a07259ae773347e09c494007f8562bab  ${JOB_URL}/${buildNr}/api/json  |grep -Po '"shortDescription":\s*"\K..*?(?=")'
}

getstart(){
  buildNr=$1
  curl -u admin:a07259ae773347e09c494007f8562bab  ${JOB_URL}/${buildNr}/api/json |grep "Running as SYSTEM"  |awk -F '<b>' '{print $2}' |awk -F '</b>' '{print $1}'
}


# 执行一些操作
state=$(getBuildState ${BUILD_NUMBER}  )
string1=$BUILD_USER
string2=$JOB_BASE_NAME
string3=$BUILD_DISPLAY_NAME
number=$BUILD_NUMBER
string4=$(getBuildUser ${BUILD_NUMBER}  )
starttime=$(getstart ${BUILD_NUMBER}  )
nowTime=$(date "+%Y-%m-%d %H:%M:%S")

echo ${starttime}
echo ${state}
echo 结束时间：$(date)
end_time=$(date +%s)
cost_time=$[$end_time - start_time]
runtime="$(($cost_time)) s"

if [[ "x${state}" == "xSUCCESS" ]] ; then
   curl -X POST -H "Content-Type: application/json" \
        -d '{"msg_type":"post","content": {"post": {"zh_cn": {"title": "Jenkins构建通知","content": [[{"tag": "text","text": "'"应用名称：$string2\n发起人：$string4\n持续时间：$runtime\n版本号：$string3\n构建人：$string1\n状态>：成功\n日期：$nowTime"'"}]]} } }}' \
https://open.feishu.cn/open-apis/bot/v2/hook/65f4093c-c223-4b35-8bcb-
else
   curl -X POST -H "Content-Type: application/json" \
        -d '{"msg_type":"text","content":{"text": "'"Jenkins构建通知\n应用名称：$string2\n发起人：$string4\n持续时间：$runtime\n版本号：$string3\n构建人：$string1\n状态：失败\n日期：$nowTime"'"}}' \
https://open.feishu.cn/open-apis/bot/v2/hook/65f4093c-c223-4b35-8bcb- && exit 1
fi