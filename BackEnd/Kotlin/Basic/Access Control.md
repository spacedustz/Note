## 💡 코틀린에서 접근 제어를 다루는 법

목차

- 가시성 제어
- 코틀린 파일의 접근 제어
- 다양한 구성요소의 접근 제어
- 자바와 코틀린을 함께 사용할 경우 주의점
- 정리

---

## 💡 가시성 제어

자바의 기본 접근 지시어는 Default 이지만, 코틀린은 public인걸 조심하자.

<br>

public

- 모든곳에서 접근 가능

protected

- 선언된 클래스 또는 하위 클래스에서만 접근 가능

internal

- 같은 모듈에서만 접근 가능

private

- 선언된 클래스 내에서만 접근 가능

---

## 💡 파일 접근 제어

코틀린은 .kt 파일에 변수, 함수, 클래스 여러개를 바로 만들 수 있다.

<br>

public

- 기본값, 어디서든 접근 가능

protected

- 파일(최상단)에는 사용 불가능

internal

- 같은 모듈에서만 접근 가능

private

- 같은 파일 내에서만 접근 가능

---

## 💡 다양한 구성요소의 접근 제어

클래스, 생성자, 프로퍼티에 대한 접근 제어

<br>

### 클래스 안의 멤버 접근 제어 범위

public

- 모든 곳에서 접근 가능

protected

- 선언된 클래스 또는 하위 클래스에서만 접근 가능

internal

- 같은 모듈에서만 접근 가능

private

- 선언된 클래스 내에서만 접근 가능

<br>

### 생성자

생성자도 가시성 범위는 동일하다 하지만,

**생성자에 접근지시어를 붙이려면 'constructor' 키워드**를 붙여야 한다.

```kotlin
class Bus internal constructor(
    val price: Int
)
```

<br>

자바에서 유틸성 코드를 작성할때 abstract class + private constructor를 이용해 인스턴스화를 막는데 자주 사용했다.

코틀린에서도 비슷하게 가능하지만, 파일 최상단에 바로 유틸 함수를 작성하면 더 편하다.

```java
// Java
public abstract class StringUtils {
    private StringUtile() {}
    
    public boolean isDirectoryPath(String path) {
        return path.endsWith("/");
    }
}
```

```kotlin
// Kotlin
fun isDirectoryPath(path: String): Boolean {
    return path.endsWith("/")
}
```

<br>

### 프로퍼티

getter, setter 한번에 접근 지시어를 정하거나, setter에만 추가로 가시성을 부여할 수 있다.

```kotlin
class Car(
    internal val name: String,
    _price: Int
) {
    var price = _price
    private set
}
```

---

## 💡 자바와 코틀린을 함께 사용할 경우 주의점

internal은 바이트코드 상 public이 되므로 Java에서 Kotlin 모듈의 internal 코드를 가져올 수 있다.

Kotlin과 Java의 protectec는 다르다, Java는 같은 패키지의 Kotlin protected 멤버에 접근이 가능하다.

---

## 💡 정리

- kotlin에서 패키지는 namespace 관리용이기 때문에 protected는 의미가 달라졌다.
- kotlin에서는 default가 사라지고 모듈 간 접근을 통제하는 internal이 새로 생겼다.
- 생성자에 접근 지시어를 붙일때는 **constructor**를 명시적으로 써주어야 한다.
- 유틸성 함수를 작성할 때 파일 최상단을 이용하면 편리하다.
- 프로퍼티의 custom setter에 접근 지시어를 붙일 수 있다.
- 자바에서 코틀린 코드를 사용할 때 internal과 protected는 주의해야 한다.
