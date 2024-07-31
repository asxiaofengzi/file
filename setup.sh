#!/bin/bash

# 定义一些变量
GIT_REPO_TINY_WEBSERVER="https://github.com/asxiaofengzi/TinyWebServer.git"
GIT_REPO_LEARN_TINY_WEBSERVICE="https://github.com/asxiaofengzi/learn_TinyWebservice.git"
FRP_DOWNLOAD_URL="https://github.com/fatedier/frp/releases/download/v0.59.0/frp_0.59.0_linux_amd64.tar.gz"
ORACLE_GZ_CLIENT_BOT_URL="https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot.tar.gz"
FILE_URL="https://github.com/asxiaofengzi/file.git"

# 配置git
echo "配置git..."
yum install git
git config --global user.name "xiaofengzi"
git config --global user.email "asxiaofengzi@gmail.com"

# 创建c++_project目录并克隆项目
echo "克隆项目到c++_project目录..."
mkdir /root/c++_project
cd /root/c++_project
git clone "$GIT_REPO_TINY_WEBSERVER"
git clone "$GIT_REPO_LEARN_TINY_WEBSERVICE"
cd /root
git clone "$FILE_URL"

# 配置frp，设置成开机自启动服务
echo "配置frp服务..."
mkdir /root/frp
cd /root/frp
yum install wget
wget "$FRP_DOWNLOAD_URL"
tar -zxvf frp_0.59.0_linux_amd64.tar.gz
cd frp_0.59.0_linux_amd64
mv /root/file/setup_frps_service.sh /root/frp/frp_0.59.0_linux_amd64
chmod +x setup_frps_service.sh
# 执行frp服务设置脚本，假设 setup_frps_service.sh 脚本内容是正确的
# 注意：确保 setup_frps_service.sh 脚本具有执行权限
./setup_frps_service.sh
cd /root

# 安装甲骨文刷机脚本
echo "安装Oracle刷机脚本..."
mkdir /root/oracle
cd /root/oracle
wget -O gz_client_bot.tar.gz "$ORACLE_GZ_CLIENT_BOT_URL"
tar -zxvf gz_client_bot.tar.gz --exclude=client_config
tar -zxvf gz_client_bot.tar.gz --skip-old-files client_config
chmod +x sh_client_bot.sh
# 禁用 sh_client_bot.sh 脚本中的 tail -f 命令
ORACLE_SCRIPT="/root/oracle/sh_client_bot.sh"
sed -i '/tail -f ${CLIENT_LOG_FILE}/s/^/#/' "$ORACLE_SCRIPT"
bash sh_client_bot.sh
sed -i 's/^\#\s*tail -f '${CLIENT_LOG_FILE}'//' /root/oracle/sh_client_bot.sh

# 编辑client_config配置文件
# vi /root/oracle/client_config

# 运行oracle.sh脚本，假设该脚本存在于当前目录且具有执行权限
mv /root/file/oracle.sh /root/oracle
chmod +x /root/oracle/oracle.sh
./oracle.sh

# 再次运行刷机脚本
sh /root/oracle/sh_client_bot.sh
cd /root

echo "所有操作完成。"