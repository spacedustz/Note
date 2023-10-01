## 📘 Spring RestTemplate

HTTP 프로토콜을 사용하여 Rest API에 쉽게 액세스 할 수 있게 해주는 스프링 프레임워크의 클래스입니다.

GET, POST, PUT, DELETE 등의 HTTP Method를 지원하며, 서버로 부터 응답을 받을때 JSON, XML등 다영한 포맷 형식을 지원합니다.

<br>

> **WebCllient vs RestTemplate**

WebClient는 Web Flux에서 제공하는 Reactor를 이용한 비동기 & 논블로킹 방식을 사용하여 데이터를 주고 받는 반면,

Spring WebClient와 비교하여 차이점이 있다면, RestTemplate는 HTTP 요청에 대해 동기식 & 블로킹하여 데이터를 주고 받습니다.

---

##  다양한 함수