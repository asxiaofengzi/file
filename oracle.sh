#!/bin/bash

# 定义插入的内容
insert_content="[DEFAULT]
user=ocid1.user.oc1..aaaaaaaafveiqfdx6u5x2gxyhwyrnruf2t6at3fetgvvdsrbpzr72zouyhka
fingerprint=7b:bc:90:4e:0b:41:85:a4:e1:a1:9a:97:0d:ce:f3:ac
tenancy=ocid1.tenancy.oc1..aaaaaaaaqoq7tw47guxsg3umhgbbnsk4dfknuuf362nxjqemn55ygrvyfixa
region=ap-singapore-1
key_file=/root/oracle/MyBot.pem"

# 定义文件路径
config_file="/root/oracle/client_config"

# 创建一个临时文件
tmp_file=$(mktemp)

# 读取原文件，插入内容并替换 username 和 password
awk -v insert="$insert_content" '
  BEGIN {print_oci = 1}
  /oci=begin/ {print; print_oci = 0; print insert; next}
  /oci=end/ {print_oci = 1}
  {
    if (print_oci) {
      sub(/^username=.*/, "username=77ce24d081a34f53972f9c07bbae0fc6")
      sub(/^password=.*/, "password=d671d52685614a1e85305a69a6a7c935")
      print
    }
  }
' "$config_file" > "$tmp_file"

# 将临时文件内容覆盖原文件
mv "$tmp_file" "$config_file"

echo "内容已插入到 $config_file 文件中的 oci=begin 和 oci=end 之间，并替换了 username 和 password。"
