## **💡 Generic**

타입을 추후에 지정할 수 있도록 일반화 해두는 것

<br>

### **예시**

**제네릭을 사용하지 않았을때 작성한 비효율적인 코드**

```java
class Basket {
    private String item;

    Basket(String item) {
        this.item = item;
    }

    public String getItem() {
        return item;
    }

    public void setItem(String item) {
        this.item = item;
    }
}
class BasketString { private String item; ... }
class BasketInteger { private int item; ... }
class BasketChar { private char item; ... }
class BasketDouble { private double item; ... }
```

<br>

하지만 아래 예시로 단 하나의 Basket 클래스 만으로
모든 타입의 데이터를 저장할 수 있는 인스턴스 생성가능

```java
class Basket<T> {
    private T item;

    public Basket(T item) {
        this.item = item;
    }

    public T getItem() {
        return item;
    }

    public void setItem(T item) {
        this.item = item;
    }
}
```

<br>

위의 Basket 클래스는 다음과 같이 인스턴스화도 가능하다

```java
Basket<String> basket1 = new Basket<String>("기타줄");
```

위의 코드는 "Basket 클래스 내의 T를 String으로 바꿔라" 라는 의미이기도 하며, 실행하면 타입<T>가 전부 String이 됨

------

### **Generic Class 정의**

- Generic이 사용된 클래스를 칭함
- 클래스 변수에는 타입 매개변수를 사용못함 ex) static T item1; // X

<br>

**기본 형식**

- class Basket<T> // 임의의 타입 매개변수 T 선언
- class Basket<T, V> // 임의의 타입매개변수 여러개 선언

<br>

**Generic Class 사용**

- 멤버를 구성하는 코드에 특정한 타입지정이 되지않은 클래스이므로, 제네릭을 인스턴스화를 할때 타입지정 해줘야함
- 단, 타입 매개변수에 치환될 타입으로 기본타입 지정 X , Wrapper Class O

```java
Basket<String>  basket1 = new Basket<String>("Hello");
Basket<Integer> basket2 = new Basket<Integer>(10);
Basket<Double>  basket3 = new Basket<Double>(3.14);
```

<br>

위의 코드에서 new Bastet<> 의내용은 생략 가능(참조변수의 타입으로 유추 가능하기 때문)

------

### **Generic Class 다형성 적용**

```java
class Flower { ... }
class Rose extends Flower { ... }
class RosePasta { ... }

class Basket<T> {
    private T item;

    public T getItem() {
        return item;
    }

    public void setItem(T item) {
        this.item = item;
    }
}

public static void main(String[] args) {
		Basket<Flower> flowerBasket = new Basket<>();
		flowerBasket.setItem(new Rose());      // 다형성 적용
		flowerBasket.setItem(new RosePasta()); // 에러
}
```

<br>

**제한된 Generic Class**

- 타입 매개변수를 선언할때 extends로 상속이 되면 상위클래스로 지정된 클래스의 하위 클래스만 지정하도록 제한
  - ex) class Basket<T extends Flower>
- 특정 클래스와 특정 인터페이스를 구현한 클래스만 타입으로 지정할 수 있도록 & 를 사용하여 제한
  - ex) class Basket<T extends Flower & Plant> // 무조건 클래스명을 먼저 써야함

```java
class Flower { ... }
class Rose extends Flower { ... }
class RosePasta { ... }

class Basket<T extends Flower> {
    private T item;
	
		...
}

public static void main(String[] args) {

		// 인스턴스화 
		Basket<Rose> roseBasket = new Basket<>();
		Basket<RosePasta> rosePastaBasket = new Basket<>(); // 에러
```

<br>

**Generic Method**

- 클래스 전체가 아닌 클래스 내부의 특정 메소드만 제네릭 선언
- 제네릭 클래스/메소드 는 서로 다른 타입의 매개변수로 간주
- static 메소드에서도 선언/사용 가능

```java
class Basket<T> {                        // 1 : 여기에서 선언한 타입 매개변수 T와 
		...
		public <T> void add(T element) { // 2 : 여기에서 선언한 타입 매개변수 T는 서로 다른 것입니다.
				...
		}
}
```

<br>

아래의 예시는 제네릭 메소드의 호출 방법이며 제네릭 메소드에서 선언한 타입매개변수의 구체적 타입이 지정됨

```java
Basket<String> basket = new Bakset<>(); // 위 예제의 1의 T가 String으로 지정됩니다. 
basket.<Integer>add(10);                // 위 예제의 2의 T가 Integer로 지정됩니다. 
basket.add(10);                         // 타입 지정을 생략할 수도 있습니다. 
```

------

## **💡 와일드카드**

- 일반적으로 extends 나 super를 조합하여 사용

<br>

**와일드카드 ex)**

```java
<? extends T>
<? super T>
```

<? extends T>는 와일드카드에 **상한 제한**을 두는 것으로서,

**T와 T를 상속받는 하위 클래스 타입만 타입 파라미터로 받을 수 있도록 지정**

<br>

반면, <? super T>는 와일드카드에 **하한 제한**을 두는 것으로, **T와 T의 상위 클래스만 타입 파라미터로 받도록 함**

<br>

참고로, **extends 및 super 키워드와 조합하지 않은 와일드카드(<?>)는 <? extends Object>와 같다**

즉, 모든 클래스 타입은 Object 클래스를 상속받으므로, 모든 클래스 타입을 타입 파라미터로 받을 수 있음을 의미

<br>

```java
class Phone {}

class IPhone extends Phone {}
class Galaxy extends Phone {}

class IPhone12Pro extends IPhone {}
class IPhoneXS extends IPhone {}

class S22 extends Galaxy {}
class ZFlip3 extends Galaxy {}

class User<T> {
		public T phone;

		public User(T phone) {
				this.phone = phone;
		}
}
```

<br>

위 코드의 상속 계층도

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java53.png) 

- call : 휴대폰의 기본적인 통화 기능으로, **모든 휴대폰에서** 사용할 수 있는 기능입니다.
  - → ? extends Phone으로 타입을 제한할 수 있습니다.
- faceI : 애플의 안면 인식 보안 기능으로, **아이폰만** 사용 가능합니다.
  - → ? extends IPhone으로 타입을 제한할 수 있습니다.
- samsungPay : 삼성 휴대폰의 결제 기능으로, **삼성 휴대폰에서만** 사용 가능합니다.
  - → ? extends Galaxy로 타입을 제한할 수 있습니다.
- recordVoice : 통화 녹음 기능을 일컬으며, **아이폰을 제외한 안드로이드 휴대폰에서만** 사용 가능합니다.
  - → ? super Galaxy로 타입을 제한할 수 있을 것으로 보입니다.

```java
class PhoneFunction {
    public static void call(User<? extends Phone> user) {
        System.out.println("-----------------------------");
        System.out.println("user.phone = " + user.phone.getClass().getSimpleName());
        System.out.println("모든 Phone은 통화를 할 수 있습니다.");
    }

    public static void faceId(User<? extends IPhone> user) {
        System.out.println("-----------------------------");
        System.out.println("user.phone = " + user.phone.getClass().getSimpleName());
        System.out.println("IPhone만 Face ID를 사용할 수 있습니다. ");
    }

    public static void samsungPay(User<? extends Galaxy> user) {
        System.out.println("-----------------------------");
        System.out.println("user.phone = " + user.phone.getClass().getSimpleName());
        System.out.println("Galaxy만 삼성 페이를 사용할 수 있습니다. ");
    }

    public static void recordVoice(User<? super Galaxy> user) {
        System.out.println("-----------------------------");
        System.out.println("user.phone = " + user.phone.getClass().getSimpleName());
        System.out.println("안드로이드 폰에서만 통화 녹음이 가능합니다. ");
    }
}
```

---

## **💡 Wrapper 클래스**  

- **값에 Null이 들어올 수 있을때 NPE를 방지하기 위해 많이 사용한다.**
- 프로그래밍을 하다보면 기본타입의 데이터를 객체로 표현해야 할 경우가 있는데 이때 사용함
- 자바의 모든 기본타입은 값은 갖는 객체생성이 가능하며, 이를 포장객체라고 부르며, 기본타입의 값을 내부에 두고 포장
- 래퍼 클래스로 감싸고 있는 기본타입 값은 외부에서 변경X, 값을 변경하려면 새로운 포장객체를 생성해야함

<br>

기본 타입에 대응하는 Wrapper 클래스의 종류

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java54.png)