## 💡 코틀린에서 상속을 다루는 법

목차

- 추상 클래스
- 인터페이스
- 클래스 상속 시 주의점
- 상속 관련 지시어
- 정리

---

## 💡 추상 클래스

코틀린은 상속 시 ' : ' 키워드를 사용하며, 상위 클래스의 생성바롤 바로 호출한다.

상속을 받으려면 'override' 키워드를 붙여주어야 한다.

자바와 코틀린 둘 모두 추상 클래스를 인스턴스화 할 수 없다.

<br>

Animal 이라는 추상 클래스를 구현한 Cat, Penguin 예시

```java
// Java
@Getter
public abstract class JavaAnimal {
    protected final String species;
    protected final int legCount;
    
    publuc JavaAnimal(String species, int legCount) {
        this.species = species;
        this.legCount = legCount;
    }
    
    abstract public void move();
}

// Cat
public class JavaCat extends JavaAnimal {
    public JavaCat(String species) {
        super(species, 4);
    }
    
    @Override
    public void move() {
        System.out.println("고양이");
    }
}

// Penguin
public final class JavaPenguin extends JavaAnimal {
    private final int wingCount;
    
    public JavaPenguin(String species) {
        super(species, 2);
        this.wingCount = 2;
    }
    
    @Override
    public void move() {
        System.out.println("펭귄");
    }
    
    @Override
    public int getLegCount() {
        return super.legCount + this.wingCount;
    }
}

```

<br>

```kotlin
//Kotlin
abstract data class Animal(
	protected val species: String,
	protected open val legCount: Int
) {
    abatract fun move()
}

// Cat
Class Cat(
species: String
): Animal(species, 4) {
    
    override fun move() {
        println("고양이")
    }
}

// Penguien
class Penguin(
    species: String
): Animal (species, 2) {
    private val wingCount: Int = 2
    
    override fun move() {
        println("펭귄")
    }
    
     override val legCount: Int get() = super.legCount + this.wingCount
}
```

---

## 💡 인터페이스

코틀린은 default 메서드가 없어도 인터페이스 구현이 가능하다.

상속과 마찬가지로 인터페이스 구현도 ' : '를 사용한다.

중복되는 인터페이스를 특정할 때  super<타입.함수 를 사용한다.

추상클래스와 마찬가지로 인터페이스도 자바, 코틀린 둘 모두 인스턴스화가 불가능하다.

Backing Filed가 없는 프로퍼티를  Interface 에 만들 수 있다.

<br>

Flyable 과 Swimmable을 구현한 Penguin 예시

```java
// Java
public interface JavaSwimable {
    default void act() {
        System.out.println("어푸 어푸");
    }
}

public interface JavaFlyable {
    default void ac() {
        System.out.println("파닥 파닥");
    }
}

public final class JavaPenguin 
    extends JavaAnimal 
    implements JavaFlyable, JavaSwimable {
    
    @Override
    public void act() {
        JavaSwimable.super.act();
        JavaFlyable.super.act();
    }
}
```

```kotlin
// Kotlin
interface Swimable {
    fun act() {
        println("어푸 어푸")
    }
}

interface Flyable {
    fun act() {
        println("파닥 파닥")
    }
}

class Penguin(
    species: String
): Animal(species, 2), Swimable, Flyable {
    
    override fun act() {
        super<Swimable>.act()
        super<Flyable>.act()
    }
}
```

---

## 💡 클래스 상속 시 주의점

상위 클래스를 설계할 때 생성자 또는 초기화 블럭에 있는 프로퍼티에 open 사용을 피하자.

<br>

```kotlin
open class BVase(
    open val number: Int = 100
) {
    init {
        println("Base Class")
        println(number)
    }
}

class Derived(
    override val number: Int
): Base(number) {
    init {
        println("Derived Class")
    }
}
```

---

## 💡 상속 관련 지시어

코틀린에서의 상속 관련 4가지 키워드

- final : override를 할 수 없게 함, default로 보이지 않게 존재한다.
- open : override를 열어준다.
- abstract : 반드시 override 해야한다.
- override : 상위 타입을 override 한다.

---

## 💡 정리

- 상속 & 구현을 할때 ' : ' 키워드를 사용한다.
- 상위 클래스 상속을 구현할 때 **생성자를 반드시 호출**해야 한다.
- override를 필수로 붙여야 한다.
- abstract 멤버가 아니면 기본적으로 override가 불가능하므로 open을 사용해야 한다.
- 상위 클래스의 생성자 또는 초기화 블럭에서 open 프로퍼티 사용을 지양하자.
