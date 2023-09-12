## Redis Configuration

Red Hat Enterprise 9.2.0 버전에서 진행하며,

Redis의 각종 옵션들을 공식 문서를 보며 대충 번역해서 자주 사용할 것 같은 옵션들만 정리합니다.

[Redis Configuration 공식 문서](https://redis.io/docs/management/config)

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

# Redis 포트 & 서비스 활성화 된지 확인
systemctl status redis && netstat -lntp | grep 6379
```

---

## Configuration

> 📕 **/etc/redis.conf**

`redis.conf`파일의 형식은 매우 간단합니다.

```bash
keyword arg1 arg2 ... argN
```

위 형식이 전부입니다.

<br>

**redis.conf**

```bash
# ============================== General ==============================
# 비밀번호 설정 (공백 포함 가능)
requirepass "hello world"

# Redis는 기본적으로 데몬으로 동작하지 않지만, systemd에 의해 관리되길 원하는 경우 Yes로 줍니다.
daemonize no

# 만약 Redis를 Daemon으로 돌릴 경우 systemd에 Signal을 보낼 수 있습니다.
# no : - systemd와 상호작용 없음
# upstart : Redis를 SIGSTOP 모드로 전환합니다.
# systemd : $NOTIFY_SOCKET에 READY=1 을 작성해 systemd에 신호를 보내며 정기적으로 상태를 업데이트 합니다.
# auto : UPSTART_JOB or NOTIFY_SOCKET 변수를 기반으로 upstart 또는 systemd를 감지합니다.
supervised auto

# 로그 레벨을 지정합니다.
# 로그 레벨은 debug, verbose, notice, warning이 있습니다.
loglevel notice

# 로그 파일 이름 지정, 데몬화된 Redis인 경우 /dev/null로 전송됩니다.
logfile ""

# Syslog 사용 여부
syslog-enabled no

# 프로세스에 Title 달기, 아래 템플릿을 사용합니다.
set-proc-title yes
proc-title-template "{title} {listen-addr} {server-mode}"

# ============================== SnapShot ========================================
# DB 덤프 파일 지정
dbfilename {file-name}.rdb

# 작업 디렉터리 지정
dir ./

# 데이터를 디스크에 저장합니다.
# save <seconds> <changes>의 형식을 가지며, 빈 문자열을 지정할 경우, 스냅샷을 비활성화 합니다.
save ""
save 3600 1 # 키가 1개이상 변경된 경우, 3600초 이후 저장
save 300 100 # 키가 100개이상 변경된 경우 300초 이후 저장
save 60 10000 # 키가 10000개이상 변경된 경우 60초후 저장

# Redis는 기본적으로 RDB 스냅샷이 활성화 되어 있습니다.
# 백그라운드 저장이 실패한 경우, 쓰기 허용을 중지합니다.
# 백그라운드 저장이 다시 정상 작동할 경우, 다시 쓰기를 허용 합니다.
stop-writes-on-bgsave-error yes

# .rdb 데이터베이스를 덤프할 때 LZF로 압축할지 여부 (Default : yes)
rdbcompression yes

# RDB를 로드할때 체크섬이 있으면 약 10%의 성능 저하가 있지만 손상 방지엔 좋습니다.
# 성능이 많이 중요 하다면 체크섬을 비활성화 해두면 됩니다.
rdbchecksum yes

# ============================== Replication ==============================
#   +------------------+      +---------------+
#   |      Master      | ---> |    Replica    |
#   | (receive writes) |      |  (exact copy) |
#   +------------------+      +---------------+
# 1)
# Redis Replication은 비동기로 동작합니다.
# 지정된 수의 Replica과 연결되지 않은 것으로 나타나면 Write를 중지하도록 Master를 구성할 수 있습니다.
#
# 2)
# Redis Replica는 짧은 시간 복제 링크가 손실된 경우 Master와 부분적 재 동기화를 수행할 수 있습니다.
# 서버 요구사항에 따라 Replicate BackLog 크기를 구성 할 수 있습니다.
#
# 3)
# Replication은 자동으로 이루어지며, 사용자의 개입이 필요하지 않습니다.
# 네트워크 파티션 Replica는 자동으로 Master에 다시 연결하고 동기화를 재 시도 합니다.
# 
# 사용법 : replicaof <master-IP> <master-Port>

# Redis Replica(복제) 노드 설정
replicaof 127.0.0.1 6380

# 만약 Master가 비밀번호로 보호되고 있는 경우 복제본에 인증을 지시할 수 있습니다.
masterauth <master-password>

# Replica가 Master와 연결이 끊어지거나 Replica만 살아 있을경우 데이터를 전달할 지 여부
# No로 설정되면 Master와 연결이 끊어졌다는 에러만 반환합니다.
replica-serve-stale-data yes

# Replica를 읽기 전용으로 설정
replica-read-only yes

# Replica Disk Sync Strategy : Disk or Socket 방식
# 새로운 Replica가 시작할때 or 재접속할 때 Master -> Replica로 전체 동기화를 합니다.
# Master는 RDB 파일을 생성해서 Replica로 전달합니다.
# 이 때, Replica에서 파일을 로드하는 전략을 지정하는 옵션입니다.
# Yes로 지정하면 디스크에, No로 설정하면 소컷으로 전송합니다.
repl-diskless-sync yes

# ============================== Include ==============================
# 다른 Conf 파일 적용
include /path/to/local.conf

# ============================== Module ==============================
# Redis가 시작될 때 모듈 로드
loadmodule /path/to/module.so

# ============================== Network ==============================
# 허용할 IP & 대역 설정
bind 192.168.0.150 10..0.5 # 여러개의 Listener 설정
bind * -::* # 모든 인터페이스 허용
bind 127.0.0.1 ::1 # Dual-Stack IP Loopback 허용

# Protected Mode 설정, Default는 Enabled이다.
protected-mode yes

# 포트 설정
port 6379

# TCP Max Socket Connection 설정
# 초당 요청 수가 높은 환경에서는 느린 클라이언트 연결 문제를 방지하기 위해 
# 높은 백로그가 필요합니다. Linux 커널은 이를 /proc/sys/net/core/somaxconn 값으로 자동으로 자릅니다.
# 따라서 원하는 효과를 얻으려면 somaxconn 및 tcp_max_syn_backlog 값을 모두 높여야 합니다.
tcp-backlog 511

# 클라이언트가 N초 동안 유휴 상태이면 연결을 닫습니다. (0은 비활성화)
timeout 0

# TCP Keep Alive
# 0이 아니면 SO_KEEPALIVE를 사용해 통신이 없을떄 TCP ACK를 클라이언트에 보냅니다.
# 기본값은 300초 입니다.
# 이 옵션은 2가지 상황에서 유용합니다.
# 1) Dead Peer 감지
# 2) 네트워크를 강제로 살아있는 것으로 간주하게 만듭니다.
tcp-keepalive 300

# ============================== TLS/SSL ==============================
# TLS/SSL은 기본적으로 비활성화 되어 있습니다.
# TLS 수신 포트를 지정하여 TLS를 활성화 할 수 있습니다.
port 0
tls-port 6379

# 서버를 인증하는데 사용할 X.509 인증서와 Private Key 구성, 파일은 PEM 형식이어야 합니다.
tls-cert-file redis.crt
tls-key-file redis.key
tls-key-file-pass secret # 만약 키 파일이 암호화 되어 있다면 여기에 입력 해줍니다.

# Redis는 보통서버 기능(연결 허용)과 클라이언트 기능(마스터에서 복제, 클러스터 버스 연결 설정 등)에 동일한 인증서를 사용합니다. 
# 때때로 클라이언트 전용 또는 서버 전용 인증서로 지정하는 속성을 사용하여 인증서가 발급됩니다. 
# 이 경우 들어오는(서버) 연결과 나가는(클라이언트) 연결에 서로 다른 인증서를 사용하는 것이 좋습니다.
tls-client-cert-file client.crt
tls-client-key-file client.key
tls-client-key-file-pass secret # 만약 키 파일이 암호화 되어 있다면 여기에 입력 해줍니다.

# 이전 버전의 OpenSSL(< 3.0)에 필요한 Diffie-Hellman(DH)키 교환을 활성화 하도록 DH 매개변수를 구성합니다.
# 최신 버전에서는 이 구성이 필요하지 않고, 권장하지 않는 옵션입니다.
tls-dh-params-file redis.dh


```

---
## Redis-Cli

> 📕 **Redis CLI 접속 방법**

```bash
redis-cli -h [접속IP] -p [포트] -a [비밀번호]
```

<br>

> 📕 **데이터 저장**

`redis-cli set {키} {값}` 형식으로 데이터를 저장합니다.

```bash
redis-cli set key1 "value1"
```

<br>

> 📕 **데이터 조회**

`get [Key]`형식으로 데이터를 조회합니다.

```bash
# 단일 키값 검색
redis-cli get key1

# 모든 데이터 조회
redis-cli keys *
```

<br>

> 📕 **데이터 삭제**

`del [Key]` 형식으로 데이터를 삭제합니다.

```bash
# 단일 키값 삭제
redis-cli del [Key]

# 모든 데이터 삭제
redis-cli flushall
```