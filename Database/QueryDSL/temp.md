## **JPAQueryFactory**

 클래스이름에 Q가 붙은 이상한(?) 것을 만든 것처럼 Query DSL은 EntityManager말고도 한 가지가 더 필요하다.

```
JPAQueryFactory jpaQueryFactory = new JPAQueryFactory(em);
```

 위와같이 선언해서 사용한다. Test 코드에서 활용한다면, 다음과 같이 사용하면 모든 테스트 메소드에서 초기화 없이 사용할 수 있다.

```
    @Autowired
    EntityManager em;
    JPAQueryFactory queryFactory;

    @BeforeEach
    public void createQF() {
        queryFactory = new JPAQueryFactory(em);
    }
```

 

## **기본 Q-Type 활용**

다음은 Q클래스 인스턴스를 사용하는 2가지 방법이다.

```
QMember qMember = new QMember("m");//별칭 지정
QMember qMember = QMember.member;//기본 인스턴스 사용
```

**※ QMember를 static import하면 QMember.member를 member로 사용할 수 있다.(대신에 member라는 변수명을 사용하지 않도록 유의하도록 하자.)**

 

#### **검색 조건 쿼리**

**- select()** 

**- from()**

**- selcetFrom() (select + from 한번에 처리)**

**- where(), and(), or()**

**- orderBy()**

**(이 외에도 JPQL문법을 모두 사용 가능)**

```
 Member findMember = jpaQueryFactory
                .select(m)
                .from(m)    //selectFrom(m)으로 치환 가능
                .where(m.id.eq(1L)).and(m.age.eq(20))
                .fetchOne();
```

#### **동일성 체크**

**- eq(), ne(), not() // == , != ,!= (not은 마지막에 붙여준다.)**

**- isNotNull() // Null이 아니면 true**

 

#### **원소, 범위 체크**

**- in(1,2,3,4), notIn(1,3,5), between(10,20) // 원소에 있는경우, 원소에 없는경우, 10 ~ 20 사이** 

**- x.goe(y); (x >= y)**

**- x.gt(y); (x > y)**

**- x.loe(y); (x <= y)**

**- x.lt(y); (x < y)**

#### **그 외**

**- like("str%"); (like 검색)**

**- contains("str"); (like %str%)**

**- startsWith("str"); (like str%)**

####  **결과 조회**

**- fetch(); 리스트 조회 없으면 빈 리스트 반환**

**- fetchOne(); 단일 객체 반환, 없으면 null, 둘 이상이면 NonUniqueResultException**

**- fetchFirst(); 가장 먼저 찾는걸 반환**

**- fetchResults(); 페이징 정보 포함, total 쿼리 추가 실행 / 페이징이 아니라면 지양**

**- fetchCount(); count쿼리로 갯수 조회 (long형)**

 

#### **정렬**

**- desc(), asc()**

**- nullsLast(), nullsFirst() // null 데이터 순서 부여**

---

### 조건절 (where clause)

이미 위에 테스트코드에의해 스포일러 당한 부분이 없잖아 있지만 좀 더 자세하게 살펴보겠습니다.

```java
queryFactory.select(player).from(player);
queryFactory.selectFrom(player);
```

우선 `select`, `from`의 파라미터가 같은 경우 `selectFrom`으로 합칠 수 있습니다.

테스트 코드를 먼저 살펴보면,

```java
@Test
void simpleQuerydslWithWhereClauseTest() {
    // given
    JPAQueryFactory queryFactory = new JPAQueryFactory(entityManager);
    Player founded = queryFactory.selectFrom(player)
        .where(player.name.like("%Son")
            .and(player.age.lt(30))
            .and(player.team.name.ne("Manchester City F.C.")))
        .fetchOne();
    // then
    assertNotNull(founded);
    assertEquals("Heungmin Son", founded.getName());
}
```

조건절인 `where` 부분을 살펴보면 SQL을 작성하듯이 편리하게 작성할 수 있습니다.

equals(==, `eq`), not equals(!=, `ne`), `like`, less than(<, `lt`) 등 `SQL`로 표현할 수 있는 연산자들을 영어의 축약형으로 사용하고, `and`, `or` 등 조건 추가도 `method chaining` 형태로 쉽게 가능합니다.

`and` 조건을 사용하는 경우 `method chaning` 방식대신 `콤마(,)`를 이용해 파라미터를 분리하여 작성해도 되는데 이 방식은 동적 쿼리를 작성할 때 매우 편리합니다.

```java
Player founded = queryFactory.selectFrom(player)
    .where(player.name.like("%Son"),
        player.age.lt(30),
        player.team.name.ne("Manchester City F.C."))
    .fetchOne();
```

테스트를 실행해서 쿼리를 확인해보면,

```text
2021-07-16 23:21:09.697 DEBUG 12812 --- [           main] org.hibernate.SQL                        : 
    /* select
        player 
    from
        Player player 
    where
        player.name like ?1 escape '!' 
        and player.age < ?2 
        and player.team.name <> ?3 */ select
            player0_.player_id as player_i1_1_,
            player0_.age as age2_1_,
            player0_.name as name3_1_,
            player0_.team_id as team_id4_1_ 
        from
            player player0_ cross 
        join
            team team1_ 
        where
            player0_.team_id=team1_.team_id 
            and (
                player0_.name like ? escape '!'
            ) 
            and player0_.age<? 
            and team1_.name<>?
```

의도한대로 잘 표현된 것을 확인할 수 있습니다.

제공하는 검색 조건은 JPQL과 동일하고 아래 처럼 표현할 수 있습니다.

- `eq("something")`: = 'something'
- `ne("something")`: != 'something'
- `eq("something").not()`: != 'something'
- `like("%something")`: like '%something'
- `startsWith("something")`: like 'something%'
- `contains("something")`: like '%something%'
- `isNull()`: is null
- `isNotNull()`: is not null
- `isEmpty()`: 길이가 0
- `isNotEmpty()`: 길이가 0이 아님
- `in("foo", "bar")`: in("foo", "bar")
- `notIn("foo", "bar")`: not in("foo", "bar")
- `in("foo", "bar").not()`: not in("foo", "bar")
- `between(20, 30)`: between 20, 30
- `notBetween(20, 30)`: not between 20, 30
- `between(20, 30).not()`: not between 20, 30
- `gt(28)`: > 28
- `goe(28)`: >= 28
- `lt(28)`: < 28
- `loe(28)`: <= 28

### 결과 매핑

Querydsl은 결과를 매핑하는 방법 역시 여러 가지로 제공합니다.

- `fetch()`: 리스트 반환, 결과가 없는 경우 빈 리스트 반환

- ```
  fetchOne()
  ```

  : 한 건 조회

  - 결과가 없는 경우: `null` 반환
  - 결과가 여러 개인 경우: `NonUniqueResultException` 발생

- ```
  fetchFirst()
  ```

  : 처음 한 건 조회

  - `limit(1).fetch()`와 동일

- ```
  fetchResults()
  ```

  : 결과에 페이지 정보 포함,

   

  ```
  total count
  ```

   

  쿼리 추가 수행

  - `total count` 쿼리는 `count(id)` 사용

- `fetchCount()`: `count` 쿼리 수행