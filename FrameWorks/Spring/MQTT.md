## Integration MQTT Broker

**Develop Environment**
- Spring Boot 3.1.2
- JDK 17
- Gradle
- JPA

<br>

### MQTT 란?

Message Queue for Telemetry Transport의 약자로 M2M 또는 IoT를 위한 경량 프로토콜입니다.

<br>

### Connection Oriented

MQTT Broker와 연결을 요청하는 Client는 TCP/IP Socket 연결 후 명시적으로 Connection을 끊거나

네트워크에 따라 연결이 끊어질 때까지 Status를 유지합니다.

<br>

## Broker

Publisher와 Subscriber 사이에서 Message를 관리하며 전송해주는 역할을 합니다.

<br>

### 다양한 MQTT Broker

- Mosquitto
- Mosca
- HiveMQ
- RabbitMQ
- MQTT Plugins
- 등등

<br>

### Pub/Sub Model

Broker를 통한 발행/구독 메시징 패턴으로 발행측은 브로커에게 메시지를 전송하며,

브로커는 구독하고 있는 클라이언트들에게 메시지를 브로드캐스트 합니다.

즉, 1:1 / 1:N 통신이 가능합니다.

<br>

### QoS(Quality of Service)

- `0` : **최대 한번 전송**하며 메시지를 전달만 할 뿐 구독하는 클라이언트가 받는걸 보장하지 않습니다.
- `1` : **최소 1회 전송**하며 구독하는 클라이언트가 메시지를 받았는지 불확실하면 정해진 횟수만큼 전송합니다.
- `2` : 구독하는 클라이언트가 요구된 메시지를 **정확히 한 번** 수신할 수 있도록 보장합니다.

<br>

### Topic

메시지를 발행/구독하는 행위는 채널 단위로 일어납니다.

이를 Topic이라고 하며 Topic은 `/` 로 구분되느 계층 구조를 갖습니다.

최상위 Topic은 `/` 로 시작하지 않아야 하며 와일드 카드를 사용할 수 있습니다.

- `+` : One-Level Wild Card
- `#` : Multi-Level Wild Card

<br>

[상세 내용 -> HiveMQ, topic best practices](https://www.hivemq.com/blog/mqtt-essentials-part-5-mqtt-topics-best-practices/)

```
a/b/c/d
a/b/+/d
a/b/#
```

<br>

### LWT (Last will and Testament)

신뢰할 수 없는 네트워크를 포함하는 경우 자주 사용되기 때문에 비정상적으로 연결이 끊어질 수 있다고 가정합니다.

LWT는 유언, 유언장이라는 의미로 Broker와 Client의 연결이 끊기면 자동으로 다른 Subscriber에게 Message를 전송하는 기능입니다.

일반적으로 Broker에 연결을 시도하는 시점에 지정되며 will topic, will message, will qos 등을 지정합니다.

---

## MQTT Broker 구현 (Mosquitto)

MQTT Broker로 Mosquito를 사용하여 테스트합니다.

Mosquitto는  MQTT 3.1 / 3.1.1을 구현한 오픈소스 Message Broker이며 QoS 2를 지원합니다.

```bash
docker run -d -n broker -p 1883:1883 -
```