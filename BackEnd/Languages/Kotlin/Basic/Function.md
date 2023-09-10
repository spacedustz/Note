## 💡 코틀린에서 함수를 다루는법

목차

- 함수 선언 문법
- Default Parameter
- Named Argument (parameter)
- 같은 타입의 여러 파라미터 받기 (가변인자)

---

## 💡 함수 선언 문법

함수는 클래스 내부,  파일 최상단, 한 파일 안에 여러 함수가 존재할 수 있다.

<br>

코틀린에서 함수의 결과값이 하나라면 block 대신 = 를 사용 가능하다.

그리고, 파라미터의 타입이 동일하면 타입추론이 가능해 반환타입의 생략도 가능하다.

block { }을 사용하는 경우 반환타입이 Unit이 아니면 타입 명시를 해줘야 한다.

<br>

### 두 정수를 받아 더 큰 정수를 반환하는 예시

```java
// Java
public int max(int a, int b) {
    if (a > b) {
        return a;
    }
    return b;
}
```

코틀린에서 if-else는 Expression이기 때문에 if 내부의 return과 외부의 return, 중괄호도 생략이 가능하다.

```kotlin
// Kotlin
fun max(a: Int, b: Int) = if (a > b) a else b ?: 0
```

---

## 💡 Default Parameter

자바에서 함수를 적절히 사용처에 맞게 함수를 오버로딩하여 사용했지만 불필요한 중복 함수를 만들어야 했다.

코틀린에서는 함수 선언 시 파라미터의 값을 Default로 고정하여 만들 수 있다.

즉, **외부에서 파라미터를 넣어주지 않아도 함수 선언 시 지정한 기본 값을 Default 값으로 변환**해준다.

<br>

### 주어진 문자열을 N번 출력하는 예시

보통 자바에서 어떤 함수를 사용하다가 파라미터의 개수를 고정하거나 변형하고 싶을때 오버로딩하여 사용한다.

즉, 메서드를 3개나 만드는 중복 작업이 필요하다.

```java
// Java
public void repeat(String str, int num, boolean useNewLine) {
    for (int i=1; i<=num; i++) {
        if (useNewLine) {
            System.out.println(str);
        } else {
            System.out.print(str);
        }
    }
}

public void repeat(String str, int num) {
    repeat(str, num, true);
}

public void repeat(String str) 
    repeat(str, 3, true);
```

<br>

간결해진 코드

```kotlin
// Kotlin
fun repeat(str: String, num: Int = 3, useNewLine: Boolean = true) {
    for (i in 1..num) {
        if (useNewLine) {
            println(str)
        } else {
            print(str)
        }
    }
}
```

---

## 💡 Named Argument

파라미터에서 이름을 통해 직접 어떤 값을 넣어줄지 지정하고, 지정되지 않은건 기본값을 사용한다.

Named Argument를 사용하면 Builder를 만들지 않고도 Builder의 장점을 가질 수 있다.

<br>

제한사항으로는 Java 함수를 코틀린에 가져와 쓸때는 Named Argument를 사용할 수 없다.

이유는, JVM에서 Java가 바이트코드로 변환됐을 때 파라미터 이름을 보존하지 못하기 때문이다.

<br>

repeat 함수를 호출할 때 파라미터의 값을 num = 3, useNewLine = false 로 하고싶을때 예시

useNewLine = false 부빈이 Named Argument 코드이다.

```kotlin

fun main() {
    // 예시 함수 1 - Named Argument
    repeat("Hello", useNewLine = false)
    
    // 예시 함수 2 - Named Argument
    printNameAndGender(name = "홍길동", gender = "남자")
}

// 예시 함수 1
fun repeat(str: String, num: Int = 3, useNewLine: Boolean = true) {
    for (i in 1..num) {
        if (useNewLine) {
            println(str)
        } else {
            print(str)
        }
    }
}

// 예시 함수 2
fun prntNameAndGender(name: String, gender: String) {
    println(name)
    println(gender)
}
```

---

## 💡 같은 타입의 여러 파라미터 받기 (가변인자)

자바의 가변인자인 Type...은 코틀린에서 변수명 앞에 'vararg' 키워드를 사용한다.

<br>

그리고, 가변인자를 가진 함수를 **배열을 이용하여 사용할 때**, 

printAll(*array) 처럼 앞에 * (Spread 연산자)를 붙여야 한다.

<br>

문자열을 N개 받아 출력하는 예시

```java
// Java
public static void printAll(String... strs) {
    for (String str : strs) {
        System.out.println(str);
    }
}
```

```kotlin
// Kotlin
fun main() {
    printAll("A", "B", "C")
    
    val array = arrayOf("A", "B", "C")
    printAll(array)
}

// printAll 함수
fun printAll(vararg strs: String) {
    for (str in strrs) {
        println(str)
    }
}
```

