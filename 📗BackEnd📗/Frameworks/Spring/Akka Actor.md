## Akka Actor

Akka Actor는 동시성 모델을 기반으로 하는 어플리케이션 프레임워크 입니다.

프레임워크는 Scala로 작성되었으므로 Java 기반의 어플리케이션에서 완벽하게 호환됩니다.

따라서 기존 Spring 기반에서 통합하거나, Spring Bean을 Actor에 연결하는 경우도 매우 많습니다.

<br>

Spring/Akka 통합의 문제는 Spring의 Bean 관리와 Akka Actor 관리 간의 차이가 있습니다.

Actor는 일반적인 Spring Bean Life Cycle과 다른 특정한 LifeCycle을 가집니다.

<br>

**build.gradle**

```groovy
implementation group: 'com.typesafe.akka', name: 'akka-actor_3', version: '2.8.0'
```

