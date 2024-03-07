#!/bin/bash

## 유저 & 그룹 & 권한 설정
groupadd user
groupadd mariadb
usermod -g user dains
useradd mariadb -g mariadb

usermod -aG sudo dains
usermod -aG sudo mariadb

## 방화벽 설정
sudo ufw disable
sudo apt -y install firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-port=5001/tcp &&
sudo firewall-cmd --permanent --add-port=5002/tcp &&
sudo firewall-cmd --permanent --add-port=5003/tcp &&
sudo firewall-cmd --permanent --add-port=8080/tcp &&
sudo firewall-cmd --permanent --add-port=7682/tcp &&
sudo firewall-cmd --permanent --add-port=7681/tcp &&
sudo firewall-cmd --permanent --add-port=3000/tcp &&
sudo firewall-cmd --permanent --add-port=1883/tcp &&
sudo firewall-cmd --permanent --add-port=4369/tcp &&
sudo firewall-cmd --permanent --add-port=8100/tcp &&
sudo firewall-cmd --permanent --add-service=mysql &&
sudo firewall-cmd --permanent --add-service=redis &&
sudo firewall-cmd --reload

## OpenJDK 17 설치
sudo apt -y install openjdk-17-jdk

## MariaDB 설치
## /etc/mysql/mariadb.conf.d/50-server.cnf = 외부 접속 binding 변경
## /etc/mysql/my.cnf 포트변경
sudo apt -y install mariadb-server
sudo mariadvb-secure-installation

## Redis 설치
## /etc/redis/redis.conf - bind, port 변경
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt-get -y update
sudo apt-get -y install redis

## Yarn 설치
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt -y install yarn

# NodeJS 설치
sudo curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get -y install nodejs
sudo npm install yarn
sudo npm install next