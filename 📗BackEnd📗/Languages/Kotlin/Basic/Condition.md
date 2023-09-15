## 💡 코틀린에서 조건문을 다루는법

목차

- Condition
- Expression & Statement
- Switch & When

---

## 💡 Condition

자바와 코틀린의 if문 차이점

- void 생략 (Unit 키워드 사용, Unit 생략 가능)
- 함수를 만들때 fun 키워드 사용
- Exception을 던질 때 new 키워드 생략

```java
// Java
private void validateScoreIsNotNegative(int score) {
    if (score < 0) {
        throw new IllegalArgumentException(String.format("%s는 0보다 작을 수 없습니다."), score);
    }
}
```

```kotlin
fun validateScoreIsNotNegative(score: Int) {
    if (score < 0) {
        throw IllegalArgumentException("${score}는 0보다 작을 수 없습니다.")
    }
}
```

<br>

## 💡 Expression & Statement

자바와 코틀린의 if - else문 차이점

- 자바에서 if-else는 Statement 이지만, 코틀린에선 Expression이다.
- Expression 이므로 바로 return 하거나, 변수에 대입할 수 있다.
- 코틀린의 if-else 만으로 자바의 삼항연산자를 대체할 수 있다.

<br>

Statement : 프로그램의 문장 전체를 의미하며, 하나의 값으로 도출되지 않는다.

Expression : 하나의 값으로 도출되는 문장

```java
// Java
private String getPassOrFail(int score) {
    if (score >= 50) {
        return "P";
    } else {
        return "F";
    }
}
```

```kotlin
// Kotlin
fun getPassOrFail(score: Int): String {
    return if (score >= 50) {
        return "P"
    } else {
        return "F"
    }
}

// if의 다른 사용법
fun startsWithA(obj: Any): Boolean {
    return when (obj) {
        is String -> obj.startsWith("A") // Smart Casting
        else -> false
    }
}
```

<br>

## 💡 Switch & When

자바와 코틀린의 switch문 차이점

- 자바의 switch를 코틀린에서 when으로 사용한다.
- when은 Expression이기 때문에 바로 return이 가능하다.
- case를 작성하지 않고 화살표로 분기를 준다.
- default 대신 else를 사용한다.
- when의 조건부에는 어떠한 Expression이라도 들어갈 수 있다. (is, as, .. 등)
- 여러개의 조건을 동시에 검증이 가능하다.
- when의 조건 ()이 없는 경우도 가능하다.
- **when은 Enum Class, Sealed Class와 함께 사용할 경우 더욱 더 진가를 발휘한다.**

```java
// Java
private String getGradeWithSwitch(int score) {
    switch (score / 10) {
        case 9:
            return "A";
        case 8:
            return "B";
        case 7:
            return "C";
        default:
            return "D";
    }
}
```

<br>

'90.99' 에 대한 설명을 하자면 score가 90~99 범위이면 "A"를 리턴한다.

```kotlin
// Kotlin
fun getGradeWithSwitch(score: Int): String {
    return when (score / 10) {
        9 -> "A"
        8 -> "B"
        7 -> "C"
        ele -> "D"
    }
}

// when의 다른 사용법
fun getGradeWithSwitch(score: Int): String {
    return when (score) {
        in 90.99 -> "A"
        in 80.89 -> "B"
        in 70.79 -> "C"
        else -> "D"
    }
}

// 여러개의 조건을 동시에 검증
fun judgeNumber(num: Int) {
    when (num) {
        1, 0, -1 -> println("어디서 많이 본 숫자입니다.")
        else -> println("1, 0, -1이 아닙니다.")
    }
}

// 조건이 없는 경우
fun judgeNumber(num: Int) {
    when {
        num == 0 -> println("숫자는 0입니다.")
        num % 2 == 0 -> println("숫자는 짝수입니다.")
        else -> println("숫자는 홀수입니다.")
    }
}
```
