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

그리고 서브 쿼리는 성능적으로 안좋기 때문에 보통 쿼리를 나누거나, Join을 통해 해결합니다.

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

---

## QueryDSL Case

```java
List<String> result = queryFactory
	.select(member.age
			.when(10).then("열살")
			.when(20).then("스무살")
			.otherwise("기타"))
	.from(member)
	.fetch();
```

<br>

> **여러 조건**

- 0 ~ 30 살이 아닌 회원 먼저
- 그다음 0 ~ 20 살
- 그다음 21 ~ 30 살

```java
// 복잡한 조건을 변수로 선언해서 select, orderBy 등에서 사용 가능합니다.
NumberExpression<Integer> rankPath = new CaseBuilder()
	.when(member.age.between(0, 20)).then(2)
	.when(member.age.between(21, 30)).then(1)
	.otherwise(3);

List<Tuple> result = queryFactory
	.select(member.username, member.age, rankPath)
	.from(member)
	.orderBy(rankPath.desc())
	.fetch();

for (Tuple tuple : result) {
	String username = tuple.get(member.username);
	Integer age = tuple.get(member.age);
	Integer rank = tuple.get(rankPath);

	log.info("Username : {}, Age : {}, Rank : {}", username, age, rank);
}
```

```
결과 
username = member4 age = 40 rank = 3 
username = member1 age = 10 rank = 2 
username = member2 age = 20 rank = 2 
username = member3 age = 30 rank = 1
```