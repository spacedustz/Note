## **💡 IoC (Inversion of Control)**  

1. 어플리케이션 흐름의 주도권을 Spring이 갖게 하는 것
2. 서버 컨테이너 기술, 디자인 패턴, 객체지향 설계 등에 적용

<br>

### **예시**

main() 메소드가 없는 서블릿 컨테이너에서 클라이언트의 요청이 들어올때마다

컨테이너 내의 컨테이너 로직(service() 메소드)이 서블릿을 직접 실행시키기 때문에 main()이 불필요함

이 경우, 서블릿 컨테이너가 서블릿을 제어하고 있기 때문에 어플리케이션의 주도권은 서블릿 컨테이너에 있다

서블릿과 웹 어플리케이션 간의 IoC(제어의 역전) 개념이 적용된 것

<br>

**그럼 스프링에는 이 IoC 개념이 어떻게 적용되어 있을까?**

답은 **DI (Dependency Injection) 의존성 주입**이다.

---

## **💡 Dependency Injection** 

IoC의 개념을 구체화 시킨 것

<br>

- MenuController 클래스는 클라이언트의 요청을 받는 endpoint 역할
- MenuService 클래스는 전달받은 클라이언트의 요청을 처리하는 역할
- 컨트롤러는 메뉴판의 메뉴목록을 조회하기 위해 서비스의 기능인 getMenuList()를 사용함
- 이 예시는 **의존관계**는 성립되었지만 **의존성 주입**은 이루어지지 않음

<br>

MenuController가 MenuService에 의존한 관계 예시

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Dependency_Injection_1.png) 

- 위의 의존관계에 비교하면, 위는 MemberController에서 MenuService의 객체를 직접 생성한 반면,
- 이 예시는 MenuController 생성자로 MenuService의 객체를 전달 받고 있음
- 주입엔 메소드,gettet / setter 주입 등 여러 방법이 있지만 이렇게 **생성자 주입**을 통한걸 **의존성 주입**이라고 함
- 의존성 주입엔 왠만하면 **생성자 주입**으로만 하는걸 추천한다

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Dependency_Injection_2.png) 

------

### **왜 의존성 주입이 필요할까**

- 현재 클래스 내부에서 외부 클래스의 객체를 생성하기 위해 **new 연산자** 를 쓸지 말지 여부 결정
- new를 이용해 객체 생성하면 객체지향 설계관점에서 문제 발생 가능성
- **Reflection 기법을 이용해** Runtime시에 동적인 객체 생성도 가능
- **Stub =** 메소드가 호출되면 미리 준비된 데이터 응답, 고정된 데이터 = 멱등성 (idempotent)

<br>

### **new 연산자를 사용하여 객체 전달을 할 경우, 참조할 클래스 변경시 사용하는 모든 클래스를 변경해야함**

- 컨트롤러에 private MenuServiceStub menuService; 추가
- CafeClient에 MenuServiceStub menuService = new MenuServiceStub(): 추가
- MenuService를 MenuServiceStub으로 변경
- ↑ 위와 같이 할 시 모든 클래스를 일일이 변경해야하며, 강한 결합이라고도 부름
- 결론적으로 의존성 주입을 하더라도 느슨합 결합을 하여 변동사항에 동적으로 대처할 수 있어야함

<br>

### **느슨한 의존성 주입 방법 = 인터페이스 사용**

- 컨트롤러가 서비스를 직접적으로 의존하는게 아닌 인터페이스에 의존한 상태
- 컨트롤러는 서비스에 의존하지만 서비스의 구현체가 무엇인지 알 수 없고, 알 필요도 없다
- 왜냐면 컨트롤러 입장에선 메뉴 목록 데이터를 조회할 수 만 있으면 되니까
- 즉, 어떤 클래스가 인터페이스 같이 일반화된 구성요소에 의존할때, 느슨한 결합 이라고 불림
- 인터페이스 타입의 변수에 인터페이스의 구현 객체를 할당 하면 **업캐스팅**이라고 함

<br>

### **핵심 포인트**

- 애플리케이션 흐름의 주도권이 사용자에게 있지 않고, Framework이나 서블릿 컨테이너 등 외부에 있는 것 즉, 흐름의 주도권이 뒤바뀐 것을 **IoC(Inversion of Control)**라고 한다.

- **DI(Dependency Injection)**는 IoC 개념을 조금 구체화 시킨 것으로 객체 간의 관계를 느슨하게 해준다.

- 클래스 내부에서 다른 클래스의 객체를 생성하게 되면 두 클래스 간에 의존 관계가 성립하게 된다.

- 클래스 내부에서 new를 사용해 참조할 클래스의 객체를 직접 생성하지 않고, **생성자 등을 통해 외부에서 다른 클래스의 객체를 전달 받고 있다면 의존성 주입이 이루어 지고 있는 것**이다.

- new 키워드를 사용하여 객체를 생성할 때, 클래스 간에 **강하게 결합**(**Tight Coupling)**되어 있다고 한다.

- 어떤 클래스가 인터페이스 같이 일반화 된 구성 요소에 의존하고 있을 때, 클래스들 간에 **느슨하게 결합**(**Loose Coupling)**되어 있다고 한다.

- 객체들 간의 느슨한 결합은 요구 사항의 변경에 유연하게 대처할 수 있도록 해준다.

- 의존성 주입(DI)은 클래스들 간의 강한 결합을 느슨한 결합으로 만들어준다.

- Spring에서는 애플리케이션 코드에서 이루어지는 의존성 주입(DI)을 Spring에서 대신 해준다.

  

- 객체 지향 설계 원칙에서 DI와 관련된 설계 원칙을 찾아보자.

  - SOLID(객체 지향 설계 원칙): https://ko.wikipedia.org/wiki/SOLID[(객체지향_설계)](https://ko.wikipedia.org/wiki/SOLID_(객체_지향_설계))
  - SOLID 요약: [https://itvillage.tistory.com/entry/객체지향-설계-원칙-SOLID-원칙﻿](https://itvillage.tistory.com/entry/객체지향-설계-원칙-SOLID-원칙)