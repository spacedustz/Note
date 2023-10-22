
## 📘 QueryDSL 벌크 연산

**주의점 :** JPQL 배치와 마찬가지로, 영속성 컨텍스트에 있는 Entity를 무시하고 실행되기 때문에 , 배치 쿼리를 실행하고 나면 영속성 컨텍스트를 초기화 하는 것이 안전합니다.

<br>


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