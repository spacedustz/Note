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

> 📕 **제어권 반환 : Blocking & Non-Blocking**

**Blocking**

- Application이 Kernel로 작업 요청을 할 때, Kernel에서는 요청에 대한 로직을 실행합니다.
- 이 때, Application은 요청에 대한 응답을 받을 때까지 대기합니다.
- Application은 Kernel이 작업을 끝낼때까지 백그라운드에서 작업이 끝났는지 지속적으로 확인합니다. (Polling)

<br>

**Non-Blocking**

- Application이 요청을 하고 바로 **제어권**을 돌려받습니다.
- 즉, 요청이 Blocking 되지 않았으므로 Non-Blocking이라고 불립니다.

<br>

> **📕 응답값 반환 : Sync & Async**

Blocking & Non-Blocking은 **제어권 반환**에 중점을 두지만, Sync & Async는 **응답값 반환**에 중점을 둡니다.

Sync는 결과값을 직접 받아 처리하는 반면, Async는 결과값을 받을때 어떻게 할지의 CallBack 함수를 미리 정의합니다.

<br>

> 📌 **Sync Blocking / Sync Non-Blocking**

동기 방식의 블로킹은 작업을 수행한 순서

<br>

> 📌 **Async Blocking / Async Non-Blocking**

---

## WebClient

> 📕 **Dependencies**

```groovy
implementation 'org.springframework.boot:spring-boot-starter-webflux'
```

<br>

