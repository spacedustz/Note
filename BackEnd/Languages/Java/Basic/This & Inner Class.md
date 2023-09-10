## **💡 This vs This()**

<br>

### **this**

- 인스턴스 자기 자신을 가리킴
- 참조변수를 통해 인스턴스의 멤버에 접근하는것처럼 this를통해 인스턴스 자신의 변수에 접근 가능함
- 인스턴스의 필드명과 지역변수를 구분하기 위한 용도

```java
Car(String model, String color, boolead inConvertible) {
  this.model = mode;
}
```

<br>

### **this()**

- 같은 클래스안에서 메소드끼리 서로 호출이 가능한것처럼, 생성자도 상호호출이 가능하며, 이를 위해 this() 를 사용함
- 반드시 첫 줄에 정의되어야함
- 즉, this()는 자신이 속한 클래스에서 다른 생성자를 호출 하는경우에 사용
- 예를 들면, 클래스명이 Car라면 클래스의 생성자를 호출하는것은 this()이며, 그 효과는 Car()과 같다

<br>

**this() 메소드의 동작조건**

- 반드시 생성자의 내부에서만 사용가능
- 반드시 생성자의 첫 줄에 위치해야 함

<br>

**ex)**

```java
public class Test {
    public static void main(String[] args) {
        Example example = new Example();
        Example example2 = new Example(5);
    }
}

class Example  {
    public Example() {
        System.out.println("Example의 기본 생성자 호출!");
    };

    public Example(int x) {
        this();
        System.out.println("Example의 두 번째 생성자 호출!");
    }
}

//Output
Example의 기본 생성자 호출!
Example의 기본 생성자 호출!  // this() 의 출력값임
Example의 두 번째 생성자 호출!
```

<br>

위의 예시 코드에서 Example 클래스는 매개변수가 없는 기본생성자, 다른하나는 int타입의 매개변수를 가진 생성자 보유.

2번째 생성자의 내부에 this() 메소드가 정의되어있음

2번째 생성자의 출력을 보면 this() 메소드로 인해 첫번째 생성자의 출력결과와 동일한 결과 후 2번째 출력결과가 나온다

------

## **💡 Inner Class**

클래스 내에 선언된 클래스

<br>

멤버 내부 클래스 = 인스턴스 내부 클래스 + 정적 내부 클래스

<br>

 **ex) 외부 클래스에 포함될 수 있는 3가지의 내부 클래스의 종류 (익명 내부클래스 제외)**

```java
class Outer { // 외부 클래스

class Inner { // 인스턴스 내부 클래스
}

static class StaticInner { // 정적 내부 클래스
}

void run() {
  class LocalInner { // 지역 내부 클래스
}
```



선언 위치에 따른 이너클래스의 구분

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java39.png) 

<br>

####  **인스턴스 내부 클래스**

- 객체 내부에 멤버의 형태로 존재하며, 외부 클래스의 모든 접근지정자의 멤버에 접근가능

<br>

**ex)**

```java
class Outer { //외부 클래스
    private int num = 1; //외부 클래스 인스턴스 변수
    private static int sNum = 2; // 외부 클래스 정적 변수

    private InClass inClass; // 내부 클래스 자료형 변수 선언

    public Outer() {
        inClass = new InClass(); //외부 클래스 생성자
    }

    class InClass { //인스턴스 내부 클래스
        int inNum = 10; // 내부 클래스의 인스턴스 변수

        void Test() {
            System.out.println("Outer num = " + num + "(외부 클래스의 인스턴스 변수)");
            System.out.println("Outer sNum = " + sNum + "(외부 클래스의 정적 변수)");
        }
    }

    public void testClass() {
        inClass.Test();
    }
}

public class Main {
    public static void main(String[] args) {
        Outer outer = new Outer();
        System.out.println("외부 클래스 사용하여 내부 클래스 기능 호출");
        outer.testClass(); // 내부 클래스 기능 호출
    }
}

// 출력값

외부 클래스 사용하여 내부 클래스 기능 호출
Outer num = 1(외부 클래스의 인스턴스 변수)
Outer sNum = 2(외부 클래스의 정적 변수)
```