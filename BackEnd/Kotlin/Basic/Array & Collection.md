## 💡 코틀린에서 배열과 컬렉션을 다루는 법

목차

- Array
- Collection - List, Set, Map
- Null 가능성, Java와 함께 사용
- 정리

---

## 💡 Array

코틀린엑서 배열을 잘 쓸일이 없지만 그래도 자바와 차이점을 설명한다.

for loop를 쓸때 **indices** 키워드를 사용하여 0 부터 index 까지의 Range를 나타낼 수 있다.

또 다른 방법은 withIndex()를 사용하면, 인덱스와 값을 한번에 가져올 수 있다.

<br>

**자바 예시 코드**

```java
int[] array = {100, 200};

for (int i=0; i<array.length; i++) {
    System.out.println("%s %s", i, array[i]);
}
```

<br>

**코틀린 예시 코드**

방법 1: indices는 0부터 마지막 index까지의 Range이다.

```kotlin
val array = arrayOf(100, 200)

for (i in array.indeices) {
    println("${i} ${array[i]}")
}
```

방법 2 : withIndex()를 사용하면, 인덱스와 값을 한번에 가져올 수 있다.

```kotlin
val array = arrayOf(100, 200)

for ((idx, value) in array.withIndex()) {
    println("${idx} ${value}")
}
```

값을 쉽게 넣을수도 있다.

```kotlin
val array = arrayOf(100, 200)
array.plus(300) // 값 넣기

for ((idx, value) in array.withIndex()) {
    println("${idx} ${value}")
}
```

---

## 💡Collection - List, Set, Map

코틀린에서 컬렉션을 생성할 때, 불변인지 가변인지를 설정해야 한다.

Collection을 만들자마자, Collections.unmodifiableList()를 붙여준다.

**불변 컬렉션이라 하더라도 Reference Type인 Element의 필드는 바꿀 수 있다.**

<br>

가변 컬렉션

- 컬렉션에 Element를 추가, 삭제할 수 있다.

불변 컬렉션

- 컬렉션에 Element를 추가, 삭제할 수 없다.

![image-20230423191124531](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/kotlin_collection.png) 

<br>

### List

불변리스트의 생성은 listOf()를 사용한다.

가변리스트의 생성은 mutableListOf()를 사용한다.

우선 불변리스트로 만들되, 필요한 경우 가변 리스트로 변경하는걸 추천한다.

```kotlin
/* ----- 불변 리스트 ----- */
val numbers = listOf(100, 200)
val emptyList = emptyList<Int>()

// 하나를 가져오기
println(numbers[0])

// For-Each
for (number in numbers) {
    println(number)
}

// 전통적인 For문
for ((index, number) in numbers.withIndex()) {
    println("$index $number")
}

/* ----- 가변 리스트 ----- */
val numbers = mutableListOf(100, 200)
numbers.add(300)
```

<br>

### Set

집합은 List와 다륵 순서가 없고, 같은 Element는 하나만 존재할 수 있다. (데이터 중복 불가능)

기본 구현체는 LinkedHashSet 이다.

Set도 List와 같이 불변으로 만드려면 setOf()를 사용한다.

가변 집합을 만들고 싶으면 동일하게 mutableSetOf()를 사용한다.

```kotlin
val numbers = setOf(100, 200)

// For-Each
for (number in numbers) {
    println(number)
}

// 전통적인 For문
for ((index, value) in numbers.withIndex()) {
    println("$index $number")
}
```

<br>

### Map

List와 Set과 동일하게 불변은 mapOf(), 가변은 mutableMapOf()를 사용한다.

정적 팩토리 메서드를 바로 활용할 수도 있다.

<br>

**예시**

가변 Map 이기 때문에 (key, value)를 넣을 수 있다.

Java 처럼 put을 쓸 수도 있고, map[key] = value를 쓸 수도 있다.

```kotlin
// 가변 Map인 MutableMapOf() 생성
val map = mutableMapOf<Int, String>()
map[1] = "MONDAY"
map[2] = "TUESDAY"

mapOf(1 to "MONDAY", 2 to "TUESDAY")

// 불변 Map인 mapOf() 생성
val map = mapOf<Int, String>()

for (key in map.keys) {
    println(key)
    println(value)
}

for ((key, value) in map.entries) {
    println(key)
    println(value)
}
```

---

## 💡Null 가능성, Java와 함께 사용

? 위치에 따라 null 가능성 의미가 달라지므로 차이를 잘 이해해야 한다.

자바는 nullable 타입과 non-nullable 타입을 구분하지 않는다.

그래서 Kotlin의 컬렉션이 Java에서 호출되면 컬렉션 내용이 변할 수 있음을 감안해야 한다.

코틀린 쪽에서 Collections.unmodifableXXX()를 활용하면 변경 자체를 막을 순 있다.

<br>

List<Int?>

- 리스트에 null이 들어갈 수 있지만, 리스트 자체는 절대 null이 아님

List<Int>?

- 리스트에는 null이 들어갈 수 없지만, 리스트 자체는 null일 수 있음

List<Int?>?

- 리스트에 null이 들어갈 수도 있고, 리스트 자체가 null일 수도 있음

---

## 💡 정리

- 코틀린에서는 컬렉션을 만들때도 불변/가변을 명시해야 한다.
- List, Set, Map에 대한 사용법이 변경/확장 되었다.
- Java와 Kotlin 코드를 섞어 컬렉션을 사용할 때는 주의 해야한다.
  - Java에서 Kotlin 컬렉션을 가져갈 때, 불변 컬렉션을 수정 할 수도 있고,
    non-nullable 컬렉션에 null을 넣을 수도 있다.
  - Kotlin에서 Java 컬렉션을 가져갈 때는 **플랫폼 타입**을 주의해야 한다.