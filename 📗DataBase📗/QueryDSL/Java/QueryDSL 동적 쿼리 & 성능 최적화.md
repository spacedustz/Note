## 📘 QueryDSL 동적 쿼리 & 성능 최적화 - Builder

> 📌 **조회 최적화용 DTO**

- DTO의 Q-Type을 생성하기 위해 `./gradlew compileQuerydsl` 실행

```java
@Data
public class MemberTeamDto {
	private Long memberId;
	private String username;
	private int age;
	private Long teamId;
	private String teamName;

	@QueryProjection
	public MemberTeamDto(Long memberId, String username, int age, Long teamId, String teamName) {
		this.memberId = memberId;
		this.username = username;
		this.age = age;
		this.teamId = teamId;
		this.teamName = teamName;
	}
}
```

<br>

> 📌 **회원 검색 조건**

```java
// 회원명, 팀명, 나이(ageGoe, ageLoe)
@Data
public class MemberSearchCondition {
	private String username;
	private String teamName;
	private Integer ageGoe;
	private Integer ageLoe;
}
```

<br>

> 📌 **동적 쿼리 Builder - Boolean Builder**

```java
// 회원명, 팀명, 나이(ageGoe, ageLoe)
pubic List<MemberTeamDto> searchByBuilder(MemberSearchCondition condition) {
	BooleanBuilder builder = new BooleanBuilder();

	if (hasText(condition.getUsername())) {
		builder.and(member.username.eq(condition.getUsername()));
	}

	if (hasText(condition.getTeamName())) {
		builder.and(team.name.eq(condition.getTeamName()));
	}

	if (condition.getAgeGoe() != null) {
		builder.and(member.age.goe(condition.getAgeGoe()));
	}

	if (condition.getAgeLoe != null) {
		builder.and(member.age.loe(condition.getAgeLoe()));
	}

	return queryFactory
						.select(new QMemberTeamDto(
							member.id,
							member.username,
							member.age,
							team.id,
							team.name))
						.from(member)
}
```