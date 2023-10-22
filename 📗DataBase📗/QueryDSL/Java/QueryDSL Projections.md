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

---

## @QueryProjection - 프로젝션 결과 반환

> **생성자 + @QueryProjection**

```java
@Data
@NoArgsConstructor
public class MemberDto {
	private String username;
	private int age;

	@QueryProjection
	public MemberDto(String username, int age) {
		this.username = username;
		this.age = age;
	}
}
```

<br>

> **@QueryProjection 활용**

컴파일러로 타입을 체크할 수 있는 가장 안전한 방법입니다.

단점은, DTO에 @QueryProjection 어노테이션 유지와, DTO까지 Q Type을 생성해야 합니다.

```java
List<MemberDto> result = queryFactory
	.select(new QMemberDto(member.username, member.age))
	.from(member)
	.fetch();
```