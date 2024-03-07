```bash
# 그룹 생성
groupadd -g 1001 user
groupadd -g 1002 mariadb

# 유저 생성 & 그룹 할당 & 비밀번호 설정
useradd dains -g user
useradd mariadb -g mariadb
passwd dains
passwd mariadb


# sudoers 추가
usermod --append -G wheel dains
usermod --append -G wheel mariadb

# JDK 17
dnf -y install java-17-openjdk.x86_64
readlink -f /usr/bin/java
vi /etc/profile
|
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.9.0.9-2.el9.x86_64/bin/java
|
source /etc/profile

# SELinux Off
setenforce 0

# Redis 설치 & 포트 변경
dnf -y install redis
systemctl start redis
sytemctl enable redis
vi /etc/redis/redis.conf

# MariaDB 설치 & 포트 변경
dnf -y install mariadb-server
systemctl start mariadb
mysql_sucure_installation
vi /etc/my.cnf.d/mariadb-server.cnf

# 방화벽 섫정
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=redis
firewall-cmd --permanent --add-service=mysql
firewall-cmd --permanent --add-port=ssh/tcp
firewall-cmd --permanent --add-port=5001/tcp
firewall-cmd --permanent --add-port=5002/tcp
firewall-cmd --permanent --add-port=7681/tcp
firewall-cmd --permanent --add-port=7682/tcp
firewall-cmd --permanent --add-port=1883/tcp
firewall-cmd --permanent --add-port=4369/tcp
firewall-cmd --permanent --add-port=8100/tcp

# DB 구성
mysql -u root -p
create database dains default character set utf8mb4 collate utf8mb4_general_ci;
create user 'dains'@'%' identified by '1234';
grant all privileges on dains.* to 'dains'@'%';
flush privileges;
```