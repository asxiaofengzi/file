#!/bin/bash

# 检查是否为root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "此脚本需要root权限"
        exit 1
    fi
}

# 更改root密码
change_root_password() {
    echo "正在更改root密码..."
    passwd root
    if [[ $? -eq 0 ]]; then
        echo "root密码已更改。"
    else
        echo "root密码更改失败。"
        exit 2
    fi
}

# 修改SSHD配置
update_sshd_config() {
    local sshd_config="/etc/ssh/sshd_config"
    echo "正在更新SSHD配置文件..."
    # 备份原始sshd配置文件
    cp "$sshd_config" "${sshd_config}.backup"

    # 修改SSH端口为22
    sed -i 's/^Port .*/Port 22/' "$sshd_config"

    # 允许root用户登录
    sed -i 's/^PermitRootLogin .*/PermitRootLogin yes/' "$sshd_config"

    # 启用密码认证
    sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' "$sshd_config"

    # 设置ClientAliveInterval为3600秒
    sed -i 's/^ClientAliveInterval .*/ClientAliveInterval 3600/' "$sshd_config"

    echo "SSHD配置已更新。"
}

# 禁用SELinux
disable_selinux() {
    local selinux_config="/etc/selinux/config"
    echo "正在禁用SELinux..."
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' "$selinux_config"
    if grep -q "SELINUX=disabled" "$selinux_config"; then
        echo "SELinux 已禁用。"
    else
        echo "禁用SELinux失败。"
        exit 3
    fi
}

# 停止并禁用firewalld
stop_and_disable_firewalld() {
    echo "正在停止firewalld服务..."
    systemctl stop firewalld
    if [[ $? -eq 0 ]]; then
        echo "firewalld服务已停止。"
    else
        echo "停止firewalld服务失败。"
        return 1
    fi

    echo "正在禁用firewalld服务..."
    systemctl disable firewalld
    if [[ $? -eq 0 ]]; then
        echo "firewalld服务已禁用。"
    else
        echo "禁用firewalld服务失败。"
        return 1
    fi
}

# 主逻辑
check_root
change_root_password
update_sshd_config
disable_selinux
stop_and_disable_firewalld

# 重新启动sshd服务以应用更改
systemctl restart sshd

echo "所有更改已成功应用,请执行reboot。"