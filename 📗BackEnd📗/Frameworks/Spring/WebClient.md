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

---

## 📘 Synchronouse & Asynchronouse

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/webclient.png)

<br>

> 📌 **Sync Blocking / Sync Non-Blocking**

**Sync Blocking**

동기 방식의 블로킹은 작업을 수행한 순서에 맞게 수행됩니다.

- Kernel : 작업 할동안 대기하셈
- Application : 기다리는중
- Kernel : 끝남, 결과 받으셈

<br>

**Sync Non-Blocking**

동기 방식의 논블로킹은 작업을 시작하고 제어권을 다시 돌려주기 때문에 다른 작업을 수행할 수 있습니다.

종료 시점은 Application단의 Process or Thread가 Polling(지속적인 완료 확인) 을 합니다.

- Kernel : 나 작업할 동안 딴거 하고 있으셈
- Application : (다른 일 하면서) 다 됨?
- Kernel : ㄴㄴ
- Application : (다른 일 하면서2) 다 됨?
- Kernel : ㅇㅇ 받으셈 (결과)

<br>

> 📌 **Async Blocking / Async Non-Blocking**

**Async Blocking**

비동기 방식의 블로킹은 비동기의 장점을 못살리는 대표적인 경우입니다.

- Application : 결과 나오면 알려주셈
- Kernel : ㄴㄴ 작업 동안 기달리셈 (Blocking)
- .....
- Kernel : 끝남 가져가셈 (결과)

---

## WebClient

> 📕 **Dependencies**

```groovy
implementation 'org.springframework.boot:spring-boot-starter-webflux'
```

<br>

