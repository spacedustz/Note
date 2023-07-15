## 💡 TypeQuery  &  Query

- TypeQuery
  - 반환 타입이 명확할 때 사용
- Query
  - 반환 타입이 명확하지 않을 때 사용

```java
// Member 타입, 명확한 반환 타입
TypedQuery<Member> query =
    em.createQuery("SELECT m FROM member m", Member.class);

// String, int 2가지의 명확하지 않은 반환 타입
Query query = 
    em.createQuery("SELECT m.username, m.age from Member m");
```

---

## 💡 JPA Sub Query

쿼리 안에 서브 쿼리 작성

<br>

### JPA 서브 쿼리의 한계

- JPA는 WHERE, HAVING 에서만 서브 쿼리 사용 가능
- SELECT도 가능 (Hibernate에서 지원)
- FROM의 서브 쿼리는 현재 JPQL에서 불가능
  - JOIN으로 풀 수 있으면 풀어서 해결한다.

<br>

### 지원 함수

- [NOT] EXISTS : 서브쿼리에 결과가 존재하면 TRUE
  - {ALL | ANY | SOME} : 서브쿼리
  - ALL 모두 만족하면 TRUE
  - ANY, SOME : 같은의미, 조건을 하나라도 만족하면 TRUE
- [NOT] IN : 서브쿼리의 결과 중 하나라도 같은 것이 있으면 TRUE

<br>

서브쿼리 예시

- 팀 A소속인 회원

```java
select m from Member m where exists (select t from m.team t where t.name = '팀A')
```

- 전체 상품 각각의 재고보다 주문량이 많은 주문들

```java
select o from Order o where o.order Amount > ALL (select p.stockAmount from Product p)
```

- 어떤 팀이든 팀에 소속된 회원

```java
select m from Member m where m.team = ANY (select t from Team t)
```

