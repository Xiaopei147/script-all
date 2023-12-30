from flask import Flask, render_template, request
import requests

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/submit', methods=['POST'])
def submit():
    # 获取用户输入
    email = request.form['email']
    password = request.form['password']
    steps = request.form['steps']

    # 构造URL
    url = f"https://apis.jxcxin.cn/api/mi?user={email}&password={password}&step={steps}&ver=cxydzsv3.1"

    # 发送请求
    response = requests.get(url)

    return render_template('result.html', response=response.text)

if __name__ == '__main__':
    app.run(port=5004)

