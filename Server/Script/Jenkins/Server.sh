#!/bin/bash

# APT 업데이트
apt-get -y update
apt-get -y upgrade
echo ----- APT Update 종료 ---- | tee settinglogs


# 기본 패키지 설치
apt install -y firewalld mysql-client net-tools curl wget gnupg lsb-release ca-certificates apt-transport-https software-properties-common gnupg-agent openjdk-11-jdk
echo ----- 기본 패키지 설치 완료 ----- >> settinglogs


# OpenJDK 전역변수 설정
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
echo ----- $JAVA_HOME ----- >> settinglogs


# Firewalld 시작
systemctl start firewalld && systemctl enable firewalld
echo ----- Firewalld 시작 ----- >> settinglogs


# 포트 오픈
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=5000/tcp
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=18080/tcp
firewall-cmd --permanent --add-port=13306/tcp

# Jenkins < - > Github Webhook을 위한 IP 허용
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address=192.30.252.0/22 port port="22" protocol="tcp" accept' && firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address=185.199.108.0/22 port port="22" protocol="tcp" accept' && firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address=140.82.112.0/20 port port="22" protocol="tcp" accept' && firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address=143.55.64.0/20 port port="22" protocol="tcp" accept' && firewall-cmd --permanent --add-rich-rule='rule family="ipv6" source address=2a0a:a440::/29 port port="22" protocol="tcp" accept' && firewall-cmd --permanent --add-rich-rule='rule family="ipv6" source address=2606:50c0::/32 port port="22" protocol="tcp" accept'


# Firewall Settings 저장
firewall-cmd --reload
echo ----- Firewalld 설정 완료 ----- >> settinglogs


# 도커 설치

## 도커 GPG Key 추가
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

## 도커 저장소 설정
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

## 도커 엔진 설치
apt install -y docker-ce docker-ce-cli containerd.io
echo ----- 도커 설치 완료 ----- >> settinglogs

## 도커 시작
systemctl start docker && systemctl enable docker
echo ----- 도커 시작 ----- >> settinglogs


# 젠킨스 설치
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt -y update

apt install -y jenkins
echo ----- Jenkins 설치 완료 ----- >> settinglogs

# 도커, sudo 권한 부여
usermod -aG docker jenkins
usermod -aG sudo jenkins
chmod 666 /var/run/docker.sock


# 젠킨스 포트 변경
sed -i 's/8080/18080/g' /usr/lib/systemd/system/jenkins.service


# 젠킨스 시작
systemctl start jenkins && systemctl enable jenkins
echo ----- Jenkins 시작 완료 ----- >> settinglogs