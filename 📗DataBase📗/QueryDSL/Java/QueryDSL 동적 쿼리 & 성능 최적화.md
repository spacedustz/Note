## 📘 QueryDSL 동적 쿼리 & 성능 최적화 - Builder

> 📌 **조회 최적화용 DTO**

```java
@Data
public class MemberTeamDto {
	private Long memberId;
	private String username;
	private int age;
	private Long teamId;
	private String teamName;
}
```