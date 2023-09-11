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
- 메시지 소비 후에도 메시지를 보관하기 원할 때
- 속도가 큰 문제가 아닌경우
- 데이터의 크기가 클 경우

---

## Redis 설치

도커 컨테이너 사용 X

```bash
apt-get -y update
apt-get -y upgrade
apt-get install redis-server
```

<br>

각종 설정

```bash

```