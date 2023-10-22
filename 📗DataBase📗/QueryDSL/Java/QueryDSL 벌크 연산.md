
## 📘 QueryDSL 벌크 연산

> 📌 **ㅇㅇ**

```java
long count = queryFactory
	.update(member)
	.set(member.username, "비회원")
```