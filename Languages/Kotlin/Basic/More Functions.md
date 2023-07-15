## 💡 코틀린에서 다양한 함수를 다루는 법

목차

- 확장 함수
- infix 함수 (중위함수)
- inline 함수
- 지역 함수
- 정리

---

## 확장 함수

[확장함수 블로깅 해 놓은 글 링크](https://iizz.tistory.com/230)

멤버함수와 확장함수의 시그니처가 같다면 멤버함수가 우선적으로 호출된다.

자바에서 코틀린의 확장함수를 사용할때는 정적멤버를 다루듯이 사용하면 된다.

`this`를 이용해 실제 클래스 안의 값에 접근한다.

만약 확장함수가 public이고 확장함수의 수신객체의 private 함수를 가져오면 캡슐화가 깨질까?

- 답은 애초에 그걸 방지하기 위해 확장함수는 private 또는 protected 멤버를 가져올 수 없다.

```kotlin
fun main() {
    val str = "ABC"
    str.lastChar()
}

fun String.lastChar(): Char {
    return this[this.length - 1]
}
```

<br>

확장함수가 오버라이드 된다면?

현재 변수에 할당된 타입에 의해 어떤 확장함수가 호출될지 결정된다.

```kotlin
open class Train(
    val name: String = "아아"
    val price: Int = 5000
)

fun Train.isExpensive(): Boolean {
    println("Train의 확장함수")
    return this.price >= 10000
}

calass Srt : Train("SRT", 40_000)

fun Srt.isExpensive(): Boolean {
    println("Srt의 확장함수")
    return this.price >= 10000
}

fun main() {
    
    // Train의 함수 호출
    val train: Train = train()
    train.isExpensive()
    
    // Train의 함수 호출
    val str1: Train - srt()
    srt1.isExpensive()
    
    // Srt의 함수 호출
    val str2: Srt = Srt()
    srt2.isExpensive
}
```

<br>

### 확장 프로퍼티

확장 프로퍼티의 원리는 **확장함수 + Custom Getter**와 동일하다.

```kotlin
fun String.lastChar(): Char {
    return this[this.length - 1]
}

val String.lastChar: Char
  get() = this[this.length - 1]
```



---

## infix 함수

함수를 호출하는 새로운 방법이다. `infix` 키워드를 통해 구현 가능하며, 멤버함수에도 붙일 수 있다.

for-each에서 쓰는 downTo, step도 함수에 속한다. (중위함수)

`변수.함수이름`(argument) 대신 `변수 함수이름 argument` 으로 사용이 가능하다.

위처럼 중위함수 사용하려면 변수와 함수가 1개씩 존재해야 한다.



```kotlin
// 확장 함수
fun Int.add(other: Int): Int {
    return this + other
}

// 중위 함수
infix fun Int.add2(other: Int): Int {
    return this + other
}

fun main() {
    // 확장 함수 호출
    3.add(4)
    
    // 중위 함수 호출
    3 add 4
}
```

---

## Inline 함수

함수가 호출되는 대신, 함수를 호출한 지점에 함수 본문을 그대로 복붙하고 싶은 경우 사용한다.

- 함수를 파라미터로 전달할때(함수 콜 체) 오버헤드를 줄일수 있다.
- Inline 함수의 사용은 성능 측정과 함께 신중하게 사용해야 한다. 

```kotlin
fun main() {
    3.add(4)
}

inline fun Int.add(other: Int): Int {
    return this + other
}
```

바이트코드 결과값

- 실제 함수 본문의 로직 자체가 복붙된다.

```java
public static final void main() {
    byte $this$add$iv = 3;
    int other$iv = 4;
    int $i$f$add = false;
    
    // 실제 함수 로직 본문이 호출된다
    int var10000 = $this$add$iv + other$iv; 
}
```

---

## 지역 함수

함수 내부에 함수를 선언할 수 있다.

불필요한 중복 코드를 특정 함수 내에서만 사용하고 싶을때 사용한다.

<br>

불필요한 중복 코드가 들어가 있는 예시

```kotlin
fun createPerson(firstName: String, lastName: String): Person {
    if (firstName.isEmpty()) {
        throw IllegalArgumentException("firstName은 비어있을 수 없습니다! - 현재값 : $firstName")
    }
    
    if (lastName.isEmpty()) {
        throw IllegalArgumentException("lastName은 비어있을 수 없습니다! - 현재값 : $lastName")
    }
    
    return Person(firstName, lastName, 1)
}
```

개선된 코드

```kotlin
fun createPerson(firstName: String, lastName: String: Person {
    fun validateName(name: String, fieldName: String) {
        if (name.isEmpty()) {
            throw IllegalArgumentException("${fieldName}은 비어있을 수 없습니다! - 현재값 : $name")
        }
    }
    
    validateName(firstName, "firstName")
    validateName(lastName, "lastName")
    
    return Person(firstName, lastName, 1)
}
```

---

## 정리

**확장함수**

- 확장함수는 원본 클래스의 private, protected 멤버에 접근이 안된다.
- 멤버함수, 확장함수 중 호출되었을 때, 멤버함수에 우선권이 있다.
- 확장함수는 현재 타입을 기준으로 호출된다.
- Java 에서는 Static 함수를 사용하는것 처럼 Kotlin의 확장함수를 사용할 수 있다.

<br>

**infix & Inline & Local 함수**

- infix 함수는 함수 호출 방식을 바꿔준다.
- 함수를 복사-붙여넣기를 가능하게 해주는 Inline 함수가 존재한다.
- 코틀린에서는 함수안에 함수를 선언할 수 있고, 지역함수라고 부른다.
