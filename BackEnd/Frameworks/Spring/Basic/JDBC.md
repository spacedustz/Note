## **💡 JDBC**  

### **JDCB API 동작 흐름**

- JDBC 드라이버 로딩 - DriveManager 클래스 통해서 로딩
- Connection 객체 생성 - DriverManagerfmf 통해 DB와 연결되는 세션인 객체 생성
- Statement 객체 생성 - 작성된 쿼리문을 실행하기 위한 객체로, 객체 생성 후 정적 퀴리 문자열을 입력으로 가짐
- 쿼리 실행 - 생성된 Statement 객체를 이용해서 쿼리 실행
- ResultSet 객체로부터 데이터 조회 - 실행된 쿼리문에 대한 데이터 Set
- ResultSet -> Statement -> Connection 순으로 객체 Close

<br>

### **Connection Pool (DBCP)**

- Connection 객체 생성은 리소스를 많이 요구한다.
- 그래서, 미리 Connection 객체를 생성해두고 DB 연결 요청이 오면 만들어둔 객체 사용
- 성능 향상
- 이러한 작업을 해두는 툴을 스프링 부트에선 Default로 **HikariCP**를 DBCP로 지정

<br>

### **ORM (Object-Relational Mapping) 객체 중심 기술**

- 이전에는 SQL 쿼리 중심의 기술로 SQL 쿼리문이 중심이었지만, 요즘은 객체 중심이라고 하여
  객체를 전달하면 자동으로 SQL문으로 매핑후 DB에서 데이터를 조작할 수 있다.
- 자바에서 대표적인 ORM 기술은 JPA.

<br>

### **Spring Data JDBC 적용 순서**

- build.gradle 라이브러리 추가
- application.yml에 DB설정 추가
- resourse에 sql파일 생성 후 sql script 작성
- application.yml에 스크립트 파일 매핑
- DB와 연동할 Entity 생성
- Repository 생성
- Service에 Repo를 DI주입
- Repo에 상속된 crud인터페이스의 메소드를 이용해서 DB작업 수행