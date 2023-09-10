## **💡 JPQL 객체지향 쿼리**

<br>

### **다양한 쿼리 지원**

- **JPQL**
- JPA Criteria
- **QueryDSL** 
  - 동적 쿼리 생성의 편리함
  - 실무 사용 권장

- Native SQL 
  - JPQL로 해결할 수 없는 DB 의존적인 기능을 사용할 때
  - ex: Oracle CONNECT BY, SQL HINT
  - createNativeQuery() 사용

- JDBC API 직접 사용, MyBatis, SpringJdbcTemplate 함께 사용
  - 영속성 컨텍스트를 적잘한 시점에 강제로 flush가 필요하다.
  - ex: JPA를 우회해서 SQL을 실행하기 직전 수동 flush
  - JPA를 사용하면서  JDBC 커넥션을 직접 사용하거나, JDBC Template, MyBatis 등 혼용 가능

---


### **소개**

- **Java Persistence Query Language**
- 가장 단순한 조회 방법
  - EntityManager.find()
  - 객체 그래프 탐색
    - (a.getB().getC())로 get get get 하면서 계속 찾아다닐 수 없다.

---

### **기타**

- 서브 쿼리 지원
- EXISTS, IN
- BETWEEN, LIKE, IS NULL

------

### **특징**

- JPA를 사용하면 엔티티 객체를 중심으로 개발
- 문제는 검색 쿼리
- 검색을 할 때도 테이블이 아닌 엔티티 객체를 대상으로 검색을 해야한다.
  - DB를 몰라야 한다. 자바 코드에서 멤버 테이블이 있구나 보다, 멤버 객체가 있구나라는
    생각을 가지고 개발해야 한다.
- 근데, 모든 DB 데이터를 객체로 변환해서 검색하는 것은 불가능하다.
- **애플리케이션이 필요한 데이터만 DB에서 불러오려면 결국 검색 조건이 포함된 SQL이 필요하다.**
- 그래서 JPA는 SQL을 추상화한 JPQL이라는 객체 지향 쿼리 언어를 제공한다.
- SQL과 문법이 유사하고, SELECT, FROM, WHERE, GROUP BY, HAVING, JOIN등을 지원한다.
- **JPQL은 엔티티 객체를 대상으로 쿼리**를 질의하고
- **SQL은 데이터베이스 테이블을 대상으로 쿼리**를 질의한다.

- ex) 객체를 대상으로 JPQL 작성

```java
//검색
String jpql= "select m From Member m where m.name like '%hello%'";

List<Member> result = em.createQuery(jpql, Member.class).getResultList();
```

- 위의 JPQL에 의해 변환되어(데이터베이스 방언을 참조해서 DB에 맞는 쿼리로) 실행된 SQL

```sql
select
  m.id as id,
  m.age as age,
  m.USERNAME as USERNAME,
  m.TEAM_ID as TEAM_ID
from
  Member m
where
  m.age>18
```

- 테이블이 아닌 객체를 대상으로 검색하는 객체지향 쿼리라고 이해하면 되며,
- SQL을 추상화해서 특정 데이터베이스 SQL에 의존하지 않는다.
- JPQL을 한마디로 정의하면 객체 지향 SQL 이다.

---

## 💡 JPQL 기본 함수

- CONCAT : 문자 더하기
- SUBSTRING : 자르기
- TRIM : 공백 제거
- LOWER, UPPER : 대소문자
- LENGTH : 길이
- LOCATE : 위치
- ABS, SQRT, MOD : Math
- SIZE, INDEX (JPA 용도) : 컬렉션의 크기

<br>

### **사용자 정의 함수 호출**

- 하이버네이트는 사용전 방언에 추가해야 한다.
- DB에 커스텀 Function 만든 후 사용

```java
public class MyH2Dialect extends H2Dialect {
    public MyH2Dialect() {
        registerFunction("customDB", new StandardSQLFunction("customDB", StandardBasicTypes.String))
    }
}
```

```sql
select function ('customDB', i.name) from Item i
```

------

## 💡 **문법**

```sql
select_문 :: =
  select_절
  from_절
  [where_절]
  [groupby_절]
  [having_절]
  [orderby_절]
  
# 벌크연산
update_문 :: = update_절 [where_절]
delete_문 :: = delete_절 [where_절]
```

- 몇가지 유의 사항은 존재 한다.
  - from절에 들어가는 것은 객체이다.
  - select m from Member m where m.age > 8
  - 엔티티와 속성은 대소문자를 구분
    - 예를 들면, Member 엔티티와 username 필드
  - JPQL 키워드는 대소문자 구분 안함
    - SELECT, FROM, where
  - 엔티티 이름을 사용한다. 테이블 이름이 아니다
    - 엔티티명 Member
  - 별칭은 필수이다, as 생략가능
    - Member의 별칭 m

<br>

### JPQL 타입 표현

문자 : 'HELLO', 'She''s'

숫자 : 10L(Long), 10D(Double) , 10F(Float)

Boolean : TRUE, FALSE

ENUM : org.MemberType.Admin (패키지명 포함), 파라미터 바인딩 사용 권장

엔티티 타입 : TYPE(m) - Member (상속 관계에서 사용)

<br>

### 기타 표현

- SQL과 문법이 같다
- EXIST, IN, AND, OR, NOT
- =, >, >=, <, <=, <>
- BETWEEN, LIKE, IS NULL

<br>

### **집합과 정렬**

- 기본적인 집합 명령어 다 동작 한다.

```sql
select
   COUNT(m),   //회원수
  SUM(m.age), //나이 합
  AVG(m.age), //평균 나이
  MAX(m.age), //최대 나이
  MIN(m.age) //회소 나이
from Member m
```

- GROUP BY, HAVING
- ORDER BY

---

## 💡 조건식 - CASE

조건식에는 기본 CASE, 단순 CASE가 있다.

<br>

### 기본 CASE

```java
String query =
    "select " +
    "case " +
    "when m.age <= 10 then '학생요금' " +
    "when m.age >= 60 then '경로요금' " +
    "else '일반요금' " +
    "end " +
    "from Member m";
```

<br>

### 단순 CASE

```java
String query =
    "select " +
    "case t.name " +
    "when '팀A' then '인센티브110%' " +
    "when '팀B' then '인센티브120%' " +
    "else '인센티브105%' " +
    "end " +
    "from Team t";
```

<br>

### COALESCE

하나씩 조회해서 null이 아니면 반환

```java
select coalesce(m.username, '이름 없는 회원') from Member m
```

<br>

### NULLIF

두 값이 같으면 null 반환, 다르면 첫번째 값 반환

```java
select NULLIF(m.username, '관리자') from Member m
```

------

## **💡 Reference**

- 자바 ORM 표준 JPA 프로그래밍
- 저자 직강 - https://www.youtube.com/watch?v=WfrSN9Z7MiA&list=PL9mhQYIlKEhfpMVndI23RwWTL9-VL-B7U