## **💡 ObjectMapper**  

**Jackson 라이브러리의 클래스**

<br>

JSON - > Java 객체로 **Deserialization**
Java 객체 -> JSON으로 **Serialization**
ObjectMapper는 생성 비용이 비싸기 때문에 Bean & Static으로 처리하는걸 권장

<br>

### **Serialization**

```java
// Object Mapper를 이용한 직렬화

try {
    Question question = Question.builder()
            .questionId(1L)
            .title("제목")
            .content("내용")
            .build();

    objectMapper.writeValue(new File("src/question.json"), question);
} catch (IOException e) {
    e.printStackTrace();
}
```

<br>

### **Deserialization**

```java
// Object Mapper를 이용한 역직렬화

try {
    LoginDto loginDto = objectMapper.readValue(request.getInputStream(), LoginDto.class);
} catch (JsonProcessingException e) {
    e.printStackTrace();
}
```

<br>

### **계층 형태의 복잡한 JSon Deserialization**

```java
ObjectMapper objectMapper = new ObjectMapper();
objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        
try {
	PersonDto personDto = objectMapper.readValue(complicatedJson, PersonDto.class);
	System.out.println(personDto.getName());
	System.out.println(personDto.getContact().getPhoneNumber());
	System.out.println(personDto.getJob().getWorkplace().getName());
} catch (JsonProcessingException e) {
	e.printStackTrace();
}
```

---

## 💡 Type Casting

자바에는 두가지 유형의 캐스팅이 있다.

<br>

**업 캐스팅**

- 작은 타입 -> 큰 타입
- byte - short - char - int - long - float - double

<br>

**다운 캐스팅**

- 큰 타입 -> 작은 타입
- double - float - long - int - char - short - byte

<br>

### 업 캐스팅

작은 타입을 큰 타입으로 캐스팅할때는 자동으로 타입 변환이 된다.

```java
public class Main {
    publuc static void main(String[] args) {
        int num = 9;
        double upNum = num; // 자동 타입 변환
        
        System.out.println(num); // 9
        System.out.println(upNum); // 9.0
    }
}
```

<br>

### 다운 캐스팅

큰 타입을 작은 타입으로 캐스팅할때는 수동으로 타입 변환을 해줘야 한다.

```java
public class Main {
    public static void main(String[] args) {
        double upNum = 9.78d;
        int num = (int) upNum; // 수동 타입 변환
        
        System.out.println(upNum); // 9.78
        System.out.println(num); // 9
    }
}
```

