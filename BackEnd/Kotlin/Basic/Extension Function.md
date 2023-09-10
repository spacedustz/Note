## 💡 Extention Function

클래스에 상속하거나 디자인 패턴을 사용하지 않고 새로운 기능으로 클래스를 확장할 수 있는 기능이다.

이때, 추가적인 메서드를 구현하면 이를 **확장 함수**, 추가적인 프로퍼티면 **확장 프로퍼티**이다.

<br>

### **언제 확장 함수가 필요할까?**

자신이 만든 클래스의 경우 새로운 함수가 필요하면 그냥 추가하면 된다.

하지만 외부 라이브러리를 사용할때는 함수를 추가하기가 어렵거나 변경이 어렵다.

이 때 원하는 새로운 함수를 자유롭게 만들수 있는 기능이다.

<br>

즉, 기존 클래스에 메서드를 추가하는 것이며, 확장 함수는 static 메서드이다.

<br>

### 기본 구조

**Receiver Type**

- 확장의 대상이 될 클래스

**Receiver Object**

- 확장 함수의 내부 구현 시 this 키워드를 사용하여 Receiver Type이 가지고 있는
  public 인스턴스에 접근하는 객체이다.
- **this는 생략이 가능하다**.

**생성 방법**

- ReceiverType.ReceiverObject() 형식으로 생성한다.

<br>

### 특징

- 정적으로 바인딩 된다.
  - **정적 바인딩이란?** : 함수 호출 부분에 메모리 주소값을 저장하는 작업이,
    컴파일 시간에 행해지며 컴파일 이후 값이 변경되지 않는것을 의미한다.
- 보일러플레이트 코드를 줄일 수 있다.
- 상속이나 복잡한 디자인 패턴 없이 간단하게 클래스를 확장할 수 있다.
- static 메서드이며 클래스 밖에 선언되기 때문에 **오버라이딩이 불가능**하다.

<br>

아래 예시를 보자.

**open 키워드** : 부모 클래스에는 항상 open 키워드가 들어가야 하며, 
코틀린에서 open 키워드가 없는 클래스는 기본적으로 상속이 불가능한 final class 이다.

```kotlin
// 부모 클래스 Shape
open class Shape

// Rectangle 클래스가 Shape 클래스를 상속 받음.
class Rectangle : Shape()

// Shape 클래스의 확장 함수 getName()
fun Shape.getName() = "shape"

// Rectangle 클래스의 확장함수 getName
fun Rectangle.getName() = "rectangle"

// 확장함수 호출
fun printClassName(s : Shape){
    println(s.getName())
}

// 결과값 : shape
printClassName(Rectangle())
```

printClassName()에 Rectangle 타입의 인스턴스를 전달했지만 확장 함수는 정적 바인딩 되므로,
확장 함수 호출 부분에 저장되는 메모리 주소가 이미 컴파일 되는 시간에 결정되었다.

<br>

즉, 확장 함수 호출 부분인 s.getName() 부분에 이미 Shape 클래스의 확장 함수인,
getName() 함수의 메모리 주소가 들어있다.

<br>

결국 printClassName(Rectangle())로 호출하더라도 프로세서의 경우,
s.getName() 부분에 저장된 메모리 주소만을 알고있어 이 위치에 있는 코드를 실행한다.

<br>

**※ 함수나 프로퍼티의 이름이 겹치지 않도록 주의하며, Receiver Type의 멤버함수로**

**변수 타입, 파라미터 타입과 개수가 같은 함수가 있으면 무시된다.**

```kotlin
class Car {
    fun shape(str : String) {
        println("빨강")
    }
    
    fun num(int : Int) {
        println("1")
    }
}

// 함수명, 파라미터 타입이 같은 확장함수, 출력 불가능 (무시됨)
fun Car.shape(str : String) {
    println("노랑")
}

// 함수명은 같지만 파라미터 타입이 다르므로 출력이 가능하다.
fun Car.num(str : String) {
    println("2")
}

fun main() {
    Car().shape("A")
    Car().num(1)
    Car().num("B")
}

// 결과값
빨강
1
2
```

Car.shape(str : String)의 경우 멤버 함수인 shape()와 이름도 같고,
파라미터 타입도 같아서 출력되지 않는다.

<br>

하지만 Car.num(str : String)의 경우 함수명은 같지만 파라미터의 타입이 달라서 출력이 된다.

즉, 오버로딩이 된다.

<br>

### 예시

아래 예시는 MutableList의 두 인덱스의 값을 변경하는 swap() 확장 함수를 정의한다.

```kotlin
fun MutableList<Int>.swap(idx1: Int, idx2: Int) {
    val tmp = this[idx1] // this는 MutableList 클래스를 의미한다
    this[idx1] = this[idx2]
    this[idx2] = tmp
}

fun main() {
    val list = mutableListOf(1, 2, 3)
    list.swap(0, 2)
    print(list)
    
    // 결과값 : 3, 2, 1
}
```

<br>

Generic을 이용한 좀 더 유연한 확장 함수 정의

특정 타입만 사용하도록 확장 함수 정의를 할 수 있게도 가능하다.

```kotlin
fun<T> MutableList<T>.swap(idx1: Int, idx2: Int) {
    val tmp = this[idx1]
    this[idx1] = this[idx2]
    this[idx2] = tmp
}
```