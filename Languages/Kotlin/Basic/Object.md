## 💡 코틀린에서 Object 키워드를 다루는 법

목차

- Companion Object
- Singleton
- Anonymous Class

---

## 💡 Companion Object

코틀린에서 Static 함수는 **companion object**(동반 객체)를 선언하여 사용한다.

하지만 자바의 Static과 **companion object**는 비슷해보이지만 근본적으로 다르다.

<br>

- conpanion object는 하나의 객체로 간주된다
- 이름을 붙일수도 있고 companiom 객체에 인터페이스 구현도 가능하다.
- conpanion에 유틸성 함수도 넣을 수 있지만 최상단 파일을 활용하는게 더 좋다.

<br>

**자바 코드 예시**

```java
// Java
public class JavaPerson {
    private static final int MIN_AGE = 1;
    
    public static JavaPerson newBaby(String name) {
        return new JavaPerson(name, MIN_AGE);
    }
    
    private String name;
    private int age;
    
    private JavaPerson(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

<br>

**코틀린 코드 예시**

static 변수인 MIN_AGE에 붙은 **const**는 상수인게 확실할때 사용하며,

기본타입과 String 타입에만 붙일 수 있다.

const 키워드를 안붙이면 런타임 시 변수가 할당되지만 붙이면 컴파일 시 변수가 할당된다.

<br>

companion에 Factory라는 이름을 부여하고 Log 인터페이스도 구현한 예시

```kotlin
// Kotlin
class Person private constructor(
    var name: String,
    var age: Int
) {
    companion object Factory : Log {
        private const val MIN_AGE = 1
        
        fun newBaby(name: String): Person {
            return Person(name, MIN_AGE)
        }
        
        override fun log() {
            println("대충 Log 인터페이스의 abstract 메서드 구현한 내용")
        }
    }
}
```

<br>

### Companion 호출

코틀린 코드에서 @JvmStatic Annotation을 쓰면 자바에서 static 처럼 바로 사용이 가능.

```kotlin
fun main() {
    // 이름이 없는 Companion 호출
	Person.Companion.newBaby("A")
    
    // Factory라는 이름이 있는 Companion 호출
    Person.Factory.newBaby("A")
}

```

---

## 💡 Singleton

코틀린에서 싱글톤은 너무 간단해서 설명할게 거의 없다.

그냥 **object**키워드만 붙여주면 싱글톤 객체가 생성되며 사용법은 자바와 같다.

<br>

**자바 코드 예시**

```java
public class JavaSingleton {
    private Java Singleton(){}
    private static final JavaSingleton INSTANCE = new JavaSingleTon();
    
    public static JavaSingleton getInstance() {
        return INSTANCE;
    }
}
```

<br>

**코틀린 코드 예시**

```kotlin
fun() {
    println(Singleton.a)
    Singleton.a += 10
    println(Singleton.a)
}

object Singleton {
    var a: Int = 0
}
```

---

## 💡 Anonymous Class

**익명클래스란?**

특정 인터페이스나 클래스를 상속받은 구현체를 일회성으로 사용할 때 쓰는 클래스

<br>



**자바 코드 예시**

자바의 익명 클래스 기본 구현 방법

```java
// 익명 클래스 기본 구현 방법
함수(new 구현객체) {
    @Override
    메서드 구현(){}
}
```

Movable 인터페이스의 move(), fly()를 구현한 익명 클래스 구현 예시

```java
public static void main(String[] args) {
    moveSomething(new Movable() {
        @Override
        public void move() { System.out.println("움직인다."); }
        
        @Override
        public void fly() { System.out.println("난다."); }
    });
}

private static void moveSomething(Movable movable) {
    movable.move();
    movable.fly();
}
```

<br>

**코틀린 코드 예시**

위의 자바 예시를 그대로 코틀린으로 변환한 코드 예시

```kotlin
fun main() {
    moveSomething(
    	object : Movable {
            
            override fun move() {
                println("무브 무브")
            }
            
            override fun fly() {
                println("날다 날다")
            }
        }
    )
}

private fin moveSomething(Movable movable) {
    movable.move()
    movable.fly()
}
```

