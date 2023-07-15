## **💡 클래스**  


-   객체를 정의하는 틀 또는 설꼐도와 같은 의미
-   객체의 상태를 나타내는 필드 / 객체의 행동을 나타내는 메소드로 구성됨
-   하나의 클래스로부터 여러개의 인스턴스 (인스턴스==메모리에 할당된 객체); 생성 가능

<br>

### **클래스의 구성요소**

-   필드 : 클래스의 속성을 나타내는 변수
-   메소드 : 클래스의 기능을 나타내는 함수
-   생성자 : 클래스의 객체 생성
-   이너 클래스 : 클래스 내부의 클래스

<br>

### **클래스 예시**

**차(Car)**

-   설계도

**필드(field)**

-   car.modelName = "람보르기니"
-   car.modelYear = 2016
-   car.color = "주황색"
-   car.maxSpeed = 350

**메소드(method)**

-   car.accelerate()
-   car.brake()

**인스턴스 == 객체(instance)**

-   내 차(myCar) : 설계도에 의해 생산된 차량
-   친구 차(friendCar) : 설계도에 의해 생산된 또 다른 차량

---

## **💡 객체**  


-   속성(filed)과 객체(method) 로 정의
-   하나의 객체는 다양한 속성과 기능의 집합으로 이루어질 수 있음
-   이러한 속성과 기능은 이너클래스와 함께 객체의 멤버 라고 부름

<br>

### **예시**

**속성 :** 모델, 바퀴개수, 문개수, 색상 등

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java31.png) 

**기능 :** 시동, 가속, 정지 등

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java32.png) 

<br>

### **객체의 생성**

-   new 키워드를 사용하여 객체 생성, 생성후 포인트연산자 . 을 통해 해당 객체의 멤버에 접근 가능함

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java33.png) 

<br>

### **기본형식**

-   클래스명 참조\_변수명; // 인스턴스 참조를 위한 참조변수 선언
    -   ex) class Car

-   참조\_변수명 = new 생성자(); // 인스턴스 생성 후, 객체의 주소 -> 참조변수에 저장 
    -   ex) Car = new Car();

-   ※ 간편식 = 클래스명 참조\_변수명 = new 생성자();

<br>

### **Back단에서의 동작방식**

-   참조변수는 실제 데이터값을 저장 X , 실제 데이터가 위치해있는 힙 메모리의 주소를 저장하는 변수
-   즉, 객체를 생성한다는 것은 해당 객체를 힙메모리에 넣고 그 주소값을 참조변수에 저장 하는것과 동일함
-   간단히 말하면, 객체의 필드값은 객체내부에 있고 내부에있는 메소드는 클래스영역에 1개만 두고 공유함  

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java34.png) 

<br>

**객체 활용**

-   객체의 응용에서 중요한 부분은 포인트연산자 . 이며, 해당 위치에 있는 객체 내부를 보세요 라는 의미임

<br>

**CarTest Class 생성**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java35.png) 

<br>

**Car Class 생성**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java36.png) 

**Car 클래스**

-   model과 color의 속성을가지며 power(), accelerate(), stop()의 기능을 가지고 있음

**CarTest 클래스**

-   tesla 인스턴스를 생성해 Car 클래스에서 정의한 속성과 기능을 method를 이용해 출력

---

## **💡 필드**

-   클래스에 포함된 변수를 의미하며, 객체의 속성을 정의할때 사용함
-   자바는 클래스&인스턴스&지역 변수로 구분되는데, 필드는 클래스&인스턴스 변수임
-   위의 인스턴스&클래스 변수는 static 키워드의 유무로 구분 가능
-   static과 함께 선언된건 클래스변수, 그렇지 않은건 인스턴스 변수
-   위의 두가지 모두 해당되지 않을때는 메소드내에 포함된 모든 변수는 지역변수임

<br>

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java37.png)

<br>

**인스턴스 변수**

-   고유한 속성을 저장하기 위한 변수

**클래스 변수**

-   한 클래스에 생성된 모든 인스턴스들이 특정한 값을 공유해야 하는 경우 static 선언
-   클래스 변수는 인스턴스를 따로 생성안해도 클래스명.클래스변수명을 통해 사용가능

**지역 변수**

-   메소드 내에서만 선언되며 메소드 내 ( {} ) 블록 에서만 사용가능
-   ※ 지역변수와 다르게 필드변수는 자동으로 강제초기화가 됨

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java38.png)

---

## **💡 Method**  


-   특정 작업을 수행하는 일련의 명령문들의 집합 (클래스의 기능)
-   메소드 시그니처(머리) 메소드 바디(몸) 으로 구분할 수 있다

```java
public static int add(int x, int y) { // 메소드 시그니처

  int result = x + y; // 메소드 바디

  return result;
```

**※ 반환타입이 void 가 아닌경우는 전부 return문을 써야한다.**

<br>

**메소드 호출**

-    클래스의 멤버이므로 클래스 외부에서 메소드를 사용하기 위해서 먼저 인스턴스를 생성해야하고,   . 을통해 호출

 **메소드 오버로딩**

-   하나의 클래스 안에 같은 이름의 다수의 메소드 정의

 **오버로드 성립 조건**

-   같은 이름의 메소드명 사용
-   매개변수의 개수나 타입이 다르게 정의되어야 함

```java
public class Overloading {

  public static void main(String[] args) {
    Shape s = new Shape(); // 객체 생성
    s.area(); // 메소드 호출
    s.area(5);
    s.area(10,10);
    s.area(6.0, 12.0);
  }

class Shape {
  public void area() { // 메소드 오버로딩, 같은이름의 메소드 4개
    System.out.println("넓이");
  }

  public void area(int r) {
    System.out.println("원 넓이 = " + 3.14 * r * r);
  }

  public void area(int w, int l) {
    System.out.println("직사각형 넓이 = " + w * l);
  }

  public void area(double b, double h) {
    System.out.println("삼각형 넓이 = " + 0.5 * b & h);
  }
}
```

Overloading 클래스에서 오버로딩의 값을 정의하고

Shape 클래스에서 타입을 지정해줌



**출력값**

넓이

원 넓이 = 78.5

직사각형 넓이 = 100

삼각형 넓이 = 36.0