## SubQuery Join

`com.querydsl.jpa.JPAExpressions`을 사용합니다.

Subquery Join은 하위 쿼리를 사용하여 조인을 수행하는 방식입니다.

Subquery Join을 사용하면 메인 쿼리와 서브쿼리 사이에 조인을 수행할 수 있습니다.

이를 통해 복잡한 조인 조건이나 필터링 작업을 수행할 수 있습니다.


---

## eq()

```kotlin
/**  @desc SubQuery Join - eq 사용 */
@Test  
fun subQueryJoin() {  
    val m = QMember.member  
    val sub = QMember("sub")  
  
    val result = queryFactory  
        .selectFrom(m)  
        .where(m.age.eq(JPAExpressions  
            .select(sub.age.max())  
            .from(sub)  
        ))  
        .fetch()  
  
    assertThat(result).extracting("age").containsExactly(40)  
}
```

위의 코드는 Subquery Join을 사용하여 나이가 가장 많은 멤버를 조회하는 예제입니다.

`subQueryJoin()` 함수에서는 `Member`와 `sub`라는 별칭으로 사용할 서브쿼리용 `QMember` 인스턴스를 생성합니다.

<br>

주어진 쿼리에서는 

`selectFrom(m)`을 통해 `Member` 엔티티를 조회하고, 

`where()` 절에서 `m.age.eq()`를 사용하여 나이가 서브쿼리의 최댓값과 일치하는 멤버를 찾습니다.

<br>

이때, 서브쿼리에서는 `JPAExpressions.select()`를 사용하여 `sub.age.max()`를 조회하고, `from(sub)`를 통해 `sub`를 서브쿼리의 별칭으로 지정합니다.

`fetch()` 메서드를 호출하여 쿼리를 실행하고 결과를 가져옵니다. 

이 결과는 나이가 가장 많은 멤버의 리스트일 것입니다.

<br>

마지막으로 `assertThat()` 메서드를 사용하여 결과를 검증합니다. 

`extracting("age")`을 통해 결과 리스트에서 "age" 속성만 추출하고, 

`containsExactly(40)`을 통해 추출한 속성 값이 40인지 확인합니다. 

<br>

즉, 나이가 가장 많은 멤버의 나이가 40인지를 검증하는 것입니다.

따라서 위의 코드는 Subquery Join을 사용하여 나이가 가장 많은 멤버를 조회하고, 그 나이가 40인지를 확인하는 예제입니다.

---

## goe

```kotlin
/** @desc SubQuery Join - geo 사용 */
@Test  
fun subQueryJoinGoe() {  
    val m = QMember.member  
    val sub = QMember("sub")  
  
    val result = queryFactory  
        .selectFrom(m)  
        .where(m.age.goe(JPAExpressions  
            .select(sub.age.avg())  
            .from(sub)  
        ))  
        .fetch()  
  
    assertThat(result).extracting("age").containsExactly(30, 40)  
}
```

  
위의 코드는 Subquery Join을 사용하여 평균 나이보다 크거나 같은 멤버를 조회하는 예제입니다.

`subQueryJoinGoe()` 함수에서는 `Member`와 `sub`라는 별칭으로 사용할 서브쿼리용 `QMember` 인스턴스를 생성합니다.

<br>

주어진 쿼리에서는 `selectFrom(m)`을 통해 `Member` 엔티티를 조회하고,

`where()` 절에서 `m.age.goe()`를 사용하여 나이가 서브쿼리의 평균값보다 크거나 같은 멤버를 찾습니다.

<br>

이때, 서브쿼리에서는 `JPAExpressions.select()`를 사용하여 `sub.age.avg()`를 조회하고, `from(sub)`를 통해 `sub`를 서브쿼리의 별칭으로 지정합니다.

`fetch()` 메서드를 호출하여 쿼리를 실행하고 결과를 가져옵니다.

이 결과는 평균 나이보다 크거나 같은 멤버의 리스트일 것입니다.

<br>

마지막으로 `assertThat()` 메서드를 사용하여 결과를 검증합니다. 

`extracting("age")`을 통해 결과 리스트에서 "age" 속성만 추출하고,

`containsExactly(30, 40)`을 통해 추출한 속성 값이 30과 40인지 확인합니다.

<br>

즉, 평균 나이보다 크거나 같은 멤버의 나이가 30과 40인지를 검증하는 것입니다.

따라서 위의 코드는 Subquery Join을 사용하여 평균 나이보다 크거나 같은 멤버를 조회하고, 그 나이가 30과 40인지를 확인하는 예제입니다.

---

