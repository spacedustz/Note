## **💡 Native Application**

<br>

### **장점**

- 웹앱보다 빠르고, 설치된 기기의 시스템/리소스 접근 용이 (ex: GPS , Camera)
- 오프라인 환경에서 사용가능, 웹앱에 비해 보안성 ↑ , 임베디드와는 조금 다른 개념

<br>

### **단점**

- 느린 업데이트, 앱스토어에 승인이 까다롭고 비용발생
- 웹앱에 비해 개발비용 증가 (플랫폼 호환성)

------

## **💡 TCP/IP**

- OSI 7 계층에선 3계층인 IP와 4계층인 TCP를 합친 통신규약의 모음(프로토콜 스택)
- TCP/IP 4계층은 데이터가 계층이동을 할때마다 헤더를 추가하고(캡슐화),
  추가된 헤더를 읽고 알맞은 행동을 취한 후 ,헤더 제거(역캡슐화)

<br>

### **TCP 3 Way HandShaking**

- Listen - Received - Established
- SYN Flag - SYN/ACK Flag - ACK Flag

------

## **IP Address**

- 크게 공인,사설 아이피가 있으며 대역마다 정해진 IP range가 존재한다 (WAN = 공인, LAN=사설)
- 사설 IP 대역 (사설 대역을 제외한 나머지 대역은 공인IP 대역)
  - 10.0.0.0 ~ 10.255.255.255
  - 172.16.0.0 ~ 172.31.255.255
  - 192.168.0.0 ~ 192.168.255.255
- 보통 1개의 대역당 네트워크, 브로드캐스트, 게이트웨이 주소를 제외한 나머지 주소를 서브넷에 따라 IP 가용 가능
  - 보통 통상적으로 네트워크 당 IP 할당을 0번,게이트웨이 1번,브로드캐스트 255번을 사용한다.
  - 게이트웨이 주소는 임의로 변경 가능 보통 1,254 번 사용
  - ex) prefix가 25일 경우는 0~127 에서 0(network) 127(broadcast)를 제외한 1 or 126번이 보통 게이트웨이 IP로 씀

------

## **Subnet Mask**

- 서브넷은 2진수로된 4개의 8비트필드이며 1필드당 옥텟이라고 부르고, 4개의 옥텟 으로 이루어져있다
- 2진수 필드에서 1 = 네트워크, 0 = 호스트
- **prefix가 몇**이냐에 따라 네트워크의 개수와 호스트의 가용 가능 수를 알 수 있음
  - ex) **prefix가 26**인 255.255.255.192 의 비트를 보자.11111111.11111111.11111111.11000000 이며
    1 부분이 네트워크 0 부분이 호스트임
  - 아주 간단히 설명하면 네트워크 개수 = 2^n (n=추가된 비트 수) 이며 프리픽스가 26이면,
    24에서 26으로 2가 증가했으니 2^2=4 4개의 네트워크로 서브넷팅 된것이며,
    네트워크를 4개로 분리했으니 1개의 네트워크당 0~63,64~127,~128~191,192~255 의 IP대역을 가짐
  - **prefix가 30이면?** 네트워크가 64개로 분리된것이고 1개의 네트워크당 4개의 호스트를 가지며,
    네트워크당 네트워크,브로드캐스트,게이트웨이 주소를 할당하면 가용가능한 IP는 1개일 것임.
    0~3 : 0=네트워크주소 1=게이트웨이주소 3=브로드캐스트주소, 그럼 남는건 2번 하나로 사용가능 IP는 1개이다

------

## **Wild Mask**

서브넷의 10진주소를 반전시켜 놓은 것, 라우터의 OSPF 라우팅테이블 설정,방화벽 등 서버의 각종 설정에 쓰인다

------

## **URL**

:scheme: :host: :url-path: :query:

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/network.png)

------

## **Domain**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/network2.png)

<br>

### **nslookup**

- set type=a(a record) = ip에 매핑될 도메인 (ipv4)
- set type=aaaa(aaaa record) = ipv6
- set type=mx(mx record) = 메일서버
- set type=txt(spf record) = 도메인 질의(접근제어, whitelist 개념)
- set type=ptr([tr record) = 역방향 질의(접근제어, 보통 해외메일 체크시 사용)

------

## **쿠키 & 세션**

- 쿠키 = 웹앱에서 유저가 설정했던 항목들에 대해 저장
- 세션 = 서버에 Session-id를 할당해서 유저 식별, 세션정보는 쿠키에서 관리하며, 실제매칭값은 서버에서 관리

------

## **Server Side Rendering** vs **Client Side Rendering**

- SSR = 서버내에서 렌더링상태로 웹에 전송, SEO 최적화
- CSR = 클라이언트에서 렌더링, DB데이터를 가져올떈 API 호출

------

## **Web Security**

- Cross-Origin Resource Sharing (CORS) 
- XSS
-  CSRF

------

## **HTTP Message**

- HTTP의 특징: **Stateless(무상태성)**

<br>

###  **HTTP Message의 구조**

- start line : start line에는 요청이나 응답의 상태를 나타냅니다. 항상 첫 번째 줄에 위치함
           응답에서는 status line이라고 부름
- HTTP headers : 요청을 지정하거나, 메시지에 포함된 본문을 설명하는 헤더의 집합임
- empty line : 헤더와 본문을 구분하는 빈 줄이 있음
- body : 요청과 관련된 데이터나 응답과 관련된 데이터 또는 문서를 포함함.
        요청과 응답의 유형에 따라 선택적으로 사용

이 중 start line과 HTTP headers를 묶어 요청이나 응답의 헤드(head)라고 하고, [payload](https://ko.wikipedia.org/wiki/페이로드_(컴퓨팅))는 body라고 이야기함

<br>

### **HTTP Request**

- 수행할 작업(GET,PUT,POST 등)이나 방식(HEAD or OPTIONS)을 설명하는 HTTP Method를 나타냄
  ex) GET Method는 리소스를 받아야하고, POST method는 데이터를 서버로 전송
- 요청 대상(일반적으로 URL이나 URI) 또는 프로토콜, 포트, 도메인의 절대 경로는 요청 컨텍스트에 작성됨
  이 요청 형식은 HTTP method 마다 다름
- HTTP 버전에 따라 HTTP message의 구조가 달라짐, 따라서 start line에 HTTP 버전을 함께 입력

<br>

###  **Chrome Error Message**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/network3.png) 

------

## **자가 점검 리스트**

- 웹 애플리케이션 네이티브 애플리케이션의의 기본 개념에 대해 이해할 수 있다.
- 네트워크를 만드는 기술을 이해할 수 있다.
  - TCP/IP의 기본에 대해 이해할 수 있다.
  - IP의 기본개념에 대해 이해할 수 있다.
  - TCP와 UDP 개념과 그 차이를 이해할 수 있다.
  - PORT의 개념과 그 차이를 이해할 수 있다.
  - URL, DNS의 기본에 대해 이해할 수 있다.
  - DNS 기본적인 작동원리를 이해할 수 있다.
- 웹을 구성하는 기술을 이해할 수 있다.
  - 웹의 기본적인 개념에 대해 이해할 수 있다.
  - 클라이언트-서버 아키텍처에 대해 이해할 수 있다.
  - 웹 애플리케이션 아키텍처에 대해 이해할 수 있다.
  - 웹 애플리케이션 아키텍처 요청흐름에 대해 이해할 수 있다.
  - 웹 애플리케이션을 구현하는 방식과 기술들에 대해 이해할 수 있다.
  - SSR 과 CSR의 기본 개념과 그 차이를 이해할 수 있다.
  - CORS 의 기본 개념에 대해 이해할 수 있다.
  - SPA 를 가능하게 하는 AJAX에 대해 이해할 수 있다.
- HTTP messages의 구조를 설명할 수 있다.
  - HTTP의 동작 방식을 이해할 수 있다.
  - HTTP requests와 responses를 구분할 수 있다.
  - HTTP의 응답 메시지를 찾아볼 수 있다.