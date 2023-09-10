## Spring AOP - Logging

관점 지향 프로그래밍.

어떤 로직을 핵심 기능과 부가 기능으로 나누고, 그걸 기준으로 각각 모듈화 한다.

이때 AOP는 부가 기능에 해당하며 비즈니스 로직을 수행하는 데 필요한 로깅, 보안, 트랜잭션 등 공통 적용 기능이다.

---

## Why?

기본 기능 구현이 끝난 후, 성능 최적화를 통해 프로젝트의 완성도를 높이고자 했다.

하지만 모든 로직에 적용하는건 시간 관계상 불가능 했고, 

로깅을 통해 API 요청 비율과 응답 속도를 남겨 이를 활용하여 우선적으로 적요알 메서드를 찾으려고 했다.

---

## @TimeTrace Annotation 생성

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface TimeTrace {
  /** Aspect에서 log.warn을 표시할 시간 기준 ms */
  int millis() default 50;
}
```

`@Target(ElementType.METHOD)`

- 사용자가 생성한 어노테이션이 적용될 타입을 메서드 레벨로 지정

`@Retention(RetentionPolicy.RUNTIME)`

- 생성한 어노테이션의 Life Cycle을 Runtime이 끝날 때까지 유지한다.

`int millis() default 50;`

- TimeTraceAspect 클래스의 doLogTime 메서드에서 사용한다.
- 메서드 소요시간이 default로 설정된 50보다 길면 log.warn을 띄움