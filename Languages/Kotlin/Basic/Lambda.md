## 💡 코틀린에서 람다를 다루는 법

목차

- Java에서 람다를 다루기 위한 노력
- Kotlin에서의 Lambda
- Closure
- Try-With-Resources
- 정

---

## Java에서 람다를 다루기 위한 노력



과일 가게에서 특정 과일만 요구하는 코드 예시

- 만약 다른 종류의 과일을 같이 요구할때, 가격을 필터링 해야할때, 아래의 코드는 매우 비효율적인 코드이다.
- 파라미터를 늘리는 것도 좋지만 람다를 이용하는게 훨씬 깔끔하고 좋다.

```java
public calss Fruit {
    private final String name;
    private final int price;
    
    public Fruit(String name, int price) {
        this.name = name;
        this.price = price;
    }
    
    public String getName() { return name; }
    
    public int getPrice() {
        return price;
    }
    
    public static void main(String[] args) {
        
        List<Fruit> fruits = Arrays.asList(
        new Fruit("사과", 1_000),
        new Fruit("사과", 1_200),
        new Fruit("사과", 1_200),
        new Fruit("사과", 1_500),
        new Fruit("바나나", 3_000),
        new Fruit("바나나", 3_200),
        new Fruit("바나나", 2_500),
        new Fruit("수박", 10_000),
        );
        
        findFruits(fruits);
    }
    
    private List<Fruit> findFruits(List<Fruit> fruits, String name) {
        List<Fruit> apples = new ArrayList<>();
        
        for (Fruit fruit : fruits) {
            if (fruit.getName().equals(name)) {
                apples.add(fruit);
            }
        }
        return apples;
    }
}
```

<br>

개선된 코드

- 인터페이스의 파라미터로 익명 클래스인 FruitFilter를 받고있다.
- 함수를 호출할때 `filterFruits(fruits, new FruitFilter()) 익명 클래스를 넣어주면 된다.
- 생성한 익명 클래스 내에서 인터페이스의 메서드를 Override 하여, 
  Custom한 필터를 만들어 파라미터로 넘길 수 있다.

```java
public interface FruitFilter {
    boolean isSelected(Fruit fruit);
}

// 익명 클래스
filterFruits(fruits, new FruitFilter()) {
    @Override
    public boolean isSelected(Fruit fruit) {
        return Arrays.asList
            ("사과", "바나나").contains(fruit.getName()) 
            &&
            fruits.getPrice() > 5000;
    }
}

private List<Fruit> filterFruits(List<Fruit> fruits, FruitFilter filter) {
    List<Fruit> results = new ArrayList<>();
    
    for (Fruit fruit : fruits) {
        if (filter.isSelected(fruit)) {
            results.add(fruit);
        }
    }
    
    return results;
}
```

람다 사용으로 인해 간결해진 코

 ```java
 filterFruits(fruits, fruit -> fruit.getName().equals("사과"));
 ```

---

## Kotlin에서의 Lambda

- 코틀린에서는 함수가 그 자체로 값이 될 수 있다.
- 변수에 할당 할 수도, 파라미터로 넘길 수도 있다.
- 마지막 파라미터가 함수인 경우, 소괄호밖에 람를 사용 가능하다.

<br>

```kotlin
fun main() {
	val fruits = listOf(
        new Fruit("사과", 1_000),
        new Fruit("사과", 1_200),
        new Fruit("사과", 1_200),
        new Fruit("사과", 1_500),
        new Fruit("바나나", 3_000),
        new Fruit("바나나", 3_200),
        new Fruit("바나나", 2_500),
        new Fruit("수박", 10_000),
        )
    
    // 람다를 만드는 방법 1 - 함수 명이 없다
    val isApple: (Fruit) -> Boolean = fun(fruit: Fruit) {
        return fruit.name == "사과"
    }
    
    // 람다를 만드는 방법 2 - 함수 명이 없다
    val isApple2: (Fruit) -> Boolean = { fruit: Fruit -> fruit.name == "사과"}
    
    // 함수 호출
    isApple(fruits[0])
    // 명시적 함수 호출
    isApple.invoke(fruits[0])
    
    // isApple 함수를 넣어 호출
    filterFruits(fuirts, isApple)
    
    // isApple2 함수를 넣어 호출
    filterFruits(fruits) { it.name == "사과" }
}

// filter 함수 자체를 파라미터로 받아 사용
private fun filterFruits(fruits: List<Fruit>, filter: (Fruit) -> Boolean): List<Fruit> {
    val results = mutableListOf<Fruit>()
    
    for (fruit in fruits) {
        if (filter(fruit)) {
            results.add(fruit)
        }
    }
    return results
}
```

---

## Closure

람다 실행 시점에 참조하고 있는 변수들을 모두 가져와 사용 가능하게 만들어 준다.

람다를 일급 시민으로 간주할 수 있게 해준다.

<br>

**자바 코드 **

- 자바는 람다를 쓸 때 사용할 수 있는 변수에 제약이 있다.
- 확실한 final 변수가 아니면 사용이 불가능하다.

```java
String targetFruitName = "바나나";
targetFruitName = "수박";

// 컴파일 에러
filterFruits(fruits, (fruit) -> targetFruitName.equals(fruit.getName()));
```

<br>

**코틀린 코드**

- 코틀린에서는 아무런 문제 없이 동작한다.
- 람다가 시작하는 지점에 참조하고 있는 변수들을 모두 **포획**하여 그 정보를 가지고 있다.

```kotlin
var targetFruitName = "바나나"
targetFruitName = "수박"
filterFruits(fruits) { it.name = targetFruitName }
```

---

## Try-With-Resources

`T.use`부분은 Closeable 구현한 구현체인 T에 대한 확장함수이며, 파라미터로 람다를 받는다.

파라미터는 block이라는 이름을 가진 함수이며 이 block 함수는 T 타입을 받아서 R 타입을 반환한다.

즉, 람다를 받도록 만들어진 함수가 block 함수이다.

```kotlin
public inline fun <T: Closeable?, R> T.use(block: (T) -> R): R {}
```

<br>

```kotlin
fun readFile(path: String) {
    BufferedReader(FileReader(path)).use { reader -> pirntln(reader.readLine()) }
}
```

---

## 정리

함수는 Java에서 2급시민이지만, 코틀린에서는 1급시민이다.

때문에, 함수 자체를 변수에 넣을 수도 있고 파라미터로 전달할 수도 있다.

코틀린에서 함수 타입은 (파라미터 타입, ...) -> 반환타입 이었다.

<br>

 코틀린에서 람다는 두 가지 방법으로 만들 수 있고, { } 방법이 더 많이 사용된다.

함수를 호출하며, 마지막 파라미터인 람다를 쓸 때는 소괄호 밖으로 람다를 뺄 수 있다

<br>

코틀린에서 람다는 두 가지 방법으로 만들 수 있고, { } 방법이 더 많이 사용된다.

함수를 호출하며, 마지막 파라미터인 람다를 쓸 때는 소괄호 밖으로 람다를 뺄 수 있다.

람다의 마지막 expression 결과는 람다의 반환 값이다.

<br>

코틀린에서 람다는 두 가지 방법으로 만들 수 있고, { } 방법이 더 많이 사용된다.

함수를 호출하며, 마지막 파라미터인 람다를 쓸 때는 소괄호 밖으로 람다를 뺄 수 있다.

람다의 마지막 expression 결과는 람다의 반환 값이다.

코틀린에서는 Closure를 사용하여 non-final 변수도 람다에서 사용 할 수 있다
