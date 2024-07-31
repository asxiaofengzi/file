#!/bin/bash

# 定义一些变量
GIT_REPO_TINY_WEBSERVER="https://github.com/asxiaofengzi/TinyWebServer.git"
GIT_REPO_LEARN_TINY_WEBSERVICE="https://github.com/asxiaofengzi/learn_TinyWebservice.git"
FRP_DOWNLOAD_URL="https://github.com/fatedier/frp/releases/download/v0.59.0/frp_0.59.0_linux_amd64.tar.gz"
ORACLE_GZ_CLIENT_BOT_URL="https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot.tar.gz"

# 配置git
echo "配置git..."
yum install git
git config --global user.name "xiaofengzi"
git config --global user.email "asxiaofengzi@gmail.com"

# 创建c++_project目录并克隆项目
echo "克隆项目到c++_project目录..."
mkdir c++_project
cd c++_project
git clone "$GIT_REPO_TINY_WEBSERVER"
git clone "$GIT_REPO_LEARN_TINY_WEBSERVICE"
cd /root

# 配置frp，设置成开机自启动服务
echo "配置frp服务..."
mkdir /root/frp
cd /root/frp
yum install wget
wget "$FRP_DOWNLOAD_URL"
tar -zxvf frp_0.59.0_linux_amd64.tar.gz
cd frp_0.59.0_linux_amd64

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
bash sh_client_bot.sh

# 编辑client_config配置文件
vi /root/oracle/client_config

# 运行oracle.sh脚本，假设该脚本存在于当前目录且具有执行权限
./oracle.sh

# 再次运行刷机脚本
sh /root/oracle/sh_client_bot.sh
cd /root

echo "所有操作完成。"