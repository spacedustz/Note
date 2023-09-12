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

## Configuration

[Redis Configuration 공식 문서](https://redis.io/docs/management/config)

> 📕 **/etc/redis.conf**

`redis.conf`파일의 형식은 매우 간단합니다.

```bash
keyword arg1 arg2 ... argN
```

위 형식이 전부입니다.

<br>

**redis.conf**

```bash

## 비밀번호 설정 (공백 포함 가능)
requirepass "hello world"

# ==================== Include ====================
## 다른 Conf 파일 적용
include /path/to/local.conf

# ==================== Module ====================
## Redis가 시작될 때 모듈 로드
loadmodule /path/to/module.so

# ==================== Network ====================
## Redis Replica 노드 설정
replicaof 127.0.0.1 6380

## 허용할 IP & 대역 설정
bind 192.168.0.150 10..0.5 # 여러개의 Listener 설정
bind * -::* # 모든 인터페이스 허용
bind 127.0.0.1 ::1 # Dual-Stack IP Loopback 허용

## Protected Mode 설정, Default는 Enabled이다.
protected-mode yes

## 포트 설정
port 6379

## TCP Max Socket Connection 설정
## 초당 요청 수가 높은 환경에서는 느린 클라이언트 연결 문제를 방지하기 위해 
## 높은 백로그가 필요합니다. Linux 커널은 이를 /proc/sys/net/core/somaxconn 값으로 자동으로 자릅니다.
## 따라서 원하는 효과를 얻으려면 somaxconn 및 tcp_max_syn_backlog 값을 모두 높여야 합니다.
tcp-backlog 511

## 클라이언트가 N초 동안 유휴 상태이면 연결을 닫습니다. (0은 비활성화)
timeout 0

## TCP Keep Alive
## 0이 아니면 SO_KEEPALIVE를 사용해 통신이 없을떄 TCP ACK를 클라이언트에 보냅니다.
```

---
## 기본 사용법

`redis-cli` 명령어를 이용해 값을 넣거나 조회를 할 수 있습니다.

```bash
# 값 설정
redis-cli set key1 "value1"

# 값 검색
redis-cli get key1

# 값 증가 & 감소
redis-cli incr key1
redis-cli decr key1

# 키 만료시간 설정
redis-cli expire key1 60
```