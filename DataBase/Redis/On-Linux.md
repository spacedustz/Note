## Redis 기본 사용법

Red Hat Enterprise 9.2.0 버전에서 진행합니다.

---

## 서버 세팅

> 📕 Shell Script 작성

```bash
#!/bin/bash

# 패키지 설치
dnf -y update && dnf -y upgrade && dnf -y install firewalld redis yum-utils net-tools wget curl 

# 방화벽 포트 & 서비스 설정
systemctl start firewalld && systemctl enable firewalld && firewall-cmd --permanent --add-port=6379/tcp && firewall-cmd --permanent --add-service=redis && firewall-cmd --reload && 


# Redis 설정
echo "bind 0.0.0.0" > /etc/redis.conf
systemctl start redis && systemctl enable redis 
```

---

## 기본 사용법

`redis-cli` 명령어를 이용해 값을 넣거나 조회를 할 수 있습니다.

```bash
# 값 설정
redis-cli set key1 "value1"

# 값 검색
redis-cli get key1

```