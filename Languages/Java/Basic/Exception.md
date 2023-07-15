## **💡 Exception**

프로그램의 비정상 종료 방지, 정상 실행상태 유지

<br>

모든 Exception의 최고 상위 클래스는 Exception 이며 일반예외와 실행예외로 나뉨

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java55.png)  

------

### **try - catch문 기본 형식**

```java
try {
    // 예외가 발생할 가능성이 있는 코드를 삽입
} 
catch (ExceptionType1 e1) {
    // ExceptionType1 유형의 예외 발생 시 실행할 코드
} 
catch (ExceptionType2 e2) {
    // ExceptionType2 유형의 예외 발생 시 실행할 코드
} 
finally {
    // finally 블럭은 옵셔널
    // 예외 발생 여부와 상관없이 항상 실행
}
```

<br>

**예시**

```java
public class RuntimeExceptionTest {

    public static void main(String[] args) {

        try {
            System.out.println("[소문자 알파벳을 대문자로 출력하는 프로그램]");
            printMyName(null); // (1) 예외 발생
            printMyName("abc"); // 이 코드는 실행되지 않고 catch 문으로 이동
        } 
        catch (ArithmeticException e) {
            System.out.println("ArithmeticException 발생!"); // (2) 첫 번째 catch문
        } 
        catch (NullPointerException e) { // (3) 두 번째 catch문
            System.out.println("NullPointerException 발생!"); 
            System.out.println("e.getMessage: " + e.getMessage()); // (4) 예외 정보를 얻는 방법 - 1
            System.out.println("e.toString: " + e.toString()); // (4) 예외 정보를 얻는 방법 - 2
            e.printStackTrace(); // (4) 예외 정보를 얻는 방법 - 3
        } 
        finally {
            System.out.println("[프로그램 종료]"); // (5) finally문
        }
    }

    static void printMyName(String str) {
        String upperCaseAlphabet = str.toUpperCase();
        System.out.println(upperCaseAlphabet);
    }
}

// 출력값
[소문자 알파벳을 대문자로 출력하는 프로그램]
NullPointerException 발생!
e.getMessage: null
e.toString: java.lang.NullPointerException
[프로그램 종료]
java.lang.NullPointerException
	at RuntimeExceptionTest.printMyName(RuntimeExceptionTest.java:20)
	at RuntimeExceptionTest.main(RuntimeExceptionTest.java:7)
```

------

### **예외 전가 (throws)**

- try - catch문 외에 예외를 호출한 곳으로 다시 예외를 떠넘김
- 이를 위해서는 메소드의 선언부 끝에 아래와 같이 throws 와 발생할 예외들을 쉼표로 구분하여 나열

```java
반환타입 메서드명(매개변수, ...) throws 예외클래스1, 예외클래스2, ... {
	...생략...
}
void ExampleMethod() throws Exception {
}
```

<br>

**예시**

```java
public class ThrowExceptionTest {

    public static void main(String[] args) {
        try {
            throwException();
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
    }

    static void throwException() throws ClassNotFoundException, NullPointerException {
        Class.forName("java.lang.StringX");
    }
}

//출력값
java.lang.StringX
```

<br>

```java
public class ThrowExceptionTest {

    public static void main(String[] args) {
        try {
            throwException();
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
    }

    static void throwException() throws ClassNotFoundException, NullPointerException {
        Class.forName("java.lang.StringX");
    }
}

//출력값
java.lang.StringX
```

------

### **의도적인 예외 발생 (throw)**

```java
public class ExceptionTest {

    public static void main(String[] args) {
        try {
            Exception intendedException = new Exception("의도된 예외 만들기");
            throw intendedException;
        } catch (Exception e) {
            System.out.println("고의로 예외 발생시키기 성공!");
        }
    }
    
}

//출력값
고의로 예외 발생시키기 성공!
```

