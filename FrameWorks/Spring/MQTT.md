## Integration MQTT Broker

**Spec**
- Spring Boot 3.1.2
- Gradle
- JPA

<br>

### MQTT 란?

Message Queue for Telemetry Transport의 약자로 M2M 또는 IoT를 위한 경량 프로토콜입니다.

<br>

**Connection Oriented**

MQTT Broker와 연결을 요청하는 Client는 TCP/IP Socket 연결 후 명시적으로 Connection을 끊거나

네트워크에 따라 연결이 끊어질 때까지 Status를 유지합니다.

<br>

**Broker**

Publisher와 Subscriber 사이에서 Message를 관리하며 전송해주는 역할을 합니다.

<br>

다양한 MQTT Broker
- Mosquito
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

##QoS(Quality of Service)

- `0` : **최대 한번 전송**하며 메시지를 전달만 할 뿐 구독하는 클라이언트가 받는걸 보장하지 않습니다.
- `1` : **최소 1회 전송**하며 구독하는 클라이언트가 메시지를 받았는지 불확실하면 정해진 횟수만큼 전송합니다.
- `2` : 구독하는 클라이언트가 요구된 메시지를 **정확히 한 번** 수신할 수 있도록 보장합니다.

<br>

### Topic

