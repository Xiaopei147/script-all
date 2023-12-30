from flask import Flask, request, render_template
import requests
import datetime
import json

app = Flask(__name__)

messages = []

# 获取公网IP地址的函数
def get_public_ip():
    try:
        response = requests.get('https://api.ipify.org?format=json')
        data = response.json()
        return data['ip']
    except:
        return 'Unknown'

# 发送消息到企业微信群机器人
def send_message_to_wechat_robot(content):
    webhook_url = 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key='  # 企业微信群机器人的Webhook地址
    headers = {'Content-Type': 'application/json'}
    data = {
        "msgtype": "text",
        "text": {
            "content": content
        }
    }
    requests.post(webhook_url, headers=headers, data=json.dumps(data))

@app.route('/submit_message', methods=['POST'])
def submit_message():
    email = request.form['email']
    nickname = request.form['nickname']
    public_ip = get_public_ip()  # 获取公网IP地址
    content = request.form['content']
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    message = {
        'timestamp': timestamp,
        'email': email,
        'nickname': nickname,
        'public_ip': public_ip,
        'content': content
    }
    messages.append(message)

    with open('messages.txt', 'a') as file:
        file.write(f"{timestamp} | {email} | {nickname} | {public_ip} | {content}\n")

    # 向企业微信群机器人发送消息
    send_message_to_wechat_robot(f"收到新的留言：\n昵称：{nickname}\n邮箱：{email}\n内容：{content}")

    return '留言已提交成功!'

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(port=5001)

