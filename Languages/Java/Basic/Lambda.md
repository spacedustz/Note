## **💡 Lambda**

- 함수형 프로그래밍을 지원하는 문법요소
- 메소드를 하나의 식(expression)으로 표현한 것으로 코드의 간결성,명확성을 목표로 함
- 익명의 객체이기 때문에 java의 문법요소를 해치지 않으면서 함수형 인터페이스를 사용가능함
- 기본적으로 **반환타입과 이름을 생략 가능**하며, **익명 함수(anonymous function)** 라고 불림

<br>

### **Lambda의 기본형식**

```java
//기존 메서드 표현 방식
void sayhello() {
	System.out.println("HELLO!")
}

//위의 코드를 람다식으로 표현한 식
() -> System.out.println("HELLO!")
```

<br>

### **메소드를 Lambda식으로 만드는 예시**

```java
int sum(int num1, int num2) {
	return num1 + num2;
}
```

↓↓↓↓↓

```java
(int num1, int num2) -> { // 반환타입과 메서드명 제거 + 화살표 추가
	return num1 + num2;
}
```

<br>

### **다른 예시**

```java
// 기존 방식
void example1() {
	System.out.println(5);
}

// 람다식
() -> {System.out.println(5);}
// 기존 방식
int example2() {
	return 10;
}

// 람다식
() -> {return 10;}
// 기존 방식
void example3(String str) {
	System.out.println(str);
}

// 람다식
(String str) -> {	System.out.println(str);}
```

<br>

**특정 조건이 충족되면 더욱 축약 가능**

메소드 바디에 실행문이 하나만 존재할 경우 중괄호 생략

```java
// 람다식
(int num1, int num2) -> {
	num1 + num2
}
(int num1, int num2) -> num1 + num2
```

<br>

**매개변수 타입을 유추할 수 있는 경우 매개변수 타입 생략**

```java
(num1, num2) -> num1 + num2
```

<br>

### **람다식 작성하기**

<br>

- 람다식은 익명함수답게 메서드에서 이름과 반환타입을 제거하고 매개변수 선언부와 몸통{} 사이에 ->를 추가한다
- 람다식에 선언된 매개변수의 타입은 추론이 가능한 경우는 `생략`이 가능하다
- 반환값이 있는 메서드의 경우 (반환타입이 void가 아닌 경우) return 문 대신 식으로 대신 할 수 있다
- 람다는 `문장`이 아닌 `식` 이므로 끝에 `;`를 붙이지 않는다
- 매개변수가 하나인 경우에는 `괄호()`를 생략할 수 있지만, 매개변수의 `타입`이 있다면 `괄호()`를 생략할 수 없다 마찬가지로 `괄호{}` 안의 문장이 한 문장일 경우 생략가능하며 문장의 끝에 `;`를 붙이지 않는다

```java
반환타입 메서드이름 (매개변수) {
	실행 문장;
}

↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓

// 반환 타입과 메서드 이름이 사라졌다

(매개변수) -> {
	실행 문장
}
```

예를 들어 두 값 중 큰 값을 반환하는 max 메서드를 보면 아래 코드처럼 된다

```java
int max(int a, int b) {
    return a > b ? a : b;
}

↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓

// 매개변수의 타입 추론으로 인한 타입 생략

(a, b) -> {
    return a > b ? a : b;
}
```

아래와 같이 선언된 매개변수가 하나뿐인 경우에는 괄호()를 생략할 수 있다

단, 매개변수의 타입이 있으면 괄호()를 생략할 수 없다

마찬가지로 `{}`도 한 문장이면 `{}`를 생략 가능하지만, 문장의 끝에 `;`를 붙이면 안된다

```java
(a) -> a * a      =>  a -> a * a // OK

(int a) -> a * a  =>  int a -> a * a // 에러, 타입이 있으면 괄호를 생략할 수 없다
    
(String name, int i) -> System.out.println(name + "=" + i); // 에러, ;을 붙이면 안됨
```

------

## **💡 함수형 인터페이스**

- Java에서 함수는 반드시 클래스 내부에 정의되어야 하기 때문에 독립적인 메소드가 존재할 수 없다
- Lambda 또한 객체이며, 이름이 없기 때문에 익명 클래스임
- 단 하나의 추상메소드만 선언될 수 있다
- (Lambda식 **:** 인터페이스의 메소드) 가 1:1로 매칭되어야 함

<br>

이 때, 람다식으로 정의된 익명 객체의 메서드를 어떻게 호출할 것인가?

예를 들어 한 람다식을 a 라는 참조 변수에 저장해보자

```java
타입 a = (int a, int b) -> a > b ? a : b // 참조변수의 타입은?
```

참조변수니까 클래스 or 인터페이스가 가능하며 람다식과 동등한 메서드가 정의되어 있는 것이어야 한다.

그래야만 참조변수로 익명 객체(람다식)의 메서드를 호출할 수 있다.

<br>

아래 코드 예시를 보자

```java
// 인터페이스
interface TestFunction {
    public abstract int max(int a, int b);
}

// 익명 클래스를 구현한 구현 객체
TestFunction a = 
    new TestFunction() {
    public int max(int a, int b) {
        return a > b ? a : b;
    }
}
int big = a.max(5, 3);

// 위의 익명 객체를 람다식으로 대체하여 메서드 호출
TestFunction a = (int a, int b) -> a > b ? a : b;
int big = a.max(5, 3);
```

이렇게 TestFunction 인터페이스를 구현한 익명 객체를 람다식으로 대체가 가능한 이유는,

람다식도 실제로는 익명 객체이고, 인터페이스를 구현한 익명 객체 메서드의

매개변수, 타입, 개수, 반환값이 일치하기 때문이다

<br>

그래서 인터페이스를 통해 람다식을 다루기로 결정되었으며

람다식을 다루기 위한 인터페이스를 `함수형 인터페이스`라고 부른다 (@FunctionalInterface 어노테이션 사용)

<br>

**단, 함수형 인터페이스는 오직 `하나의 추상 메서드`만 정의되어 있어야 한다는 제약이 있다.**

<br>

그래야 람다식과 인터페이스의 메서드가 1:1 매칭으로 연결될 수 있기 때문이다

반면에 static 메서드와 default 메서드의 개수에는 제약이 없다

<br>

위에서 봤던 sum() 예시를 다시 보면 sum()도 익명 클래스이다.
익명 클래스 = 객체의 선언&생성을 동시에 하여 고유한 객체로 여기며, 단 한번만 사용되는 일회용 클래스임

```java
// sum 메서드 람다식
(num1, num2) -> num1 + num2

// 람다식을 객체로 표현
new Object() {
	int sum(int num1, int num2) {
		return num1 + num1;
	}
}
```

위의 코드 예제에서 익명 객체를 생성하여 참조변수 obj 에 담아준다 하더라도
sum 메서드를 사용할 수 있는 방법이 없다.

이 같은 문제를 해결하기 위해 사용하는 자바의 문법 요소가 바로 자바의 함수형 인터페이스이다.

<br>

### **함수형 인터페이스의 적용**

```java
public class LamdaExample1 {
    public static void main(String[] args) {
		   /* Object obj = new Object() {
            int sum(int num1, int num2) {
                return num1 + num1;
            }
        };
			*/ 
		ExampleFunction exampleFunction = (num1, num2) -> num1 + num2
		System.out.println(exampleFunction.sum(10,15))
}

@FunctionalInterface // 컴파일러가 인터페이스가 바르게 정의되었는 지 확인할 수 있도록
interface ExampleFunction {
		public abstract int sum(int num1, int num2);
}

// 출력값
25
```

<br>

### **매개변수&리턴값이 없는 Lambda식**

매개변수 & 리턴값이 없는 추상메소드를 가진 함수형 인터페이스 예시

```java
@FunctionalInterface
public interface MyFunctionalInterface {
    public void accept();
}
```

↓↓↓↓↓

```java
MyFunctionalInterface example = () -> { ... };

// example.accept();
```

<br>

```java
public class MyFunctionalInterfaceExample {
	public static void main(String[] args) throws Exception {
		MyFunctionalInterface example;
		example = () -> {
			String str = "첫 번째 메서드 호출!";
			System.out.println(str);
		};
		example.accept();

		example = () -> System.out.println("두 번째 메서드 호출!");
		//실행문이 하나라면 중괄호 { }는 생략 가능
		example.accept();
	}
}

// 출력값
첫 번째 메서드 호출!
두 번째 메서드 호출!
```

<br>

### **매개변수가 있는 Lambda식**

```java
@FunctionalInterface
public interface MyFunctionalInterface {
    public void accept(int x);
}
```

↓↓↓↓↓

```java
public class MyFunctionalInterfaceExample {
    public static void main(String[] args) throws Exception {
        MyFunctionalInterface example;
        example = (x) -> {
            int result = x * 5;
            System.out.println(result);
        };
        example.accept(2);

        example = (x) -> System.out.println(x * 5);
        example.accept(2);
    }
}

// 출력값
10
10
```

<br>

### **리턴값이 있는 Lambda식**

```java
@FunctionalInterface
public interface MyFunctionalInterface {
    public int accept(int x, int y);
}
```

↓↓↓↓↓

```java
public class MyFunctionalInterfaceExample {
    public static void main(String[] args) throws Exception {
        MyFunctionalInterface example;
        example = (x, y) -> {
            int result = x + y;
            return result;
        };
        int result1 = example.accept(2, 5);
        System.out.println(result1);
        

        example = (x, y) -> { return x + y; };
        int result2 = example.accept(2, 5);
        System.out.println(result2);
       

	      example = (x, y) ->  x + y;
				// 실행문이 한 줄인 경우, 중괄호 {}와 return문 생략가능
        int result3 = example.accept(2, 5);
        System.out.println(result3);
       

        example = (x, y) -> sum(x, y);
				// 실행문이 한 줄인 경우, 중괄호 {}와 return문 생략가능
        int result4 = example.accept(2, 5);
        System.out.println(result4);
 
    }

    public static int sum(int x, int y){
        return x + y;
    }
}

//출력값
7
7
7
7
```

<br>

### **메소드 레퍼런스**

- 불필요한 매개변수 제거를 위해 사용
- 정적 & 인스턴스 메소드 & 생성자 참조 가능 

<br>

**정적 메소드 참조 방식**

```java
클래스 :: 메서드
```

<br>

**인스턴스 메소드 참조 방식 (객체 먼저 생성해야함)**

```java
참조 변수 :: 메서드
```

<br>

**생성자 참조 = 객체생성**

```java
클래스 :: new
```