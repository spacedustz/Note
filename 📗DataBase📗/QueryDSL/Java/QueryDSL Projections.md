## QueryDSL Projections

<b

> **프로퍼티 직접 접근**

```java
List<MemberDto> result = queryFactory
	.select(Projections.bean(MemberDto.class, member.username, member.age))
	.from(member)
	.fetch();
```