## 💡 코틀린에서 다양한 클래스를 다루는 법

목차

- Data Class
- Enum Class
- Sealed Class, Sealed Interface
- 정

---

## 💡 Data Class

클래스 뒤에 **data** 키워드를 붙여주면 아래 항목들이 포함된 클래스가 만들어진다.

- builder
- equals
- hashCode
- toString

<br>

계층간의 데이터를 전달하기 위한 DTO (Data Transfer Object)

- 데이터 (필드)
- 생성자와 Getter
- equals, hashCode, toString

```kotlin
data class PersonDTO(
    val name: String,
    val age Int
)
```

---

## 💡 Enum Class

추가적인 클래스르 상속받을 수 없다.

인터페이스는 구현할 수 있으며, 각 코드가 싱글톤으로 이루어져 있다.

```kotlin
enum calss Country(
    val code: String
) {
    KOREA("KO")
    AMERICA("US")
}
```

<br>

**when** 키워드는 Enum Class나 Sealed Class와 함께 사용할때 더욱 진가를 발휘한다.

<br>

**자바 코드 예시**

코드가 많아지게 된다면 else 로직 처리에 대한 애매함이 있다

```kotlin
// Java
private static void handleCountry(JavaCountry country) {
    if (country == JavaCountry.KOREA) {
        // 대충 로직
    }
    
    if (country == JavaCountry.AMERICA) {
        // 대충 로직
    }
}
```

<br>

**코틀린 코드 예시**

컴파일러가 country의 모든 타입을 알고있어, 다른 타입에 대한 로직(else)을 작성하지 않아도 된다.

Enum에 변화가 있으면 알 수 있다.

```kotlin
private fun handleCountry(country: Country) {
    when (country) {
        Country.KOREA -> TODO()
        Country.AMERICA -> TODO()
    }
}
```

---

## 💡 Sealed Class, Sealed Interface

컴파일 타임때 하위 클래스의 타입을 모두 기억한다.

즉, 런타임때 클래스 타입이 추가될 수 없다.

하위 클래스는 같은 패키지에 있어야 한다.

추상화가 필요한 Entity or DTO에 sealed class를 활용한다.

<br>

**Enum과 다른점**

- 클래스를 상속받을 수 있다.
- 하위 클래스는 멀티 인스턴스가 가능하다.

<br>

상속이 가능한 추상 클래스를 만들되, 외부에서는 이 클래스를 상속받지 못하게 하는 클래스 예시

```kotlin
sealed class HyundaiCar(
    val name: String,
    val price: Long
) {
    
    class Avante : HyundaiCar("아반떼", 1_000L)
    class Sonata : HyundaiCar("소나타", 2_000L)
    class Granduer : HyundaiCar("그랜저", 3_000L)
}
```

---

## 💡 정리

- Data Class는 equals, hashCode, tosTring을 자동으로 생성해준다.
- Enum Class는 Java와 동일하지만 when과 함께 사용하면 큰 장점이 있다.
- Sealed Class 역시 when과 함께 사용하면 큰 장점이 있다.

