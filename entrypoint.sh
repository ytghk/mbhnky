#!/usr/bin/env bash

# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
UUID=${UUID:-'de04add9-5c68-8bab-950c-08cd5320df18'}

sed -i "s/UUID/$UUID/g" ./config.json
sed -i "s/UUID/$UUID/g" /etc/nginx/nginx.conf

# 设置 nginx 伪装站
rm -rf /usr/share/nginx/*
wget https://github.com/Misaka-blog/xray-for-paas/raw/main/mikutap.zip -O /usr/share/nginx/mikutap.zip
unzip -o "/usr/share/nginx/mikutap.zip" -d /usr/share/nginx/html
rm -f /usr/share/nginx/mikutap.zip

# 伪装 xray 执行文件
RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
mv xray ${RELEASE_RANDOMNESS}
cat config.json | base64 > config
rm -f config.json

nginx
base64 -d config > config.json
./${RELEASE_RANDOMNESS} -config=config.json
