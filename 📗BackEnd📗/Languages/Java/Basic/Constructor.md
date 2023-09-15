## **💡 생성자**

인스턴스 생성시 호출되는 인스턴스 변수 초기화 메서드  


-   이름은 반드시 클래스의 이름과 동일해야함
-   생성자 = 메소드
-   호출되는 시점 = 인스턴스 생성 시
-   목적 = 인스턴스 변수 초기화
-   리턴 타입이 아예 없음 (void와는 다른 동작방식)
-   오버로딩 가능

<br>

**기본 형식**

```java
클래스명(매개변수) { // 생성자 기본 구조 , 매개변수는 있을수도,없을수도 있음 

...
```

} 

<br>

**기본 생성자 vs 매개변수가 있는 생성자**

모든 클래스에는 반드시 하나 이상의 생성자가 존재해야함

<br>

**기본생성자**

매개변수가 없는 생성자를 의미한다

**ex)**

-   클래스명(){} // 기본생성자
-   DefaultConst(){} // 예시) DefaultConst 클래스의 기본생성자

<br>

**매개변수가 있는 생성자**

-   메소드처럼 매개변수 호출 시 해당 값을 받아 인스턴스를 초기화
-   고유한 특성의 인스턴스를 계속 생성해야 할 때 인스턴스마다 각각 다른 값을 가지고 초기화 가능

<br>

**ex) 인스턴스 생성 후 인스턴스의 필드값을 일일이 설정해줄 필요없이 생성과 동시에 값 설정 가능**

```java
public class ConstructorExample {
    public static void main(String[] args) {
        Car c = new Car("Model X", "빨간색", 250);

or Cat aru = new Cat(name: "아루", age: 10);
        System.out.println("제 차는 " + c.getModelName() + "이고, 컬러는 " +  c.getColor() + "입니다.");    }
}

class Car {
    private String modelName;
    private String color;
    private int maxSpeed;

    public Car(String modelName, String color, int maxSpeed) {
        this.modelName = modelName;
        this.color = color;
        this.maxSpeed = maxSpeed;
    }

    public String getModelName() {
        return modelName;
    }

    public String getColor() {
        return color;
    }
}

//Output
제 차는 Model X이고, 컬러는 빨간색입니다.
```

<br>

### **생성자 오버로딩**

```java
public class ConstructorExample {
  public static void main(String[] args) {
    Constructor constructor1 = new Constructor();
    Constructor constructor2 = new Constructor("Hello World");
    Constructor constructor3 = new Constructor(5,10);
  }
}

class Constructor {
  Constructor() { // (1) 생성자 오버로딩
    System.out.println("1번 생성자");
  }

  Constructor(String str) { // (2) 생성자 오버로딩
    System.out.println("2번 생성자");
  }

  Constructor(int a, intb) { // (3) 생성자 오버로딩
    System.out.println("3번 생성자");
  }
}
```

