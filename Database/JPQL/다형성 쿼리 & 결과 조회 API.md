## 💡 다형성 쿼리

### Type

조회 대상을 특정 하위 클래스로 한정할 수 있다.



예를 들어서 Item이 상위클래스이고 Book, Movie, Song 등 하위 클래스들이 있다고 가정한다.

Item의 하위 클래스 중 Book, Movie만 조회해보자.

```java
String query = "select i from Item i where type(i) in (Book, Movie)";
```



### Treat (JPA 2.1)

- 자바의 타입 캐스팅과 유사하다.
- 상속 구조에서 부모 타입을 특정 자식 타입으로 다룰 때 사용한다.
- FROM, WHERE, SELECT(Hibernate 지원)를 사용한다.



부모 타입의 다운캐스팅 예시

```java
String query = "select i from Item i where treat(i as Book).auther = 'Kim'";
```

---

## 💡 **결과 조회 API**

- query.getResultList()
  - 결과가 하나 이상인 경우(컬렉션일 때), 리스트를 반환한다.
- query.getSingleResult() 
  - 결과가 정확히 하나, 단일 객체를 반환한다.(정확히 하나가 아니면 예외 발생)
  - 결과가 없을때 - NoResultException
  - 둘 이상일 때 - NonUniqueResultException
