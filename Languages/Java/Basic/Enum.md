## **💡 Enum (열거형)**

- 서로 연관된 상수들의 집합 (상수 = final 키워드를 통한 변하지 않는 값 선언)
- 상수명은 대문자로 하는것이 관례
- 상수 하나하나는 객체로 간주함
- 따로 값을 지정해주지 않으면 0부터 시작하는 int형 값 자동할당

<br>

### **기본 형식**

- enum 열거형이름 {상수명1, 상수명2 ...}
- enum Seasons {SPRING, SUMMER, FALL, WINTER}
- JDK1.5 이전버전에서는 Enum을 지원하지 않아 아래와 같은 전역변수를 상수로 선언하는 방식을 사용했다.

```java
public static final int SPRING = 1;
public static final int SUMMER = 2;
public static final int FALL   = 3;
public static final int WINTER = 4;

public static final int DJANGO  = 1;
public static final int SPRING  = 2; // 계절의 SPRING과 중복 발생!
public static final int NEST    = 3;
public static final int EXPRESS = 4;
```

<br>

위와 같이 상수를 선언하고, 상수명이 중복이 되면 컴파일 에러가 발생함

```java
interface Seasons {
	int SPRING = 1, SUMMER = 2, FALL = 3, WINTER = 4;
}

interface Frameworks {
	int DJANGO = 1, SPRING = 2, NEST = 3, EXPRESS = 4;
}
```

1차적인 해결법으로 위와 같이 인터페이스를 사용하여 상수구분을 함으로써 해결이 가능하지만,

타입 안정성이라는 새로운 문제가 생김

이외에도, 객체 생성을 통한 방법 외 여러가지가 있지만 switch문에 활용할 수 없는 등 여러 문제가 있다.

(switch 문은 사용자정의 타입이 호환이 안됨)

------

### **Enum을 활용한 상수 정의**

```java
enum Seasons { SPRING, SUMMER, FALL, WINTER }
enum Frameworks { DJANGO, SPRING, NEST, EXPRESS }
```

위와 같이 enum을 활용해 코드작성을 하면 앞선 문제들의 해결과 코드의 간결을 동시에 챙길수 있다

또한, switch문에서도 활용이 가능하다

<br>

switch문을 활용한 enum의 상수 정의

```java
enum Seasons {SPRING, SUMMER, FALL, WINTER}

public class Main {
    public static void main(String[] args) {
        Seasons seasons = Seasons.SPRING;
        switch (seasons) {
            case SPRING:
                System.out.println("봄");
                break;
            case SUMMER:
                System.out.println("여름");
                break;
            case FALL:
                System.out.println("가을");
                break;
            case WINTER:
                System.out.println("겨울");
                break;
        }
    }
}

//출력값 
봄
```

------

### **Enum에서 사용할 수 있는 Method**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java52.png)

<br>

```java
enum Level {
  LOW, // 0
  MEDIUM, // 1
  HIGH // 2
}

public class EnumTest {
    public static void main(String[] args) {
        Level level = Level.MEDIUM;

        Level[] allLevels = Level.values();
        for(Level x : allLevels) {
            System.out.printf("%s=%d%n", x.name(), x.ordinal());
        }

        Level findLevel = Level.valueOf("LOW");
        System.out.println(findLevel);
        System.out.println(Level.LOW == Level.valueOf("LOW"));

        switch(level) {
            case LOW:
                System.out.println("낮은 레벨");
                break;
            case MEDIUM:
                System.out.println("중간 레벨");
                break;
            case HIGH:
                System.out.println("높은 레벨");
                break;
        }
    }
}

//출력값
LOW=0
MEDIUM=1
HIGH=2
LOW
true
중간 레벨
```

위의 코드에서

values() = level에 정의된 모든 상수를 배열로 반환함

name() , ordinal() = values로 받은 배열의 각각 이름과 순서를 출력값으로 반환

valueOf() = 지정된 열거형에서 이름과 일치하는 열거형의 상수를 반환

ordinal = 객체의 순번(인덱스 번호) 리턴

<br>

**Java에서 열거형은 상수명의 중복,타입의 안정성, 보다 편리한 상수선언을 보장하며 switch문에서 동작가능** 