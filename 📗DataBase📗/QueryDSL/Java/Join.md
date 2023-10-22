## QueryDSL 기본 Join

```
join(조인 대상, 별칭으로 사용할 Q타입)
```

```java
List<Member> result = queryFactory.selectFrom(member).join(member.team, team).where(team.name.eq("teamA")).getch()
```
