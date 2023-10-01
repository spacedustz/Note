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
- 자바의 광활한 Reference 타입에 대해 제약 없이 객체를 외부로 내보낼 수 있다.

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

> 📌 **만약 직렬화 대상에 포함시키고 싶지 않은 필드가 있을 때**

아래 코드의 4개의 변수 중 age를 직렬화 대상에 포함시키고 싶지 않다면, 

단순히 변수명 앞에 `transient` 키워드를 붙이면 됩니다.

이때 `transient` 키워드가 붙은 변수의 기본값은 각 타입의  Default 값으로 들어갑니다.
- Primitive : 각 타입의 Default 값 (ex: int는 0 으로 들어감)
- Reference : null

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
  
    // 객체 직렬화 함수
    public static void doSerialize() {  
        // 직렬화할 테스트 객체 생성  
        SerializableTest test = new SerializableTest(1, "사람1", "1234", 20);  
  
        // 외부 파일 명  
        String fileName = "test.ser";  
  
        // File Stream 객체 생성 (try with resource 사용)  
        try (FileOutputStream fos = new FileOutputStream(fileName);  
            ObjectOutputStream out = new ObjectOutputStream(fos)) {  
  
            // 직렬화 가능 객체를 바이트 스트림으로 변환하고 파일에 저장  
            out.writeObject(test);  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
    }  
  
    public static void main(String[] args) {  
        doSerialize();  
    }  
}
```

<br>

이후 코드를 실행사키면 `test.ser`파일이 프로젝트 최상단에 생성되고, 내용을 보면 사람이 읽을 수 없는 문자로 되어있는 걸 볼 수 있습니다.

```
파일 내부의 값 : ��������������������������������������������
```

<br>

> 📌 **ObjectInputStream을 이용한 객체 역직렬화**

역직렬화 (스트림으로부터 객체를 입력)에는 ObjectInptuStream을 사용합니다.

**역직렬화 시 주의사항:**

- 직렬화 대상이 된 객체의 클래스가 외부 클래스라면, 클래스 경로(Class Path)에 존재해야 하며, Import 된 상태여야 합니다.

<br>

아래 코드는 외부 파일을 읽어 역직렬화 하여 다시 자바 객체로 변환하는 예시입니다.

```java
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
  
    // 객체 직렬화  
    public static void doSerialize() {  
        // 직렬화할 테스트 객체 생성  
        SerializableTest test = new SerializableTest(1, "사람1", "1234", 20);  
  
        // 외부 파일 명  
        String fileName = "test.ser";  
  
        // File Stream 객체 생성 (try with resource 사용)  
        try (FileOutputStream fos = new FileOutputStream(fileName);  
            ObjectOutputStream out = new ObjectOutputStream(fos)) {  
  
            // 직렬화 가능 객체를 바이트 스트림으로 변환하고 파일에 저장  
            out.writeObject(test);  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
    }  
  
    // 객체 역직렬화  
    public static void doDeserialize() {  
        String fileName = "test.ser";  
  
        // File Stream 객체 생성 (try with resource 사용)  
        try (FileInputStream fis = new FileInputStream(fileName);  
             ObjectInputStream in = new ObjectInputStream(fis)) {  
  
            // 바이트 스트림을 다시 자바 객체로 변환 (이때 캐스팅 필요)  
            SerializableTest test = (SerializableTest) in.readObject();  
            System.out.println(test);  
        } catch (IOException | ClassNotFoundException e) {  
            e.printStackTrace();  
        }  
    }  
  
    public static void main(String[] args) {  
        doSerialize();  
        doDeserialize();  
    }  
}
```

<br>

이렇게 역직렬화 코드를 실행시키면, 생성자로 객체 초기화 없이 바로 객체 정보를 가져와 인스턴스화 할 수 있습니다.

```
역직렬화된 객체 출력 값 : SerializableTest{id=1, password='1234', name='사람1', age=20}
```

---

## 📘 직렬화 객체를 리스트로 관리하기

만약 여러개의 객체를 직렬화 하고, 이를 역직렬화 할때 주의할 점이 있습니다.

**역직렬화 시, 직렬화 할때의 순서와 반드시 일치해야 합니다.**

예를 들어 객체 a1,a2,a3 순서로 직렬화 했다면, 역직렬화 시에도 a1,a2,a3 순서로 역직렬화 해야 합니다.

(파일에 직렬화 순서대로 바이트 문자가 작성되니 상식적이긴 합니다.)

<br>

그래서 직렬화할 객체가 많다면, ArrayList와 같은 컬렉션에 저장해서 관리하는 것이 좋습니다.

많은 객체를 담고, ArrayList 하나만 역직렬화하면 되니까 순서를 고려할 필요가 없어집니다.

아까 위에서 다양한 자바의 Reference를 간단하게 역직렬화 할 수 있다고 했는데, 이럴때 그 장점을 사용합니다.

```java
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
  
    // 객체 직렬화  
    public static void doSerialize() {  
        // 직렬화할 테스트 객체 생성  
        SerializableTest test = new SerializableTest(1, "사람1", "1234", 20);  
  
        // 외부 파일 명  
        String fileName = "test.ser";  
  
        // File Stream 객체 생성 (try with resource 사용)  
        try (FileOutputStream fos = new FileOutputStream(fileName);  
            ObjectOutputStream out = new ObjectOutputStream(fos)) {  
  
            // 직렬화 가능 객체를 바이트 스트림으로 변환하고 파일에 저장  
            out.writeObject(test);  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
    }  
  
    // 객체 역직렬화 함수
    public static void doDeserialize() {  
        String fileName = "test.ser";  
  
        // File Stream 객체 생성 (try with resource 사용)  
        try (FileInputStream fis = new FileInputStream(fileName);  
             ObjectInputStream in = new ObjectInputStream(fis)) {  
  
            // 바이트 스트림을 다시 자바 객체로 변환 (이때 캐스팅 필요)  
            SerializableTest test = (SerializableTest) in.readObject();  
            System.out.println(test);  
        } catch (IOException | ClassNotFoundException e) {  
            e.printStackTrace();  
        }  
    }  

		// List 직렬화 함수
    public static void doListSerialize() throws IOException, ClassNotFoundException {  
        // 직렬화 할 테스트 객체 3개  
        SerializableTest a1 = new SerializableTest(1, "사람1", "1234", 20);  
        SerializableTest a2 = new SerializableTest(2, "사람2", "1234", 25);  
        SerializableTest a3 = new SerializableTest(3, "사람3", "1234", 30);  
  
        // 외부 파일명  
        String fileName = "testList.ser";  
  
        // 리스트 생성 & 객체 추가  
        List<SerializableTest> list = new ArrayList<>();  
        list.add(a1);  
        list.add(a2);  
        list.add(a3);  
  
        // 리스트 자체를 직렬화 하기  
        FileOutputStream fos = new FileOutputStream(fileName);  
        ObjectOutputStream out = new ObjectOutputStream(fos);  
        out.writeObject(list);  
        out.close();  
  
        // 역직렬화 하여 리스트 객체에 넣기  
        FileInputStream fis = new FileInputStream(fileName);  
        ObjectInputStream in = new ObjectInputStream(fis);  
        List<SerializableTest> deserializedList = (List<SerializableTest>) in.readObject();  
        in.close();  
  
        System.out.println(deserializedList);  
    }  
  
    public static void main(String[] args) throws IOException, ClassNotFoundException {  
//        doSerialize();  
//        doDeserialize();  
        doListSerialize();  
    }  
}
```

<br>

```
출력 값 : 
[SerializableTest{id=1, password='1234', name='사람1', age=20}, SerializableTest{id=2, password='1234', name='사람2', age=25}, SerializableTest{id=3, password='1234', name='사람3', age=30}]
```

---

## 📘 Custom Serialization

직렬화 & 역직렬화에 호출되는 `readObject()`, `writeObject()`를 재정의 해 Custom Serialization을 할 수 있습니다.

예를 들면, 어떤 클래스의 특정 필드는 보안에 민감하기 때문에 특정 필드만 직렬화가 동작하지 않게 만들 수 있습니다.

<br>

```java
public class CustomDeserializableTest implements Serializable {  
    int id;  
    String name;  
    String password;  
    int age;  
  
    public CustomDeserializableTest(int id, String name, String password, int age) {  
        this.id = id;  
        this.name = name;  
        this.password = password;  
        this.age = age;  
    }  
  
    @Override  
    public String toString() {  
        return "CustomDeserializableTest{" +  
                "id=" + id +  
                ", name='" + name + '\'' +  
                ", password='" + password + '\'' +  
                ", age=" + age +  
                '}';  
    }  
  
    // 직렬화 재정의  
    private void writeObject(ObjectOutputStream out) throws IOException {  
        out.writeInt(id);  
        out.writeObject(name);  
        out.writeInt(age);  
    }  
  
    // 역직렬화 재정의  
    private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException {  
        this.id = in.readInt();  
        this.name = (String) in.readObject();  
        this.age = in.readInt();  
    }  
  
    public static void doCustomSerialize() throws IOException, ClassNotFoundException {  
        CustomDeserializableTest test = new CustomDeserializableTest(1, "사람1", "1234", 20);  
        String fileName = "CustomTest.ser";  
  
        // 직렬화  
        ObjectOutputStream out = new ObjectOutputStream(new BufferedOutputStream(new FileOutputStream(fileName)));  
        out.writeObject(test);  
        out.close();  
  
        // 역직렬화  
        ObjectInputStream in = new ObjectInputStream(new BufferedInputStream(new FileInputStream(fileName)));  
        CustomDeserializableTest deserializedTest = (CustomDeserializableTest) in.readObject();  
        in.close();  
  
        System.out.println(deserializedTest);  
    }  
  
    public static void main(String[] args) throws IOException, ClassNotFoundException {  
        doCustomSerialize();  
    }  
}
```

<br>

코드를 실행해보면 password 부분은 직렬화, 역직렬화 대상에서 제외되어 보이지 않게 됩니다.

```
결과값 : CustomDeserializableTest{id=1, name='사람1', password='null', age=20}
```

---

## 📘 객체 상속 관계에서의 직렬화

만약 상속 관계에서 상위 클래스가 Serializable 인터페이스를 구현했다면, 하위 클랫는 구현하지 않아도 직렬화가 가능합니다.

그럼 하위 클래스에서만 Serializable을 구현하면 어떻게 될까요?

직렬화 시, **상위 클래스의 인스턴스 필드는 무시되고 하위 클래스의 필드만 직렬화가 됩니다.**

<br>

**상위 클래스까지 직렬화 하려면?**

- 상위 클래스가 Serializable을 구현하도록 하기
- writeObject / readObject 재정의 하기

---

## 📘 직렬화 버전 관리 (SerialVersionUID)

Serializable 인터페이스를 구현하는 모든 직렬화된 클래스는 **serialVersionUID(SUID)** 라는 고유 식별번호를 부여 받습니다.

이 식별 ID는 클래스를 직렬화/역직렬화 하는 과정에서 동일한 특정을 갖는지 검증하는데 사용됩니다.

<br>

그래서 클래스 내부 구성이 수정될 경우, 기존에 직렬화한 SUID와 현재 클래스의 SUID 버전이 다르기 때문에,

이를 인지하고 InvalidClassException을 발생시켜 UID 값 불일치가 되는 현상을 미리 방지합니다.

<br>

단, 직렬화 스펙 상 **serialVersionUID**값 명시는 **필수가 아니며,** 만일 클래스에 SUID 필드를 명시하지 않는다면,

시스템이 런타임 시 클래스의 이름, 생성자 등과 같은 클래스 구조를 이용해 암호 해시함수를 적용해 자동으로 클래스 내부에 생성합니다.

<br>

예를 들어 다음 클래스를 직렬화 시켜 TestUser.ser 파일로 저장하고, 서비스에서 가져와 역직렬화 해 사용한다고 가정합니다.

```java
public class SerialVersionUIDTest implements Serializable {  
    private String name;  
    private int age;  
    private String address;  
}
```

<br>

이 클래스에 Email 필드를 추가해야 한다는 요구사항 명세가 왔고, email 필드를 추가하고 프로그램을 실행 시키면 아래와 같은 Exception이 발생합니다.

```
Exception in thread "main" java.io.InvalidClassException
serialVersionUID = 183812845818421, local class serialVersionUID = 9883287472372 // UID 값 불일치
```

<br>

앞선 예제들에서도 직렬화 클래스를 선언할 때 SUID 값을 생략했지만, 내부적으로는 식별번호가 생성되어 있어,

나중에 클래스를 수정하게 된다면 SUID 값도 변하게 되서 역직렬화 시 Exception이 발생하는 것입니다.

---

## 📘 직렬화 버전 수동 관리

만약 네트워크로 객체를 직렬화해서 전송하거나 할 경우, 수신자아 송신자  모두 같은 버전의 클래스를 가지고 있어야 합니다.

이 때 클래스에 조금의 변경사항이라도 있으면 모든 사용자에게 재 배포해야 하는 상황이 발생해 프로그램 관리가 어렵게 됩니다.

<br>

따라서 직렬화 클래스는 왠만한 상황에선 serialVersionUID를 직접 명시해주어 **Serial버전을 수동으로 관리**하는 것을 권장합니다.

SUID를 직접 명시해주면 클래스의 내용이 변경되어도, 내부적으로 자동 생성된 SUID 값으로 자동 변경되지 않습니다.

이외에도 런타임 시 SUID를 생성하는 시간도 무시 못하기 때문에 미리 명시하는걸 강력히 권장합니다.

<br>

**serialVersionUID**는 아래와 같이 `private static final` 제어자로 선언해야 하며 타입은 `long`입니다.

```java
public class SerialVersionUIDTest implements Serializable {  
    // serialVersionUID 명시  
    @Serial  
    private static final long serialVersionUID = 123L;  
      
    private String name;  
    private int age;  
    private String address;  
}
```

<br>

이제 SUID를 선언한 클래스를 직렬화하여 외부 파일로 추출하고,

email 필드를 클래스에 새로 추가한 다음, 역직렬화 해보면 email 필드는 알아서 null로 초기화 후 역직렬화에 성공하게 됩니다.

```
SerialVersionUIDTest{name='사람1', age=20, address='조선', email='null'}
```

<br>

이렇게 클래스 내에 **serialVersionUID**를 명시해주면, 내용이 바뀌어도 버전이 유지됨으로 인해,

필드가 매칭되지 않더라고 일단 역직렬화 동작 자체를 수행할 수 있게 됩니다.

<br>

> 📌 **SerialVersionUID 값 자동 생성하기**

serialVersionUID는 정수값이라 어떠한 값으로도 지정할 수 있지만, 단순한 값이면 중복 우려가 있습니다.

그래서 중복값을 갖지 않도록 serialVersion 값을 생성해주는 프로그램을 사용하는 것이 좋습니다.

JVM을 설치할 때 같이 설치되는 `serialver.exe`를 사용해서 생성된 값을 이용할 수 있지만 사용이 번거로우므로,

IntelliJ를 이용해 간단한 설정(클릭 한번)으로 SUID 값을 생성할 수 있습니다.

- IntelliJ Settings - `serializable` 검색
- JVM Languege - `Serializable class without serialVersionUID` 에 체크

위와 같이 설정하면, Serializable을 구현한 클래스명에 마우스 커서를 올려놓으면 SerialVersionUID 생성 버튼이 나옵니다.

<br>

> 📌 **SerialVersionUID 수동 관리 시 주의사항**

**serialVersionUID를 명시하는것이 만능은 아닙니다.**

위 예제들과 같이 단순히 필드 변수 하나 **추가** 정도는 문제가 없지만, 필드의 타입을 변경하면 버전을 수동 관리 해도 예외가 발생합니다.

<br>

예를 들어 특정 필드의 타입을 int -> long 으로 업데이트 하고 역직렬화를 해보면 `incompatible type` 에러가 발생합니다.

자바에서 직렬화를 사용할 때 예외가 발생하거나 주의 해야 하는 상황들 입니다.

1. 멤버 변수를 추가할 때 (영향 없음 - 기본값으로 설정)
2. 멤버 변수가 삭제될 때  (영향 없음)
3. 멤버 변수의 이름이 바뀔 때 (영향 없음 - 값이 할당되지 않음)
4. 멤버 변수의 접근 제어자 변경 (영향 없음)
5. 멤버 변수의 타입이 바뀔 때  (영향 있음)
6. 멤버 변수에 static 와 transient 추가  (영향 없음)

<br>

위의 주의 사항을 보면 **타입 변경**시에만 조심하면 될것 같지만, 

사실 직렬화를 사옹할땐 **자주 변경될 소지가 있는 클래스**의 객체는 그냥 직렬화 대신 다른 방법을 사용하는게 좋습니다.