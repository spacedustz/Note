## 📘 Spring Expression Language (SpEL)

Spring Data Redis와 Cache 기능을 사용하면서 `@Cacheable()`의 속성값으로 SpEL을  자주 사용하게 되어 정리해봅니다.

<br>

**SpEL 이란?**

**런타임 시** 객체에 대한 쿼리와 조작을 지원하는 강력한 표현 언어입니다. 

- SpEL 표현식은 `#` 기호로 시작하며 중괄호로 묶어서 표현합니다. `#{Expressions}`
- 속성 값을 참조할 땐 `$` 기호와 중괄호로 묶어서 표현합니다. `${prop.name}`
- ex) `#{${prop} + 2}` 

---

## 📘 연산자

> 📕 **산술 연산자**

```java
@Value("#{19 + 1}") // 20
private double add;

@Value("#{2 ^ 10}") // 1024
private double powerOf;

@Value("#{(2 + 2) * 2 + 9}") // 17
private double brackets;
```

<br>

> 📕 **관계 및 논리 연산자**

```java
@Value("#{1 == 1}") // true
private boolean equal;

@Value("#{!true}") // false
private boolean notTrue;
```

<br>

> 📕 **조건부(삼항) 연산자**

```java
@Value("#{some.property != null ? some.perperty : 'default'}")
private String ternary;

@Value("#{some.property != null ?: 'default'}") // 위와 동일하게 null인 경우 default 주입
private String elvis;
```

<br>

> 📕 **정규식(Regex) 표현법**

**matches**를 이용해 문자열에 정규식을 사용 가능합니다.

```java
@Value("#{'100' matches '\\d+'}") // true
private boolean validNumericStringResult;

@Value("#{'100asdf' matches '\\d+'}") // false
private boolean invalidNumericStringResult;
```

<br>

> 📕 **Spring Security 간단한 활용**

