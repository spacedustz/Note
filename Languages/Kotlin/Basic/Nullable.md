## 💡 코틀린에서 Null을 다루는법

코틀린에서는 기본적으로 모든 변수에 Null이 들어갈 수 없게 설정 되어있다.

위의 Long은 객체이다, 그러므로 Null이 들어갈 수 있음을 의미한다.

코틀린에서는 'Null이 될 수 있는'을 '?' 기호로 타입 뒤에 정의한다.

- var 변수명: 타입? = 값

```kotlin
var number1: Long? = 1_00L
number1 = null
```

<br>

**Nullable 타입은 Null 체크를 무조건 해주어야 한다.**

---

### 예시

- 1번 함수, boolean (Primitive Type)
- 2번 함수, Boolean (Reference Type)
- 3번 함수, boolean (Primitive Type)

1번 함수의 파라미터의 타입인 String에서 Nullable을 선언해줬다.

함수의 반환타입은 Boolean에 '?'를 붙이지 않은 이유는 Primitive boolean은 Null이 들어올 수 없기 때문이다.

<br>

2번 함수의 반환타입 Boolean은 자바에서 Reference 타입 Boolean이기 때문에 Boolean에 '?'를 붙여줬다.

<br>

3번 함수의 파라미터를 Null일 수 있고 반환타입은 자바의 Primitive Type인 boolean 이기 때문에 '?'는 String에만 붙임.

```kotlin
fun main() {
    
}

// 1번 함수, boolean (Primitive Type)
fun startsWithA1(str: String?): Boolean {
    if (str == null) {
        throw IllegalArgumentException("Null이 들어왔습니다.")
    }
    return str.startsWith("A")
}

// 2번 함수, Boolean (Reference Type)
fun startsWithA2(str: String?): Boolean? {
    if (str == null) {
        return null;
    }
    return str.startsWith("A")
}

// 3번 함수, boolean (Primitive Type)
fun startsWithA3(str: String?) {
    if (str == null) {
        return false;
    }
    return str.startsWith("A")
}
```

---

## 💡 Safe Call과 Elvis 연산자

코틀린에서 '안전한 호출'이라는 의미이다.

<br>

아래 예시에서 'str?.' 부분이 Safe Call이며, 값이 Null이 아닐경우 에만 실행하도록 보장한다.

만약, 값이 Null이면 'str?.length' 문장 전체의 값이 Null이 되고, 아닌 경우 그대로 값이 출력된다.

```kotlin
val str: String? = "ABC"
str.length // 실행 불가능
str?.length // 실행 가능, Safe Call
```

<br>

### Elvis 연산자

앞의 연산결과가 Null이면 뒤의 값을 사용하게 해주는 연산자이다.

아래의 코드에서 'str?.length ' Safe Call 문장의 결과값이 Null이라면 0 을 출력한다는 의미이다.

```kotlin
val str: String? = "ABC"
str?.length ?: 0
```



### Nullable & SafeCall & Elvis 응용

3가지를 이용해 위의 1,2,3번 함수를 좀 더 코틀린스럽게 바꿔보자.

<br>

**코드 수정 전**

```kotlin
fun main() {
    
}

// 1번 함수, boolean (Primitive Type)
fun startsWithA1(str: String?): Boolean {
    if (str == null) {
        throw IllegalArgumentException("Null이 들어왔습니다.")
    }
    return str.startsWith("A")
}

// 2번 함수, Boolean (Reference Type)
fun startsWithA2(str: String?): Boolean? {
    if (str == null) {
        return null;
    }
    return str.startsWith("A")
}

// 3번 함수, boolean (Primitive Type)
fun startsWithA3(str: String?) {
    if (str == null) {
        return false;
    }
    return str.startsWith("A")
}
```

<br>

**코드 수정 후**

```kotlin
fun main() {
    
}

// 1번 함수, boolean (Primitive Type)
fun startsWithA1(str: String?): Boolean {
    return str?.startsWith("A") ?: throw IllegalArgumentException("값이 Null 입니다.")
}

// 2번 함수, Boolean (Reference Type)
fun startsWithA2(str: String?): Boolean? {
    return str?.length("A")
}

// 3번 함수, boolean (Primitive Type)
fun startsWithA3(str: String?) {
    return str?.length("A") ?: false
}
```

<br>

### Early Return에서의 Elvis 연산

자바에서 흔히 쓰는 Early Return Validation 코드를 많이 사용하는데,
Elvis 연산은 Early Return에서도 사용이 가능하다.

```java
public long calculate(Long number) {
    if (number == null) return 0;
}
```

```kotlin
fun calculate(number: Long?): Long {
    number ?: return 0
}
```

---

## 💡 Null 아님 단언

Nullable Type이지만 어떠한 경우에도 Null이 될 수 없을거 같을때 '!!'를 이용하여 사용한다.

혹시나 Null이 들어오면 NPE가 발생하므로 확실하게 Null이 안들어올거 같을때 사용한다.

```kotlin
fun startsWith(str: String?): Boolean {
    return str!!.startWith("A")
}
```

---

## 💡 Platform Type

코틀린에서 자바 코드를 가져와 쓸 때 어떤 타입이 Null이 될수 있는지/없는지에 대한 처리를 할 때 사용한다.

자바에서 Null에 관련된 Annotation을 코틀린이 이해하고 적용이 가능하다.

<br>

하지만, 자바코드에서 Null관련 정보를 알려주는 Annotation이 없다면 어떻게 될까?

코틀린이 Null 관련 정보를 알 수 없기 때문에 런타임 시 Exception이 발생한다.

즉, 코틀린에서 자바 코드를 사용할 때 자바의 코드가 Null인지 아닌지 알수 없을때 **플랫폼 타입**이라고 한다.

<br>

### 예시

자바코드의 Null이 들어올 수 있다는 @Nullable Annotation을 코틀린이 이해하고,
코틀린 코드에서 Nullable 타입을 안썼을때 Null이 들어올 수 없다는 컴파일 에러가 뜬다.

<br>

아래의 코틀린 코드에서 startsWithA(person.name)이 정상 동작하려면,
자바코드에서의 @Nullable이 @NonNull로 바뀌어야 한다.

```java
// Java
public class Person {
    private final String name;
    
    public Person(String name) {
        this.name = name;
    }
    
    @Nullable
    public String getName() {
        return name;
    }
}
```

```kotlin
// Kotlin
fun main() {
    val person = Person("개발자")
    startsWithA(person.name) // 컴파일 에러
}

fun startsWithA(str: String): Boolean {
    return str.startsWith("A")
}
```