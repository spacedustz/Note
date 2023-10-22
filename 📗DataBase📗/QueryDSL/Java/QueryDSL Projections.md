## QueryDSL Projections

> **프로퍼티 직접 접근**

```java
List<MemberDto> result = queryFactory
	.select(Projections.bean(MemberDto.class, member.username, member.age))
	.from(member)
	.fetch();
```

<br>

> **필드 직접 접근**

```java
List<MemberDto> result = queryFactory
	.select(Projections.fields(MemberDto.class, member.username, member.age))
	.from(member)
	.fetch();
```

<br>

> **별칭이 다를 때**

```java
List<UserDto> fetch = queryFactory
	.select(Projections.fields(
		UserDto.class, 
		member.username.as("name"), 
		ExprettionUtils.as(
			JPAExpressions.select(memberSub.age.max()).from(memberSub), "age")
			)
	).from(member)
	.fetch();
```

<br>

> **생성자 사용**

```java
List<MemberDto> result = queryFactory
	.select(Projections.constructor(MemberDto.class, member.username, member.age))
	.from(member)
	.fetch();
```