RabbitMQ 등 다른 메시지 큐도 많은데 Redis의 Pub/Sub 기능을 사용하는 이유는,

성능과 Push Based Subscription 방식 때문입니다.

이벤트를 저장하지 않기 때문에 속도가 매우 뺴르며 Publish한 데이터를 저장할 필요가 없습니다.

그리고 Pub/Sub뿐 아니라 다양한 Json을 주고 받을 떄 저장이 필요한데 이 경우도 RedisJson을 활용하는 등 활용할 기능이 많습니다.

<br>

두 번째로는 Push Based Subscription입니다. 

Kafka의 경우 Subscriber가 Pull 요청을 보내야 Message를 받아오는데,

Redis는 Publisher가 Publish하면 자동으로 모든 Subscriber에게 Message를 BroadCasting 합니다.

<br>

> 📕 **Redis vs Kafka**

**Redis**
- 모든 Subscriber에게 BroadCasting을 원하고, 데이터를 저장하지 않을 때
- 속도가 중요하고, 데이터 손실을 감수할 수 있는 경우
- 시스템에서 전송된 메시지를 보관하는 것을 원하지 않을 경우 (성능)
- 처리할 데이터의 양이 크지 않을 때

<br>

**Kafka**
- 신뢰성 있는 메시지의 전달 보장을 위할 때
- 메시지 소비 후에도 큐의 메시지를 복제 & 보관하기 원할 때
- 속도가 큰 문제가 아닌 경우
- 데이터의 크기가 클 경우

---

## Redis 설치

도커 컨테이너 사용 X

<br>

> 📕 **설치**

**Debian 기반**

```bash
apt-get -y update
apt-get -y upgrade
apt-get -y install redis-server
systemctl start redis-server && systemctl enable redis-server
```

**RPM 기반**

```bash
dnf -y update
dnf -y upgrade
dnf -y install redis-server
systemctl start redis-server && systemctl enable redis-server
```

<br>

> 📕 **각종 설정값 변경**  => `/etc/redis/redis.conf`

```bash
# 최대 메모리 사양 
# -> 최대 사용 메모리 사양을 256mb로 설정한다. 단위는 mb나 g 등 필요에 맞춰 적어주면된다. 
maxmemory 256mb 

# 메모리 초과 사용 시 후처리 방식 설정 
# -> 지금 설정한 allkeys-lru 옵션은 가장 오래된 데이터를 삭제하고, 새로운 데이터를 저장하는 옵션이다. 
maxmemory-policy allkeys-lru 

# 프로세스 포트 
# -> port 부분은 초기에 주석처리가 되어 있는데, 디폴트 값으로 6379 포트에서 동작한다. 
# -> 만약, 6379가 아닌 다른 포트를 설정하고 싶다면 주석을 해제하고 포트번호를 입력하면된다. 
port 1234 

# 외부접속 허용 
# -> 기본 실행 환경은 localhost(127.0.0.1)로 되어있다. 
# -> 만약, 모든 외부접속에 대한 허용을 하고 싶다면, 0.0.0.0 으로 변경하면 된다. 
bind 0.0.0.0 

# 비밀번호 설정 
# -> 서버 접속에 비밀번호를 적용시키고 싶다면 아래와 같이 수정하자. 
requirepass [접속 패스워드 입력] 

# 암호화된 비밀번호가 필요하다면, 터미널에 다음 명령어로 생성 가능하다. 
echo "MyPassword" | sha256sum
```

---

## Spring Redis

> 📕 **build.gradle Dependency 추가**

```groovy
implementation('org.springframework.boot:spring-boot-starter-data-redis')
```

<br>

> 📕 ****