## QueryDSL 기본 Join

```
join(조인 대상, 별칭으로 사용할 Q타입)
```

```java
List<Member> result = queryFactory.selectFrom(member).join(member.team, team).where(team.name.eq("teamA")).fetch();
```

---

## 연관관계가 없는 필드 조임

```java
List<Member> result = queryFactory.select(member).from(member, team).where(member.username.eq(team.name)).fetch()
```

---

## On Join

> **조인 대상 필터링**

```java
List<Tuple> result = queryFactory.select(member, team).from(member).leftJoin(member.team, team).o
```