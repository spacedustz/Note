## 📘 Serialization vs JSON 비교

직렬화를 알아보게 된 계기는 CSV, JSON 같은 훌륭한 데이터 포맷이 있는데 왜 굳이 직렬화를 사용하는지 입니다.

<br>

직렬화란 자바 Object & Data를 다른 컴퓨터의 자바 시스템에서 사용 하도록 **바이트 스트림(streams of byte)** 형태로,

**연속적인(Serial)** 데이터로 변환하는 **포맷 변환 기술**입니다.

반대로 역직렬화는 바이트로 변환된 데이터를 원래대로 자바 시스템의 Object & Data로 변환하는 기술입니다.

<br>

이를 시스템적으로 보면 JVM의 Heap or Stack 메모리에 상주하는 객체를 직렬화해 DB나 외부 저장소에 저장하고,

다른 컴퓨터의 자바 시스템에서 이 파일을 역직렬화 하여 자바 객체르 변환 후 JVM 메모리에 적재시켜 사용합니다.

<br>

이처럼 자바 직렬화는 외부 파일이나 네트워크를 통해 클라이언트 간 객체 데이터를 주고 받을 때 사용합니다.

<br>

>📌  **범용 포맷이 아닌 자바 직렬화(Serialization)을 사용하는 상황**

- 자바의 고유 기술인 만큼 당연히 자바 시스템 개발에 최적화 되어 있다.
- 자바의 광활한 Referense 타입에 대해 제약 없이 객체를 외부로 내보낼 수 있다.

<br>

예를 들어, 기본형 타입이나 배열과 같은 타입들은 왠만한 프로그래밍 언어가 공통으로 사용하는 타입이기 때문에,

이러한 값들은 범용적인 포맷인 JSON 등으로 충분히 상호 이용이 가능합니다.

<br>

하지만 자바의 컬렉션, 커스텀 자료형 등의 데이터는 단순 파일 포맷만으로 타입 개수에 한계가 있습니다.

그래서 이런 객체들을 내보내기 위해선 각 데이터를 알맞게 매칭시키는 별도의 파싱(Parsing)이 필요합니다.

<br>

여기서 만약 내보낼 데이터가 도착할 곳이 자바스크립트, 파이썬 같은 시스템이 아니라 자바 시스템을 사용하는 컴퓨터 라면,

직렬화 기본 조건만 지키면 하드코딩 없이 바로 외부로 보낼수 있으며, 역직렬화를 통해 복잡한 객체 구조를 그대로 가져올 수 있습니다.

---

## 📘 객체 직렬화 & 역직렬화

객체를 직렬화 하기 위해선 `java.io.Serializable` 인터페이스를 구현해야 합니다.

그렇지 않으면 `NotSerializableException` 런타임 에러가 발생합니다.

Serializable 인터페이스는 아무런 내용도 없는 **마커 인터페이스**로써 직렬화를 고려해 작성한 클래스인지를 판단하는 기준으로 사용됩니다.

<br>

```java
import java.io.Serializable;

public class SerializableTest implements Serializable {  
  
    int id;  
    String name;  
    String password;  
    int age;  
  
    public SerializableTest(int id, String name, String password, int age) {  
        this.id = id;  
        this.name = name;  
        this.password = password;  
        this.age = age;  
    }  
  
    @Override  
    public String toString() {  
        return "SerializableTest{" +  
                "id=" + id +  
                ", password='" + password + '\'' +  
                ", name='" + name + '\'' +  
                ", age=" + age +  
                '}';  
    }
}
```

<br>

> 📌 **ObjectOutputStream을 이용한 객체 직렬화**

직렬화 (스트림에 객체를 출력)에는 ObjectOutputStream을 사용합니다.

객체가 직렬화될때 오직 객체의 인스턴스 필드값만을 저장하고, static 필드나 메서드는 직렬화하여 저장하지 않습니다.

아래 코드는 외부 파일에 객체를 직렬화 하는 예시입니다.

```java

```