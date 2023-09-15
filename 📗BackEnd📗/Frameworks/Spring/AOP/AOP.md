## **💡 AOP (Aspect Oriented Programming) 란?**  

**어플리케이션에 필요한 기능 중 공통적으로 적용되는 공통 기능에 대한 관심과 관련됨**

<br>

**공통관심사항**
어플리케이션 전반에 걸쳐 공통으로 사용되는 기능들

<br>

**핵심관심사항**
어플리케이션의 주 목적을 달성하기 위한 핵심 로직에 대한 관심사

<br>

**커피 주문 어플리케이션 예시**

핵심관심사항 = 메뉴등록,주문기능

공통관심사항 = 어플리케이션 보안

<br>

**AOP가 필요한 이유**

- 코드의 간결성
- 객체 지향 설계 원칙에 맞는 코드 구현
- 코드의 재사용성

<br>

### **핵심 포인트**

- AOP(Aspect Oriented Programming)는 관심 지향 프로그래밍이다.
- AOP에서 의미하는 Aspect는 애플리케이션의 공통 관심사를 의미한다.
- 애플리케이션의 공통 관심사는 비즈니스 로직을 제외한 애플리케이션 전반에 걸쳐서 사용되는 공통 기능들을 의미한다.
- 애플리케이션 전반에 걸쳐서 사용되는 공통 기능에는 로깅, 보안, 트랜잭션, 모니터링, 트레이싱 등의 기능이 있다.
- AOP를 애플리케이션에 적용해서 다음과 같은 이점을 누릴 수 있다.
  - 코드의 간결성 유지
  - **객체 지향 설계 원칙**에 맞는 코드 구현
  - 코드의 재사용
- AOP로 적용 할만한 공통 기능에는 뭐가 있을지 생각

---

## **💡 AOP 활용**

관점 지향 프로그래밍

<br>

- Aspect를 사용하여 핵심 기능과 부가 기능을 분리하고 부가 기능을 어디에 적용할지 선택하는 기능
- OOP를 대체하기 위한 것이 아닌, OOP의 부족한 부분을 보조하는 목적으로 개발됨
  - 여러곳에 쓰이는 부가기능의 변경,삭제의 번거로움을 해소
- **Aspect** : 부가 기능을 정의한 코드인 어드바이스(Advice)와 어드바이스를 어디에 적용할지 결정하는
- 포인트컷(PointCut)을 합친 개념. (Advice + PointCut ⇒ Aspect)
- **핵심 기능**(Core Concerns) : 업무 로직을 포함하는 기능
  - 객체가 제공하는 **고유의 기능(업무 로직 등을 포함)**
- **부가 기능**(CROSS-CUTTING CONCERNS) : 핵심 기능을 도와주는 부가적인 기능
  - 핵심 기능을 보조하기 위해 제공되는 기능
  - 로그 추적 로직, 보안, 트랜잭션 기능 등이 있음
  - 단독으로 사용되지 않고 핵심 기능과 함께 사용

------

### **Join Point**  

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/AOP.png) 

- Spring AOP는 프록시 방식을 사용하므로 조인 포인트는 항상 **메소드 실행 지점으로 제한**
- 클래스 초기화, 객체 인스턴스화, 메소드 호출, 필드 접근, 예외 발생과 같은 실행 흐름에서의 특정 포인트를 의미
- 어플리케이션에 새로운 동작을 추가하기 위해 조인포인트에 관심 코드(aspect code)를 추가할 수 있음
- 횡단 관심은 조인포인트 전/후에 AOP에 의해 자동으로 추가됨

------

### **AOP 용어**

<br>

- Advice

  - 조인포인트에서 수행되는 코드를 의미

  - Aspect를 언제 핵심 코드에 적용할 지 정의

  - 전체 시스템 Aspect에 API호출 제공

  - 메소드 호출 전, 각 상세정보와 모든 메소드를 로그로 남기기 위해 메소드 시작 전 포인트 선택

  - 부가 기능에 해당함

    

- PointCut

  - Join Point 중 Advice가 적용될 위치 선별

  - AspectJ 표현식을 사용한 지정

  - 프록시를 사용하는 Spring AOP는 메소드 실행 지점만 PointCut으로 선별 가능

    

- Weaving

  - PointCut으로 결정한 타겟의 Join Point를 Advice에 적용, Advice를 핵심코드에 적용하는 것을 의미함

  - 핵심 기능 코드에 영향을 주지 않고 부가기능 추가 가능

  - AOP 적용을 위해 Aspect 객체에 연결한 상태임

    - 컴파일 타임(AspectJ Compiler)

    - 로드 타임

    - 런타임 (Spring AOP = Runtime / Proxy 방식)

      

- AOP Proxy

  - AOP 기능을 구현하기 위해 만든 Proxy 객체

  - Spring에서 AOP Proxy는 **JDK 동적 Proxy** 또는 **CGLIB Proxy**임

    

- Advisor

  - 하나의 Advice, 하나의 PointCut 으로 구성됨
  - Spring AOP 에서만 쓰는 용어

------

### **타입별 Advice**

<br>

#### **Advice 순서**

- Advice는 기본적으로 순서보장 X
- 순서를 지정하려면 @Aspect 적용 단위로 org.springframework.cokr.annotation.@Order Annotation을 적용해야함
  - **Advice 단위가 아닌 클래스 단위로 적용가능**
  - 하나의 Aspect에 여러 Advice가 존재하면 순서 보장 X
- **Aspect를 별도의 클래스로 분리**해야함

<br>

#### **Advice 종류**

<br>

**@Before**

- Join Point 실행 이전에 실행됨
- 타겟 메소드가 실행되기 전, 처리해야할 필요가 있는 부가기능을 호출하기 전, 공통기능 실행
- Before Advice를 구현한 메소드는 일반적으로 void 타입이며, 리턴값이 있더라도 Advice 적용과정에 영향 X
- **주의점.** 메소드에서 예외를 발생시킬 경우 대상 객체의 메소드 호출이 안됨
- 아래는 Before의 코드 예시

```java
@Before("hello.aop.order.aop.Pointcuts.orderAndService()")
public void doBefore(JoinPoint joinPoint) {
    log.info("[before] {}", joinPoint.getSignature());
}
```

<br>

**@AfterReturning**

- Join Point가 정상완료 된 후 실행
- 메소드가 예외 발생하지않고 실행된 이후 공통 기능 실행
- 코드 예시

```java
@AfterReturning(value = "hello.aop.order.aop.Pointcuts.orderAndService()", returning = "result")
public void doReturn(JoinPoint joinPoint, Object result) {
    log.info("[return] {} return={}", joinPoint.getSignature(), result);
}
```

<br>

**@After Throwing**

- 메소드가 예외를 던지는 경우 실행
- 메소드를 실행하는 도중 예외 발생 시 공통기능 실행
- 코드 예시

```java
@AfterThrowing(value = "hello.aop.order.aop.Pointcuts.orderAndService()", throwing = "ex")
public void doThrowing(JoinPoint joinPoint, Exception ex) {
    log.info("[ex] {} message={}", joinPoint.getSignature(), ex.getMessage());
}
```

<br>

**@After (finally)**

- Join Point의 동작과는 상관없이 실행
  - 예외 동작의 finally를 생각하면 됨
- 메소드 실행 후 공통기능 실행
- 일반적으로 리소스를 해제 하는데 사용

<br>

**@Around**

- 메소드 호출 전후에 수행되며 가장 강력한 Advice임
  - Joint Point 실행 여부 선택 = joinPoint.proceed()
  - 전달 값 변환 = joinPoint.proceed(args[])
  - 반환값 변환
  - 예외 변환
  - try ~ catch 문 처리
- 메소드 실행 전/후, 예외 발생 시점에 공통기능 실행
- Advice의 첫 파라미터는 ProceedingJoinPoint를 사용해야됨
- proceed()를 통해 대상 실행
-  proceed()를 여러 번 실행 가능

------

### **PointCut 표현식**  

- 관심 조인 포인트를 결정하므로 Advice가 실행되는 시기 제어가능
- AspectJ는 PointCut을 편리하게 표현하기 위한 특별한 표현식 제공 ex) @Pointcut("execution(* hello.aop.order..*(..))")

```java
@Pointcut("execution(* transfer(..))") // 포인트컷 표현식
private void anyOldTransfer() {} // 포인트컷 서명
```

<br>

#### **포인트컷 지시자의 종류**

| 종류        | 설명                                                         |
| ----------- | ------------------------------------------------------------ |
| execution   | 메서드 실행 조인트 포인트를 매칭한다. 스프링 AOP에서 가장 많이 사용하며, 기능도 복잡하다. (제일 많이 사용함) |
| within      | 특정 타입 내의 조인 포인트를 매칭한다.                       |
| args        | 인자가 주어진 타입의 인스턴스인 조인 포인트                  |
| this        | 스프링 빈 객체(스프링 AOP 프록시)를 대상으로 하는 조인 포인트 |
| target      | Target 객체(스프링 AOP 프록시가 가르키는 실제 대상)를 대상으로 하는 조인 포인트 |
| @target     | 실행 객체의 클래스에 주어진 타입의 애너테이션이 있는 조인 포인트 |
| @within     | 주어진 애너테이션이 있는 타입 내 조인 포인트                 |
| @annotation | 메서드가 주어니 애너테이션을 가지고 있는 조인 포인트를 매칭  |
| @args       | 전달된 실제 인수의 런타임 타입이 주어진 타입의 애너테이션을 갖는 조인 포인트 |
| bean        | 스프링 전용 포인트컷 지시자이고 빈의 이름으로 포인트컷을 지정한다. |

<br>

#### **PointCut 표현식 결합 (&&, ||, !)**

```java
@Pointcut("execution(public * *(..))")
private void anyPublicOperation() {} // (1)

@Pointcut("within(com.xyz.myapp.trading..*)")
private void inTrading() {} // (2)

@Pointcut("anyPublicOperation() && inTrading()")
private void tradingOperation() {} // (3)
```

- anyPublicOperation은 메서드 실행 조인 포인트가 공용 메서드의 실행을 나타내는 경우 일치
- in Trading 메서드 실행이 거래 모듈에 있는 경우에 일치
- tradingOperation은 메서드 실행이 거래 모듈의 공개 메서드를 나타내는 경우 일치

<br>

#### **일반적인 PointCut 표현식**

- 모든 공개 메서드 실행
  - execution(public * *(..))

<br>

- set 다음 이름으로 시작하는 모든 메서드 실행
  - execution(* set*(..))

<br>

- AccountService 인터페이스에 의해 정의된 모든 메소드의 실행
  - execution(* com.xyz.service.AccountService.*(..))

<br>

- service 패키지에 정의된 메서드 실행
  - execution(* com.xyz.service.*.*(..))

<br>

- 서비스 패키지 또는 해당 하위 패키지 중 하나에 정의된 메서드 실행
  - execution(* com.xyz.service..*.*(..))

<br>

- 서비스 패키지 내의 모든 조인 포인트 **(Spring AOP에서만 메서드 실행)**
  - within(com.xyz.service.*)

<br>

- 서비스 패키지 또는 하위 패키지 중 하나 내의 모든 조인 포인트 **(Spring AOP에서만 메서드 실행)**
  - within(com.xyz.service..*)

<br>

- AccountService 프록시가 인터페이스를 구현하는 모든 조인 포인트 **(Spring AOP에서만 메서드 실행)**
  - this(com.xyz.service.AccountService)

<br>

- AccountService 대상 객체가 인터페이스를 구현하는 모든 조인 포인트 **(Spring AOP에서만 메서드 실행)**
  - target(com.xyz.service.AccountService)

<br>

- 단일 매개변수를 사용하고 런타임에 전달된 인수가 Serializable과 같은 모든 조인 포인트 **(Spring AOP에서만 메소드 실행)**
  - args(java.io.Serializable)

<br>

- 대상 객체에 @Transactional 애너테이션이 있는 모든 조인 포인트 **(Spring AOP에서만 메서드 실행)**
  - @target(org.springframework.transaction.annotation.Transactional)

<br>

- 실행 메서드에 @Transactional 애너테이션이 있는 조인 포인트 **(Spring AOP에서만 메서드 실행)**
  - @annotation(org.springframework.transaction.annotation.Transactional)

<br>

- 단일 매개 변수를 사용하고 전달된 인수의 런타임 유형이 @Classified 애너테이션을 갖는 조인 포인트(Spring AOP에서만 메서드 실행)
  - @args(com.xyz.security.Classified)

<br>

- tradeService 라는 이름을 가진 스프링 빈의 모든 조인 포인트 **(Spring AOP에서만 메서드 실행)**
  - bean(tradeService)

<br>

- 와일드 표현식 *Service 라는 이름을 가진 스프링 빈의 모든 조인 포인트
  - bean(*Service)