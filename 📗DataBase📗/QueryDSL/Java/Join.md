## QueryDSL 기본 Join

```
join(조인 대상, 별칭으로 사용할 Q타입)
```

```java
// 기본 조인  
List<Member> result = queryFactory  
        .selectFrom(member)  
        .join(member.team, team)  
        .where(team.name.eq("teamA"))  
        .fetch();
```

---

## 연관관계가 없는 필드 조인

```java
List<Member> result = queryFactory  
        .select(member)  
        .from(member, team)  
        .where(member.username.eq(team.name))  
        .fetch()
```

---

## On Join

> **조인 대상 필터링**

On을 호라용해 조인 대상을 필터링할 때, 내부조인(Inner Join)이라면 where를 쓰는거와 동일하기 떄문에 그냥 where를 쓰자

```java
List<Tuple> result = queryFactory  
        .select(member, team)  
        .from(member).leftJoin(member.team, team).on(team.name.eq("teamA"))  
        .fetch();
```

<br>

> **연관관계 없는 필드 외부 조인**

```java
List<Tuple> result = queryFactory  
        .select(member, team)  
        .from(member).leftJoin(member.username.eq(team.name))  
        .fetch();  
  
for (Tuple tuple : result) {  
    log,info("t : {}", tuple);  
}
```

---

## Fetch Join

- join(), leftJoin()등 조인 기능 뒤에 fetchJoin()을 추가하면 됩니다.

> **Fetch Join 미적용 쿼리**

```java
Member find = queryFactory  
        .selectFrom(member)  
        .where(member.username.eq("member1"))  
        .fetchOne();  
  
boolean loaded = emf.getPersistenceUnitUtil().isLoaded(find.getTeam());  
  
assertThat(loaded).as("Fetch Join 미적용").isFalse();
```

<br>

> **Fetch Join 적용**

```java
Member find = queryFactory  
        .selectFrom(member)  
        .join(member.team).fetchJoin()  
        .where(member.username.eq("member1"))  
        .fetchOne();  
  
boolean loaded = emf.getPersistenceUnitUtil().isLoaded(find.getTeam());  
  
assertThat(loaded).as("Fetch Join 적용").isTrue();
```

---

## 서브쿼리 eq

QueryDSL 에서의 서브쿼리는 **Select / Where** 절에서만 지원합니다. (From은 미지원)

서브쿼리는 JPAExpressions를 통해 생성합니다.

이때 서브쿼리를 ExpressionUtils.as()로 감싸면 결과에 대한 Alias를 지정할 수 있습니다.

**Ex:**

```java
ExpressionUtils.as(
	JPAExpressions.select(subBOard.views.avg()).from(subBoard), "CustomAlias")
)
```

<br>

나이가 제일 많은 회원 조회

```java
QMember memberSub = new QMember("memberSub");

List<Member> result = queryFactory  
        .selectFrom(member)  
        .where(member.age.eq(  
                JPAExpressions  
                        .select(memberSub.age.max())  
                        .from(memberSub)  
        ))  
        .fetch();
```

---

## 서브쿼리 goe

```java
Qmember memberSub = new Qmember("memberSub");  
  
List<Member> result = queryFactory  
        .selectFrom(member)  
        .where(member.age.goe(  
                JPAExpressions  
                        .select(memberSub.age.avg())  
                        .from(memberSub)  
        ))  
        .fetch();
```