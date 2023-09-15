## 💡 Final

- 재할당이 금지된 변수. 변수와 같이 선언-할당-사용이 가능하지만 재할당이 금지되어있음.
- 상수는 final이라는 키워드를 사용해 선언할 수 있으며, 관례적으로 대문자에 _를 넣어 구분하는 형태를 사용
- ex) final double CALCULATOR_PI = 3.14;

<br>

### **상수를 사용하는 이유**

- 프로그램이 실행되면서 값이 변하면 안되는 경우
- 코드의 가독성 높이기 위함 (값을 저장하고있는 상수명으로 값을 사용가능하기 때문)
- 코드 유지관리를 손쉽게

<br>

### 초기화 방법

1. 필드 선언 시 값 할당
2. 생성자로 초기화

<br>

### Final  Object

객체 변수에 final을 선언하면 그 변수에 다른 참조 값을 지정할 수 없다.

즉, 한번 생성된 final 객체는 같은 타입으로 생성이 불가능하고, 객체 자체는 변경이 불가능하지만
객체 내부 변수는 변경이 가능하다.

```java
@Getter
@Setter
class Company {
    String name = "회사명";
}

public class Final_Ex {
    public static void main(String[] args) {
        // 객체를 한번 생성하면 재생성 불가능
        final Company company = new Company();
        // 클래스의 필드는 변경이 가능하다
        company.setName("ex회사");
    }
}
```

<br>

### Final  Class

final 클래스는 상속이 불가능하지만 필드는 setter를 통해 변경이 가능하다.

```java
final class Company {
    String name = "회사명";
    
// final 클래스는 상속이 불가능하다
class Company_A extends Company {}
}
```

<br>

### Final  Method

메서드에 final을 사용하면 상속받은 부모 클래스의 final 메서드를 오버라이딩이 불가능하다.

자신이 만든 메서드를 변경 불가능하게 만들고 싶을때 사용된다.

```java
class Company {
    String name = "회사명";
    
    public final void print() {
        System.out.println("회사 이름은 :" + name + " 입니다");
    }
}

class Company_A extends Company {
    String name = "회사A";
    
    // 메서드 오버라이딩 불가능
    public void print() {}
}

```

<br>

### Final Parameter

```java
class Company {
    String name = "회사명";
    
    // name = "회사1" 이라고 가정하고, 파라미터로 받은 name 변수는 변경이 불가능하다
     public void setName(final String name) {
         this.name = name;
     }
}

class Final_Ex {
    public static void main(String[] args) {
        final Company company = new Company();
        company.setName("회사2"); // 변경 불가능
    }
}
```

