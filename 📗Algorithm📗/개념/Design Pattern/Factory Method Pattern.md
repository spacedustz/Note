## 💡 Factory Method Pattern 

**Factory Method Pattern을 사용하는 이유**

- **객체 간 결합도** ↓ (유지보수성 증가, 불필요한 클래스 의존성 제거)
- 객체의 생성 처리를 서브 클래스로 분리&처리하도록 캡슐화 하는 패턴
- 특정 조건에 따라 객체를 다르게 생성해야 할 경우
- 서브 클래스(팩토리 클래스)에 객체 생성 위임

<br>

**객체 간 결합도란?**
클래스에 변경이 생겼을때 다른 클래스에 미치는 영향 (의존성)

------

### **Factory Method Pattern을 사용하지 않는 경우**

- 팩토리 메서드 패턴을 사용하지 않는 아래 코드의 문제점
  - 중복 코드의 발생
  - 객체 간 결합도 ↑

```java
/* ----------------팩토리 메서드 사용 X--------------- */

// abstract 클래스를 정의하여 캡슐화
public abstract class Source {
    
}

public class ProcessA extends Source {
    public A() {
        System.out.println("Process A 생성");
    }
}

public class ProcessB extends Source {
    public B() {
        System.out.println("Process B 생성");
    }
}

public class ProcessC extends Source {
    public C() {
        System.out.println("Process C 생성");
    }
}

// 문자열에 따른 클래스 생성의 분기 처리
public class NotFactory {
    public Source create(String source) {
        Source returnSource = null;
        
        switch (source) {
            case "A": returnSource = new ProcessA();
            case "B": returnSource = new ProcessB();
            case "C": returnSource = new ProcessC();
        }
    }
}

public class Client {
    public static void main(String[] args) {
        NotFactory non = new NotFactory();
        non.create("A");
        non.create("B");
    }
}
```

------

### **Factory Method Pattern 사용**

- 팩토리 메서드를 사용함으로 얻는 장점은 본문 상단에 명시함

```java
/* ----------------팩토리 메서드 사용 --------------- */

// 리팩터링 포인트 1. 팩토리 메서드로 객체 생성 위임
public class Factory {
    public Source create(String source) {
        Source returnSource = null;
        
        switch (source) {
            case "A": returnSource = new ProcessA(); break;
            case "B": returnSource = new ProcessB(); break;
            case "C": returnSource = new ProcessC(); break;
        }
        return returnSource;
    }
}

public class ProcessA extends Source {
    public A() {
        System.out.println("Process A 생성");
    }
}

public class ProcessB extends Source {
    public B() {
        System.out.println("Process B 생성");
    }
}

public class ProcessC extends Source {
    public C() {
        System.out.println("Process C 생성");
    }
}

// 리팩터링 포인트 2. 팩토리 메서드에서 생성한 객체 리턴
public class UseFactory {
    public Source create(String source) {
        Factory factory = new Factory();
        Source returnSource = factory.create(source);
        
        return returnSource;
    }
}

public class Client {
    public static void main(String[] args) {
        UseFactory use = new NotFactory();
        use.create("A");
        use.create("B");
    }
}
```