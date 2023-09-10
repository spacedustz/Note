## Anotation

### @RequestPart

- 파일과 DTO를 같이 받을 때 사용, 파일 받을때 MultipartFile 사용
- Value, ruquired 옵션
  - 일반 DTO는 Json 포맷이므로 Multipart-form Data는 일반 DTO에 같이 들어갈 수 없으므로,
    @RequestPart를 사용해 입력 받을때 DTO와 같이 받는게 가능하다.

---

### @PostMapping

- Consumes - 들어오는 데이터 타입 정의
  - MediaType.APPLICATION_JSON_VALUE
- Produces - 반환하는 데이터 타입 정의
  - MediaType.APPLICATION_JSON_VALUE

---

### @RequestAttribute

- request 객체의 attribute를 추출한다.

---

### @JsonIdentityInfo

- N:M 양방향 관계 엔티티 사이클 방지 어노테이션
- 양방향 관계 설정 후, 데이터를 불러오는 과정에서 무한재귀로 데이터를 불러와 StackOverFlow를 발생시킨다.
- Json Type으로 엔티티를 변환할 때 @Id를 바탕으로 중복된 아이디는 Json으로 변환시키지 않는 기능을 한다.
- @JsonIdentityInfo(generator = ObjectGenerators.IntSequenceGenerator.class)
- Property를 지정해주지 않으면 default로 @Id 어노테이션 기능을 실행한다.

---

### @Converter & @Convert

- 엔티티의 데이터를 변환해서 DB에 저장할 수 있다.
- 예를 들면 엔티티는 Boolean, DB는 Y & N 값을 저장하고 싶을 경우
- 기본적으로 Boolean Type으로 지정하면 0,1로 저장된다.
- AttributeConverter<엔티티 컬럼 타입, DB 컬럼 타입> 구현

```java
@Converter
class BooleanToYNConverter implements AttributeConverter<Boolean, String>{
    @Override
    public String convertToDatabaseColumn(Boolean attribute){
        return (attribute != null && attribute) ? "Y" : "N";
    }

    @Override
    public Boolean convertToEntityAttribute(String dbData){
        return "Y".eqauls(dbData);
    }
}
```

---

### @DynamicUpdate

- Hibernate의 추가기능이다.
- 업데이트 쿼리를 할 시 변경될 열만 변경한다
- 성능 오버헤드가 있으므로 필요할때만 사용

---

### @Basic

- 엔티티의 필드를 언제 가져올지 결정하는 어노테이션이다. (default FetchType은 Eager이다)
- JPA Entity에 적용되며 @Column은 DB의 열에 적용된다.

`@Basic` 어노테이션은 JPA에서 가장 기본적인 어노테이션 중 하나입니다. 이 어노테이션은 필드 또는 프로퍼티에 적용하여 해당 속성을 기본적인 매핑으로 처리합니다. `@Basic` 어노테이션은 생략 가능하며, 생략할 경우에도 기본적인 매핑 규칙에 따라 자동으로 처리됩니다.

`@Basic` 어노테이션은 단순한 값을 가지는 데이터 타입을 매핑할 때 사용됩니다. 예를 들어, 기본형(primitive type)이나 문자열(String), 날짜(Date) 등을 매핑할 때 `@Basic` 어노테이션을 사용할 수 있습니다. 이 어노테이션에는 다양한 속성을 설정할 수 있으며, 예를 들어 `optional`, `fetch`, `targetEntity` 등이 있습니다.

---

### @Formula

- 가상의 컬럼 매핑할 수 있다.
- JPA상에는 존재하지만 DB에선 존재하지 않는 컬럼을 가상 컬럼이라고 한다.
- Native SQL을 사용한다.
- 가상컬럼은 @Formula 안에 정의된 내용을 서브쿼리로 질의해 결과를 가져와준다.
- @Formula(**Native Query**)
- @Formula의 Default FetchType은 Eager이다.

---

### @JsonInclude

- DTO에 @JsonInclude(JsonInclude.NON_NULL)을 사용하면 Null 필드를 안보이게 할 수 있다.

---

## @Inheritance

`@Inheritance` 어노테이션은 JPA에서 상속 구조를 매핑하기 위해 사용됩니다. 이 어노테이션은 상속 관계에 있는 엔티티 클래스들 간의 매핑 전략을 지정하는 데에 사용됩니다. `@Inheritance` 어노테이션은 엔티티 클래스의 상위 클래스 또는 부모 클래스에 적용됩니다.

`@Inheritance` 어노테이션에는 `strategy` 속성이 있으며, 이 속성을 사용하여 상속 전략을 지정할 수 있습니다. `InheritanceType` 열거형을 사용하여 전략을 선택할 수 있습니다. `InheritanceType` 열거형에는 다음과 같은 전략들이 정의되어 있습니다:

1.  `SINGLE_TABLE`: 단일 테이블 전략입니다. 상속 계층 구조의 모든 엔티티가 하나의 테이블에 저장되며, 구분 컬럼을 사용하여 각 엔티티를 식별합니다.
    
2.  `TABLE_PER_CLASS`: 구체적인 엔티티마다 별도의 테이블을 생성하는 전략입니다. 각 엔티티는 자체 테이블을 가지며, 공통 속성은 중복되어 저장될 수 있습니다.
    
3.  `JOINED`: 조인 전략입니다. 각 엔티티는 자체 테이블을 가지며, 공통 속성은 부모 엔티티의 테이블에 저장되며 조인을 통해 필요한 데이터를 가져옵니다.
    

`@Inheritance` 어노테이션에 `strategy` 속성을 설정할 때 `InheritanceType.JOINED`를 지정하면 조인 전략이 사용됩니다. 이 전략에서는 각 엔티티가 자체 테이블을 가지고 있으며, 공통 속성은 부모 엔티티의 테이블에 저장됩니다. 필요한 경우 조인을 통해 데이터를 가져옵니다. 이를 통해 상속 관계의 엔티티를 효과적으로 매핑할 수 있습니다.

---

## @Table

@Table(indexes = [Index(name="i_sigungu", columnList = "sigungu")])

`@Table` 어노테이션은 JPA에서 엔티티와 매핑되는 테이블의 속성을 설정하기 위해 사용됩니다. 이 어노테이션은 엔티티 클래스에 적용되며, 해당 테이블의 이름, 인덱스, 고유 제약 조건 등을 설정할 수 있습니다.

주어진 코드에서 `@Table(indexes = [Index(name="i_sigungu", columnList = "sigungu")])`는 `indexes` 속성을 사용하여 테이블에 인덱스를 생성하는 예시입니다. `indexes` 속성은 `@Table` 어노테이션의 하위 속성으로서, 하나 이상의 인덱스를 설정할 수 있습니다.

인덱스는 데이터베이스에서 데이터의 검색 속도를 향상시키기 위해 사용되는 자료 구조입니다. `Index` 어노테이션을 사용하여 특정 열 또는 열들에 인덱스를 생성할 수 있습니다.

위의 코드에서는 `name` 속성을 사용하여 인덱스의 이름을 "i_sigungu"로 지정하고, `columnList` 속성을 사용하여 인덱스를 생성할 열을 "sigungu"로 지정하였습니다. 이는 "sigungu" 열에 대한 인덱스를 생성하는 것을 의미합니다.

인덱스는 데이터베이스의 검색 성능을 향상시키기 위해 사용되며, 특정 열 또는 열들에 대한 데이터의 정렬 및 검색을 빠르게 수행할 수 있습니다.