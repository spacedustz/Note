## Fetch Join

Fetch Join은 관계형 데이터베이스에서 성능을 향상시키기 위해 사용되는 기능입니다.

**SQL에서 제공하는 기능이 아닌, JPA에서만 지원되는 기능이다.**

일반적인 조인과는 달리 Fetch Join은 연관된 엔티티 또는 컬렉션을 함께 로딩하여 지연로딩을 회피합니다. 

이를 통해 추가적인 SQL 쿼리 호출 없이 연관된 엔티티를 로딩할 수 있습니다.

Fetch Join의 사용방법은 `join(), leftJoin()`등 조인 기능의 뒤에 `fetchJoin()`을 붙이면 됩니다.

<br>

### Fetch Join 미적용 예시

첫 번째 테스트인 `noFetchJoin()` 함수에서는 Fetch Join을 적용하지 않은 상황을 테스트합니다. 

주어진 쿼리에서는 `Member` 엔티티를 조회하고, 이름이 "member1"인 멤버를 찾습니다. 

<br>

그 후 `emf.persistenceUnitUtil.isLoaded()` 메서드를 사용하여 `findMember`의 `team` 속성이 로딩되었는지 확인합니다. 

`isLoaded()` 메서드는 엔티티의 특정 속성이 로딩되었는지 여부를 확인하는 메서드입니다.

이 테스트는 Fetch Join을 적용하지 않았으므로, `findMember`의 `team` 속성은 지연로딩(lazy loading)되어서 실제로 조회되지 않습니다. 

따라서 `loaded` 변수의 값은 `false`가 되어야 합니다.

```kotlin
/**  
 * 지연로딩으로 Member, Team SQL 쿼리 각각 실행  
 * @desc Fetch Join 미적용 예시  
 */  
@Test  
fun noFetchJoin() {  
    val m = QMember.member  
    em.flush()  
    em.clear()  
      
    val findMember = queryFactory  
        .selectFrom(m)  
        .where(m.name.eq("member1"))  
        .fetchOne()  
      
    val loaded: Boolean = emf.persistenceUnitUtil.isLoaded(findMember?.team)  
      
    assertThat(loaded).`as`("Fetch Join 미적용").isFalse  
}
```

<br>

### Fetch Join 적용 예시

두 번째 테스트인 `fetchJoin()` 함수에서는 Fetch Join을 적용한 상황을 테스트합니다.

이번에는 `join()` 메서드와 `fetchJoin()` 메서드를 사용하여 `Member`와 `Team` 엔티티를 함께 로딩합니다.

<br>

그 후, 이름이 "member1"인 멤버를 찾습니다.

마찬가지로 `isLoaded()` 메서드를 사용하여 `findMember`의 `team` 속성이 로딩되었는지 확인합니다.

이 테스트는 Fetch Join을 적용하였기 때문에, `findMember`의 `team` 속성은 즉시 로딩되어서 함께 조회됩니다.

따라서 `loaded` 변수의 값은 `true`가 되어야 합니다.

```kotlin
/** @desc Fetch Join 적용 예시 */@Test  
fun fetchJoin() {  
    val m = QMember.member  
    val t = QTeam.team  
  
    em.flush()  
    em.clear()  
  
    val findMember = queryFactory  
        .selectFrom(m)  
        .join(m.team, t).fetchJoin()  
        .where(m.name.eq("member1"))  
        .fetchOne()  
  
    val loaded: Boolean = emf.persistenceUnitUtil.isLoaded(findMember?.team)  
  
    assertThat(loaded).`as`("Fetch Join 적용").isTrue  
}
```
