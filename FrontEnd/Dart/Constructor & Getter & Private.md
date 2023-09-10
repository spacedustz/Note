**Java & Kotlin과 동일한 내용은 안쓰고 새로운 내용만 작성**

---

## Constructor

- 생성자를 만드는 2가지 방법이 있다.

```dart
class User {
    String name = '이름';
    
    // Constructor 1
    User(String name): this.name = name;
}
```

```dart
class User {
    String name = '이름';
    
    // Constructor 2
    User(this.name);
}
```

<br>

### Named Constructor

- `클래스명.붙이고 싶은 이름()`으로 Named Constructor를 생성할 수 있다.

```dart
void main() {
    User user = User.fromList(
    [
        ['a', 'b', 'c'],
        'd'
    ]);
}

class User {
    String name = '이름';
    List<String> members;
    
    // Named Constructor
    User.fromList(List values): this.members = values[0], this.name = values[1];
}
```

**만약 생성자나 변수에 `const` 키워드를 붙이면 같은 인스턴스로 간주한다.**

- `const` 키워드는 런타임 시 값을 모르면 컴파일 단계에서 에러.

---

## Getter / Setter

- Dart에서의 Getter는 다른 동작 없이 바로 `get` 키워드로 선언하면 된다.

```dart
void main() {
    // Getter 호출
    User.firstMember;
}

get firstMember {
    return this.members[0];
}

// 타입 명시
String get firstMember {
    return this.members[0];
}
```

<br>

- Dart에서의 Setter도 Getter와 비슷하다.
- 하지만, 다른 점은 **Setter의 파라미터는 무조건 1개만 들어가야하는 법칙이 존재한다.**

```dart
void main() {
    // Setter 호출
    User.firstMember = "바꿀이름";
}

set firstMember(String name) {}
```

---

## Private 속성

- 현재 **파일 내부에서만 사용 가능한 스코프를 지닌 키워드**이다.
- 외부에서 파일 전체를 불러오더라도 외부에서 사용이 불가능하게 만든다.
- 클래스나 변수, 함수 등을 Private으로 바꾸고 싶으면,
   이름의 맨 처음에 `_`언더스코어를 1개 붙여주면 된다.(ex: class _User)