## 💡 페이징 API

JPA는 페이징 API를 다음 두 API로 추상화 해뒀다.

- 조회 시작위치(0부터 시작)
  - setFirstResult(int startPosition)
- 조회할 데이터 수
  - setMaxResults(int maxResult)

<br>

### **예시**

- 모든 데이터 베이스의 방언이 동작한다.
- LIMIT & OFFSET은 MySQL 방언이다.
  - hibernate.dialect를 Oracle12cDialect로 변경해주면 
    Oracle 방언인 rownum 3 depth 전략으로 페이징을 짠다.

```java
// Member Class에 toString()을 Override 해준다.
for (int i=0, i<100; i++) {
    Member member = new Member();
    member.setUsername("member" + i);
    member.setAge(i);
    em.persist(member);
}

em.flush();
em.clear();

// desc = 역순
List<Member> resultList = em
    .createQuery("select m from Member m order by m.age desc", Member.class)
    .setFirstResult(1)
    .setMaxResult(10)
    .getResultList();

System.out.println("result.size = " + result.size());
for (Member m : result) {
    System.out.println("m = " + member)
}
```

```sql
SELECT
  M.ID AS ID,
  M.AGE AS AGE,
  M.TEAM_ID AS TEAM_ID,
  M.NAME AS NAME
FROM
  MEMBER M
ORDER BY
  M.name DESC LIMIT ?, offset ?
```

<br>

위 쿼리의 Oracle 방언

```sql
SELECT * FROM
  ( SELECT ROW_.*, ROWNUM ROWNUM_
   FROM
      ( SELECT
          M.ID AS ID,
          M.AGE AS AGE,
          M.TEAM_ID AS TEAM_ID,
          M.NAME AS NAME
         FROM MEMBER M
         ORDER BY M.NAME
        ) ROW_
    WHERE ROWNUM <= ?
    )
WHERE ROWNUM_ > ?
```
