## 💡 코틀린에서 연산자를 다루는법

목차

- 단항 & 산술연산자
- 비교연산자 / 동등 & 동일성
- 논리 & 특이한 연산자
- 연산자 오버로딩

---

## 💡 단항 연산자 / 산술 연산자

- 단항 : ++, --
- 산술 : +, -, *, /, %
- 산술 대입 : +=, -=, *=, /=, %=

---

## 💡 비교 연산자와 동등성 & 동일성

<br>

### 비교연산자

- 비교 : >, <, >=, <=
- 비교연산자를 사용하면 자동으로 **compareTo()**를 호출해준다.
- compareTo 메서드 : 더 작으면 양수, 같으면 0, 크면 음수 반환

```kotlin
// compareTo 예시
val money1 = JavaMoney(2_000L)
val money2 = JavaMoney(1_000L)

// 내부적으로 compareTo가 자동으로 호출된다.
if (money1 > money2) {
    println("Money1이 Money2보다 금액이 큽니다.")
}
```

<br>

### 동등성 & 동일성

- 자바에서 동일성은 '==', 동등성은 'equals'를 사용했었다.
- 코틀린에서는 동일성에 '===' 사용, 동등성에 '=='를 호출한다.
- '=='를 사용하면 간접적으로 equals를 호출해준다.

```kotlin
val money1 = JavaMoney(1_000L)
val money2 = money1
val money3 = JavaMoney(1_000L)

println(money1 === money2) // 동일성 (주소값) True
println(muney1 == money3) // 동등성 (결과값) True
```

---

## 💡 논리 연산자 / 코틀린의 특이한 연산자

<br>

### 논리 연산자

- 논리 : &&, ||, !
- 자바와 완전히 동일하며 Lazy 연산을 수행한다.

<br>

### 특이한 연산자

in, !in

- 컬렉션이나 범위에 포함되어 있다. / 포함되어 있지 않다.

```kotlin
println(1 in numbers)
```

<br>

a..b

- a부터 b까지의 범위 객체를 생성한다.

```kotlin
if (score in 0..100) {}
```

---

## 💡 연산자 오버로딩

코틀린은 특정 연산자의 역할을 함수로 정의할 수 있다.

연산자 오버로딩을 할때 **operator**라는 키워드를 사용하며 이미 정의된 함수를 새롭게 정의하면 된다.

<br>

### 이항 산술 연산 오버로딩

- 코틀린은 +,- 같은 산술 연산자를 오버로딩해서 사용 가능하다.
- 객체끼리 더하거나 뺄 때, 원하는 동작을 함수안에 구현하면 연산자를 통해 표현이 가능하다.
- 코틀린은 언어에서 미리 정해둔 연산자만 오버로딩할 수 있기 떄문에, 
  다른 언어와 비교해서 오버로딩 연산자를 정의하고 사용하는 것이 더 쉽고 편리하다.

| 식         | 함수 이름                            |
| ---------- | ------------------------------------ |
| **a \* b** | **times**                            |
| **a / b**  | **div**                              |
| **a % b**  | **mod (version 1.1 이상부터는 rem)** |
| **a + b**  | **plus**                             |
| **a - b**  | **minus**                            |

<br>

#### **예시**

**두 객체를 더하는 확장 함수 정의**

```kotlin
// 이항 산술 연산 오버로딩
data class Point(val x: Int, val y: Int) {
    // 연산자를 확장 함수로 정의
    operator fun plus(other: Point): Point {
        return Point(x + other.x, y + other.y)
    }
}

fun main() {
    val point1 = Point(10, 20)
    val point2 = Point(30, 40)

    // 결과값 : Point(x=40, y=60)
    println(point1 + point2)
}
```

<br>

**연산자를 정의할 때 두 파라미터가 같은 타입일 필요가 없다.**

```kotlin
/* ----- 두 파라미터의 타입이 서로 다른 확장 함수 정의 ----- */
operator fun Point.times(scale: Double) : Point {
    return Point( (x * scale).toInt(), (y * scale).toInt() )
}

fun main() {
    val point = Point(10, 20)
    
    // 결과값 : Point(x=15, y=30)
    println(point * 1.5)
}
```

<br>

**또한, 연산자 함수의 반환타입이 꼭 파라미터와 일치하지 않아도 된다.**

```kotlin
/* ----- 결과 타입이 피연산자 타입과 전혀 다른 연산자 정의 ----- */
operator fun Char.times(count: Int) : String {
    return this.toString().repeat(count)
}

fun main() {
    // 결과값 : AAA
    println('A' * 3)
}
```

---

### 단항  산술 연산자 오버로딩

이항 연산 오버로딩과 마찬가지로 미리 정해진 함수를 선언하면서 operator로 표시한다.

| 식       | 함수 이름  |
| -------- | ---------- |
| +a       | unaryPlus  |
| -a       | unaryMinus |
| !a       | not        |
| ++a, a++ | inc        |
| --a, a-- | dec        |

<br>

#### 예시

단항연산자는 파라미터가 없다.

```kotlin
operator fun Point.unaryMinus() : Point {
    // 각 좌표에 -(음수)를 취한 좌표 반환
    return Point(-x, -y)
}

fun main() {
    val point = Point(10, 20)
    
    // 결과값 : Point(x = -10, y = -20)
    println(-point)
}
```

<br>

"++" 와 "--" 의 경우 inc(), dec()만 구현해두면 알아서 전위/후위 증가/감소 연산을 해준다.

```kotlin
operator fun Int.inc() = this + 2

fun main() {
    var num = 0
    
    println(num++) // 0
    println(num)   // 2
    println(++num) // 4
}
```

---

## 💡 복합 대입 & 비교 연산자 오버로딩

<br>

### 복합 대입 연산자 오버로딩

"+=", "-=" 등의 연산자를 복합 대입 연산자라고 하며,
"+" 대응 함수인 plus와 같은 연산자를 오버로딩하면
코틀린은 그와 관련된 연산자인 "+=" 도 자동으로 구현해준다.

<br>

```kotlin
var point = Point(1, 2)
point += Point(3, 4) // point = point + Point(3, 4)와 동일하다

// 결과값
Point(x=4, x=6)
```

---

### 비교연산자 오버로딩 - 동등성 연산자 : equels

코틀린에선 모든 객체에 비교 연산을 수행하는 경우, 
equals나 compareTo를 호출해야 하는 자바와 달리
"==" 연산자를 직접 사용할 수 있어서 비교 코드가 더 간결하며 이해가 쉽다.

<br>

코틀린은 "==" 를 equals()로 컴파일하며, "!=" 역시 equals()를 사용하여,
결과 값을 not 처리하는 식으로 동작한다.

<br>

a == b 라는 코드는 내부에서 인자의 null 체크를 하므로,
다른 연산과 달리 null이 될 수 있는 값에도 적용할 수 있는 이유이다.

<br>

즉, a == b는 내부적으로 a?.equals(b) ?: (b == null)로 동작한다.

<br>

이경우 a가 null인지 판단해서 null이 아닌 경우만 a.equals(b)가 호출되고,
만약 a가 null이라면 b도 null인 경우에만 true가 반환된다.

```kotlin
class Point(val x: Int, val y: Int) {
    override fun equals(other: Any?): Boolean {
        return super.equals(other)
    }
}
```

equals() 함수 앞에 override가 붙은 이유는 Any에 정의된 함수이므로 오버라이딩해서 사용하자.

Any에 정의된 equals의 소스코드를 보면 equals() 함수에 operator가 명시되어 있다.

그렇기 때문에, 하위 클래스에서는 override를 해서 사용할 수 있지만,
Any가 최상위 객체이며 Any를 상속받는 equals()가 확장함수보다 우선순위가 높다.

그래서 사실상 확장 함수로 재정의해서 사용할 수가 없다.

---

### 비교연산자 오버로딩 - 순서 연산자 : compareTo

자바에서 정렬이나 최대/최소값을 비교하는 알고리즘에는 Comparable 인터페이스가 있다.

 이 CompareTo 메서드를 짧게 호출할 방법이 없어서 항상 object.compareTo()의 형태이다.

<br>

코틀린도 똑같이 Comparable 인터페이스를 지원하며, compareTo 메서드 호출의
convention을 제공하여 비교연산자(<, >, <=.,>=)는 compareTo 호출로 컴파일 된다.

<br>

즉, a >= b 코드는 a.compareTo(b) >= 0 으로 컴파일 된다.