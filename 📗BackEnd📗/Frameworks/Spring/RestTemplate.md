## 📘 Spring RestTemplate

HTTP 프로토콜을 사용하여 Rest API에 쉽게 액세스 할 수 있게 해주는 스프링 프레임워크의 클래스입니다.

GET, POST, PUT, DELETE 등의 HTTP Method를 지원하며, 서버로 부터 응답을 받을때 JSON, XML등 다영한 포맷 형식을 지원합니다.

<br>

> **WebCllient vs RestTemplate**

WebClient는 Web Flux에서 제공하는 Reactor를 이용한 비동기 & 논블로킹 방식을 사용하여 데이터를 주고 받는 반면,

Spring WebClient와 비교하여 차이점이 있다면, RestTemplate는 HTTP 요청에 대해 동기식 & 블로킹하여 데이터를 주고 받습니다.

---

##  📘 HTTP Request & Response에 대한 다양한 함수 제공

RestTemplate의 경우 Http 요청 및 응답에 대한 HTTP Method 별 (GET,POST,PUT,PATCH,DELETE) 함수를 제공합니다.

<br>

|**Method**|**HTTP Method**|**Return Type**|**설명**|
|---|---|---|---|
|**getForObject()**|GET|Object|GET 요청에 대한 결과를 객체로 반환합니다|
|**getForEntity()**|GET|ResponseEntity|GET 요청에 대한 결과를 ResponseEntity로 반환합니다|
|**postForLocation()**|POST|URI|POST 요청에 대한 결과로 헤더에 저장된 URI 반환합니다|
|**postForObject()**|POST|Object|POST 요청에 대한 결과를 객체로 반환합니다|
|**postForEntity()**|POST|ResponseEntity|POST 요청에 대한 결과를 ResponseEntity로 반환합니다|
|**put()**|PUT|void|PUT 요청을 실행합니다|
|**patchForObject()**|PATCH|Object|PATCH 요청을 실행하고 결과를 객체로 반환합니다|
|**delete()**|DELETE|void|DELETE 요청을 실행합니다|
|**headForHeaders()**|HEADER|HttpHeaders|헤더 정보를 추출하고 HTTP HEAD 메서드를 사용합니다|
|**optionsForAllow()**|OPTIONS|`Set<HttpMethod>`|지원되는 HTTP 메서드를 추출합니다|
|**exchange()**|any|ResponseEntity|헤더를 생성하고 모든 요청 방법을 허용합니다|
|**execute()**|any|T|요청/응답 콜백을 수정합니다|

---

## 📘 HTTP Request & Response의 자동 변환/역직렬화

RestTemplate는 요청 및 응답을 자동으로 변환하고 역직렬화 하는 기능을 제공합니다.

변환은 내부적으로 MessageConverter에 의해 자동으로 처리됩니다.

MessageConverter는 요청 및 응답 Body의 데이터 형식을 반환하고, Header의 컨텐츠 형식을 설정합니ㅏㄷ.

기본적으로 다양한 MessageConverter를 제공하며, 어플리케이션에서 직접 추가할 수 있습니다.

<br>

```java
// RestTemplate 인스턴스 생성
RestTemplate restTemplate = new RestTemplate();

// Request Paramater 설정
HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_JSON);
HttpEntity<RequestDto> request = new HttpEntity<>(requestDto, headers);

// HTTP 요청 및 응답 처리
ResponseDto response = restTemplate.exchange(url, HttpMethod.POST, request, ResponseDto.class).getBody();
```

---

## 📘 Request & Response를 다양한 형식으로 처리



```java

```