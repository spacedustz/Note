## 📘 RabbitMQ with MultiThreading

단일 서버의 RabbitMQ  Connection을 맺을때 RabbitConfig를 작성해서 했었는데,

이번은 여러서버에 분산된 RabbitMQ를 클러스터링 하지않고 Spring Boot 서버에서 멀티스레딩으로,

각각의 RabbitMQ Connection Factory에 연결하여 데이터를 받아 보겠습니다.

<br>

이번에는 Queue에서 바로 데이터를 Receive 하지 않습니다.

- 각 서버당 RabbitMQ Connection을 따로 만

<br>

> 📕 **RabbitService**

```java

```