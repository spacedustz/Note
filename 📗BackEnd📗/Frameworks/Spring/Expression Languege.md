## 📘 Spring Expression Language (SpEL)

Spring Data Redis와 Cache 기능을 사용하면서 `@Cacheable()`의 속성값으로 SpEL을 자주 사용하게 되어 정리해봅니다.

<br>

**SpEL 이란?**

**런타임 시** 객체에 대한 쿼리와 조작을 지원하는 강력한 표현 언어입니다. 

- SpEL 표현식은 `#` 기호로 시작하며 중괄호로 묶어서 표현합니다. `#{Expressions}`
- 속성 값을 참조할 땐 `$` 기호와 중괄호로 묶어서 표현합니다. `${prop.name}`
- ex) `#{${prop} + 2}` 

---

## 📘 산술 연산자