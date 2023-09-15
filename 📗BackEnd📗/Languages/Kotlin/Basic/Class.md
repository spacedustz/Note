## 💡 코틀린에서 클래스를 다루는법

목차

- 클래스와 프로퍼티
- 생성자와 init
- Custom Getter/Setter
- Backing Field

---

## 💡 클래스와 프로퍼티

<br>

개명이 불가능한 국가에 거주하는 Person 클래스를 가진 자바 코드 예시이다.

현재로써는 name 변수를 초기화를 할 수 없어서 에러가 나므로 Getter/Setter를 생성해준다.

```java
// Java
public class Person {
    private final String name;
    private int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public String getName() {
        return name;
    }
    
    public int getAge() {
        return age;
    }
    
    public void setAge(int age) {
        this.age = age;
    }
}
```

<br>

코틀린에서는 필드만 만들면 Getter/Setter를 자동으로 만들어주며, constructor는 생략이 가능하다.

코틀린에서는 '.필드' 를 통해 Getter/Setter를 바로 호출 하며, 자바 클래스를 옮겨와도 동일하게 적용할 수 있다.

즉, 클래스의 생성자에 바로 변수를 선언할 수 있게 된다.

```kotlin
// Kotlin

// v1 - 이 코드에서 클래스의 필드 선언과 생성자를 동시에 선언할 수 있다.
class Person constructor(name: String, age: Int) {
    val name = name
    var age = age
}

// v2 - 필드 선언과 생성자 생략, '.필드' 를 통해 Getter/Setter를 바로 호출 한다.
class Person(val name: String, var age: Int)

// Getter, Setter 호출
fun main() {
    var person = Person("홍길동", 100)
    println(person.name)
    person.age = 10
    println(person.age)
}
```

---

## 💡 생성자와 init

- 클래스에 기본생성자가 아닌 생성자가 있으면 **주 생성자**라고 부른다.
- 추가적으로 생성하는 생성자는 **부 생성자**이다.
- 부 생성자는 최종적으로 주 생성자를 **this**로 호출을 해야하며, body를 가질 수 있다.
- 실제로 가장 마지막 생성자 호출 시, 역순으로 초기화 블럭 -> 1번쨰 생성자 ... 순으로 호출이 된다.

<br>

**보통 부 생성자를 만들기보다 Default Parameter를 쓰는게 더 편하다.**

어쩔수 없이 부 생성자를 써야 할 경우 정적 팩토리 메서드를 추천한다.

<br>

자바에서 클래스이 변수 검증로직은 보통 생성자에 넣지만,

코틀린에서는 클래스 초기화 시점에 검증로직을 추가하고 싶다면  init 이라는 초기화 블록을 사용할 수 있다.

코틀린에서 여러개의 생성자를 생성할 경우, 'constructor' 키워드를 사용해 만들어야 한다.

<br>

클래스가 생성되는 시점에 나이를 검증하는 예시

자바는 보통 생성자에 검증코드를 작성한다.

```java
// Java
public class Person {
    private final String name;
    private int age;
    
    public Person(String name, int age) {
        // 검증 로직 추가
        if (this.age <= 0) {
            throw new IllegalArgumentException(String.format("나이는 %s일 수 없습니다", age));
        }
        this.name = name;
        this.age = age;
    }
    
    public String getName() {
        return name;
    }
    
    public int getAge() {
        return age;
    }
    
    public void setAge(int age) {
        this.age = age;
    }
    
    // 생성자 1개 추가 생성
    public Person(String name) {
        this(name, 1);
    }
}
```

<br>

코틀린에서는 클래스 초기화 시점에 검증로직을 추가하고 싶다면  init 이라는 초기화 블록을 사용할 수 있다.

```kotlin
// Kotlin
class Person(val name: String, var age: Int) {
    
    // 클래스가 초기화되는 시점에 1번 호출되는 초기화 블록
    init {
        if (age <= 0) {
            throw IllegalArgumentException("나이는 ${age}일 수 없습니다.")
        }
    }
    
    // 생성자 1개 추가 생성
    constructor(name: String): this(name, 1)
}
```

---

## 💡 Custom Getter/Setter

함수를 만드는 대신 프로퍼티로 Custom Getter/Setter를 선언할 수 있다.

객체의 속성이면 Custom Getter를 이용하고 그렇지 않다면 함수로 만드는걸 추천한다.

Custom Getter를 사용하면 자기 자신의 변형도 가능하다.

Custom Getter를 만들때는 **'field' 키워드**를 사용한다.

<br>

성인인지 확인하는 함수 예시

 ```java
 // Java
 public boolean isAdult() {
     return this.age >= 20;
 }
 ```

<br>

```kotlin
// Kotlin
val isAdult: Boolean get() = this.age >= 20

class Person(
val name: String,
var age: Int
) {
    init {
        if (age <= 0) {
            throw IllegalArgumentException("나이는 $age일 수 없습니다.")
        }
    }
    
    val isAdult: Boolean
      get() = this.age >= 20
}


val name = name // 생성자에서 받은 name을 불변 프로퍼티에 바로 대입
  get() = field.uppercase() // name에 대한 Custom Getter 생성


// field라고 하지않고 name을 대입하게 되면 똑같이 무한루프가 발생한다.
var name = name
  set(value) {
      field = value.uppercase()
  }
```

---

## 💡 Backing Field

위의 예시 코드에서 name은 name에 대한 Custom Getter인 get()을 호출하고,
그 Custom Getter은 다시 name을 호출해 무한루프가 발생한다.

이러한 무한루프를 막기 위한 예약어인 'field' 키워드를 사용하여 자기 자신을 가리킨다.

<br>

**Name을 set하는 예시**

사실 Setter 자체를 안쓴다

```kotlin
var name: String = name
	set (value) {
        field = value.uppercase()
    }
```

