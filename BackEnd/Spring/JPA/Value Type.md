## **💡 JPA 데이터 타입 분류**

JPA의 데이터 타입에는 엔티티 타입과 값 타입이 있다.

<br>

**값 타입의 종류**

- 기본값(Primitive, Wrapper, String)
- 임베디드(복합 값 타입)
- 값 타입 컬렉션

**Entity Type**

@Entity로 정희 하는 객체이며, 데이터가 변해도 식별자로 지속적인 추적이 가능하다.

ex: 회원 엔티티의 키나 나이 값을 변경해도 식별자로 인식이 가능하다.

<br>

**Value Type**

int, Integer, String 처럼 단순히 값으로 사용하는 자바 기본 타입이나 객체이다.

ex: 숫자 100을 200으로 변경하면 완전히 다른 값으로 대체된다.

생명주기를 엔티티에 의존하며, 식별자가 없고 값만 있으므로 변경 시 추적이 불가능하다.

값 타입은 공유하면 안된다. (Side Effect 발생)

------

## **💡 기본 값 타입**

Primitive Type은 공유가 안되므로 안전한 값 타입이다. (기본 타입은 항상 값을 복사한다.)

Wrapper Type은 공유는 가능하지만 변경이 안된다. (같은 메모리 주소를 사용하기 떄문)

```java
// Primitive Value Type
// 결과값 : a = 20 , b = 10
int a = 10;
int b = a;
a = 20;

// Wrapper Value Type
// 결과값 : 20, 20
Integer a = new Integer(10);
Integer b = a;
a.setValue(20)
System.out.println("a = " + a);
System.out.println("b = " + b);
```

------

## **💡 임베디드 타입 (복합 값 타입)**

새로운 값 타입을 직접 정의할 수 있다.

주로 기본 값 타입을 모아서 만든것을 복합 값 타입이라고도 한다.

기본 값 타입과 같은 특징을 가지며 int, String과 같은 값 타입을 의미한다.

- @Embeddable - 값 타입을 정의하는 곳에 표시
- @Embedded - 값 타입을 사용하는 곳에 표시
- 기본 생성자 필수
- Embedded 타입이 Null이면 매핑한 컬럼도 모두 Null이 들어간다.

<br>

**장점**

- 코드의 재사용성
- 높은 응집도
- Period.isWork() 처럼 해당 값 타입만 사용하는 의미있는 메서드를 만들 수 있음.
- 임베디드 타입을 포함한 모든 값 타입은, 값 타입을 소유한 엔티티에 생명주기를 의존한다.

<br>

### **예시**

Member의 공통된 속성인 workPeriod와 homeAddress를 값 타입으로 만든다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Value.png) 

```java
// Member Class
@Entity
public class Mamber {
    private Long id;
    private String name;
    @Embedded
    private Period period;
    @Embedded
    private Address address;
}

// Period Class
@NoArgsConstructor
@Embeddable @Getter @Setter
public class Period {
    private LocalDateTime startDate;
    private LocalDateTime endDate;
}

// Address Class
@NoArgsConstructor
@Embeddable @Getter @Setter
public class Address {
    private String city;
    private String street;
    private String zipCode;
}
```

<br>

### **임베디드 타입과 테이블 매핑**

임베디드 타입은 엔티티의 값을 뿐이다.

임베디드 타입을 사용하기 전과 후에 매핑하는 테이블은 같다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Value2.png) 

<br>

### **임베디드 타입과 연관관계**

아래의 그림에서 PhoneNumber라는 값 타입이 PhoneEntity라는 엔티티의 FK를 들고 있다.

값 타입이라도 엔티티를 가질 수 있다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Value3.png) 

<br>

### **Attribute Override**

한 엔티티에서 같은 값 타입을 사용할 때 컬럼 중복을 방지한다.

@AttributeOverrides, @AttributeOverride를 사용해서 컬럼명, 속성을 재정의 한다.

```java
// Member Class
@Entity
public class Mamber {
    private Long id;
    private String name;
    @Embedded
    private Period period;

    // 2개의 Address 값 타입 중, workAddress를 재정의 한다.
    @Embedded
    private Address homeAddress;

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "city", column = @Column(name = "WORK_CITY")),
        @AttributeOverride(name = "street", column = @Column(name = "WORK_STREET")),
        @AttributeOverride(name = "zipcode", column = @Column(name = "WORK_ZIPCODE"))
    })
    private Address workAddress;
}
```

------

## **💡 값 타입 컬렉션**

Member 엔티티에 값 타입을 컬렉션으로 가지고 있을때의 예시

- 값 타입 컬렉션의 Default Fetch 전략은 Lazy를 사용한다.
- 변경사항이 발생하면, 주인 엔티티와 연관된 모든 데이터를 삭제하고,
  값 타입 컬렉션에 있는 현재 값을 모두 다시 저장한다.
- 값 타입 컬렉션을 매핑하는 테이블은 모든 컬럼을 묶어서 PK를 구성해야 한다.
  (Null 입력 X, 중복 저장 X)
- 실무에서는 상황에 따라 값 타입 컬렉션 대신 1:N 관계를 고려한다.
  (값 타입 컬렉션을 Cascade, Orphan을 활용한 값 타입을 보유한 엔티티로 변환)

<br>

참고: 값 타입 컬렉션은 Cascade + Orphan 제거 기능을 필수로 가진다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Value4.png) 

<br>

### **매핑**

```java
@ElementCollection
@CollectionTable(name = "FAVORITE_FOOD",
                joinColumns = @JoinColumn(name = "MEMBER_ID"))
@Column(name = "FOOD_NAME")
private Set<String> favoriteFoods = new HashSpet<>();

// ---------------------

@ElementCollection
@CollectionTable(name = "ADDRESS",
                joinColumns = @JoinColumn(name = "MEMBER_ID"))
private List<Address> addressHistory = new ArrayList<>();
```

<br>

### **저장 & 조회 & 수정**

Member만 Persist를 했을 뿐인데 값 타입 컬렉션도 같이 Insert가 된다.

즉, 값 타입의 생명주기는 위에 말한것처럼 엔티티에 의존한다.

참고: 값 타입 컬렉션은 Cascade + Orphan 제거 기능을 필수로 가진다.

```java
/* ---------- 저장 ----------
  Member만 Persist를 해도 값 타입 컬렉션들이 같이 저장된다. 
*/
Member member = new Member();
member.setName("member1");
member.setHomeAddress(new Address("homeCity", "street", "10000"));

member.getFavariteFoods().add("치킨");
member.getFavariteFoods().add("피자");
member.getFavariteFoods().add("김밥");

member.getAddressHistory().add(new Address("old1", "street", "10000"));
member.getAddressHistory().add(new Address("old2", "street", "10000"));

em.persis(member);
em.flush();
em.clear();

/* ---------- 조회 ----------
  값 타입 컬렉션은 Lazy Loading이기 떄문에 멤버를 조회했을때 결과에 안나온다. 
*/
Member findMember = em.find(Member.class, member.getId());

/* ---------- 수정 ----------
  값 타입 컬렉션은 불변이어야 하기 때문에 새로운 인스턴스를 생성해야 한다.
  city의 정보만 수정 homeCity -> newCity
*/
Address a = findMember.getHomeAddress();
findMember.setHomeAddress(new Address("newCity", a.getStreet(), a.getZipcode()));

// 치킨 -> 한식으로 수정
findMember.getFavoriteFoods().remove("치킨");
findMember.getFavoriteFoods().add("한식");

tx.commit();
```

------

## **💡 값 타입과 불변 객체**

- 임베디드 타입 같은 값 타입은 기본 타입처럼 공유가 가능하기 떄문에 항상 값을 복사해서 사용해야 한다.
- 위의 경우처럼 임베디드 타입같은 객체 타입은 객체의 공유 참조를 피할 수 없다.
- 굳이 공유하고 싶다면 값 타입을 공유하는 것이 아닌 엔티티를 만들어서 사용하는것을 추천한다.
- 위의 모든 경우를 피하고 싶을때 값 타입을 생성할때부터 불변 객체로 설계해야한다.
  (생성 시점 이후 절대 값을 변경할 수 없는 객체)
- 생성자로만 값을 설정하고 Setter를 만들지 않으면 된다.

참고: Integer, String 은 자바의 대표적인 불변객체이다.

값 타입의 실제 인스턴스인 값을 공유하지 말고 값(인스턴스)를 복사해서 사용하자.

```java
// 새 값 타입 생성
Address address = new Address("city", "street", "10000");
Member m1 = new Member();
m1.setName("m1");
m1.setHomeAddress(address);
em.persist(m1);

// 위에서 만든 값타입의 값을 복사한 새 Address 생성
Address copyAddress = new Address(address.getCity, address.getStreet(), address.getZipcode());

Member m2 = new Member();
m2.setName("m2");
m2.setHomeAddress(copyAddress); // 복사된 값인 copyAddress로 설정
em.persist(m2);

member.getHomeAddress().setCity("newCity");

tx.commit;
```

------

## **💡 값 타입의 비교**

- 동일성(identity) 비교 : 인스턴스의 참조 값을 비교, == 사용
- 동등성(equivalence) 비교 : 인스턴스의 값을 비교, equals() 사용
- 값 타입은 a.equals(b)를 사용해서 동등성 비교를 해야 함
- 값 타입의 equals() 메서드를 적절하게 재정의 해야함. (주로 모든 필드에서 사용)

<br>

### **Override된 equals() 재정의**

```java
// 값 타입 클래스 내부
@Override
public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    Address address = (Address) o;
    return Objects.equals(city, address.city) &&
        Objects.equals(street, address.street) &&
        Objects.equals(zipcode, address.zipcode);
}

@Override
public int hashCode() {
    return Objects.hash(cit, street, zipcode);
}
```