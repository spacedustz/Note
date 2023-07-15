## **💡 Spring Memo**

<br>

### **개념**

| **ApplicationContext**                                       | 스프링 컨테이너, AnnotationConfigApplicationContext의 상위 인터페이스 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **AnnotationConfigApplicationContext**                       | AnnotatedBeanDefinitionReader를 사용해서  AppConfig.class를 읽고 BeanDefinition을 생성함,  getBean() 등 더 많은 기능을 쓰려면 얘를 생성해야함 |
| 보통 ApplicationContext ac = new AnnotationConfigApplicationContext(); 로 선언해서 사용함 |                                                              |
| **Spring Bean**                                              | key,value 형태로 값 저장                                     |
| **Bean Definition**                                          | 스프링이 다양한 형태의 설정정보를 BeanDefinition으로 추상화해서 사용 |
| **실습에서 쓰는 빈 등록 방식**                               | Factory Method 방식                                          |

------

### **Class**

| **Assumptions**                                              | 특정 조건이 충족되는 경우에만 테스트를 실행하는데 사용       |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **Assertions**                                               | (junit.jupiter / assertj.core 두개의 클래스가 존재)          |
| 실습에서의 assertThat()은 assertj.core 클래스 import assertThrows를 사용할때는 junit클래스 import |                                                              |
| **MethodArgumentNotValidException**                          | 유효성 검증 실패 시 발생, getRejectedValue() , getFieldErrors() , getField() 등 보유 |
| **ConstraintViolationException**                             | URI에 유효하지 않은 변수 값을 전송할 경우 발생               |

------

### **Method**

| **assertThat()**                                             | (비교대상값, 비교대상로직이 담긴 Matcher)                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| assertThat Ex) assertThat(result, CoreMatchers.is(10)); assertThat(abc).isNotSameAs(bcd) |                                                              |
| **assertThrows()**                                           | (발생할 예외클래스의 class타입, 예외가 발생할 로직)          |
| assertThrows Ex) assertThrows(NoSuchBeanDefinitionException.class,         () -> ac.getBean("xxxxx", MemberService.class)); |                                                              |
| **getInstance()**                                            | 인스턴스 get                                                 |
| **getBean(빈이름, 타입)**                                    | 같은 타입의 스프링 빈이 둘 이상이면 오류 발생                |
| **getBeansofType()**                                         | 반환타입:Map, 해당 타입의 모든 빈을 조회 (Object.class)를 넣고 조회하면 모든 스프링 빈 조회 |
| **getRole()**                                                | 스프링 내부에서 사용하는 빈 구분                             |
| **getBeanDefinition()**                                      | Bean에 대한 meta data 정보들을 반환, 코드에서는 스프링이 내부에서 사용하는 빈을 getRole() 로 구분하기 위해 사용 |
| **getBeanDefinitionNames()**                                 | 스프링에 등록된 모든 빈 이름을 조회                          |
| **ROLE_APPLICATION**                                         | 일반적으로 사용자가 정의한 빈                                |
| **ROLE_INFRASTRUCTURE**                                      | 스프링이 내부에서 사용하는 빈                                |
| **afterPropertiesSet()**                                     | 스프링 컨테이너가 의존성 주입이 완료되면 초기화 메소드실행, **InitializingBean**의 구현체 |
| **destroy()**                                                | 빈 종료될때 disconnect() 실행, **DisposableBean**의 구현체   |

<br>

------

### **구조**

| **첫 클래스**            | 멤버선언 : private, 생성자, getter/setter                    |
| ------------------------ | ------------------------------------------------------------ |
| **등급**                 | enum                                                         |
| **인터페이스**           | void 기능                                                    |
| **구현체**               | 클래스에 @Component, 생성자에 @Autowired, 자기자신 private 타입; , @Override 메소드 구현 private final = 무조건 생성자에 값이 들어가야함 |
| **Custom Exception**     | enum, 내부 멤버변수에 @Getter, 생성자(int 발생할 HTTP코드번호, String 메시지) |
| **Controller**           | @RestController, @RequestMapping, @Validated, @Slf4j(logging) private final (연동할클래스+생성자주입) 엔티티객체를 응답으로 전송함으로써 역할 구분 해줘야함 |
| **Service**              | @Service , Entity 멤버를 이용하여 기능 구현 public ENTITY method_name(Entity entity) {  Entity method_name = entity;  return method_name; |
| **DTO**                  | **[ResponseDTO]** @Getter,Setter & @생성자, 필요한 Request에 대한 모든 멤버변수 보유  **[HTTP_REQUEST_TYPE + DTO]** Request에 따라 필요한 멤버변수 + getter & setter 필요에 따라 추가,valid설정 |
| **Entity**               | **@Getter&Setter + @Cons , 필요에 따라 멤버변수 추가**       |
| **Mapper(Interface)**    | @Mapper(componentModel=" ") Entity Dto(Dto dto) 를 통한 엔티티 -> Response 객체로 응답을 위한 매핑 정보 작성 후 구현체 생성 |
| **Exception**            | **[ErrorResponse] @Getter **필요에의한 구체적인 예외 행동 설정, 내부에 static class 만들어서 구현(@getter) ** [ErrorAdvice] @RestControllerAdvice , 예외 공통화 파일** public ErrorResponse Method_Name(처리할예외클래스 변수) {  final ErrorResponse 변수명 = ErrorResponse.of(변수.기능메소드)  return response; |
| **Repository (구현체X)** | extends crudRepository, 레포의 구현은 Spring Data JDBC에서 내부적으로 Java Reflection + Proxy 기능을 이용해 레포의 구현체 생성 |

<br>

| **테스트**      | @Test, @DisplayName, @Scope / static class = 테스트 설정정보 수동 등록 |
| --------------- | ------------------------------------------------------------ |
| **테스트 타입** | void                                                         |
| **선언부**      | assertThat() 검증, assrtThrows() 예외 발생 로직 테스트, ac.close() = 콜백 메소드 호출 |