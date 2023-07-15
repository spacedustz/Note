## **💡 Join**

<br>

### **Inner Join**

- 멤버 내부의 팀에 m.team으로 접근
- 팀이 없으면 조회가 안된다.

```sql
SELECT m
FROM Member m
[INNER] JOIN m.team t
```

```java
// 1:N은 Fetch Type을 Lazy로 하는걸 잊지 말자
String query = "select m from Member m inner join m.temm t";
List<Member> result = em.createQuery(query, Member.class).getResultList();
```

<br>

### **Outer Join**

- 팀이 없어도 멤버만 조회가 된다.

```sql
SELECT m
FROM MEMBER m
LEFT [OUTER] JOIN m.team t
```

```java
String query = "select m from Member m left outer join m.temm t";
List<Member> result = em.createQuery(query, Member.class).getResultList();
```

<br>

### **Theta Join**

- 연관관계 없이 유저명과 팀의이름이 같은 경우 찾아라 라는 쿼리 날릴 수 있다.
- 이런 조인을 세타 조인이라고 한다.

```sql
SELECT COUNT(m)
FROM Member m, Team t
WHERE m.username = t.name
```

```java
String query = "select m from Member m, Temm t where m.username = t.name";
List<Member> result = em.createQuery(query, Member.class).getResultList();
```

참고:

- **하이버네이트 5.1부터 세타 조인도 외부 조인이 가능!**

<br>

### **On** 

조인 대상의 필터링, 연관관계 없는 엔티티의 외부 조인 기능

- **조인 대상 필터링**
- 아래 예시는 회원과 팀을 조인하면서, 팀 이름이 A인 팀만 조인하는 예시이다.

````sql
SELECT m.*
FROM Member m LEFT JOIN Team t
ON m.TEAM_ID=t.id and t.name = 'A'
````

```java
// select 으로 멤버와 팀 둘다 가져온다
// 멤버의 팀을 가져온다 = m.team
// 팀의 이름이 A 인것만 가져온다 =  on t.name = 'A'
String query = "select m from Member m left join m.team t on t.name = 'A'";
```

- **연관관계 없는 엔티티의 외부 조인 가능 (하이버네이트 5.1부터)**
- 아래 예시는 회원의 이름과 팀의 이름이 같은 대상을 외부 조인하는 예시이다.

```sql
SELECT m.*
FROM Member m LEFT JOIN Team t
ON m.username = t.name
```

```java
String query = "select m from Member m left join Team t on m.username = t.name";
```

------

## **💡 Fetch Join**

- 현업에서 굉장히 많이 쓰인다.
- fetchType을 LAZY로 다 세팅 해놓고, 쿼리 튜닝할때 한꺼번에 조회가 필요한 경우 페치 조인을 사용한다.
- 엔티티 객체 그래프를 한번에 조회하는 방법이다.
- 별칭을 사용할 수 없다.
- SQL 조인의 종류가 아니다.
- JPQL에서 성능 최적화를 위해 제공하는 기능이다.
- 연관된 Entity나 Collection을 SQL 한 번에 같이 조회하는 기능 (성능 최적화)
- 글로벌 Fetch 전략보다 우선순위가 높다.
- 객체 그래프를 유지할 때 사용하면 효과적이다.
- **여러 테이블을 조인해서 엔티티가 가진 모양이 아닌 전혀 다른 결과를 내야하면,
  일반 조인을 사용하고 필요한 데이터만 조회해서 DTO로 반환하는 것이 좋다.**
- join fetch 명령어 사용
- ::= [ LEFT [OUTER] | INNER ] join fetch 경로

<br>

JPQL

- 멤버를 조회할 때, 팀까지 같이 조회한다.

```java
createQuery("select m from Member m join fetch m.team");
```

<br>

SQL

```sql
SELECT M.*, T.*
FROM MEMBER T
INNER JOIN TEAM T ON M.TEAM_ID = T.ID
```

최근에(jpa2.1)는 페치 조인 말고 엔티티 그래프라는 기능이 있다. 공부해보자.

---

### **Fetch Join 예시**

```java
String jpql = "select m from Member m join fetch m.team";

List<Member> members = em.createQuery(jpql, Member.class).getResultList();

for (Member member : members) {
   // Fetch Join으로 회원과 팀을 함께 조회해서 지연 로딩이 발생하지 않는다.
   System.out.println("username = " + member.getUsername() + ","
                   + "teamname = " + member.getTeam().name());
}
```

- 현업에서 많이 쓰이는 이유는 리스트 쭉 뿌릴때,
  LAZY로 가게 되면 리스트에서 반복문으로 정보 받아올 때마다 DB에 쿼리가 나간다.
- 이게 JPA N+1 문제이며 성능상 좋지 않다.
  - 리스트가 10명이다.
  - 10명의 리스트를 가져오는 쿼리 한방 나가는데,
    세부 조회를 할 때마다(10번) Lazy 로딩 되므로 쿼리가 총 11번 나가게 된다.
  - [JPA N+1 문제와 해결방안](https://jojoldu.tistory.com/165)

---

### Collection Fetch Join

주로 1:N 관계에서 컬렉션을 가져올 때 사용한다.

중복된 ID값이 있을겅우 distinct를 사용해 컬렉션에서 중복을 제거하지 않으면

보통 원래 데이터보다 더 큰 결과집합이 반환된다.

<br>

JPQL

```java
String query = "select distinct t from Team t join fetch t.members where t.name = 'teamA'";
```

<br>

SQL

```sql
SELECT T.*, M.*
FROM Team T
INNER JOIN Member M
ON T.ID = M.Team_ID
WHERE T.name = 'teamA';
```

---

### 한계

- fetch join 대상은 왠만하면 Alias 부여를 하지 않는게 좋다. (데이터 정합성의 이유)
- 둘 이상의 컬렉션은 Fetch Join을 할 수 없다.
- **컬렉션을 Fetch Join하면 페이징 API를 사용할 수 없다**
  - setFirstResult, setMaxResults 등 사용불가능
  - 1:1, N:1 같은 단일 값 연관 필드들은 Fetch Join시 페이징 API를 사용 가능하다.
  - Hibernate는 경고 로그를 남기고 메모리에서 페이징한다. (매우 위험)

<br>

### 컬렉션 페이징 API 적용

fetch join으로 해결이 불가능한, 컬렉션에 페이징을 적용하려면 BatchSize를 활용한다.

@BatchSize(size = 100), 값은 1000 이하의 적절한 값으로 설정한다.

yml 설정은 hibernate.default_batch_fetch_size의 value도 설정해주면 된다.

이렇게 Batch Size를 설정하면 N+1 쿼리가 아닌 테이블의 수 만큼 쿼리를 맟출 수 있다.

<br>

### 생각해보기

객체 그래프라는건 기본적으로 연관된 데이터를 전부 가져오는것이다.

하지만 fetch join을 하고 조건을 걸어 전체가 아닌 일부만 가져오는것보다,
그냥 직접 그 데이터들을 가져오는 쿼리를 작성하는게 더 낫다.

<br>

그리고, 단일 값 연관 필드가 아닌 컬렉션 값 연관 필드처럼 여러개의 값을 가진 쿼리의
페이징 API가 안되는 이유를 생각해보자.

<br>

간단한 예시로 팀이 "A"인 회원 2명을 조회하고 총 2페이지에 페이지당 1건을 출력한다고 가정한다.

<br>

그럼 2건의 반환 결과 중 한 페이지에 한개의 데이터만 들어가고 다른 하나가 누락되며,
반환결과에 팀 "A"는 회원을 하나만 가지고 있게 되는 셈이다.

