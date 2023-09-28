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

---

## Akka Actor에 Spring Bean 주입

사람에게 인사를 보내서 사람의 이름을 대답할 수 있는 단일 Actor로 구성된 간단한 Spring/Akka App을 만들어 보겠습니다.

<br>

모든 Akka Actor의 `onReceive` 함수는 메시지를 수신하고 지정된 로직에 따라 처리합니다.

아래 예시 코드와 같은 경우, Greet 메시지가 미리 정의된 Greet 타입인지 확인 후,

다음 Greet 인스턴스에서 사람의 이름을 가져오고 GreetingService를 이용하여 이 사람에 대한 인사말을 받습니다.

인사말을 받고 보낸 사람에게 다시 인사말 문자열로 응답합니다.

이때 메시지가 알수 없는 다른 유형인 경우, unhandled로 메시지가 전달됩니다.

<br>

또, Greet 클래스는 정적 내부클래스로 정의했는데, 허용되는 메시지 유형의 Scope는 최대한 Actor와 가깝게 정의해야 합니다.

GreetingService의 주입은 Spring 4.3으

**GreetingActor**

```java
@Component
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class GreetingActor extends UntypedActor {
	private GreetingService greetingService;

	@Override
	public void onReceive(Object message) throws Throwable {
		if (message instanceof Greet) {
			String name = ((Greet) message).getName();
			getSender().tell(greetingService.greet(name), getSelf());
		} else {
			unhandled(message);
		}
	}

	@Getter
	@AllArgsConstructor
	public static class Greet {
		private String name;
	}
}
```

<br>

**GreetingService**