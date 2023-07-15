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