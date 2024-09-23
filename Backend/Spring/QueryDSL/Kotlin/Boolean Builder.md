## QueryDsl - Boolean Builder

`BooleanBuilder`를 활용하면 동적인 쿼리 조건을 구성할 수 있으며, 필요에 따라 AND나 OR 연산으로 조건을 조합할 수 있습니다. 

이를 통해 쿼리의 유연성과 강력한 조건 검색을 달성할 수 있습니다.

---

### and() & or()

BooleanBuilder는 JPA에서 사용하는 동적 쿼리를 작성할 수 있는 빌더 클래스 중 하나입니다. 

and()와 or() 메서드는 BooleanBuilder 객체에 조건을 추가할 때 사용됩니다.

<br>

and() 메서드는 이전에 추가된 조건과 새로운 조건을 AND로 연결합니다. 예를 들어, 다음과 같은 코드를 작성할 수 있습니다.


```kotlin
val builder = BooleanBuilder()
builder.and(condition1).and(condition2)
```

위 코드에서, condition1과 condition2는 BooleanExpression 타입의 조건 객체입니다. 이전에 추가된 조건과 새로운 조건이 모두 true여야 전체 조건이 true가 됩니다.

<br>

or() 메서드는 이전에 추가된 조건과 새로운 조건을 OR로 연결합니다. 예를 들어, 다음과 같은 코드를 작성할 수 있습니다.


```kotlin
val builder = BooleanBuilder()
builder.or(condition1).or(condition2)
```

위 코드에서, condition1과 condition2는 BooleanExpression 타입의 조건 객체입니다. 이전에 추가된 조건 중 적어도 하나가 true이거나 새로운 조건이 true일 때 전체 조건이 true가 됩니다.

<br>

또한, and()와 or() 메서드는 메서드 체이닝을 통해 여러 개의 조건을 연결할 수 있습니다. 예를 들어, 다음과 같은 코드를 작성할 수 있습니다.


```kotlin
val builder = BooleanBuilder()
builder.and(condition1).or(condition2).and(condition3)
```

<br>

위 코드에서, condition1, condition2, condition3은 BooleanExpression 타입의 조건 객체입니다. 이전에 추가된 조건과 새로운 조건이 모두 true여야 하지만, 그 중 하나가 true일 때 전체 조건이 true가 되도록 조건을 연결하고 있습니다.

---
### ne()

BooleanBuilder의 `ne()` 메서드는 "not equals" 조건을 추가할 때 사용됩니다. 이 메서드는 JPA 쿼리에서 `!=` 연산자와 같은 기능을 수행합니다.

<br>

`ne()` 메서드는 BooleanBuilder 객체에 추가할 수 있는 다양한 타입의 값을 비교할 수 있습니다. 예를 들어, 다음과 같은 코드를 작성할 수 있습니다.

`BooleanBuilder builder = new BooleanBuilder(); builder.and(entity.field.ne("value"));`

위 코드에서, `entity`는 JPA 엔티티 객체를 나타냅니다. 

`field`는 해당 엔티티의 필드를 나타내며, `value`는 필드와 비교할 값입니다.

`ne()` 메서드는 필드 값과 `value` 값이 서로 같지 않은 경우 true를 반환합니다.

<br>

`ne()` 메서드는 문자열, 숫자, 날짜 등 다양한 타입의 값을 비교할 수 있습니다. 예를 들어, 문자열 값을 비교하려면 다음과 같이 작성할 수 있습니다.

`BooleanBuilder builder = new BooleanBuilder(); builder.and(entity.field.ne("string_value"));`

<br>

숫자 값을 비교하려면 다음과 같이 작성할 수 있습니다.


`BooleanBuilder builder = new BooleanBuilder(); builder.and(entity.field.ne(10));`

<br>

날짜 값을 비교하려면 다음과 같이 작성할 수 있습니다.


`BooleanBuilder builder = new BooleanBuilder(); builder.and(entity.field.ne(LocalDate.now()));`

<br>

따라서, `ne()` 메서드는 BooleanBuilder를 사용하여 JPA 동적 쿼리를 작성할 때 필드 값이 특정 값과 같지 않은 경우를 검색하는 데 사용됩니다.

---

## BooleanBuilder Methods

<br>

`and` 메서드:
    -   기능: 두 개의 조건을 AND 연산으로 결합합니다.
    -   사용 예시: `builder.and(condition1)`

<br>

`or` 메서드:
    -   기능: 두 개의 조건을 OR 연산으로 결합합니다.
    -   사용 예시: `builder.or(condition1)`

<br>

`not` 메서드:
    -   기능: 조건을 부정합니다.
    -   사용 예시: `builder.not(condition)`

<br>

`value` 메서드:
    -   기능: `BooleanBuilder` 객체를 불리언 조건으로 변환합니다.
    -   사용 예시: `val condition = builder.value`

<br>

`isNull` 메서드:
    -   기능: 주어진 필드가 NULL인지 확인하는 조건을 추가합니다.
    -   사용 예시: `builder.isNull(field)`

<br>

`isNotNull` 메서드:
    -   기능: 주어진 필드가 NULL이 아닌지 확인하는 조건을 추가합니다.
    -   사용 예시: `builder.isNotNull(field)`

<br>

`eq` 메서드:
    -   기능: 주어진 필드와 값이 같은지 확인하는 조건을 추가합니다.
    -   사용 예시: `builder.eq(field, value)`

<br>

`ne` 메서드:
    -   기능: 주어진 필드와 값이 다른지 확인하는 조건을 추가합니다.
    -   사용 예시: `builder.ne(field, value)`

<br>

`gt` 메서드:
    -   기능: 주어진 필드가 주어진 값보다 큰지 확인하는 조건을 추가합니다.
    -   사용 예시: `builder.gt(field, value)`

<br>

`lt` 메서드:
    -   기능: 주어진 필드가 주어진 값보다 작은지 확인하는 조건을 추가합니다.
    -   사용 예시: `builder.lt(field, value)`

<br>

`gte` 메서드:
    -   기능: 주어진 필드가 주어진 값보다 크거나 같은지 확인하는 조건을 추가합니다.
    -   사용 예시: `builder.gte(field, value)`

<br>

`lte` 메서드:
    -   기능: 주어진 필드가 주어진 값보다 작거나 같은지 확인하는 조건을 추가합니다.
    -   사용 예시: `builder.lte(field, value)`