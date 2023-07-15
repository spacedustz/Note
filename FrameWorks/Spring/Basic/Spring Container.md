## **💡 Spring Container**

Bean의 lifecycle 관리(Bean 생성,관리,제거 등)

<br>

Spring Framework의 핵심 개념이 필요한 이유를 이해할 수 있다.
Spring Framework에서 DI(의존성 주입)이 어떠한 방식으로 구현되는지 설명할 수 있다.
객체 지향 설계에서, AOP가 필요한 이유를 설명할 수 있다.
Spring Framework에서 AOP가 어떤 방식으로 구현되는지 설명할 수 있다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Container1.png) 

- ApplicationContext = Spring Container (interface), 다형성 적용
- XML, 애너테이션 기반의 자바 설정 클래스로 만들 수 있음
- 컨테이너는 개발자가 정의한 Bean을 객체로 만들어 관리하고 개발자가 필요로 할 때 제공
- 스프링 컨테이너를 통해 원하는 만큼 많은 객체를 가질 수 있음
- 의존성 주입을 통해 애플리케이션의 컴포넌트를 관리합니다.
  - 스프링 컨테이너는 서로 다른 빈을 연결해 애플리케이션의 빈을 연결하는 역할을 한다.
  - 개발자는 모듈 간에 의존 및 결합으로 인해 발생하는 문제로부터 자유로울 수 있다
  - 메서드가 언제, 어디서 호출되어야 하는지, 메서드를 호출하기 위해 필요한 매개 변수를 준비해서 전달 X
- 의존성을 낯추기 위해 Spring Container 사용 (낮은 결합도, 높은 캡슐화)

------

### **Spring Container 생성 과정**  

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Container2.png) 

- Configuration Metadata 사용
- 파라미터로 넘어온 설정 클래스 정보를 사용해 스프링 빈을 등록
- new AnnotationConfigApplicationContext(구성정보.class)로 스프링에 있는 @Bean의 메소드를 등록
- XML 기반으로 만드는 ClassPathXmlApplicationContext도 있음
- [애너테이션 기반 컨테이너 구성](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-annotation-config)
- 애너테이션 기반의 자바 설정 클래스로 Spring을 만드는 것을 의미함

```java
// Spring Container 생성
ApplicationContext applicationContext = new AnnotationConfigApplicationContext(DependencyConfig.class);
```

- 스프링 컨테이너를 만드는 다양한 방법은 ApplicationContext 인터페이스의 구현체임.
  - DependencyConfig.class 등의 구성 정보를 지정해줘서 스프링 컨테이너를 생성해야 함.
  - DependencyConfig에 있는 구성 정보를 통해서 스프링 컨테이너는 필요한 객체들을 생성하게 됨.
  - 어플리케이션 클래스는 구성 메타데이터와 결합되어 ApplicationContext 생성 및 초기화된 후,
    완전히 구성되고 실행 가능한 시스템 또는 어플리케이션을 갖게 됨.
- 스프링 빈 조회에서 상속관계가 있을 시 부모타입으로 조회하면 자식 타입도 함께 조회.
  - 모든 자바 객체의 최고 부모인 object타입으로 조회하면 모든 스프링 빈을 조회.
- **ApplicationContext Interface 구현체 확인**
  - Ctrl + N -> ApplicationContext
  - ApplicationContext Interface를 구현한 하위 클래스 목록이 뜸

------

### **Spring Container의 종류**

<br>

#### **BeanFactory**

- 스프링 컨테이너의 최상위 인터페이스.
- Bean을 등록,생성,조회,돌려주는 등 빈을 관리하는 역할.
- getBean() 메소드를 통해 빈을 인스턴스화.
- @Bean이 붙은 메소드의 명을 스프링 빈의 이름으로 사용해 빈 등록.

<br>

#### **ApplicationContext**

- BeanFactory의 기능을 **상속**받아 제공.
- 빈을 관리하고 검색하는 기능을 BeanFactory가 제공하고 그 외에 부가기능을 제공.
- 부가 기능 (참고)
  - MessageSource: 메세지 다국화를 위한 인터페이스
  - EnvironmentCapable: 개발, 운영 등 환경변수 등으로 나눠 처리하고, 애플리케이션 구동 시 필요한 정보들을 관리하기 위한 인터페이스
  - ApplicationEventPublisher: 이벤트 관련 기능을 제공하는 인터페이스
  - ResourceLoader: 파일, 클래스 패스, 외부 등 리소스를 편리하게 조회

<br>

#### **Container의 인스턴스화**

- ApplicationContext 생성자에 제공된 위치 경로 또는 경로는 컨테이너가 로컬 파일 시스템,
  Java CLASSPATH 등과 같은 다양한 **외부 리소스로부터 구성 메타데이터를 로드할 수 있도록 하는 리소스 문자열**.

```java
// Annotation
ApplicationContext context = new AnnotationConfigApplicationContext(DependencyConfig.class);

// XML
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");
```

------

## **💡 Bean**  

스프링 컨테이너에 의해 관리되는 재사용 소프트웨어 컴포넌트
즉, 스프링 컨테이너가 관리하는 자바 객체이며, 하나이상의 빈 관리

- 빈 = 인스턴스화된 객체
- 스프링 컨테이너에 등록된 객체를 의미함
- @Bean이 적힌 메소드를 모두 호출해서 반환된 객체를 컨테이너에 등록
- 클래스의 등록정보, getter/setter 메소드를 포함함
- 컨테이너에 사용되는 설정 metadata로 생성됨

<br>

### **Bean 접근 방법**

- getBean() 메소드로 호출해서 사용하면 안됨

```java
// create and configure beans
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");

// retrieve configured instance
PetStoreService service = context.getBean("memberRepository", memberRepository.class);

// use configured instance
List<String> userList = service.getUsernameList();
```

<br>

### **BeanDefinition**

- 스프링은 다양한 설정 형식을 BeanDefinition이라는 추상화 덕분에 지원 가능

<br>

### **BeanDefinition이 포함하는 메타데이터**

1. 패키지 수식 클래스 이름: 일반적으로 정의되는 빈의 실제 구현 클래스.

2. Bean 동작 구성 요소 - 컨테이너에서 Bean이 어떻게 동작해야 하는지 설명. (범위, 수명 주기 콜백 등)

3. Bean이 작업을 수행하는 데 필요한 다른 Bean에 대한 참조. 

4. 새로 만든 개체에 설정할 기타 구성 설정.

5. 메타데이터는 각 빈 정의를 구성하는 속성 집합으로 변환.propertyExplaind in ... 

   | Class                    | [링크](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-class) |
   | ------------------------ | ------------------------------------------------------------ |
   | Name                     | [링크](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-beanname) |
   | Scope                    | [링크](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes) |
   | Constructor arguments    | [링크](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-collaborators) |
   | Properties               | [링크](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-collaborators) |
   | Autowiring mode          | [링크](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-autowire) |
   | Lazy initialization mode | [링크](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-lazy-init) |
   | Initialization method    | [링크](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-lifecycle-initializingbean) |
   | Destruction method       | [링크](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-lifecycle-disposablebean) |

- BeanClassName : 생성할 빈의 클래스 명(자바 설정처럼 팩토리 역할의 빈을 사용하면 없음)
- factoryBeanName : 팩토리 역할의 빈을 사용할 경우 이름, 예) appConfig
- factoryMethodName : 빈을 생성할 팩토리 메서드 지정, 예) userService
- Scope : 싱글톤(기본값)
- lazyInit : 스프링 컨테이너를 생성할 때 빈을 생성하는 것이 아니라, 실제 빈을 사용할 때까지 최대한 생성을 지연처리 하는지 여부
- InitMethodName : 빈을 생성하고, 의존관계를 적용한 뒤에 호출되는 초기화 메서드 명
- DestoryMethodName : 빈의 생명주기가 끝나서 제거하기 직전에 호출되는 메서드 명
- Constructor arguments, Properties : 의존관계 주입에서 사용한다. (자바 설정처럼 팩터리 역할의 빈을 사용하면 없음)

------

### **Bean Scope**

빈이 영향을 미칠수 있는 범위

<br>

- 스프링은 6개의 Scope를 지원하며, 그중 개는 ApplicationContext를 사용하는 경우에만 사용 가능
- Bean은 여러 범위중 하나에 배치되도록 정의 가능
- 구성을 통해 생성되는 개체의 범위를 선택할 수 있기 때문에 강력&유연
- Custom 정의 범위 생성 가능
- Spring Default Bean Scope = Singleton Scope

| **Scope**   | **Description**                                              |
| ----------- | ------------------------------------------------------------ |
| singleton   | (Default) 각 Spring 컨테이너에 대한 단일 객체 인스턴스에 대한 단일 bean definition의 범위를 지정합니다. |
| prototype   | 스프링 컨테이너는 프로토타입 빈의 생성과 의존관계 주입까지만 관여하고 더는 관리하지 않는 매우 짧은 범위의 스코프이다. |
| request     | 웹 요청이 들어오고 나갈때 까지 유지되는 스코프이다.          |
| session     | 웹 세션이 생성되고 종료될 때 까지 유지되는 스코프이다.       |
| application | 웹의 서블릿 컨텍스와 같은 범위로 유지되는 스코프이다.        |
| websocket   | 단일 bean definition 범위를 WebSocket의 라이프사이클까지 확장합니다. Spring ApplicationContext의 컨텍스트에서만 유효합니다. |

------

## **💡 Singleton Scope**

클래스의 인스턴스가 딱 1개만 생성되는것을 보장하는 디자인 패턴
bean 하나에 하나씩 메타 정보가 생성되고, 스프링 컨테이너는 이런 메타 정보를 기반으로 스프링 빈을 생성

- 컨테이너의 시작과 동시에 생성되고, 컨테이너 종료시 까지 유지됨
- 하나의 공유 인스턴스만 관리함
  - private 생성자를 사용해 외부에서 임시로 new를 사용하지 못하게 해야함
- 해당 Bean Definition과 일치하는 ID를 가진 빈에 대한 모든 요청은 스프링 컨테이너에서 해당 특정 빈 인스턴스 반환
- 스프링 컨테이너 종료 시 소멸 메소드도 자동 실행

<br>

### **Singleton 정리**

- 싱글턴은 해당 빈의 인스턴스를 오직 하나만 생성해서 사용하는 것을 의미.
- 단일 인스턴스는 싱글톤 빈의 캐시에 저장.
- 이름이 정해진 빈에 대한 모든 요청과 참조는 캐시된 개체를 반환.
  - 싱글톤 스코프의 스프링 빈은 여러번 호출해도 모두 같은 인스턴스 참조 주소값을 가짐.

<br>

**작동 방식**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Singleton.png)

------

### **Singleton 실습**

<br>

### **스프링 없는 DI 컨테이너만 사용한 객체 생성**

SingletonTest 파일 생성을 만들어 테스트 한 결과 같은 memberService를 사용하지만 뒤에 붙은 주소값이 다르게 나옴

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Singleton2.png) 

<br>

### **Singleton 패턴 적용 코드**

Singleton Service 생성

테스트, 주소값이 이제 같다 / 같은 SingletonService를 사용하는 모든 객체는 같은 인스턴스를 바라보게 됨

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Singleton3.png) 

<br>

테스트, 주소값이 이제 같다 / 같은 SingletonService를 사용하는 모든 객체는 같은 인스턴스를 바라보게 됨

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Singleton4.png)

<br>

### **스프링 컨테이너에 등록하여 사용**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Singleton5.png) 

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Singleton6.png)

<br>

### **싱글톤 방식의 주의점**

- 싱글톤 방식은 여러 클라이언트가 하나의 객체 인스턴스를 공유하기 때문에 **싱글톤 객체는 무상태로 설계 해야함**
  - 특정 클라이언트가 값을 변경할 수 있으면 안됨.
  - 읽기만 가능해야 함.
  - 스프링 빈의 공유 값을 설정하면 장애가 발생할 수 밖에 없음.

<br>

### **핵심 포인트**

- 스프링 컨테이너에서 빈 스코프의 기본값은 싱글톤 스코프이다.
- 싱글톤 패턴을 사용할때 발생하는 문제점을 싱글톤 컨테이너로 해결할 수 있다.