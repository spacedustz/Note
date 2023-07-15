## **💡 HTTP API 설계**

- HTTP API 컬렉션 = POST 기반 등록 - 서버가 리소스 URI 결정
- HTTP API 스토어 = PUT 기반 등록 - 클라이언트가 리소스 URI 결정
- HTML Form 사용 = 순수 HTML + HTML Form 사용, GET, POST만 지원, 컨트롤 URI 사용(동사)

<br>

### **URI 설계**

**[참고 사이트](https://restfulapi.net/resource-naming)**

- Document - 단일 개념, ex) /users/20, /files/abc.jpg
- Collection - 서버 주체의 리소스 디렉터리, 리소스의 생성,관리 ex) /users
- Store - 클라이언트 주체의 리소스 저장소, ex) /files
- Controller, Controll URI - 위의 사항들로 해결이 힘든 추가 프로세스 실행 (동사 사용)

<br>

###  **Status Code**

- 1xx - Information
- 2xx - Successful
- 3xx - Redirection
  - PRG 패턴 - Post / Redirect / Get
  - 304 Not Modified - 리소스 수정이 되지 않았음을 전달 후, 로컬에 저장된 캐시를 리다이렉트, 응답에 메시지 바디 포함X
- 4xx - Client Error
  - 403 Forbidden - 접근 권한 불충분
- 5xx - Server Error
  - 503 Service Unavailable - 일시적 서버 과부하

 <br>

### **HTTP Header**

- header-field = field-name":" OWS field-value OWS (OWS: 띄어쓰기 허용)
- field-name - 대소문자 구분 X
- HTTP 전송에 필요한 모든 부가정보 포함
- 바디 내용,크기,압축,인증,요청 클라이언트,서버 정보, 캐시 관리 정보 등

<br>

### **HTTP Header 분류 (RFC7230)**

- 메시지 본문(Payroad)을 통해 표현 데이터 전달
- 표현은 요청 & 응답에서 전달할 실제 데이터를 의미함
- 표현 헤더의 세부 정보
  - Content-type - ex) application/json (Default = UTF-8)
  - Content-Encoding - gzip & identity(압축X)
- 협상 헤더의 세부 정보 (클라이언트가 선호하는 표현 요청, 협상헤더는 요청 시에만 사용)
  - Accept - 선호하는 미디어 타입 전달
  - Accept-Charset - 선호하는 문자 인코딩
  - Accept-Encoding - 선호하는 압축 인코딩
  - Accept-Language - 선호하는 자연어
- 협상 우선순위 (Quality Values)
  - 0~1 클수록 높은 우선순위
  - 구체적인 요청 우선

<br>

### **전송 방식**

- 단순 전송 - ex) content-type: text/html
- 압축 전송 - ex) content-encoding: gzip
- 분할 전송 - ex) transfer-encoding: chunked (context-length는 넣으면 안됨)
- 범위 전송 - ex) content-range: bytes 501-1000

<br>

### **일반 헤더 정보**

- From : 유저 에이전트 이메일 정보 - 검색엔진, 요청에서 사용
- Referer : 이전 웹페이지 주소 - 현재 요청 페이지의 이전 페이지 주소, 유입경로 분석, 요청에서 사용
- User-Agent : 유저 에이전트 어플리케이션 정보 - 통계 정보, 장애 추적, 요청에서 사용
- Server : 요청을 처리하는 ORIGIN 서버의 소프트웨어 정보, -응답에서 사용
- Date : 메시지 발생 시간 - 응답에서 사용

<br>

### **특별 헤더 정보**

- Host : 요청한 호스트 정보(도메인) - 필수, 다중 도메인 처리, 요청에서 사용
- Location : 페이지 리다이렉션, 3xx
- Allow : 허용 가능한 HTTP Method, 405
- Retry-After : User Agent가 다음 요청을 하기까지 기다리는 시간, 503

<br>

## **인증 헤더 정보**

- Authorazation : 클라이언트 인증 정보 서버에 전달
- WWW-Authenticate : 리소스 접근시 필요한 인증 방법 정의, 401

<br>

### **쿠키**

- Set-Cookie : 서버에서 클라이언트로 쿠키 전달(응답)
- Cookie : 클라이언트가 서버에서 받은 쿠키 저장, HTTP 요청시 서버로 전달
- 사용자 로그인 세션 관리, 광고 정보 트래킹
- 최소한의 정보만 사용(세션id, 인증 토큰)
- 도메인, 경로 지정 가능
- 브라우저 내부에 데이터 저장 원할 시 웹 스토리지 사용
- 생명주기 - 만료날짜를 입력 안하면 브라우저 종료시 까지만 유지

<br>

### **캐시**

- 캐시 적용 : cache-control: max-age=30
- 검증 헤더 추가 : Last-Modified: 2022년 10월 10일