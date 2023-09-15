## **💡 빌더 패턴**  

**Builder Pattern을 사용하는 이유**

- 필요한 데이터만 설정 가능
- 유연성
- 가독성
- 변경 가능성의 최소화

<br>

**Builder Pattern을 사용 안했을때 생기는 문제점**

- Entity의 필드에 변경사항이 생길 때, 생성자 & 정적 팩토리 메소드의 파라미터 수정 작업 필요
- 가독성 ↓
- 유연성 ↓
- 불필요한 변경 가능성 최소화가 안됨으로 인한 Setter 메서드 사용 & 객체 불변성 확보에 불리함

<br>

**Builder Pattern 사용 예시**

- 아래 코드에서 Builder Pattern의 장점
  - 필요에 따른 각각 다른 객체 생성 시, 객체 생성의 유연함
  - 필요에 따른 Entity 필드의 추가 & 수정 작업 필요 시의 편리함
  - Entity의 원본 필드에 final을 추가함으로써 객체 불변성 확보 (Setter 사용 지양)
  - 가독성 & 유지보수성 ↑

```java
/* -------------- Builder Pattern 사용 X -------------- */

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    private String name;
    private String adress;
    private int age;
    
    /* Entity의 필드 중 adress가 없는 객체 생성을 하기 위한 생성자 & 정적 팩토리 메서드 */
    
    public User (String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public static User of(String name, int age) {
        return new User(name, age);
    }
}

/* -------------- Builder Pattern 사용 -------------- */

@Data
@Builder
@AllArgsConstructor
public class User {
    private String name;
    private String adress;
    private int age;
}

public class UserService {
    
    // 1. 빌더 패턴을 이용한 객체 생성
    public User create() {
        User user = User.builder()
                .name("abc")
                .adress("abc")
                .age(25)
                .build();
    }
    
    // 2. Entity의 필드를 추가 해야 할때 객체의 유연한 변경 (email 필드를 추가하는걸로 가정)
    public User create() {
        User user = User.builder()
                .name("abc")
                .adress("abc")
                .email("abc@abc.com")
                .age(25)
                .build();
    }
}
```