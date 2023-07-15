## **💡 JPA (ORM) 사용이유**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/JPA.png) 



### **장점**

1. 객체지향적인 코드의 작성으로 DB의 데이터들과 매핑하여 개발의 생산성을 높여준다.
2. 유지보수성이 증대되며 엔티티들이 독립적으로 작성되어 있어 재활용성이 높다.
3. 매핑 정보가 명확하여 ERD에 대한 의존성을 낯출 수 있다.
4. DBMS에 대한 종속성이 줄어들고 많은 자료구조를 구현할 수 있다.
5. RDB의 와 객체의 패러다임 불일치 문제를 해결할 수 있고 영속성을 제공한다.
6. 기본적인 CRUD의 SQL 쿼리를 알아서 생성해서 처리해준다.

<br>

### **단점**

1. 완벽한 ORM으로만 서비스를 구현하기 어렵다.
2. 사용은 편하지만 설계는 신중히 해야하고 프로젝트의 복잡성이 올라갈수록 난이도가 올라간다.
3. 특정 자주 사용되는 대형 쿼리는 성능을 위해 SP를 쓰는 등 별도의 쿼리튜닝이 필요하다.

<br>

###  **패러다임의 불일치 란?**

- 상속
  - 객체는 상속이라는 개념이 존재한다.
  - 테이블은 상속의 개념이 없으므로 상속 관계의 객체를 저장 & 조회가 어렵다.
- 연관관계
  - 객체는 참조를 사용해서 다른 객체와 연관관계를 가지고 참조에 접근해서 조회한다.
  - 테이블은 외래키를 사용해서 다른 테이블과 연관관계를 가지고 조인을 사용해서 조회한다.
- 객체 그래프 탐색
  - 객체 A가 있고 A를 참조하는 B,C 객체를 A를 통해 참조하는 것이 그래프 탐색이다.
  - SQL을 직접 다루면 SQL에 따라 객체 그래프 어디까지 탐색할 수 있는지 정해진다.
  - 예를 들어 SQL이 B와 C까지만 조회하는 SQL이라면 B나 C까지만 참조할 수 있다.
  - 결국 어디까지 탐색이 가능한지 알아보려면 DAO를 열어서 SQL을 직접 확인해야 한다.
  - 즉, 이 기능은 연관된 객체를 사용하는 시점에만 실행하기 떄문에 지연로딩 이라고도 한다.
- 비교
  - 객체는 동등성, 동일성 비교가 모두 가능하다.
  - DB는 같은 행을 조회해도 객체의 동일성 비교에 실패한다.
  - JPA는 같은 트랜잭션일 때 같은 객체가 조회되는것을 보장한다.
- SQL을 직접 사용하면?
  - SQL과 JDBC API를 사용해서 변환 작업을 직접 해줘야 한다.

<br>

### **JPA 란?**

- 객체와 테이블의 패러다임 불일치 해결을 위한 영속성(Persistence) **ORM 프레임워크**
- Persistence Context에 객체와 DB테이블의 매핑정보를 저장.
- 이렇게 보관된 엔티티정보는 DB 테이블에 CRUD를 위해 사용됨.

<br>

### **동작원리 요약**

- begin() 트랜잭션 시작
- 객체를 persist로 영속성 컨텍스트에 저장하면 (1차캐시, 지연sql저장소에 등록)
- commit을 하면 지연 sql 저장소에 자동으로 변환되있던 (대기중인) sql문 실행으로 인해 db 등록
- 수정 - setter 사용
- 제거 - remove() 사용 (DB가 아닌 영속성 컨텍스트에서 제거)

```java
//i 1. 영속성 컨텍스트에만 엔티티 저장

    private void example01() { //i ex01
        Member member = new Member("hgd@gmail.com");
        em.persist(member);

        Member resultMember = em.find(Member.class, 1L);
        System.out.println("id: " + resultMember.getMemberId()
                + ", email: " +resultMember.getEmail());
    }

//i 2. 영속성컨텍스트에 저장된 엔티티 DB 테이블에 저장

    private void example02() {
        tx.begin();
        Member member = new Member("hgd@gmail.com");
        em.persist(member);
        tx.commit();

        Member resultMember1 = em.find(Member.class, 1L);
        System.out.println("Id: " + resultMember1.getMemberId()
        + ", email: " + resultMember1.getEmail());

        Member resultMember2 = em.find(Member.class, 2L);
        System.out.println(resultMember2 == null);
    }

//i 3. DB에 모두 저장

    private void example03() {
        tx.begin();

        Member member1 = new Member("a@a.com");
        Member member2 = new Member("b@b.com");

        em.persist(member1);
        em.persist(member2);
        tx.commit();
    }

//i 4. setter를 이용한 객체 업데이트

    private void example04() {
        tx.begin();
        em.persist(new Member("abc@abc.com"));
        tx.commit();

        tx.begin();
        Member member1 = em.find(Member.class, 1L);
        member1.setEmail("bcd@bcd.com");
        tx.commit();
    }

//i 5. 객체 삭제

    private void example05() {
        tx.begin();
        em.persist(new Member("abc@abc.com"));
        tx.commit();

        tx.begin();
        Member member = em.find(Member.class, 1L);
        em.remove(member);
        tx.commit();
    }
```

------

### **Mapping**

- Entity <-> Table
  - @Id, @Entity, @Table(Optional)
  - PK 생성 전략 권장 방법 = IDENTITY 또는 SEQUENCE
  - Entity의 필드 타입이 원시타입을 경우 왠만하면 @Column 에 null 옵션이라도 주기
- Primary Key
  - @Id 사용
  - IDENTITY 사용 - DB에 pk생성 위임 ex) @GeneratedValue(strategy = GenerationType.IDENTITY)
  - SEQUENCE - DB제공 시퀀스를 사용한 pk 생성
  - TABLE - 별도의 키 생성 테이블 사용 (성능 ↓ , 권장 X)
- Field <-> Column
  - @Column 사용 (Attr - nullable,updatable,unique)

<br>

```java
//i 1. Field <-> Column 매핑

@NoArgsConstructor
@Getter
@Entity
public class Member {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long memberId;

		// (1)
    @Column(nullable = false, updatable = false, unique = true)
    private String email;

		

    public Member(String email) {
        this.email = email;
    }
}

@Configuration
public class JpaColumnMappingConfig {
    private EntityManager em;
    private EntityTransaction tx;

    @Bean
    public CommandLineRunner testJpaSingleMappingRunner(EntityManagerFactory emFactory){
        this.em = emFactory.createEntityManager();
        this.tx = em.getTransaction();

        return args -> {
//            testEmailNotNull();   // (1)
//            testEmailUpdatable(); // (2)
//            testEmailUnique();    // (3)
        };
    }

    private void testEmailNotNull() {
        tx.begin();
        em.persist(new Member());
        tx.commit();
    }

    private void testEmailUpdatable() {
        tx.begin();
        em.persist(new Member("hgd@gmail.com"));
        Member member = em.find(Member.class, 1L);
        member.setEmail("hgd@yahoo.co.kr");
        tx.commit();
    }

    private void testEmailUnique() {
        tx.begin();
        em.persist(new Member("hgd@gmail.com"));
        em.persist(new Member("hgd@gmail.com"));
        tx.commit();
    }
}
```

------

### **연관 관계 매핑**

- 방향성을 기준으로 단방향 & 양방향으로 구분
- JDBC는 단방향만 지원하지만 JPA는 단,양방향 전부 지원
- 1:N 단방향 매핑을 잘 사용하지 않음
- 일반적으로 N:1 매핑(N쪽 테이블의 외래키 위치와 동일)후 필요한경우, 1:N 매핑을 추가로해서 양방향 관계를 만듬
- N:1 매핑부터 적용 후 객체 그래프 탐색으로 조회가 불가능할 경우 양방향 매핑 적용
- 단방향
  - 한쪽은 참조값이 있지만 한쪽은 없는 관계
- 양방향
  - 양쪽 모두 참조값이 있는 관계

<br>

```java
//i 1. N:1에서 N쪽 연관관계 매핑

    @ManyToOne
    @JoinColumn(name = "MEMBER_ID")
    private Member member;

    public void addMember(Member member) {
        this.member = member;
    }

//i 2. N:1 매핑을 이용한 회원과 주문 정보 저장

@Configuration
public class JpaManyToOneUniDirectionConfig {
    private EntityManager em;
    private EntityTransaction tx;

    @Bean
    public CommandLineRunner testJpaManyToOneRunner(EntityManagerFactory emFactory) {
        this.em = emFactory.createEntityManager();
        this.tx = em.getTransaction();

        return args -> {
            mappingManyToOneUniDirection();
        };
    }

    private void mappingManyToOneUniDirection() {
        tx.begin();
        Member member = new Member("abc@abc.com",
                "Hong Gil Dong",
                "010-1111-1111");
        em.persist(member);

        Order order = new Order();
        order.addMember(member);
        em.persist(order);

        tx.commit();

        Order findOrder = em.find(Order.class, 1L);

        System.out.println("findOrder = " + findOrder.getMember().getMemberId()
        + ", " + findOrder.getMember().getEmail());
    }
}

//i 3. 1쪽에서 양방향 관계 매핑

    //i Member Entity에 추가
    @OneToMany(mappedBy = "member")
    private List<Order> orders = new ArrayList<>();


//i 4. 양방향 관계를 추가한 주문 정보 조회 클래스 수정

    private void mappingManyToOneUniDirection() {
        tx.begin();
        Member member = new Member("abc@abc.com",
                "Hong Gil Dong",
                "010-1111-1111");

        Order order = new Order();
        //Do 1. order객체에 member객체 추가
        order.addMember(member);
        //Do 2. member객체에 order객체 추가
        member.addOrder(order);
        //Do 3. 영속성 컨테이너테  회원,주문 정보 저장
        em.persist(member);
        em.persist(order);
        //Do 4. DB에 저장
        tx.commit();
        //Do 5. 영속성 컨텍스트의 저장된 회원정보를 1차 캐시 조회
        Member findMember = em.find(Member.class, 1L);
        //Do 6. 회원객체에서 주문 객체를 불러와서 stream으로 주문 List 정보에 접근 가능
        findMember.getOrders().stream()
                .forEach(findOrder -> {
                    System.out.println("findOrder = " + findOrder.getOrderId()
                            + ", " + findOrder.getOrderStatus());
                });
    }
```

------

##  **💡 Hibernate 란?**

JPA는 자바의 ORM 기술 표준으로 인터페이스의 모음이며, 
이러한 JPA 표준 명세를 구현한 구현체이며 내부적으로 JDBC API를 사용한다.