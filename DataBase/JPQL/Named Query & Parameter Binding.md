## **💡 Named 쿼리 - 정적 쿼리**

- 엔티티 클래스에 **미리 정의**해서 이름을 부여해두고 사용하는 JPQL
- 쿼리에 이름을 부여하며, 이름을 통해 쿼리를 불러오기가 가능하다.
- 어노테이션, XML에 정의 (XML이 항상 우선권을 가진다.)
- **어플리케이션 로딩 시점에 초기화 후 재사용** (SQL 로 파싱하여 쿼리를 캐싱함)
- **어플리케이션 로딩 시점에 쿼리를 검증** - 컴파일 타임 시 에러 발생으로 인해 디버깅 용이
- 보통 엔티티에 @NamedQuery보단 @Query가 사용하기 더 편하고 좋다.

```java
// 엔티티 클래스에 정의
@Entity
@NamedQuery(
   name = "Member.findByUsername",
   query = "select m from Member m where m.username = :username")
public class Member {
...
}

// 사용
List<Member> resultList =
   em.createNamedQuery("Member.findByUsername", Member.class)
      .setParameter("username", "회원1")
      .getResultList();

// 이름 없는 Named Query
public interface MemberRepository extends JPARepository<Member, Long> {
    @Query("select m from Member m where m.address = ?1")
    Member findByAddress(String address);
}
```

---

## 💡 **Parameter Binding**

왠만하면 이름으로 바인딩하자.

위치 기준으로 바인딩 시 위치가 바뀌면 꼬일 수 있다.

<br>

**이름 기준**

```java
Member result = em.createQuery(
    "select m from Member m where m.username = :username", Member.class)
    .setParameter("username", "member1")
    .getSingleResult();
```

- SELECT m FROM Member m where m.username=:username

**위치 기준**

```java
Member result = em.createQuery(
    "select m from Member m where m.username = ?1", Member.class)
    .setParameter(1, "member1")
    .getSingleResult();
```

- SELECT m FROM Member m where m.username=?1

