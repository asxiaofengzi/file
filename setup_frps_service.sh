#!/bin/bash

# 定义frps服务的二进制文件和配置文件路径
FRPS_BINARY="/root/frp/frp_0.59.0_linux_amd64/frps"
FRPS_CONFIG="/root/frp/frp_0.59.0_linux_amd64/frps.toml"
FRPS_USER="root"

# 创建frps服务的systemd服务文件
FRPS_SERVICE_FILE="/etc/systemd/system/frps.service"

# 定义服务内容
FRPS_SERVICE_CONTENT="[Unit]
Description=FRP Server Service
After=network.target

[Service]
Type=simple
User=$FRPS_USER
ExecStart=$FRPS_BINARY -c $FRPS_CONFIG
Restart=on-failure

[Install]
WantedBy=multi-user.target"

# 写入服务文件，并将错误（如果有的话）重定向到 /root/frp/frp_0.59.0_linux_amd64/nohup.out
echo "$FRPS_SERVICE_CONTENT" | sudo tee "$FRPS_SERVICE_FILE" > /root/frp/frp_0.59.0_linux_amd64/nohup.out 2>&1

# 重新加载systemd管理器配置
sudo systemctl daemon-reload

# 启动并启用服务
sudo systemctl start frps.service
sudo systemctl enable frps.service

# 输出服务状态
sudo systemctl status frps.service