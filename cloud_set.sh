# 配置git，下载对应项目
yum install git
git config --global user.name "xiaofengzi"
git config --global user.email "asxiaofengzi@gmail.com"

mkdir c++_project
cd c++_project/
git clone https://github.com/asxiaofengzi/TinyWebServer.git
git clone https://github.com/asxiaofengzi/learn_TinyWebservice.git

# 配置frp，设置成开机自启动服务
mkdir /root/frp
cd /root/frp
yum install wget
wget https://github.com/fatedier/frp/releases/download/v0.59.0/frp_0.59.0_linux_amd64.tar.gz
tar -zxvf frp_0.59.0_linux_amd64.tar.gz 
cd /root/frp/frp_0.59.0_linux_amd64
./setup_frps_service.sh
# nohup ./frps -c frps.toml &

# 安装甲骨文刷机
mkdir /root/oracle
cd /root/oracle
wget -O gz_client_bot.tar.gz  https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot.tar.gz && tar -zxvf gz_client_bot.tar.gz --exclude=client_config  && tar -zxvf gz_client_bot.tar.gz --skip-old-files client_config && chmod +x sh_client_bot.sh && bash sh_client_bot.sh
sh /root/oracle/sh_client_bot.sh
vi /root/oracle/client_config
./oracle.sh
sh /root/oracle/sh_client_bot.sh