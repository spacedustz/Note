
## 📘 QueryDSL 벌크 연산

**주의점 : ** 

> 📌 **쿼리 1번으로 대량 데이터 수정**

```java
// 회원 이름 전부 변경
long count = queryFactory
	.update(member)
	.set(member.username, "비회원")
	.execute();

// 회원 나이에 전부 + 1
long count = queryFactory
	.update(member)
	.set(member.age, member.age.add(1))
	.execute();
```

<br>

> 📌 **쿼리 1번으로 대량 데이터 삭제**

```java
long count = queryFactory
	.delete(member)
	.where(member.age.gt(18))
	.execute();
```