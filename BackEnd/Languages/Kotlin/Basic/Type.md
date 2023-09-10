## 💡 코틀린에서 Type을 다루는 방법

코틀린에서는 선언된 기본값을 보고 타입을 추론한다.

```kotlin
val number1 = 3 // Int
val number2 = 3L // Long
val number3 = 3.0f // Float
val number4 = 3.0 // Double
```

<br>

자바는 기본 타입간의 타입 변환은 암시적으로 이루어질 수 있지만,
코틀린의 기본 타입간 타입 변환은 to를 이용한 명시적 변환이 이루어져야 한다.

<br>

아래 예시는 자바의 암시적 타입 변환 예시이다.

```java
// Java
int number1 = 4
long number2 = number1 // 암시적 타입 변환

System.out.println(number1 + number2)
```

<br>

코틀린에서의 코드

```kotlin
// ----------명시적 타입변환 예시----------- //
val number1 = 4
val number2: Long = number1.toLong() // 명시적 타입 변환

println(number1 + number2)

// ----------실수의 결과값을 얻고 싶을때----------- //
val number1 = 3
val number2 = 5
val result = number1 / number2.toDouble() // 명시적 타입 변환

println(result)

// ----------Nullable Type 일 때----------- //
val number1: Int? = 3
val number: Long = number1.?toLong() ?: 0L
```

---

## 💡 일반 타입 캐스팅

자바에서의 instanceof에 해당하는 키워드는 is로 타입을 검증하고, 

자바의 타입변환에 해당하는 ()를 as로 타입변환을 한다.

<br>

아래 코틀린 코드 예시에서 'val Person = obj as Person'은 스마트 캐스팅으로 생략이 가능하다.

즉, 코틀린 코드에서 if문이 타입 검증이 완료 되었으므로, 그 타입으로 간주해 as가 생략이 가능하다

(스마트 캐스팅)

is, !is, as, as?

```java
// Java
public static void printAgeIfPerson(Object obj) {
    if (obj instanceof Person) {
        Person person = (Person) obj;
        System.out.println(person.getAge());
    }
}
```

```kotlin
// Kotlin
fun printAgeIfPerson(obj: Any) {
    if (obj is Person) {
        // val person = obj as Person // 스마트 캐스팅으로 생략 가능
        println(person.age)
    }
}
```

<br>

### instanceof의 반대도 가능할까?

'is'의 앞에 ! 만 붙여주면 반대도 가능하다.

```kotlin
// Kotlin
fun printAgeIfPerson(obj: Any) {
    if (obj !is Person) {
        // val person = obj as Person // 스마트 캐스팅으로 생략 가능
        println(person.age)
    }
}
```

<br>

### obj에 Null이 들어올 수 있다면?

as뒤에 '?' 써줌으로써 obj가 Null이 아니면 타입변환, 아니면 전체 문장이 Null이 된다.

그렇기 때문에 전체가 'Null이 될 수 있음'이니까 Person은 Nullable Person이다.

그러므로 println()의 파라미터의 person 변수에 '?'를 붙여준다.

```kotlin
fun printAgeIfPerson(obj: Any?) {
    val person = obj as? Person
    println(person?.age)
}
```

---

## 💡 코틀린의 특이한 타입 3가지

- Any
  - 자바의 Object 역할 (모든 객체의 최상위 타입이다.)
  - 모든 Primitive의 최상위 타입도 Any이다.
  - Any 자체로 Null 포함이 안되므로 Any?로 표현한다.
  - 자바와 같이 Any에 equals / hashCode / toString 메서드가 존재한다.

<br>

- Unit
  - 자바의 void와 동일한 역할
  - void와 다르게 Unit은 그 자체로 타입 인자로 사용 가능하다.
  - 함수형 프로그래밍에서 Unit은 단 하나의 인스턴스만 갖는 타입을 의미한다.
    즉, 코틀린의 Unit은 실제 존재하는 타입이라는 것을 표현한다.

<br>

- Nothing
  - 함수가 정상적으로 끝나지 않았다는 사실을 표현한다.
  - ex: 무조건 예외를 반환하는 함수 / 무한 루프 함수 등

---

## 💡 String interpolation & String indexing

문자열 타입을 코틀린에서 사용하는 방법이다.

`${변수}`의 형식으로 사용하며 중괄호를 생략한 `$변수`의 형식도 가능하다.

하지만, 일괄적인 변환 & 정규표현식과 가독성을 위해 `${변수}` 중괄호를 사용하는게 좋다.

<br>

자바에서 문자열을 다룰때 String 클래스를 이용하거나 StringBuilder를 이용한다.

```java
// Java
Person person = new Person("홍길동", 100);

String log = String.format("사람의 이름은 %s이고 나이는 %s세 입니다.", person.getName, person.getAge());

StringBuilder sb = new StringBuilder();
sb.append("사람의 이름은");
sb.append(person.getName());
sb.append("이고 나이는");
sb.append(person.getAge());
sb.append("세 입니다.");
```

<br>

코틀린에서의 코드

```kotlin
// Kotlin
val person = Person("홍길동", 100)
val log = "사람의 이름은 ${person.name}이고 나이는 ${person.age}세 입니다."

// xx.xx이 아닌 그냥 바로 변수를 호출할 때 중괄호 생략 가능
val name = "사람"
val age = 100
val log = "사람의 이름: $name 나이: $age"
```

<br>

여러 줄에 걸친 문자열을 작성할 때

```kotlin
val name = "홍길동"
val withoutIndent =
"""
	ABC
	123
	${name}
""".trimIndent()

println(withoutIndent)

// 결과값
ABC
123
홍길동
```

<br>

문자열의 특정 문자 가져오기

자바에서는 charAt()을 썼지만 코틀린에서는 배열의 인덱스를 읽어오듯이 가져올 수 있다.

```kotlin
val str = "ABC"
println(str[0])
println(str[1])

// 결과값
A
B
```

