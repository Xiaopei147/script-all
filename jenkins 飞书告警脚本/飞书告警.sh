#!/bin/bash
JOB_URL="${JENKINS_URL}job/${JOB_NAME}"
getBuildState(){
  buildNr=$1
  curl -u jenkins_user:passwd  ${JOB_URL}/${buildNr}/api/json |grep -Po '"result":\s*"\K\w+'
}

state=$(getBuildState ${BUILD_NUMBER}  )
string1=$BUILD_USER
string2=$JOB_BASE_NAME
string3=$BUILD_DISPLAY_NAME
nowTime=$(date "+%Y-%m-%d %H:%M:%S")

echo ${state}

if [[ "x${state}" == "xSUCCESS" ]] ; then
   curl -X POST -H "Content-Type: application/json" \
        -d '{"msg_type":"post","content": {"post": {"zh_cn": {"title": "Jenkins构建通知","content": [[{"tag": "text","text": "'"应用名称：$string2\n版本号：$string3\n构建人：$string1\n状态>：成功\n日期：$nowTime"'"}]]} } }}' \
https://open.feishu.cn/open-apis/bot/v2/hook/e765b8eb-0d60-4969-
else
   curl -X POST -H "Content-Type: application/json" \
        -d '{"msg_type":"text","content":{"text":"'"Jenkins构建通知\n应用名称：$string2\n版本号：$string3\n构建人：$string1\n状态：失败\n日期：$nowTime"'"}}' \
https://open.feishu.cn/open-apis/bot/v2/hook/e765b8eb-0d60-4969- && exit1
fi
