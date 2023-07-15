## **💡 Proxy**

em.find()

- DB를 통해서 실제 엔티티 조회

em.getReference()

- DB조회를 미루는 프록시 객체 조회

------

### **find() 와 getReference()**

find()를 했을땐 정상적인 select 쿼리가 나갔지만

getReference()를 했을때 getId를 조회를 하면 Select 쿼리가 안나간다.

왜냐하면 Member의 Id는 파라미터로 들어온 값을 사용하기 때문에 프록시 객체의 초기화가 안됨.

findMember2.getUsername()을 했을때 비로소 DB의 정보를 가져와야 하므로,

getUsername()을 했을떄 Select 쿼리가 나간다.

즉, 프록시 객체에 없는 정보를 호출하면 객체가 초기화 되면서 DB의 정보를 조회한다.

```java
// Member findMember1 = em.find(Member.class, member.getId());
Member findMember2 = em.getReference(Member.class, member.getId());

System.out.println("findMember2.Id = " + findMember2.getId());
System.out.println("findMember2.username = " + findMember2.getUsername());
```

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Proxy.png) 

------

### **특징**

- 처음 사용할 때 한번만 초기화한다.
- 프록시 객체는 실제 객체의 참조(target)를 보관한다.
- 실제 객체를 상속받아서 만들어진다.
- 실제 객체의 메서드를 호출한다.
- 프록시 객체를 초기화 할떄 실제 엔티티로 바뀌는 것이 아닌, 프록시 객체를 통해 실제 엔티티에 접근이 가능하다. (실제 엔티티로 바뀌는게 아님을 주의하자.)
- 타입 체크 시 주의해야 한다. == 비교 대신 instanceof 를 사용하자.

```java
Member member1 = new Member();
member1.setUsername("member1");
em.persist(member1);

Member member2 = new Member();
member2.setUsername("member2");
em.persist(member2);

Member m1 = em.find(Member.class, member1.getId());
Member m2 = em.getReference(Member.class, member2.getId());

System.out.println("m1 == m2 : " + (m1.getClass() == m2.getClass()));

// 실행 결과 false

/* ------------------------------------------- */
private static void Logic(Member m1, Member m2) {
    System.out.println("m1 == m2 : " + (m1 instanceof Member));
    System.out.println("m1 == m2 : " + (m2 instanceof Member));
}

// 실행 결과 true
```

- 영속성 컨텍스트에 이미 실제 객체가 있다면 프록시로 호출해도 실제 객체가 나온다.
  반대로, Reference로 먼저 조회하고 Find로 조회해도 프록시 객체가 나온다.

```java
Member member = new Member();

Member m1 = em.find(Member.class, member.getId());
System.out.println("m1 = " + m1.getClass());

Member m2 = em.getReference(Member.class, member.getId());
System.out.println("m2 = " + m2.getClass());

System.out.println("a == a : " + (m1 == m2));

// 실행 결과 둘 다 실제 객체가 나오고 true가 반환된다.
```

- 중요! 준영속 상태일 때 초기화하면 LazyInitializationException 예외 발생.
- 아래의 예시 외에도 트랜잭션이 끝난 후, Lazy 로딩으로 프록시를 조회할때도 발생한다.

```java
try {
    Member member1 = new Member();
    member.setUsername("member");
    em.persist(member);

    em.flush();
    em.clear();

    Member m1 = em.getReference(Member.class, member.getId());
    System.out.println("m1 = " + m1.getClass()); // 프록시 객체

    // 영속성 컨텍스트에서 m1을 관리대상에서 제외하거나 컨텍스트를 닫는다.
    em.detach(m1);
    em.close();
    em.clear();

    // 위의 3가지 경우에 의해 컨텍스트에 없거나 컨텍스트가 닫혔기 때문에 LazyInitializationException이 발생한다.
    m1.getUsername(); // 프록시 객체 초기화

} catch (Exception e) {
    tx.rollback();
    e.printStackTrace();

} finally {
    em.close();
}
```

------

### **초기화**

프록시 객체를 초기화 할 때, 실제 엔티티로 바뀌는것은 아니며, 초기화되면 프록시 객체를 통해 실제 엔티티에 접근이 가능한 구조이다.

```java
Member member = em.getReference(Member.class, "id1");
member.getName();
```

초기화 여부 확인

```java
PersistenceUnitUtil.isLoaded(Object entity);
// or
EntityManagerFactory emf = Persistence.createEntityManagerFactory("hello");
emf.getPersistenceUnitUtil.isLoaded(객체);
```

프록시 객체 확인

```java
entity.getClass().getName();
```

강제 초기화

참고: JPA 표준에서 강제 초기화는 없다. Hibernate가 제공하는것 일 뿐이다.
강제 호출: member.getName();

```java
Hibernate.initialize(entity);
```

------

## **💡 Fetch Type**

@ManyToOne, @OneToOne의 default Fetch 전략은 Eager이다.

@OneToMany, @ManyToMany의 default Fetch 전략은 Lazy이다.

<br>

### **활용**

모든 연관관계는 기본적으로 지연 로딩을 권장한다.

N+1 문제 발생 시 Fetch Join이나 Entity Graph 사용을 권장한다.

- 객체와 연관된 객체를 자주 함께 사용 -> Eager
- 객체와 연관된 객체를 가끔 사용 -> Lazy

<br>

### **Member를 조회할 때 Team도 함께 조회해야 할까?**

Member와 Team 엔티티가 있으며 Member N, Team 1로 N:1 관계를 예시로 든다.

Member 엔티티에서 @ManyToOne 에 FetchType을 Lazy로 설정했을 경우,

연관된 엔티티인 Team을 가져올때 프록시로 가져오게 되며, 실제 Team을 사용할 때 초기화가 된다.

<br>

**회원 & 팀 출력**

```java
public void printUserAndTeam(String memberId) {
    Member member = em.find(Member.class, memberId);
    Team team = member.getTeam();
    System.out.println("회원 이름:" + member.getUsername());
    System.out.println("소속 팀: " + team.getName());
}
```

**회원만 출력**

```java
public void printUser(String memberId) {
    Member member = em.find(Member.class, memberId);
    Team team = member.getTeam();
    System.out.println("회원 이름: " + member.getUsername());
}
```

------

## **💡 Cascade**

특정 엔티티를 영속 상태로 만들 때 연관된 엔티티도 함께 영속 상태로 만들고 싶을 때 사용

연관관계를 매핑하는 것과 아무 관련이 없는 옵션이다.

Parent, Child 양방향 연관관계이며 Cascade 옵션은 All이라는 가정하에,

Parent를 Persist하면 Child까지 같이 Persist 된다.

```java
Parent parent = new Parent();
Child ch1 = new Child();
Child ch2 = new Child();

parent.addChild(ch1);
parent.addChild(ch2);

em.persist(parent);
tx.commit();
```

<br>

Cascade Option의 종류

- ALL - 모두 적용
- PERSIST - 영속
- REMOVE - 삭제
- MERGE - 병합
- REFRESH - Refresh
- Detach - Detach

------

## **💡 Orphan**

상위 엔티티와 연관관계가 끊어진 하위 엔티티 (고아 객체)

참조가 제거된 엔티티는 다른곳에서 참조하지 않는 것으로 보고 삭제하는 기능

특정 엔티티가 개인 소유할 때나, 참조하는곳이 하나일때 사용해야 한다.

고아 객체 삭제 - orphanRemoval = true

```java
// Parennt Class
@OneToMany(mappedBy = "parent", cascade = CascadeType.ALL, orphanRemoval = true)
private List<Child> childList = new ArrayList<>();

// Child 컬렉션의 1번쨰 요소를 삭제
Parent parent1 = em.find(Parent.class, id);
parent1.getChild().remove(0);
DELETE FROM CHILD WHERE ID=?
```

<br>

### **Cascade 전이 + Orphan의 생명주기**

CascadeType.ALL + orphanRemovel=true 두 옵션을 모두 활성화 하면,
상위 엔티티를 통해 하위 엔티티의 생명주기를 관리할 수 있다.

도메인 주도 설계(DDD)의 Aggregate Root 개념을 구현할 때 유용하다.

스스로 생명주기를 관리하는 엔티티는 em.persist()로 영속화, em.remove()로 제거한다.