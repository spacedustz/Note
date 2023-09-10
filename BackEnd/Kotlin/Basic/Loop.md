## 💡 코틀린에서 Loop를 다루는법

목차

- ForEach
- For
- While

---

## 💡 For-Each

자바와 코틀린의 For-Each 차이점

- 컬렉션을 만드는 방법이 다르다.
- ':' 대신 'in'을 사용한다.
- Iterable이 구현된 타입이라면 For-Each문에 전부 들어갈 수 있다.

```java
// Java
List<Long> numbers = Arrays.asList(1L, 2L, 3L);

for (long number : numbers) {
    System.out.println(number);
}
```

```kotlin
// Kotlin
val numbers = listOf(1L, 2L, 3L)

for (number in numbers) {
    println(number)
}
```

<br>

## 💡 For

- '..' : 범위를 만들어 내는 연산자, IntProgression(등차수열)을 상속받은 IntRange 클래스
- downTo : 반대로 내려갈때 사용
- step : 등차수열의 공차부분이다.
- downTo, step도 함수이다 (중위 호출 함수)
  - '변수.함수이름 argument' 가 기본 호출 방법인데, '변수 함수이름 argument' 로 사용가능하게 해준다.

```java
// Java
for (int i=1; i<=3; i++) {
    System.out.println(i);
}

for (int i=3; i>=1; i--) {
    System.out.println(i);
}

for (int i=1; i<=5; i+=2) {
    System.out.println(i);
}
```

```kotlin
// Kotlin
for (i in 1..3) {
    println(i)
}

for (i in 3 downTo 1) {
    println(i)
}

for (i in 1..5 step 2) {
    println(i)
}
```

<br>

## 💡 While

- While, Do-While 문은 자바와 완전히 동일하다.

```java
// Java
int i = 1;
while (i <= 3) {
    System.out.println(i);
    i++;
}
```

```kotlin
// Kotlin
var i = 1
while (i <= 3) {
    println(i)
    i++
}
```