## 💡 코틀린 - 그 외 다양한 기능들

목차

- Type Alias & as import
- 구조분해와 componentN 함수
- Jump & Label
- TakeIf & TakeUnless

---

## Type Alias & as import

긴 이름의 클래스 & 함수 타입이 있을때 축약하거나 더 좋은 이름을 쓰고 싶을 때 사용한다.

- type alias : 타입이나 클래스 이름에 별칭을 붙여 줄여서 사용 가능하다.
- as import : 어떤 클래스나 함수를 import 할 때 이름을 바꾸는 기능이다.

<br>

이 함수에서 파라미터로 받는 filter 부분이 길다고 느껴질 수 있다.

그리고 filter 함수의 파라미터가 많아진다면 더 길 것이다.

```kotlin
fun filterFruits(fruits: List<Fruit>, filter: (Fruit) -> Boolean ) {}
```

이럴때 `typealias` 키워드를 사용해 타입의 별칭을 지정하는게 가능하다.

```kotlin
typealias FruitFilter = (Fruit) -> Boolean

fun filterFruits(fruits: List<Fruit>, filter: FruitFilter ) {}
```

<br>

이름이 킨 클래스 컬렉션에 사용할 때도 간단히 줄일 수 있다.

```kotlin
data class UltraSuperGuardianTribe(
    val name: String
)

typealias USGTMap = Map<String, UltraSuperGuardianTribe>
```

<br>

다른 패키지의 같은 이름 함수를 동시에 가져오고 싶다면 `as`를 사용한다.

```kotlin
package com.a

fun printHelloWorld() {
    println("Hello World A")
}

// ----- //

package com.b
fun printHelloWorld() {
    println("Hello World B")
}

// ----- //
import com.a.printHelloWorld as printA
import com.b.printHelloWorld as printB

fun main() {
    printA()
    printB()
}
```

---

## 구조분해와 componentN 함수

**구조분해란?**

- 복합적인 값을 분해하여 여러 변수를 한 번에 초기화하는 것이다. 
- 구조분해 문법을 쓴다는 것은 componentN 함수를 사용한다는 소리와 마찬가지이다.
- 아래 예시를 보자.
- person 객체에 대한 초기화를 한번에 하고있고, 내부적으로 componentN 함수가 호출이 된 것이다.

```kotlin
data class Person(
    val name: String,
    val age: Int
)

fun main() {
    val person = Person("사람", 20)
	val (name, age) = Person
    println("이름 : $name, 나이 : $age")
}
```

**data class를 만들면 기본적으로 componentN 함수를 만들어준다.**

<br>

### componentN 함수란?

- 데이터 클래스는 기본적으로 자기 자신의 필드에 대한 componentN 함수를 만든다.

이게 무슨 말이냐면 위의 코드의 `val (name, age)` 부븐을 코드로 변환하면
내부적으로 이런 형태로 호출이 된다.

```kotlin
val name = person.component1()
val age = person.component2()
```

<br>

### Data Class가 아닌 Class 에서 ComponentN 함수 구현

data class는 기본적으로 componentN 함수를 만든다고 했는데 data class가 아니면 어떻게 해야 할까?

- 클래스의 body에 componentN 함수를 직접 구현하면 된다.
- componentN 함수는 **연산자의 속성을 가지므로 연산자 오버로딩 형식으로 구현해야 한다. (operator 키워드)**

```kotlin
class Person(
    val name: String,
    val age: Int
) {
    
    operator fun component1(): String {
        return this.name
    }
    
    operator fun component2(): Int {
        return this.age
    }
}
```

리스트를 인덱스와 함께 사용할때와 Map의 entries 함수도 사실 구조분해 문법을 사용한다.

```kotlin
val map = mapOf(1 to "A", 2 to "B")

for ((key, value) in map.entries) {}
```

---

## Jump & Label

### Jump

**return** : 기본적으로 가장 가까운 Enclosing Function 또는 익명함수로 값이 반환된다.

**break** : 가장 가까운 Loop가 제거된다.

**continue** : 가장 가까운 Loop를 다음 Step 으로 보낸다.

위의 기능들은 기본적으로 자바와 100% 동일하다.

하지만, For-Each에서 코틀린과 자바에 차이가 있다.

**코틀린의 forEach()에서는 continue나 break를 사용할 수 없다.**

```kotlin
fun main() {
    val numbers = listOf(1, 2, 3)
    
    numbers.map{it + 1}.forEach{println(it)}
    
    for (num in)
}
```

forEach에서 break를 쓰고 싶을 경우 `run` 키워드를 사용해서 `return@run` 키워드를 사용해야 한다.

```kotlin
fun main() {
    run {
        numbers.forEach {
            number ->
            if (number == 3) {
                return@run
            }
            println(number)
        }
    }
}
```

forEach에서 continue를 쓰고 싶을 경우 `return@forEach`를 사용해야 한다.

```kotlin
numbers.forEach {
    number ->
    if (number == 2) {
        return@forEach
    }
}
```

<br>

### Label

특정 Expression에 `라벨이름@`을 붙여 하나의 라벨로 간주하고 break, continew, return 등을 사용하는 기능

**Label을 사용한 Jump는 가급적 사용하지 않는게 좋다.**

왜냐하면 코드의 흐름이 위아래로 계속 움직일수록 시간복잡도가 기하급수적으로 증가한다.

- 첫 for 문에 라벨을 붙이고 안쪽 조건문에 부합하면 라벨이 붙은 for문에 break가 걸린다.

```kotlin
loop@ for (i in 1..100) {
    for (j in 1..100) {
        if (j == 2) {
            break@loop
        }
        println("${i}, ${j}")
    }
}
```

---

## TakeIf &  TakeUnless 

코틀린은 Method Chaining을 위한 특이한 함수인 `takeIf`, `takeUnless`를 제공한다.

```kotlin
fun getNumberOrNull(): Int? {
    return if (number <= 0) null else number
}
```

코틀린은 Method Chaining을 위한 특이한 함수를 제공한다. (takeIf)

위의 코드를 리팩터링 해보자.

`takeIf`를 사용하면 조건을 만족하면 그 값이, 아니면 Null을 반환하는 기능을 한다.

```kotlin
fun getNumberOrNullV2(): Int? {
    return number.takeIf { it > 0 }
}
```

<br>

그리고, 주어진 조건을 만족하지 않으면 그 값이, 아니면 Null이 반환되는 `takeUnless` 기능이 있다.

```kotlin
fun getNumberOrNullV3(): Int? {
    return number.takeUnless { it <= 0 }
}
```

