## **💡 Static**

정적 클래스 멤버라고도 하며 인스턴스에 소속된게 아니라 클래스에 고정된 멤버이다.

따라서 클래스 로더가 클래스를 로딩해서 메서드 메모리 영역에 적재할 때 클래스 별로 관리된다.

<br>

즉, 클래스의 로딩이 끝나는 즉시 static 멤버의 사용이 가능하다.

Garbage Collector의 영향을 받지 않으며 Heap에 속하지 않다.

<br>

모든 객체에 메모리를 공유한다. **(중요)**

보통 Utils 함수를 만드는데 자주 사용 됨 **(공통화)**

정적 멤버가 아니면 인스턴스를 생성해야지만 호출을 할 수 있다.

프로그램 종료 시 까지 메모리가 할당된 채로 존재하기 때문에 Static을 너무 남발하게 되면 성능상 안좋다.



- Class Member라고 하며, Class Loader가 Class를 Loading해서 메서드 메모리 영역에
  적재할 때 클래스별로 관리된다
- static 키워드를 통해 생성된 정적멤버들은 PermGen & MetaSpace에 저장되며
  저장된 메모리는 모든 객체가 공유하며 하나의 멤버를 어디서든 참조할 수 있다
- 그러나, GC의 관리 영역 밖에 존재하여 프로그램 종료시까지 메모리가 할당된 채로 존재
  static을 많이 사용하면 시스템 성능에 악영향을 줄 수 있다
- 클래스의 멤버(필드,메소드,이너클래스)에 사용
- 키워드가 붙으면 정적멤버라고 부름
- 다시 강조하지만 static이 붙으면 클래스명.멤버명으로 인스턴스의 생성없이도 사용 가능

<br>

**Static 변수와 Instance 변수**

```java
public class CarTest {

  public static void main(String[] args) {
    System.out.println(Car.클래스변수);
    System.out.println(Car.인스턴스변수); // 참조에러

    Car.클래스메소드();
    Car.인스턴스메소드(); // 참조에러
// ↓ String 인스턴스변수 / static String 클래스변수 / void 인스턴스메소드 / static void 클래스메소드
    Car car1 = new Car();
    Car car2 = new Car();
  }
}

class Car {

  public String 인스턴스변수 = "나는 인스턴스 변수";
  public static String 클래스변수 = "나는 클래스 변수";

  public static void 클래스메소드() {
    System.out.println(인스턴스변수); 
   // ↑  non-static field(참조불가) 에러 why? 클래스메소드에서는 클래스변수 접근O / 인스턴스변수 접근 X
    System.out.println(클래스변수);
  }

  public void 인스턴스메소드() {
    System.out.println(인스턴스변수);
    System.out.println(클래스변수);
  }
}
```
