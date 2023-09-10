## 💡 코틀린에서 컬렉션을 함수형으로 다루는 법

목차

- Filter & Map
- 다양한 컬렉션 처리 기능
- List To Map
- 중첩된 컬렉션 처리

---

##  Filter & Map

컬렉션에 `.filter`를 붙여서 다양한 조건 처리를 할 수 있다.

만약 인덱스 처리가 필요하다면 `.filterIndexed`를 사용한다.

```kotlin
data calss Fruit(
    val id: Long,
    val name: String,
    val factoryPrice: Long,
    val currentPrice: Long
)
```

filter를 통해 조건처리를 하고 map을 하여 데이터를 가공 & 변형한다.

맵에서 인덱스가 필요하다면 `.mapIndexed`를 사용한다.

```kotlin
val applePrices = fruits.filter { fruit -> fruit.name == "사과" }
	.map { fruit -> fruit.currentPrice}

val applePrices = fruits.filter { fruit - fruit.name == "사과" }
	.mapIndexed { idx, fruit -> 
                println(idx) 
                fruit.currentPrice
                }
```

Mapping의 결과가 Null이 아닌것만 가져오고 싶을 때 `.mapNotNull`을 사용한다.

 ```kotlin
 val values = fruits.filter { fruit -> fruit.name == "사과" }
 	.mapNotNull { fruit -> fruit.nullOrValue() }
 ```

**이제 저번에 구현했던 fulterFruits 함수를 함수형으로 바꿔보자**

기존 코드

```kotlin
private fun filterFruits(
    fruits: List<Fruit>, filter: (Fruit) -> Boolean
): List<Fruit> {
    val results = mutableListOf<Fruit>()
    
    for (fruit in fruits) {
        if (filter(fruit)) {
            results.add(fruit)
        }
    }
    return results
}
```

함수형으로 바꾼 코드

- 필터에 그냥 필터를 반환하면 끝이다.

```kotlin
private fun filterFruits(
    fruits: List<Fruit>, filter: (Fruit) -> Boolean
): List<Fruit> {
    return fruits.filter { filter }
}
```

---

## 다양한 컬렉션 처리 기능

**all :** 조건을 모두 만족하면 true 아니면 false

모든 과일이 사과인지 & 출고가 10,000원 이상의 과일이 하나라도 있는지에 대한 필터링 코드

```kotlin
val isAllApple = fruits.all { fruit -> fruit.name == "사과" }
```

**none :** 조건을 모두 불만족하면 true 아니면 false

```kotlin
val isNoApple = fruits.none { fruit -> fruit.name == "사과" }
```

**any : **조건을 하나라도 만족하면 true 아니면 false

```kotlin
val isNoApple = fruits.any { fruit -> fruit.factoryPrice >= 10_000 }
```

**count : **개수를 세는 기능, list의 size()와 같다

```kotlin
val fruitCount = fruit.count()
```

**sortedBy : **(오름차순) 정렬 기능

**sortedByDescending : **(내림차순) 정렬 기능

```kotlin
val fruitCount = fruits.sortedBy { fruit -> fruit.currentPrice }
val fruitCount = fruits.sortedByDescending { fruit -> fruit.currentPrice }
```

**distinctBy : **변형된 값을 기준으로 중복 제거

- 이름을 기준으로 중복을 제거하며, 이름만 출력하는 예시

```kotlin
val distinctFruitNames = fruits.distinctBy { fruit -> fruit.name }
	.map { fruit -> fruit.name }
```

**first & last : **첫번째 & 마지막 값을 가져온다 (무조건 Null이 아니어야 함), Null이 들어올 경우 Exception

**filstOrNull & lastOrNull: **첫번째 & 마지막 값 또는 Null을 가져온다

```kotlin
fruits.first()
fruits.firstOrNull()

fruits.last()
fruits.lastOrNull()
```

---

## List To Map

**groupBy : **이름을 기준으로 그룹핑 기능

- 과일의 이름을 Key로 가지고 List<Fruit>를 Value로 가진 Map 예시

```kotlin
val map: Map<String, List<Fruit>> = fruits.groupBy { fruit -> fruit.name }
```

**associateBy : **중복되지 않은 키를 가지고 Map을 만들때 사용하며 Value는 단일 객체가 들어가야 한다.

- id가 Key이고 과일이 Value인 Map 예시

```kotlin
val map: Map<Long, Fruit> = fruits.associateBy { fruit -> fruit.id }
```

<br>

List<출고가>를 가진 Map이 필요할 때의 예시

```kotlin
val map: Map<String, List<Long>> = fruits
.groupBy( { fruit -> friut.name }, { fruit -> fruit.factoryPrice } )
```

Key는 id, Value는 출고가가 필요한 경우 예시

```kotlin
val map: Map<Long, Long> = fruits
	.associateBy( { fruit -> fruit.id }, { fruit -> fruit.factoryPrice } )
```

---

## 중첩된 컬렉션 처리

- `flatMap()`을 이용하면 List안의 List를 단일 List로 바꿔준다.
- `flatten()`을 사용하면 중첩된 컬렉션이 모두 평탄화된다.

리스트 안에 리스트가 있는 구조에서 출고가와 현재가가 동일한 과일을 고르는 예시 코드

```kotlin
// 리스트
val fruitsInList: List<List<Fruit>> = listOf(
    listOf(
        Fruit(1L, "사과", 1_000, 1_500),
        Fruit(2L, "사과", 1_200, 1_500),
        Fruit(3L, "사과", 1_200, 1_500),
        Fruit(4L, "사과", 1_500, 1_500),
    ),
    listOf(
        Fruit(5L, "바나나", 3_000, 3_200),
        Fruit(6L, "바나나", 3_200, 3_200),
        Fruit(7L, "바나나", 2_500, 3_200),
    ),
    listOf(
        Fruit(8L, "수박", 10_000, 10_000),
    )
)
```

flatMap을 이용해 List안의 List를 단일 List로 바꿔준다.

단일 리스트로 바뀐 리스트를 필터링 해서 조건을 충족하는 코드이다.

```kotlin
val sameePriceFruits = fruitsInList.flatMap { list -> list.filter {
    fruit -> fruit.factoryPrice == fruit.currentPrice
}}
```

조금 더 깔끔한 코드 리팩터링

- 출고가와 현재가가 같은지 여부를 반환하는 Custom Getter를 엔티티에 작성
- List<Fruit>에 대한 확장 함수 생성
- 최종적으로 flatMap에서 확장함수만 호출해서 하나의 람다만 쓰는것처럼 보이게 리팩터링 했다.

```kotlin
// Entity
data class Fruit(
    val id: Long,
    val name: String,
    val factoryPrice: Long,
    val currentPrice: Long
) {
    
    val isSamePrice: Boolean
      get() = factoryPrice == currentPrice
}

val List<Fruit>.samePriceFilter: List<Fruit>
  get() = this.filter(Fruit::isSamePrice)

fun main() {
    val samePriceFruits = fruitsInList.flatMap { list -> list.samePriceFilter }
}
```

