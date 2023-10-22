## 📘 QueryDSL Projections

만약 아래 코드와 같이 프로젝션 대상이 여러개인 경우, 명확한 타입을 지정할 수 없습니다.

그래서 **Tuple 이나 DTO**로 값을 조회할 수 있습니다.

<br>

하지만 Tuple로 값을 가져오는 경우는 QueryDSL에 종속적이고, 

Model 객체를 로직에서 사용하는 문제를 가지고 있기에 최대한 Repository에서만 사용하는 것이 좋습니다.

<br>

즉, Repository 밖으로 나온다면 DTO로 변환하는 것을 권장합니다.

그래서 결과를 Query 의 결과를 DTO로 반환하기 위해 @QueryProjection을 사용합니다.

**@QueryProjection을 사용하고 compileQuerydsl을 실행하면 DTO도 Q파일이 생깁니다.**

<br>

> 📌 **프로퍼티 직접 접근 - Projection.bean()**

- Setter를 통해 데이터를 Injection 해주며 기본 생성자가 필수로 필요합니다.
- @NoArgsConstructor

```java
List<MemberDto> result = queryFactory
	.select(Projections.bean(MemberDto.class, member.username, member.age))
	.from(member)
	.fetch();
```

<br>

> 📌 **필드 직접 접근 - Projecitons.fields()**

- 필드의 값을 바로 주기 떄문에 Setter와 기본 생성자가 필요 없습니다.

```java
List<MemberDto> result = queryFactory
	.select(Projections.fields(MemberDto.class, member.username, member.age))
	.from(member)
	.fetch();
```

<br>

> 📌 **별칭이 다를 때 - ExpressionUtils.as()**

- ExpressionUtils.as() : 필드, 서브쿼리에 별칭 적용

```java
List<UserDto> fetch = queryFactory
	.select(Projections.fields(
		UserDto.class, 
		member.username.as("name"), 
		ExpressionUtils.as(
			JPAExpressions.select(memberSub.age.max()).from(memberSub), "age")
			)
	).from(member)
	.fetch();
```

<br>

> 📌 **생성자 사용 - Projections.constructor**

- 값을 넘길 떄 생성자와 순서가 맞아야 데이터를 잘 불러오며, @AllArgsConstructor가 필요합니다.

```java
List<MemberDto> result = queryFactory
	.select(Projections.constructor(MemberDto.class, member.username, member.age))
	.from(member)
	.fetch();
```

---

## 📘 @QueryProjection - 프로젝션 결과 반환

> 📌 **생성자 + @QueryProjection**

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

> 📌 **@QueryProjection 활용**

컴파일러로 타입을 체크할 수 있는 가장 안전한 방법입니다.

단점은, DTO에 @QueryProjection 어노테이션 유지와, DTO까지 Q Type을 생성해야 합니다.

```java
List<MemberDto> result = queryFactory
	.select(new QMemberDto(member.username, member.age))
	.from(member)
	.fetch();
```