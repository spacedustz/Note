## Akka Actor

Akka Actor는 동시성 모델을 기반으로 하는 어플리케이션 프레임워크 입니다.

프레임워크는 Scala로 작성되었으므로 Java 기반의 어플리케이션에서 완벽하게 호환됩니다.

따라서 기존 Spring 기반에서 통합하거나, Spring Bean을 Actor에 연결하는 경우도 매우 많습니다.

<br>

Spring/Akka 통합의 문제는 Spring의 Bean 관리와 Akka Actor 관리 간의 차이가 있습니다.

Actor는 일반적인 Spring Bean Life Cycle과 다른 특정한 Life Cycle을 가집니다.

또한, Actor는 Actor 자체와 Client Code에서 Access할 수 있을뿐 아니라, 직렬화가 가능하고 다른 Akka Runtime 간 이식이 가능한 Actor 참조로 분할됩니다.

<br>

다행히 Akka는 외부 종속성 주입 프레임워크를 쉽게 사용할 수 있는 Akka Extension 이라는 메커니즘을 제공합니다.

<br>

**build.gradle**

```groovy
// Akka Framework
implementation group: 'com.typesafe.akka', name: 'akka-actor_3', version: '2.8.0'

// Akka Streams
implementation group: 'com.typesafe.akka', name: 'akka-stream_2.13', version: '2.8.0'

// Akka Streams Alpakka
implementation group: 'com.lightbend.akka', name: 'akka-stream-alpakka-amqp_2.13', version: '6.0.2'
```

