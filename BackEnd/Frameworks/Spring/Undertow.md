## Undertow

Underwor란 Non-Blocking/Blocking 작업 모두에 사용할 수 있도록 설계된 NIO 기반의 초경량/고성능 WAS 서버입니다.

### Tomcat 대신 Undertow를 사용하는 이유

오랜시간 Spring Boot의 기본 내장 Tomcat을 사용한지 익숙해서 WAS에 대한 생각을 안해봤었는데 자세히 알아보니

무조건 외장 WAS라고 내장 WAS보다 성능이 좋다는 편견은 사실이 아니었고,

Tomcat 개발자들이 이미 답을 한 내용이지만, 오히려 사용하지 않을 J2EE Spec을 준수하기 위해 본 어플리케이션보다

몸집이 비대한 WAS를 굳이 사용할 필요가 없습니다.

그리고 Tomcat의 경우 오래된 방식의 내부구현으로 인해 시스템에 따라 원인불명의 오동작 문제가 많아서 주기적 모니터링 & 재시작을 해줘야 합니다.

마찬가지로 많은 트래픽이 몰릴경우 제대로 된 응답을 보내주지 못하는 경우도 발생하고 있습니다.

J2EE를 만족하지 않고도 Netty라는 아주 뛰어난 Java Network Library를 이용해 새로운 Servlet Engine이 바로 Undertow입니다.

실제로 ab와 같은 단순한 부하 테스트를 해보면 Undertow는 Tomcat보다 훨씬 빠르고 안정적이며 많은 부하를 감당 가능합니다.

즉, 굳이 J2EE를 이용하지 않고도 Enterprise급 프로그램을 만들 수 있도록 제공되는 Framework를 표방하고 나왔으며

Spring을 쓰는데 J2EE를 지원하는 WAS를 굳이 별도로 사용할 필요성이 있을진 모르겠습니다.

---

## Kotlin Spring Undertow 적용

build.gradle.kts

```
implementation("org.springframework.boot:spring-boot-starter-undertow")
```

위는 기본적인 Undertow Depndency를 추가하는 방법이고 만약 Enterprise급 어플리케이션을 운영중이라면 HA가 필수급이므로,

Undertow Graceful Shudown을 활용해 서비스 중인 노드가 Shutdown이 되더라도 다른 노드가 Active-Standby 방식으로 가용성을 보장하면 좋습니다.

### Spring Boot는 기본적으로 Graceful Shutdown을 지원하지 않는다.

Spring Boot는 종료 시그널 발생시 현재 들어온 요청을 모두 처리하지 않은 채

도중에 애플리케이션 컨텍스트를 모두 제거하기 때문에 익셉션이 발생합니다. 

즉, 개발자가 별도의 로직 처리를 해주어야 합니다.

추후 Graceful Shutdown을 사용할 일이 있으면 그때 글을 올려보겠습니다.
