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

