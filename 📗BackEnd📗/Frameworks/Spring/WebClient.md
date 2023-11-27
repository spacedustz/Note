## 📘 Spring WebClient란?

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

---

## 📘 Sync & Asyn / Blocking & Non-Blocking 개념

Blocking & Non-Blocking은 **제어권 반환**에 중점을 두지만, Sync & Async는 **응답값 반환**에 중점을 둡니다.

Sync는 결과값을 직접 받아 처리하는 반면, Async는 결과값을 받을때 어떻게 할지의 CallBack 함수를 미리 정의합니다.

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
- Kernel : ㅇㅇ 받으셈 (결과값)

<br>

> 📌 **Async Blocking / Async Non-Blocking**

**Async Blocking**

비동기 블로킹 방식은 비동기의 장점을 못살리는 대표적인 경우입니다.

- Application : 결과 나오면 알려주셈
- Kernel : ㄴㄴ 작업 동안 기달리셈 (Blocking)
- .....
- Kernel : 끝남 가져가셈 (결과값)
- Application : ㅇㅇ..

<br>

**Async Non-Blocking**

비동기 논블로킹 방식은 **작업**에 대한 서로의 자유도가 높습니다.

각자 할일을 수행하며, 필요한 시점에 각자 결과를 처리합니다.

- Application : 결과 나오면 알려주셈
- Kernel : ㅇㅇ 다른거 해
- .....
- Kernel : 작업 끝남 (결과물)
- Application : ㄱㅅ

---

## 📘 WebClient 생성

WebClient를 생성하는 방법은 2가지가 있습니다.

단순하게 create() 이용하는 방법과, option을 추가할 수 있는 build()를 사용한 생성이 있습니다.

<br>


> 📕 **Dependencies**

```groovy
implementation 'org.springframework.boot:spring-boot-starter-webflux'
```

<br>

> 📕 **create()**

- 단순하게 WebClient의 Default Setting으로 아래와 같이 생성합니다. Base URL과 함께 생성도 가능합니다.

```java
WebClient.create();
// or
WebClient.create("http://localhost:8080");
```

<br>

> 📕 **builder()**

설정을 Custom하게 바꿔서 널을 수 있는 DefaultWebClientBuilder 클래스를 사용하는 build()를 사용합니다.

**Options**

- **uriBuilderFactory** : Base URL을 커스텀 한 UriBuilderFactory
- **defaultHeader** : 모든 요청에 사용할 헤더
- **defaultCookie** : 모든 요청에 사용할 쿠키
- **defaultRequest** : 모든 요청을 커스텀할 Consumer
- **filter** : 묘든 요청에 사용할 클라이언트 필터
- **exchangeStrategies** : HTTP Message Reader & Writer 커스터마이징
- **clientConnector** : HTTP Client Library Settings

<br>

```java
// 예시
@Bean 
public WebClient webClient() {  
    return WebClient.builder()  
            .baseUrl("http://localhost:8080")  
            .defaultCookie("cookieKey", "cookieValue")  
            .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)  
            .defaultUriVariables(Collections.singletonMap("url", "http://localhost:8080"))  
            .build();  
}
```

---

## WebClient Configuration