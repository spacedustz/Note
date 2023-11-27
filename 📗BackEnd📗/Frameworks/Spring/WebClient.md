## 📘 Spring WebClient

Spring WebClient는 RestTemplate을 대체하는 HTTP Client 입니다.

기존 Sync API를 제공하며, Non-Blocking & Async 방식을 지원해서 효율적인 통신이 가능합니다.

<br>

WebClient는 Builder 방식의 인터페이스를 사용하며, 외부 API로 요청을 할 때 **리액티브 타입**의 전송과 수신을 합니다. (Mono, Flux)

<br>

> 📕 **WebClient의 특징**

- Single Thread 방식
- Non-Blocking 방식
- Json, Xml의 쉬운 응답

<br>

> 📕 **제어권 반환**

**Blocking**

- Application이 Kernel로 작업 요청을 할 때, Kernel에서는 요청에 대한 로직을 실행합니다.
- 이 때, Application은 요청에 대한 응답을 받을 때까지 대기합니다.
- Application은 Kernel이 작업을 끝낼때까지 백그라운드에서 작업이 끝났는지 지속적으로 확인합니다.

<br>

> 📕 **Dependencies**

```groovy
implementation 'org.springframework.boot:spring-boot-starter-webflux'
```

<br>

