## **💡 Cookie**  

서버에서 클라이언트에 데이터를 저장, 클라이언트에 저장된 쿠키를 이용하여 데이터를 가져옴

<br>

### **Cookie Option**

- Domain
  - 도메인 불일치 시 쿠키 전송 X
  - 도메인이란? 서브 도메인(ex: www)을 제외한 URL 중 포트까지의 URL을 의미함
  - 이 옵션을 통해 도메인이 다를때 발생할 수 있는 취약점 공격에 대한 방어가 가능함

<br>

- Path
  - 세부 경로 라우팅 기능
  - Default Path = '/'
  - 설정된 Path가 만족하는 경우, 하위의 경로가 존재해도 쿠키 전송이 가능함

<br>

- MaxAge & Expires
  - MaxAge : second 설정 == Session 쿠키
  - Expires : date 설정 == Persistent 쿠키

<br>

- Secure
  - https 프로토콜만 쿠키 전송 허용

<br>

- HttpOnly
  - Default ='false', true 설정 시 Java Script에서 쿠키의 사용자 정보에 접근가능 -> XSS 공격 위험

<br>

- sameSite
  - 요청을 보낸 Origin, Domain, Protocol, Port가 하나라도 다를 시 Cross-Origin으로 구분
  - Lax: 사이트가 서로 달라도, GET 요청이라면 쿠키 전송이 가능하다.
  - Strict: 사이트가 서로 다르면, 쿠키 전송을 할 수 없다.
  - None: 사이트가 달라도, 모든(GET, POST, PUT 등등) 요청에 대해 쿠키 전송이 가능하다.
  - 이러한 옵션들을 지정 후,
  - 서버 -> 클라로 쿠키 전송 시 헤더의 Set-Cookie 프로퍼티에 쿠키를 담아 전송
  - 클라 -> 서버로 쿠키 전송 시 헤더의 Cookie 프로퍼티에 쿠키를 담아 전송

------

## **💡 Session**

사용자가 로그인에 성공 후, 다음 인증을 필요로 하는 작업 수행 시 **매번 로그인**을 해야 할까?

위처럼 인증작업을 수행 할 시, 수 많은 로그인 요청으로 인해 서버의 리소스를 많이 낭비할 수 있다

클라이언트의 저장된 쿠키에 고유한 세션id를 담아 expire옵션 등을 설정하여 간편하게 자격 증명을 검증할 수 있다.

<br>

### **세션의 특징**

- 사용자가 로그인(인증)에 성공한 상태를 세션이라고 함
- 서버는 별도의 저장소에 세션을 저장함 (ex: redis 등 트랜잭션이 빠른 DB)
- 세션이 만들어지면 고유한 세션id 생성 후 클라이언트에 전송 될 응답쿠키에 세션id를 담아 전송
- 쿠키에 담긴 인증 성공 정보(세션id)를 이용해 서버의 api 접근 요청을 통한 서버 리소스 이용 가능
- 쿠키에 세션id가 없으면, 인증 실패로 간주하고 Exception or Error 전송
- 서버 = 세션id 발급 후 클라이언트의 쿠키에 담아 전송 후, 세션 저장 & 세션id로 인증 여부 판단
- 클라이언트 = 쿠키 내부에 세션id 저장

<br>

### **세션id를 이용한 로그아웃 로직 구현**

- 서버에서 세션 정보를 삭제
- 클라이언트에서 쿠키를 갱신
- 서버가 클라이언트의 쿠키를 임의삭제 할 수 없으므로, set-cookie 프로퍼티의 값을 무효한 값으로 갱신하는 방법 사용

------

## **💡 웹 보안 공격**  

**SQL Injection** & **Cross-Site Request Forgery (CSRF)**

<br>

### **SQL Injection 공격 시나리오**

- 클라이언트의 input form에 직접 SQL 쿼리문 작성
- AND 보다 연산 우선순위가 낮은 OR절의 '1'='1'; 가 입력되어 로그인이 성공하는 피해 발생
- SQL 마무리 키워드인 ; 와 같이 중요 테이블을 DROP 하는 SQL 쿼리문 작성

<br>

### **SQL Injection 대응 방안**

- DTO필드에 Validation 적용
  - 필드의 유효성 검증으로 인해 SQL 쿼리 입력 불가능
- Prepared Statement 사용
  - 클라이언트의 입력과 SQL문의 분리, SQL을 입력해도 Text로 인식되어 쿼리 실행 X
- Error Handling
  - DB의 테이블/컬럼 등이 노출되지 않도록 Custom Error Handling 필요

<br>

### **Cross-Site Request Forgery (CSRF) 특징 & 방지**

- 다른 Site에서 HTTP 요청을 가로채 쿼리파라미터의 내용 수정 후 요청 전송
- 쿠키 등을 사용한 로그인 방식으로 인한 same domain 검증으로 인한 방지
- 해커가 예측할 수 없는 필드 등 정보 삽입으로 인한 방지