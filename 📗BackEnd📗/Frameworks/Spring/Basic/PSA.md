## **💡 PSA (Portable Service Abstraction) 이란?**  

클라이언트가 추상화된 상위 클래스를 일관되게 바라보며 하위 클래스의 기능을 사용하는 것
↑ 일관된 서비스 추상화 (PSA)의 기본 개념
기능 접근방식을 일관되게 유지하면서 기술 자체를 유연하게 사용하는 것

<br>

서비스 추상화 다이어그램

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/PSA.png)  

<br>

**아이의 특징을 추상화한 코드 예시**

```java
public abstract class Child {
    protected String childType;
    protected double height;
    protected double weight;
    protected String bloodType;
    protected int age;

    protected abstract void smile();

    protected abstract void cry();

    protected abstract void sleep();

    protected abstract void eat();
}
```

<br>

### **핵심 포인트**

- 객체지향 프로그래밍 세계에서 어떤 클래스의 본질적인 특성만을 추출해서 **일반화** 하는것을 **추상화(Abstraction)**라고 한다.
- 클라이언트가 **추상화 된 상위 클래스를 일관되게 바라보며 하위 클래스의 기능을 사용하는 것이 바로 일관된 서비스 추상화(PSA)의 기본 개념이다.**
- 애플리케이션에서 특정 서비스를 이용할 때, **서비스의 기능을 접근하는 방식 자체를 일관되게 유지하면서 기술 자체를 유연하게 사용할 수 있도록 하는 것을 PSA(일관된 서비스 추상화)**라고 한다.
- PSA가 필요한 주된 이유는 **어떤 서비스를 이용하기 위한 접근 방식을 일관된 방식으로 유지함으로써 애플리케이션에서 사용하는 기술이 변경되더라도 최소한의 변경만으로 변경된 요구 사항을 반영하기 위함이다.**