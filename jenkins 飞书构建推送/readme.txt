#这是一个Jenkins过程推送到飞书的告警脚本，注意，因为脚本需要变量(jenkins的变量传进来)，所以一定要勾选Jenkins的构建环境中的：Set jenkins user build variables选项，并且该脚本要放在构建中执行不能发到构建后操作，否则会影响构建的结果输出

##显示持续时间
应该安装Jenkins 的 Timestamper插件，同时打开Add timestamps to the Console Output（将时间戳添加到控制台输出）
该脚本的主要原理是，根据Running as SYSTEM(开始执行构建)前，控制台的时间戳(tag1)做记录，运行该脚本末尾代表构建过程即将结束(tag2)，用tag2 - tag1就得到了该脚本持续了 * s