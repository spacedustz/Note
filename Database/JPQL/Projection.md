## 💡 **프로젝션**

Select에 조회할 대상을 지정하는 것이다.

프로젝션의 대상은 엔티티, 임베디드 타입, 스칼라 타입(숫자, 문자 등 기본 데이터 타입)이다.

프로젝션 조회 대상은 전부 영속성 컨텍스트의 관리 대상이다.

<br>

### **엔티티 프로젝션(멤버 조회)**

- SELECT m FROM Member m ...
- 결과는 멤버가 조회된다.

<br>

### **엔티티 프로젝션(멤버 안에 있는 팀 조회)**

- SELECT m.team FROM Member m ...
- 결과는 멤버가 아닌 멤버의 팀이 결과로 조회된다.

```java
List<Team> result = 
    em.createQuery("select m.team from Member m", Team.class)
    .getResultList();

// --- 쿼리 튜닝의 편리함을 위해 명시적 Join 형식으로 Join을 하는걸 권장 --- //

List<Team> result =
    em.createQuery("select t from Member m join m.team t", Team.class)
    .getResultList();
```

<br>

### **임베디드(값 타입) 타입 프로젝션**

- SELECT o.address FROM Order o
- 엔티티의 값 타입을 조회한다.
- 임베디드 타입만으로 조회가 안되고 연관된 엔티티를 거쳐서 조회해야 한다.

```java
em.createQuery("select o.address from Order o", Address.class)
    .getResultList();
```

<br>

### **스칼라 타입 (기본 데이터 타입) 프로젝션**

- hibernate에서 지원을 해서 username, age로 쓸 수 있지만
- 공식적으로는 m.username, m.age로 접근해야 한다.
- SELECT m.username, m.age FROM Member m ...

```java
em.createQuery("select distinct m.username, m.age from Member m")
    .getResultList();
```

<br>

### **여러 값 조회**

- Query 타입, Object[] 타입  조회

```java
List resultList = em
    .createQuery("select distinct m.username, m.age from Member m")
    .getResultList();

// 여러 기본타입들의 타입 캐스팅, Object 배열로 변환
Object o = resultList.get(0);
Object[] result = (Object[]) o;
```

- new 명령어 조회
  - **단순 값을 DTO로 바로 조회** 한다.
  - new 패키지명, DTO를 넣고 생성자처럼 사용해서 DTO로 바로 반환 받을 수 있다.
    (패키지 명을 포함한 전체 클래스 명 입력 필요)
  - 순서와 타입이 일치하는 DTO 생성자 필요
  - SELECT new org.MemberDTO(m.username, m.age) FROM Member m ...
  - DISTINCT는 중복을 제거 한다.

```java
em.createQuery
("select new org.MemberDTO(m.username, m.age) from Member m", MemberDTO.class)
    .getResultList();
```

