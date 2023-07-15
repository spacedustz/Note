## **💡 Annotation**

- 컴파일러에게 문법 에러를 체크하도록 정보 제공
- 프로그램 빌드 시 코드 자동 생성할수 있도록 정보 제공
- 런타임에 특정 기능 실행하도록 정보 제공

<br>

**표준 Annotation**

자바에서 기본적으로 제공하는 애너테이션입니다.

<br>

| Annotation Name      | Description                                        |
| -------------------- | -------------------------------------------------- |
| @Override            | 컴파일러에게 메서드를 오버라이딩하는 것이라고 알림 |
| @Deprecated          | 앞으로 사용하지 않을 대상을 알릴 때 사용           |
| @FunctionalInterface | 함수형 인터페이스라는 것을 알                      |
| @SuppressWarning     | 컴파일러가 경고메세지를 나타내지 않음              |

<br>

**메타 Annotation**

애너테이션에 붙이는 애너테이션으로, 애너테이션을 정의하는 데에 사용됩니다.

<br>

| Annotation Name | Description                                             |
| --------------- | ------------------------------------------------------- |
| @Target         | 애너테이션을 정의할 때 적용 대상을 지정하는데 사용한다. |
| @Documented     | 애너테이션 정보를 javadoc으로 작성된 문서에 포함시킨다. |
| @Inherited      | 애너테이션이 하위 클래스에 상속되도록 한다.             |
| @Retention      | 애너테이션이 유지되는 기간을 정하는데 사용한다.         |
| @Repeatable     | 애너테이션을 반복해서 적용할 수 있게 한다.              |

<br>

**Custom Annotation**

사용자가 직접 정의하는 애너테이션입니다.

------

### **표준 Annotation**  

**@Override**

메소드 앞에만 붙일수 있는 에너테이션
선언한 메소드가 상위클래스의 메소드를 오버라이딩하는 메소드라는것을 컴파일러에게 전
에러를 발생시켜서 휴먼에러 방지

<br>

**@Deprecated**

오래된 JDK 버전으로 인해 사용안하는 필드&메소드를 사용하지 않는 것을 권장표시

<br>

**@SuppressWarnings()**

컴파일 에러메시지 표시X

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java69.png)

<br>

**@FunctionalInterface**

- 함수형 인터페이스를 선언할때, 컴파일러가 선언이 잘되었는지 확인
- 함수형 인터페이스는 단 하나의 추상메소드만 가져야하는 제약이 있음
- 이걸 붙이지 않아도 함수형 인터페이스 선언이 가능하지만 휴먼에러 방지&확인용 Annotation임

```java
@FunctionalInterface
public interface Runnable {
	public abstract void run (); // 하나의 추상 메서드
}
```

------

### **메타 Annotation (**root Annotation)

<br>

**@Target**

적용할 대상 지정, java.lang.annotation.ElementType 열거형에 정의되어 있음

<br>

| ANNOTATION_TYPE | 애너테이션                       |
| --------------- | -------------------------------- |
| CONSTRUCTOR     | 생성자                           |
| FIELD           | 필드(멤버변수, 열거형 상수)      |
| LOCAL_VARIABLE  | 지역변수                         |
| METHOD          | 메서드                           |
| PACKAGE         | 패키지                           |
| PARAMETER       | 매개변수                         |
| TYPE            | 타입(클래스, 인터페이스, 열거형) |
| TYPE_PARAMETER  | 타입 매개변수                    |
| TYPE_USE        | 타입이 사용되는 모든 대상        |

```java
import static java.lang.annotation.ElementType.*; 
//import문을 이용하여 ElementType.TYPE 대신 TYPE과 같이 간단히 작성할 수 있습니다.

@Target({FIELD, TYPE, TYPE_USE})	// 적용대상이 FIELD, TYPE
public @interface CustomAnnotation { }	// CustomAnnotation을 정의

@CustomAnnotation	// 적용대상이 TYPE인 경우
class Main {
    
		@CustomAnnotation	// 적용대상이 FIELD인 경우
    int i;
}
```

<br>

**@Documented**

- Annotation에 대한 정보가 javadoc으로 작성한 문서에 포함되도록 설정
- java에서 제공하는 표준&메타 Annotation중 @Override , @SuppressWarnings 를 제외, 전부 @Documented 적용

```java
@Documented
@Target(ElementType.Type)
public @interface CustomAnnotation { }
```

<br>

**@Inherited**

- 하위 클래스가 Annotation을 상속받도록 함
- 상위 클래스에 붙이면, 하위 클래스도 상위에 붙은 Annotation들과 동일하게 적용됨

```java
@Inherited // @SuperAnnotation이 하위 클래스까지 적용
@interface SuperAnnotation{ }

@SuperAnnotation
class Super { }

class Sub extends Super{ } // Sub에 애너테이션이 붙은 것으로 인식
```

<br>

**@Retention**

- Annotation의 지속시간 결정
- 관련한 유지정책의 종류에는 아래 3가지가 있다

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java68.png) 

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE) 
//오버라이딩이 제대로 되었는지 컴파일러가 확인하는 용도 
//클래스 파일에 남길 필요 없이 컴파일시에만 확인하고 사라짐
public @interface Override(){ }
```

위의 예제에서 Override 애너테이션은 컴파일러가 사용하면 끝나기 때문에, 실행 시에는 더이상 사용되지 않음을 의미함

<br>

**@Repeatable**

Annotation을 여러번 붙일수 있도록 허용

```java
@Repeatable(Works.class) // ToDo 애너테이션을 여러 번 반복해서 쓸 수 있게 한다.  
@interface Work{  
    String value();  
}
```

<br>

사용자 타입의 애너테이션 ToDo 를 정의하고, @Repeatable 애너테이션을 사용하여 이것을 여러번 사용할 수 있도록 함

```java
@Work("코드 업데이트")  
@Work("메서드 오버라이딩")  
class Main{  
	... 생략 ...
}
```

<br>

위와 같이 일반적인 애너테이션과 다르게 ToDo 애너테이션을 하나의 대상에 여러번 적용하는 것이 가능함

```java
@interface Works {  // 여러개의 ToDo애너테이션을 담을 컨테이너 애너테이션 ToDos
    Work[] value(); 
}

@Repeatable(Works.class) // 컨테이너 애너테이션 지정 
@interface Work {
	String value();
}
```

일반적인 애너테이션과 달리 같은 이름의 애너테이션이 여러번 적용될 수 있기 때문에,
이 애너테이션들을 하나로 묶어주는 애너테이션도 별도로 작성

<br>

### **Custom Annotation**

```java
@interface 애너테이션명 { // 인터페이스 앞에 @기호만 붙이면 애너테이션을 정의할 수 있습니다. 
	타입 요소명(); // 애너테이션 요소를 선언
}
```

한 가지 유의할 점은,애너테이션은 java.lang.annotation 인터페이스를 상속받기 때문에 
다른 클래스나 인터페이스를 상속 받을 수 없다