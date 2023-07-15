## 💡 Kotlin에서 변수를 다루는 법

불변인 변수를 선언하려면 val를 사용한다.

가변인 변수를 선언하려면 var를 사용한다.

모든 변수는 우선 val(불변)로 만들고 필요한 경우 var(가변)로 변경하는게 디버깅 & 가독성에 좋다.

```java
// Java
long number1 = 10L;
final long number2 = 10L;

Long number3 = 1_000L;
Person person = new Person("홍길동");
```

```kotlin
// Kotlin
var number1 = 10L
val long number2 = 10L

Long number3 = 1_000L
Person person = new Person("홍길동")
```

<br>

그리고, 위의 코틀린 코드는 타입을 명시하지 않아도 자동으로 타입 추론이 되지만,
타입을 명시적으로 작성도 가능하다.

```kotlin
var number1: Long = 10L
```

<br>

초기값을 지정해주지 않는 경우는?

값을 넣지 않았기 때문에 타입을 추론을 못해서 타입을 넣어주면 된다.

```kotlin
var number1: Long
val number2: Long
```

<br>

val Collection은 불변이지만 element를 추가할 수 있다. (변경이 아닌 추가기 떄문에)

---

## 💡 Primitive Type

코틀린에서는 자바에서 사용하던 모든 Primitive 타입을 기본적으로 객체로 보며, 
내부적으로 Primitive로 바꿔서 알아서 처리해준다. (디컴파일 해보면 long으로 처리되는걸 볼 수 있다.)

즉, 프로그래머가 Boxing / Unboxing을 고려하지 않아도 되도록 알아서 처리 해준다.

```java
// Java
long number1 = 10L;
final long number2 = 10L;

Long number3 = 1_000L;
Person person = new Person("홍길동");
```

```kotlin
// Kotlin
var number1 = 10L
val long number2 = 10L

Long number3 = 1_000L
Person person = new Person("홍길동")
```

---

 ## 💡 Nullable

코틀린에서는 기본적으로 모든 변수에 Null이 들어갈 수 없게 설정 되어있다.

위의 Long은 객체이다, 그러므로 Null이 들어갈 수 있음을 의미한다.

코틀린에서는 'Null이 될 수 있는'을 '?' 기호로 타입 뒤에 정의한다.

- var 변수명: 타입? = 값

```kotlin
var number1: Long? = 1_00L
number1 = null
```

**Nullable 타입은 Null 체크를 무조건 해주어야 한다.**

---

## 💡 객체 인스턴스화

자바에서 인스턴스를 생성할 때는 'new' 키워드를 사용했었다.

코틀린에서는 new를 쓰면 안된다.

```kotlin
var Person = Person("홍길동")
```

