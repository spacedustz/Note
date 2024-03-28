## JPA - Index Hint 적용

특정 컬럼에 조회용 Index를 설정했는데 Index를 안타는 상황이 발생해서,

관계형 DB의 Optimizer Execution Plan을 개발자가 직접 제어할 수 있는 Hint를 Index에 적용하는 방법을 알아보았습니다.

JPA에서 JPQL 등을 짤떄 Index Hint는 지원이 안되서 Native Query or QueryDSL을 이용하는 2가지 방법 중

사용중인 QueryDSL에서 지원하는 JPASQLQuery를 이용해서 적용해 보겠습니다.

---
## QueryDSL의 JPASQLQuery를 이용한 방법

QueryDSL은 기본적으로 `JPASQLQuery`를 지원합니다.

JPASQLQuery는 Native SQL을 지원하는 클래스 입니다.

```java

```
