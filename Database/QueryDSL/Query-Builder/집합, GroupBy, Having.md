## 집합 함수

JPQL이 제공하는 모든 집합 함수를 제공합니다.

```kotlin
/**  
 * COUNT(m) - 회원 수  
 * SUM(m.age) - 나이 합  
 * AVG(m.age) - 평균 나이  
 * MAX(m.age) - 최대 나이  
 * MIN(m.age) - 최소 나이  
 * @desc 집합 함수  
 */  
@Test  
fun aggregation() {  
    val m: QMember = QMember.member  
  
    val result: MutableList<com.querydsl.core.Tuple>? = queryFactory  
        .select(  
            m.count(),  
            m.age.sum(),  
            m.age.avg(),  
            m.age.max(),  
            m.age.min()  
        )  
        .from(m)  
        .fetch()  
  
    val tuple = result?.get(0)  
  
    assertThat(tuple?.get(m.count())).isEqualTo(4)  
    assertThat(tuple?.get(m.age.sum())).isEqualTo(100)  
    assertThat(tuple?.get(m.age.avg())).isEqualTo(25)  
    assertThat(tuple?.get(m.age.max())).isEqualTo(40)  
    assertThat(tuple?.get(m.age.min())).isEqualTo(10)  
}
```

---

## Group By

groupBy()는 SQL의 GROUP BY 절과 유사한 역할을 합니다.

결과를 그룹화하는 데 사용되며, 그룹화 기준을 지정하여 결과를 그룹으로 나눌 수 있습니다. 

groupBy()는 SelectExpression을 매개변수로 받으며, 해당 SelectExpression을 기준으로 결과를 그룹화합니다.

```kotlin
/**   
* 팀의 이름과 각 팀의 평균 연령 구하기  
* @desc Group By 사용   
*/  
@Test  
fun group() {  
    val m: QMember = QMember.member  
    val t: QTeam = QTeam.team  
    val result: MutableList<com.querydsl.core.Tuple>? = queryFactory  
        .select(t.name, m.age.avg())  
        .from(m)  
        .join(m.team, t)  
        .groupBy(t.name)  
        .fetch()  
      
    val teamA = result?.get(0)  
    val teamB = result?.get(1)  
      
    assertThat(teamA?.get(t.name)).isEqualTo("teamA")  
    assertThat(teamA?.get(m.age.avg())).isEqualTo(15)  
      
    assertThat(teamB?.get(t.name)).isEqualTo("teamB")  
    assertThat(teamB?.get(m.age.avg())).isEqualTo(35)  
}
```

---

## Having

그룹화된 결과를 제한하려면 `having`을 사용합니다.

groupBy(), having() 예시

```kotlin
.groupBy(item.price)
.having(item.price.gt(1000))
```

having()은 SQL의 HAVING 절과 유사한 역할을 합니다. 그룹화된 결과에 조건을 적용하는 데 사용됩니다. 

<br>

특정 그룹에 대한 조건을 지정하여 그룹화된 결과를 필터링할 수 있습니다.

예를 들어, 다음과 같은 QueryDSL 코드로 "user" 테이블을 "age" 컬럼으로 그룹화하고, 그룹 중에서 "age"가 20 이상인 그룹만 선택할 수 있습니다.

```kotlin
val query = JPAQueryFactory(entityManager) 
val user = QUser.user  

val result = query     
		.select(user.age, user.count())     
		.from(user)     
		.groupBy(user.age)     
		.having(user.age.goe(20))     
		.fetch()
```

위의 예제에서는 user.age 컬럼을 기준으로 결과를 그룹화하고, having() 메서드를 사용하여 "age"가 20 이상인 그룹만 선택합니다.

이렇게 QueryDSL의 groupBy()와 having()을 사용하여 SQL 쿼리를 작성하고 원하는 그룹화 및 조건 필터링을 수행할 수 있습니다.

---

## GroupBy, Having 예시

예를 들어, "user" 테이블에 다음과 같은 데이터가 있다고 가정해보겠습니다.

```bash
id | name | age 
---+------+----- 
1  | John | 25 
2  | Jane | 30 
3  | Mark | 20 
4  | Anna | 25 
5  | Eric | 20 
6  | Lisa | 30
```

아래의 QueryDSL 코드로 "user" 테이블을 "age" 컬럼으로 그룹화하고, 그룹 중에서 "age"가 20 이상인 그룹만 선택하는 결과를 확인해보겠습니다.

```kotlin
val query = JPAQueryFactory(entityManager) 
val user = QUser.user  

val result = query     
		.select(user.age, user.count())     
		.from(user)     
		.groupBy(user.age)     
		.having(user.age.goe(20))     
		.fetch()
```

이 코드를 실행하면 다음과 같은 결과를 얻을 수 있습니다.

```diff
age | count 
----+------- 
20  | 2 
25  | 2 
30  | 2
```

위의 결과는 "age"를 그룹화 기준으로 하여, "age"가 20 이상인 그룹만 선택한 후 각 그룹의 row 수를 나타냅니다.

"age"가 20인 그룹에는 2개의 row가 있고, "age"가 25인 그룹과 30인 그룹에는 각각 2개의 row가 있습니다.

이렇게 QueryDSL의 groupBy()와 having()을 사용하면 원하는 그룹화 및 조건 필터링을 적용하여 결과를 얻을 수 있습니다