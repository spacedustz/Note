## @QueryProjection

- select 문에 대상을 지정하는 것이다.
- 컴파일 타임에 타입 체크가 가능하므로 다른 방법들보다 안전하다. 
- 하지만 DTO까지 Q파일을 생성해야 하며, DTO에 QueryDsl에 대한 의존도가 생긴다.

<br>

QueryDSL은 3가지 방법을 통해 DTO를 조회할 수 있도록 지원한다.

- 프로퍼티 접근 (Setter) : setter와 기본 생성자 필수
- 필드 직접 접근 : 기본 생성자 필수
- 생성자 사용 : 타입이 일치하는 생성자 필수

<br>

생성자를 통해 DTO를 조회하는 예시

```kotlin
data class MemberDtoQueryProjection @QueryProjection constructor(
	val username: String,
	val age: Int)
```

이후 빌드 시 DTO가 Q파일로 생성된다.

생성된 Q타입은 다음과 같이 사용 가능

- 단점 : Q클래스를 생성하며, DTO가 QueryDsl에 대한 의존성을 가짐

```kotlin
/**
* 프로젝션 - @QueryProjection 사용
* 단점 - Q클래스 생성, DTO가 QueryDsl에 대한 의존성을 가지게 된다
*/
@Test
fun testQueryProjection() {
    .select(QmemberDtoQueryProjection(member.username, member.age))
    .from(member)
    .fetch()
    
    fetch.forEach { println(it) }
}
```

---

### 프로젝션 대상이 하나인 경우

대상이 하나라면 타입을 명확히 지정하여 결과값으로 반환받을 수 있다.

member의 username은 String 이므로 위오 같이 String 타입으로 바로 조회가 가능하다. 

```kotlin
@Test
fun testSimpleProjection() {
    // given
    val fetch: List<String> = query
    .select(member.username)
    .from(member)
    .fetch()
    
    //when
    fetch.forEach { println(it) }
}
```

<br>

### 프로젝션 대상이 둘 이상인 경우

Tuple을 사용하여 결과를 조회할 수 있다.

Tuple을 사용 할 경우, 프로젝션 할 때 사용했던 Expression을 그대로 사용하여 get의 인자로 넘길 수 있다.

```kotlin
@Test
fun testTupleProjection() {
    val fetch = query
    .select(member.username, member.age)
    .from(member)
    .fetch()
    
    fetch.forEach {
        println("username : ${it.get(member.username)}")
        println("age : ${it.get(member.age)}")
    }
}
```

---

## DTO 조회 방법

QueryDSL은 3가지의 방법을 통해 DTO로 조회할 수 있도록 지원한다.

- 프로퍼티 접근 (Setter) : setter와 기본 생성자 필수
- 필드 직접 접근 : 기본 생성자 필수
- 생성자 사용 : 타입이 일치하는 생성자 필수

---

### 1.  프로퍼티 접근법 - Setter 사용

Projections.**bean**()을 사용합니다.

```kotlin
data class MemberDto(
    var username: String? = null,
    var age: Int? = null,
) 
/**
 * 프로젝션 - DTO 조회
 *
 * 프로퍼티(세터), 필드 직접, 생성자 모두
 *
 * 세터 - bean - 기본 생성자 필수
 */
@Test
fun testDTOProjection_setter() {
    //given
    val fetch = query
        .select(Projections.bean(
            MemberDto::class.java,
            member.username,
            member.age))
        .from(member)
        .fetch()

    //when
    fetch.forEach {
        println(it)
    }
}
```

---

### 2. 필드 직접 접근

Projections.**fields**()을 사용합니다.

```kotlin
data class MemberDto(
    var username: String? = null,
    var age: Int? = null,
) 
/**
 * 프로젝션 - DTO 조회
 *
 * 프로퍼티, 필드 직접, 생성자 모두
 *
 * 필드 - fields - 기본 생성자 필수(getter, setter 없어도 돼)
 */
@Test
fun testDTOProjection_field() {
    //given
    val fetch = query
        .select(Projections.fields(
            MemberDto::class.java,
            member.username,
            member.age))
        .from(member)
        .fetch()

    //when
    fetch.forEach {
        println(it)
    }
}
```

<br>

DTO와 Entity의 필드명이 다른 경우

**ExpressionUtils**.**as**(source, **alias**) : 필드나 서브 쿼리에 별칭을 적용할 사용합니다.
**username**.**as**(**alias**) : 필드에 별칭을 적용할 때 사용합니다.

```kotlin
data class UserDto(
	var name: String? = null,
	var aage: Int? = null,
) 
/**
 * 프로젝션 - DTO 조회
 *
 * fields  - 전체 생성자 있어야 함
 *
 * 별칭이 다른 경우 - as 사용
 */
@Test
fun testDTOProjection_field_other_alias() {
    //given
    val m = QMember("sub")
    val fetch = query
        .select(Projections.fields(
            UserDto::class.java,
            member.username.`as`("name"),
            ExpressionUtils.`as`(JPAExpressions.select(m.age.max()).from(m), "aage")))
        .from(member)
        .fetch()

    //when
    fetch.forEach {
        println(it)
    }
}
```

---

### 3. 생성자 사용

Projections.**contructor**()을 사용합니다.

```kotlin
data class MemberDto(
    var username: String? = null,
    var age: Int? = null,
) 
/**
 * 프로젝션 - DTO 조회
 *
 * 프로퍼티, 필드 직접, 생성자 모두
 *
 * 생성자 - constructor - 전체 생성자 있어야 함
 */
@Test
fun testDTOProjection_constructor() {
    //given
    val fetch = query
        .select(Projections.constructor(
            MemberDto::class.java,
            member.username,
            member.age))
        .from(member)
        .fetch()

    //when
    fetch.forEach {
        println(it)
    }
}
```

