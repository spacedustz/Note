## **💡 컨테이너 설정**  

**가장 중요한 Annotation 2가지**

- @Configuration
- @Bean
- Method가 Spring Container에서 관리할 새 객체를 인스턴스화, 구성 및 초기화 하는걸 나타내는데 사용됨

<br>

 **AnnotationConfigApplicationContext 를 사용하여 스프링 컨테이너를 인스턴스화 하는 방법**

- ApplicationContext 구현은 아래와 같은 Annotation이 달린 클래스로 파라미터 전달 받음
  - @Configuration 클래스
  - @Component 클래스
  - JSR-330 Metadata
- **@Configuration 클래스가 입력으로 제공**되면 @Configuration 클래스 자체가 Bean 정의로 등록되고
  클래스 내에서 선언된 모든 @Bean 메소드도 Bean 정의로 등록됨

```java
public static void main(String[] args) {
    ApplicationContext ctx = new AnnotationConfigApplicationContext(DependencyConfig.class);
    MyService myService = ctx.getBean(MyService.class);
    myService.doStuff();
}
```

- **@Component 클래스와 JSR-330 클래스가 제공**되면 빈 정의로 등록되며 필요한 경우
  해당 클래스 내에서 @Autowired 또는 @Inject와 같은 DI 메타데이터가 사용되는 것으로 가정함
- @Autowired - MyServiceImpl, Dependency1, Dependency2에서 스프링 의존성 주입 애너테이션을 사용한 예제

```java
public static void main(String[] args) {
    ApplicationContext ctx = new AnnotationConfigApplicationContext(MyServiceImpl.class, Dependency1.class, Dependency2.class);
    MyService myService = ctx.getBean(MyService.class);
    myService.doStuff();
}
```

------

### **@Bean Annotation 사용**  

<br>

**@Bean은 Method-레벨 Annotation이며, <bean /> 에서 제공하는 일부 속성 지원**

- init-method
- destroy-method
- autowiring
- @Conriguration-annoted 또는 @Component-annoted 클래스에서 사용가능
- @Bean 이 사용된 Method는 빈을 구축하는데 필요한 의존성을 나타내는데에 매개 변수를 사용 가능

<br>

**Annotation 방식의 @Bean 선언**

```java
@Configuration
public class DependencyConfig {

    @Bean
    public TransferServiceImpl transferService() {
        return new TransferServiceImpl();
    }
}
```

------

### **@Configuration Annotation 사용**  

- 해당 객체가 bean definitions의 소스임을 나타내는 Annotation임
- @Bean-annoted 메소드를 통해 Bean 선언
- @Bean 메소드에 대한 호출을 사용해 Bean 사이의 의존성을 정의할 수도 있음

<br>

**Bean 간의 의존성 주입**

- beanOne은 생성자 주입을 통해 beanTwo에 대한 참조를 받는것처럼 간단하게 의존성을 가진다

```java
@Configuration
public class DependencyConfig {

    @Bean
    public BeanOne beanOne() {
        return new BeanOne(beanTwo());
    }

    @Bean
    public BeanTwo beanTwo() {
        return new BeanTwo();
```

<br>

**@Import Annotation**

- XML 파일 내에서 요소가 사용되는 것처럼 구성을 **모듈화**하는데 사용됨
- 다른 구성 클래스에서 @Bean definitions를 가져올 수 있음

```java
@Import(DependencyConfigA.class)
```

- 컨텍스트를 인스턴스화할때 A,B 둘 다가 아닌, A를 @import한 B만 제공하면 됨
- 즉, 컨테이너의 인스턴스를 단순화하는 Annotation이며, 많은 @Conriguration을 기억할 필요없이,
  하나의 클래스만 처리하면 됨
- 추가한 @Bean에 의존성 주입

------

## **💡 Component Scan**  

- DependencyConfig 등 @Configuration 설정이 된 파일이 있을 시 **아래 코드 추가 :**
  @ComponentScan(excludeFilters = @Filter(type = FilterType.ANNOTATION, classes = Configuration.class))
- @ComponentScan - @ComponentScan이 등록된 곳에서 @Component를 가져오기 위해 사용됨.
- @Autowired - 생성자 의존성 주입에 필요한 설정 정보 대신 의존관계 자동 주입을 해주게 됨.

<br>

### **basePackages**

탐색할 패키지의 시작위치 지정하고, 해당 패키지부터 하위 패키지 모두 탐색

<br>

- @ComponentScan()의 매개변수로 basePackages ="" 할당 가능
- 지정 안할시, @ComponentScan이 붙은 설정 정보 클래스의 패키지가 시작위치가 됨
  - **설정 정보 클래스의 위치를 프로젝트 최상단에 두고 패키지 위치는 지정하지 않는 방법이 가장 편할 수 있음**
- 스프링 부트를 사용하면 @SpringBootApplication 를 이 프로젝트 시작 루트 위치에 두는 것을 추천.
  - @SpringBootApplication에 @ComponentScan이 들어있음.

<br>

### **Component Scan 기본 대상**

- @Component : 컴포넌트 스캔에서 사용.
- @Controller & @RestController : 스프링 MVC 및 REST 전용 컨트롤러에서 사용.
- @Service : 스프링 비즈니스 로직에서 사용.
  - 특별한 처리를 하지 않는다.
  - 개발자들이 핵심 비즈니스 로직이 여기에 있다는 비즈니스 계층을 인식하는데 도움이 된다.
- @Repository : 스프링 데이터 접근 계층에서 사용.
  - 스프링 데이터 접근 계층으로 인식하고, 데이터 계층의 예외를 스프링 예외로 변환해준다.
- @Configuration : 스프링 설정 정보에서 사용.
  - 스프링 설정 정보로 인식하고, 스프링 빈이 싱글톤을 유지하도록 추가 처리를 한다.
- 해당 클래스의 소스 코드에는 @Component를 포함하고 있다.

<br>

### **필터**

- includeFilters : 컴포넌트 스캔 대상을 추가로 지정.
- excludeFilters : 컴포넌트 스캔에서 제외할 대상을 지정.
- **FilterType 옵션**
  - ANNOTATION: 기본값, 애너테이션으로 인식해서 동작.
  - ASSIGNABLE_TYPE: 지정한 타입과 자식 타입을 인식해서 동작.
  - ASPECTJ: AspectJ 패턴을 사용.
  - REGEX: 정규 표현식을 나타냄.
  - CUSTOM: TypeFilter라는 인터페이스를 구현해서 처리.