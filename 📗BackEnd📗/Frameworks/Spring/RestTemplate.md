## 📘 Spring RestTemplate

[참고한 블로그](https://adjh54.tistory.com/234)

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

다양한 Request & Response를 JSON,XML등 바이너리 데이터 형식과 같은 응답 처리를 할 수 있고,

HTTP 요청 및 응답의 부분을 추출하거나 수정할 수 있습니다.

```java
RestTemplate restTemplate = new RestTemplate();
HttpHeaders headers = new HttpHeaders();
headers.add("Content-Type", "application/json");
headers.add("Authorization", "Bearer <Access_Token>");
```

<br>

|**헤더**|**이름 값**|**설명**|
|---|---|---|
|Accept|-|클라이언트가 서버에서 받기 원하는 미디어 타입을 지정합니다.|
|Accept|text/plain|일반적인 텍스트 형식을 지정합니다.|
|Accept|application/json|JSON 형식을 지정합니다.|
|Accept|application/xml|XML 형식을 지정합니다.|
|Content-Type|-|서버에서 클라이언트로 보내는 미디어 타입을 지정합니다.|
|Content-Type|text/plain|일반적인 텍스트 형식을 지정합니다.|
|Content-Type|application/json|JSON 형식을 지정합니다.|
|Content-Type|application/xml|XML 형식을 지정합니다.|

---

## 📘 Header &  Query Parameter 설정

RestTemplate는 HTTP Request에 대한 Request header 및 Query Paramenter를 설정할 수 있습니다.

<br>

**Request Header**

- Request Header는 RestTemplate의 HttpHeaders 클래스를 사용하여 설정합니다.
- HttpHeaders 클래스의 add() 메서드를 사용하여 요청 헤더에 새 항목을 추가합니다.

<br>

**Query Parameter**

- RestTemplate의 exhcange() 메서드를 호출할 때 UriComponentsBuilder를 사용하여 설정합니다.
- UriComponentsBuilder의 queryParam() 메서드를 사용하여 Query Parameter를 추가합니다.

<br>

```java
RestTemplate restTemplate = new RestTemplate();

HttpHeaders headers = new HttpHeaders();
headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl("<http://localhost/api/users>")
	.queryParam("page", 2)
	.queryParam("size", 10);

HttpEntity entity = new HttpEntity<>(headers);

ResponseEntity response = restTemplate.exchange(
	builder.toUriString(),
	HttpMethod.GET,
	entity,
	String.class);
```

---

## 📘 Request & Response에 대한 Logging

RestTemplate Bean을 구성하는데 사용되는 HttpClient는 HTTP 요청 및 응답을 로깅할 수 있는 HttpClientInterceptor를 제공합니다.

HTTP 요청/응답을 가로채서 수정하거나 로깅을 할 수 있는 Interceptor입니다.

Configuration을 설정할 떄 RestTemplate Bean에 HttpClientInterceptor를 추가해주면 됩니다.

<br>

**HttpClientInterceptor의 구현체를 작성합니다.**

```java
public class CustomInterceptor implements HttpClientInterceptor {

	@Override
	public ClientHttpResponse intercept(
		HttpRequest request,
		byte[] body, 
		ClientHttpRequestExecution execution) throws IOException {
			// Request 수정
			request.getHeaders().add("Custom-Header", "Custom-Value");

			// Request 정보 로깅
			log.info("Request URI : {}", request.getURI()); 
			log.info("Request Method : {}", request.getMethod()); 
			log.info("Request Headers : {}", request.getHeaders()); 
			log.info("Request Body : {}", new String(body, "UTF-8"));

			// 다음 인터셉터 또는 요청 실행
			ClientHttpResponse response = execution.execute(request, body);

			// Response 정보 수정
			log.info("Response Status : {}", rseponse.getStatusCode());
			log.info("Response Headers : {}", response.getHeaders());

			return response;
		}
}
```

<br>

RestTemplate 객체를 만들 때 interceptors 속성에 해당 구현체 객체를 넣습니다.

```java
RestTemplate restTemplate = new RestTemplateBuilder()
	.interceptors(new CustomInterceptor())
	.build();
```

---

## 📘 RestTemplate 구성

**Bean 등록**

- Bean에 이름을 지정한 이유는 template() 이라는 빈이 여러개이기 떄문에 Spring에서 빈 충돌을 방지하기 위해 넣어주었습니다.

```java
@Configuration
pubic class RestApiConfig {

	@Bean(name = "api")
	public RestTemplate template() {
		return new RestTemplate();
	}
}
```

<br>

**Bean으로 RestTemplate을 Bean을 주입했으니 다른 클래스에서 쉽게 사용할 수 있습니다.**

```java
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class TestService {
	private final RestTemplate template;

	public void testRequest() {
		String url = "https://security.xxx.com/api"
		ResponseEntty response = restTemplate.getForEntity(url, String.class);
		log.info("응답 값 : {}", response.getBody());
	}
}
```

<br>

> **RestTemplate**


---

## 📘 Header 구성

HttpHeaders를 사용하여 RestTemplate Header를 구성합니다.

<br>

**HttpHeaders 함수 종류**

|**메서드**|**설명**|
|---|---|
|setContentType(MediaType mediaType)|Content-Type 헤더 설정|
|`setAccept(List<MediaType>` acceptableMediaTypes)|Accept 헤더 설정|
|add(String headerName, String headerValue)|특정 헤더 추가|
|`addAll(Map<String, String>` headers)|여러 개의 헤더 추가|
|setBearerAuth(String token)|Authorization 헤더에 Bearer 토큰 추가|
|setBasicAuth(String username, String password)|Authorization 헤더에 Basic 인증 정보 추가|
|setIfNoneMatch(String etag)|If-None-Match 헤더 추가|
|setIfModifiedSince(ZonedDateTime ifModifiedSince)|If-Modified-Since 헤더 추가|
|set(String headerName, String headerValue)|특정 헤더 설정|

<br>

**💡 Content-Type 헤더**  
  
- HTTP 요청 또는 응답에서 ‘전송되는 데이터의 형식’을 지정합니다. 이 헤더는 브라우저나 서버가 어떻게 처리해야 할지를 결정합니다.  
- 예를 들어, text/plain은 일반적인 텍스트 데이터를 나타내고, application/json은 JSON 형식의 데이터를 나타냅니다.  
  
  
**💡 Accept 헤더**  
  
- 클라이언트가 서버에게 요청한 ‘데이터 유형’을 알려줍니다. 이 헤더는 클라이언트가 서버로부터 어떤 유형의 데이터를 받기를 원하는지 지정합니다.  
- 예를 들어, text/html은 HTML 문서를 나타내고, application/json은 JSON 형식의 데이터를 나타냅니다.  
  
  
**💡 If-None-Match 헤더**  
  
- ‘캐시 된 리소스를 다시 가져오는 것을 방지’ 하기 위해 사용됩니다. 이 헤더는 이전에 클라이언트에서 가져온 리소스의 ETag 값을 서버에 전송하여, 새로운 ETag 값이 없는 경우, 서버는 304 Not Modified 응답을 반환하여 클라이언트에게 새로운 리소스를 다시 가져올 필요가 없음을 알려줍니다.  

  
**💡 If-Modified-Since 헤더**  
  
- 클라이언트가 마지막으로 리소스를 가져온 시간’을 지정합니다. 이 헤더는 클라이언트가 리소스가 수정되었는지 여부를 확인하기 위해 사용됩니다. 서버가 클라이언트가 지정한 시간 이후에 리소스를 수정한 경우, 서버는 새로운 리소스를 반환하고, 그렇지 않은 경우 304 Not Modified 응답을 반환하여 클라이언트에게 새로운 리소스를 다시 가져올 필요가 없음을 알려줍니다.

<br>

**MediaType 별 종류 설명**

|**MediaType**|**Content Type**|**설명**|
|---|---|---|
|APPLICATION_JSON|application/json|JSON 형식|
|TEXT_PLAIN|text/plain|일반 텍스트 형식|
|APPLICATION_XML|application/xml|XML 형식|
|APPLICATION_ATOM_XML|application/atom+xml|Atom 피드 형식|
|APPLICATION_FORM_URLENCODED|application/x-www-form-urlencoded|HTML 폼 형식|
|APPLICATION_OCTET_STREAM|application/octet-stream|임의의 바이너리 데이터|
|APPLICATION_PDF|application/pdf|PDF 형식|
|APPLICATION_RSS_XML|application/rss+xml|RSS 피드 형식|
|APPLICATION_XHTML_XML|application/xhtml+xml|XHTML 형식|
|IMAGE_GIF|image/gif|GIF 이미지 형식|
|IMAGE_JPEG|image/jpeg|JPEG 이미지 형식|
|IMAGE_PNG|image/png|PNG 이미지 형식|
|MULTIPART_FORM_DATA|multipart/form-data|여러 개의 다른 형식의 파트를 하나의 요청에 함께 전송|
|TEXT_HTML|text/html|HTML 형식|
|TEXT_XML|text/xml|XML 형식|

---

## 📘 Body & Request Entity 구성

HTTP Request를 보내기 위한 Request Body, Response Entity를 생성하는 코드입니다.

- JSON 형태로 객체를 생성하고 전달할 값을 넣습니다.
- 생성된 객체를 toString() 으