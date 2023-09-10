## **💡 Entity 연관관계 설정**

JPA의 목적 - 객체지향 프로그래밍과 데이터베이스 사이의 패러다임 불일치 해결

<br>

**연관관계 정의 규칙**

- 방향 : 단방향, 양방향 (객체 참조)
- 연관관계의 주인 : 양방향일 때, 연관관계에서 관리 주체
- 다중성 : 1:1, 1:N, N:1, N:M

<br>

**단방향, 양방향**

- DB 테이블은 외래키 하나로 양쪽 테이블 조인이 가능하지만 객체는 참조용 필드가 있는 객체만 참조가 가능하다
- 그렇기 떄문에 두 객체 사이에 하나의 객체만 참조용 필드를 가지면 단방향, 각각 참조 필드를 가지고 있으면 양방향 관계다
- JPA를 사용하여 DB와 패러다임을 맟추기 위해서 객체는 연관관계를 잘 선택해야 한다
- 선택은 비즈니스 로직에서 두 객체가 참조가 필요한지 여부를 고민해보면 됨
- board.getPost()처럼 참조가 필요하면 Board -> Post 단방향 참조
- post.getBoard()처럼 참조가 필요하면 Post -> Board 단방향 참조

<br>

**무조건 양방향 관계를 하면 쉽지 않을까?**

- 객체 입장에서 양방향 매핑을 했을때 오히려 더 복잡해질 수 있다
- 불필요한 연관관계를 구분하기 좋은 기준은 **기본적으로 단방향으로 하고 나중에 역방향 객체 탐색이 꼭 필요하다고 느낄 때** 추가

<br>

**연관관계의 주인**

- 두 엔티티가 단방향 관계 2개(양방향)를 맺을때 주인을 지정해야 함
- 주인을 지정하는건 두 단방향 관계 중, 제어의 권한(외래키를 비롯한 테이블 레코드의 저장&수정&삭제 처리)을 갖는 실절적인 관계가 어떤것인지 JPA에게 알려준다
- 주인이 아니면 조회만 가능하며 주인이 아닌 객체에서 mappedBy를 이용해 주인을 지정해줘야함 (외래키가 있는곳을 주인으로 정하자. 무조건)

<br>

**왜 주인을 지정해야 할까?**

- 두 객체(Board, Post)가 양방향 관계를 갖는다고 가정
- Post의 Board을 다른 id를 갖는 Board로 수정하려고 할 때, Post에서 setBoard()같은 메서드를 이용해서 하는게 맞는지, Board에서 getPosts()를 이용해서 List를 수정하는게 맞는지 헷갈릴수도 있다
- 두 객체 입장에서 보면 두 방법 다 맞다
- 하지만 이렇게 양방향 관계 관리 포인트가 두 개일 때는 테이블과 매핑을 담당하는 JPA에게 혼란을 주게됨
- 즉, Post에서 Board를 수정할 때 FK를 수정할지 Board에서 Post를 수정할 때 FK를 수정할 지를 결정하기 어려움
- 그렇기 때문에 두 객체 사이의 연관관계의 주인을 정해서 명확하게 Post에서 Board를 수정할 때만 FK를 수정하겠다 라고 정하는것이다



**연관관계의 주인만 제어를 하면 되는걸까?**

- DB에 FK가 있는 테이블을 수정하려면 연관관계의 주인만 변경하는것이 맞을까? 맞다
- 맞긴 하지만 그건 DB만 생각했을때이고 객체를 생각해보면 사실 둘 다 변경을 해주는것이 좋다 (주인이 아닌곳에서도 변경)
- 왜냐하면 두 참조를 사용하는 순수한 두 객체는 데이터 동기화를 해줘야하기 때문

<br>

**다중성**

- DB를 기준으로 다중성을 결정한다
- 연관관계는 대칭성을 갖는다
  - 1:N <-> N:1
  - 1:1 <-> 1:1
  - N:M <-> N:M

단뱡향,양방향은 알고있으니 따로 적지 않으며, 1:N, N:M은 실무에서 사용 왠만하면 거의 안함

<br>

**1:1 (1:1은 단방향 지원을 안하며 양방향만 있다)**

- 두 객체 중 외래키를 어디서 관리하는게 좋을지 생각해봐야 함
- 논쟁의 여지가 조금 있지만 보통 주테이블 (N,1중 1인쪽에다가 주인 지정)

<br>

**N:M (실무에서 사용 X)**

- 조인 테이블을 만들어 양 쪽 객체의 키를 관리
- 왠만하면 다대다를 다대일로 풀어서 만드는게 추후 변경에 유연하게 대처 가능

------

### **연관관계 예시**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Relation_Mapping.png)

<br>

**N:M (실무에서 사용 X)**

Category <-> Item N:M 관계

```java
// --- Category Class ---

// 상위, 하위카테고리 기능
@ManyToOne
@JoinColumn(name = "PARENT_ID")
private Category parent;

@OneToMany(mappedBy = "parent")
private List<Category> child = new ArrayList<>();

// Item과 N:M 매핑
@ManyToMany
@JoinTable(name = "CATEGORY_ITEM",
          joinColumns = @JoinColumn(name = "CATEGORY_ID"),
          inverseJoinColumns = @JoinColumn(name = "ITEM_ID"))
private List<Item> items = new ArrayList<>();

// --- Item Class ---
@ManyToMany(mappedBy = "items")
private List<Category> categories = new ArrayList<>();
```

<br>

**1:1**

Order(주 테이블) <-> Derivery(서브 테이블) 1:1 관계

1:1 관계에서 외래키는 양쪽 어디나 둘 수 있다.

주 테이블에 외래키를 두면 성능(바로 확인 가능, 나중에 프록시 활용 등) & 객체의 입장에서 편리하다.

주 테이블이 아닌곳에 두면 1 -> N으로의 확장이 편리하다 (DB컬럼 변경 없이 N으로 변경 가능)

```java
// --- Order Class ---
@OneToOne
@JoinColumn(name = "DELIVERY_ID")
private Delivery delivery;

// --- Delivery Class ---
// 양방향으로 맺고 싶을 때 사용
@OneToOne(mappedBy = "delivery")
private Order order;
```

------

## **💡 상속관계 매핑**

RDBMS는 상속 관계가 없다.

Super타입, Sub타입 관계라는 모델링 기법이 객체의 상속과 유사하다.

객체의 상속 구조와 DB의 Super타입 Sub타입 관계를 매핑한다.

<br>

### **DB 논리모델을 물리모델로 구현하는 방법**

DB의 슈퍼타입, 서브타입 논리 모델을 물리 모델로 구현하는 방법

- 각각 테이블로 변환 -> 조인 전략
- 통합 테이블로 변환 -> 단일 테이블 전략
- 서브타입 테이블로 변환 -> 구현 클래스마다 테이블 전략

------

### **주요 Annotation**

- @Inheritance(strategy = InheritanceType.XXX)
  - JOINED - 조인 전략
  - SINGLE_TABLE - 단일 테이블 전략
  - TABLE_PER_CLASS - 구현 클래스마다 테이블 전략
- @DiscriminatorColumn(name = "XXX")
  - 상위 클래스에서 어노테이션 적용
  - Default Name = DTYPE
- @DiscriminatorValue("XXX")
  - 하위 클래스에서 어노테이션을 적용해 테이블의 이름을 변경한다.

------

### **조인 전략**

상위 클래스에서 @Inheritance Annotation을 사용하여 전략 지정

하위테이블은 PK이자 FK를 가진다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Relation_Mapping2.png) 

<br>

**장점**

- 테이블 정규화
- 외래키 참조 무결성 제약조건 활용가능
- 저장공간 효율화

**단점**

- 조회 시 조인을 많이 사용 (성능 저하)
- 조회 쿼리가 복잡함
- 데이터 저장 시 INSERT SQL 2번 호출

------

### **단일 테이블 전략**

한 테이블의 모든 컬럼을 두고 DTYPE으로 구분하는 전략

@InHeritance(strategy = SINGLE_TABLE) 적용

@DiscriminatorColumn의 생략이 가능하다.

<br>

**장점**

- 조회 시, 조인이 필요 없으므로 일반적으로 조회 성능이 빠름
- 조회 쿼리가 단순함

**단점**

- 하위 엔티티가 매핑한 컬럼은 모두 NULL 허용
- 단일 테이블에 모든것을 저장하므로 테이블이 커질 수 있다.
- 상황에 따라 조회 성능이 오히려 느려질 수 있다.

------

### **구현 클래스마다 테이블 전략**

상위 클래스 없이 공통된 속성의 컬럼들을 클래스마다 보유하는 전략

@InHeritance(strategy = TABLE_PER_CLASS) 적용

abstract class 클래스를 선언하여 그 클래스를 상속하는 방식으로 사용해도 된다.

@DiscriminatorColumn이 의미가 없으므로 적용을 하지 말자.

이 전략은 DB 설계자와 ORM 전문가 둘다 추천 X

<br>

**장점**

- 서브 타입을 명확하게 구분해서 처리할 때 효과적
- NOT NULL 제약조건 사용 가능

**단점**

- 여러 하위 테이블을 함께 조회할 때 성능이 느림 (UNION SQL 필요)
- 하위 테이블을 통합해서 쿼리가 어려움
- 상위 테이블을 조회했을때 union all로 전부 가져온다.

------

## **💡 @MappedSuperclass**

테이블과 관계없고 엔티티의 공통된 매핑 정보가 필요할 때 사용한다. (ex: id, name)

직접 생성해서 사용할 일이 없으므로 추상 클래스로 생성 권장한다.

<br>

- 상속관계 매핑이 아니며, 엔티티도 아니다. (테이블과 매핑되는것이 아님)
- 엔티티 X, 테이블과 매핑 X
- 상위 클래스를 상속받는 하위 클래스에 매핑 정보만 제공
- 조회, 검색 불가 (em.find())
- 테이블과 관계 없고 단순히 엔티티가 공통으로 사용하는 매핑 정보를 모으는 역할
- 주로 등록일, 수정일, 등록자, 수정자 같은 전체 엔티티 공통의 정보를 모을때 사용
- @Entity 클래스는 엔티티나 @MappedSuperclass로 지정한 클래스만 상속 가능

### 예시

```java
// SuperClass
@Getter @Setter
@MappedSuperclass
public class BaseEntity {
    private String createBy;
    private LocalDateTime createdDate;

    private String lastModifiedBy;
    private LocalDateTime lastModifiedDate;
}

// SuperClass 상속이 필요한 하위 클래스
public class Item extends BaseEntity {}
```