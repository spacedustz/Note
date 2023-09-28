## 📘 Akka Actor

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

## 📘 Akka Actor에 Spring Bean 주입

사람에게 인사를 보내서 사람의 이름을 대답할 수 있는 단일 Actor로 구성된 간단한 Spring/Akka App을 만들어 보겠습니다.

<br>

모든 Akka Actor의 `onReceive` 함수는 메시지를 수신하고 지정된 로직에 따라 처리합니다.

아래 예시 코드와 같은 경우, Greet 메시지가 미리 정의된 Greet 타입인지 확인 후,

다음 Greet 인스턴스에서 사람의 이름을 가져오고 GreetingService를 이용하여 이 사람에 대한 인사말을 받습니다.

인사말을 받고 보낸 사람에게 다시 인사말 문자열로 응답합니다.

이때 메시지가 알수 없는 다른 유형인 경우, unhandled로 메시지가 전달됩니다.

<br>

또, Greet 클래스는 정적 내부클래스로 정의했는데, 허용되는 메시지 유형의 Scope는 최대한 Actor와 가깝게 정의해야 합니다.

<br>

**GreetingActor**

```java
@Component
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@RequiredArgsConstroutor
public class GreetingActor extends UntypedActor {
	private final GreetingService greetingService;

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

Service의 구현은 매우 간단하게 @Component를 통해 Spring 관리 Bean으로 정의했습니다. (기본 싱글톤 범위)

```java
@Component
public class GreetingService {
	
	public String greet(String name) {
		return "Hello, " + name;
	}
}
```

---

## 📘 Akka Extension을 통한 Spring Support

Spring을 Akka와 통합하는 가장 쉬운 방법은 Akka Extension을 사용하는 것입니다.

**Extention은 Actor System 별로 생성된 Singleton Instance 입니다.**

이는 Marker Interface Extension을 구현하는 확장 클래스와 AbstractExtensionId를 상속하는 확장 ID 클래스로 구성됩니다.

이 두 클래스는 강하게 결합되어 있으므로, ExtensionId 클래스 내에 중첩된 Extension 클래스를 구현하는 것이 좋습니다.

<br>

> **Spring Extension**

확장 인스턴스인 SpringExt 객체를 AbstractExtensionId 클래스의 createExtension 함수를 구현하여 생성합니다.

SpringExtension 클래스는 싱글톤 인스턴스에 대한 참조를 가지고 있는 정적 필드인 `SPRING_EXTENSION_PROVIDER`가 있습니다.

SpringExtension이 싱글톤 이어야 함을 명시적으로 나타내기 위해 private 생성자를 추가하는 것이 좋지만, 명확성을 위해 생략합니다.

<br>

> **SpringExt 클래스**

이 클래스는 Extension을 구현한 클래스입니다.

Extension은 단순한 Marker Interface이므로 적절하게 이 클래스의 내용을 정의할 수 있습니다.

이번 예시의 경우 Spring ApplicationContext 인스턴스를 유지하기 위한 초기화 함수가 필요합니다. (`initialize() 함수`)

이 initialize()는 Extention을 초기화 할때마다 1번만 호출됩니다.

<br>

또, Props 객체를 생성하려면 SpringActorProducer 클래스와 이 클래스의 생성자 파라미터인 ApplicationContext, ActorBeanName을 받아서 생성합니다.

props() 함수는 Spring이 관리하는 Actor의 참조가 필요할 때마다 실행됩니다.

SpringActorProducer 클래스의 생성은 아래에서 설명하겠습니다.

<br>

**SpringExtension**

```java
public class SpringExtension extends AbstractExtensionId<SpringExtension.SpringExt> {

	public static final SpringExtension SPRING_EXTENSION_PROVIDER = new SpringExtension();

	@Override
	public SpringExt createExtension(ExtendedActorSystem system) {
		return new SpringExt();
	}

	public static class SpringExt implements Extension {
		private volatile ApplicationContext applicationContext;

		public void initialize(ApplicationContext applicationContext) {
			this.applicationContext = applicationContext;
		}

		public Props props(String actorBeanName) {
			return Props.create(SpringActorProducer.class, applicationContext, actorBeanName);
		}
	}
}
```

<br>

**SpringActorProducer**

Akka의 IndirectActorProducer 인터페이스를 구현하여 생성한 이 클래스는 actorClass()를 구현하여,

Actor의 인스턴스화 프로세스를 재정의 할 수 있습니다.

즉, 직접 인스턴스화 하는 대신 항상 Spring의 ApplicationContext에서 Actor Instance를 검색하게 합니다.

Actor Bean의 Scope를 ProtoType 으로 만들었으므로, 생성자를 호출할 때마다 Actor의 새 Instance가 반환됩니다.

```java
@RequiredArgsConstructor
public class SpringActorProducer implements IndirectActorProducer {
	private final ApplicationContext applicationContext;
	private String beanActorName;

	@Override
	public Actor produce() {
		return (Actor) applicationContext.getBean(beanActorName);
	}

	@Override
	public Class<? extends Actor> actorClass() {
		return (Class<? extends Actor>) applicationContext.getType(beanActorName);
	}
}
```

<br>

이제 남은 할일은 Spring에 모든 중첩된 패키지와 함께 현재 패키지를 스캔하도록 지시하는 Spring Configuration을 작성합니다.

그리고, Spring 컨테이너를 생성해 하나의 추가 Bean(ActorSystem Instance)을 추가하고,

이 ActorSystem에서 Spring Extension을 초기화하기만 하면 됩니다.

```java
@Configuration
@ComponentScan
@RequiredArgsConstructor
public class AppConfiguration {
	private final ApplicationContext applicationContext;

	@Bean
	public ActorSystem actorSystem() {
		ActorSystem system = ActorSystem.create("akka-spring-demo");
		SPRING_EXTENSION_PROVIDER.get(system).initialize(applicationContext);

		return system;
	}
}
```

---

## 📘 테스트

잘 작동하는지 테스트하기 위해 ActorSystem 인스턴스를 코드에 삽입하고 Extension을 사용하여 Actor에 대한 Props 객체를 생성합니다.

그리고, Actor에 대한 참조를 검색할 수 있습니다.

<br>

Props 객체를 통해 누군가에게 인사를 하려고 합니다.

여기서 Scala의 Future 인스턴스를 반환하는 일반적인 `akka.pattern.Patterns.ask` 패턴을 사용합니다.

계산이 완료되면 Future는 GreetingActor.onMessage()에서 반환된 값으로 해결합니다.

Scala의 Await.reslut()를 Future에 적용하여 결과를 기다리거나, 비동기 패턴으로 전체 어플리케이션을 빌드할 수 있습니다.

```java
ActorRef greeter = system.actorOf(SPRING_EXTENSION_PROVIDER
																	.get(system)
																	.props("greetingActor"), "greeter");

FiniteDuration duration = FiniteDuration.create(1, TimeUnit.SECONDS);
TimeOut timeout = Timeout.durationToTimeout(duration);

Future<Object> result = ask(greeter, new Greet("Kim"), timeout);

Assert.assertEquals("Hello, Kim", Await.result(result, duration));
```