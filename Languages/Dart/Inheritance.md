**Java & Kotlin과 동일한 내용은 안쓰고 새로운 내용만 작성**

---

## Inheritance

- 클래스 간 상속은 자바와 동일하게 extends를 사용한다.
- 상속 후 생성자에 `:`를 붙인 이유는 상위 클래스의 생성자에 Named Parameter를 썼기 떄문이다.

```dart
class Group {
    String name;
    int groupCounts;
    
    Group({
        required this.name,
        required this.groupCounts
    });
}

class BoyGroup extends Group {
    BoyGroup(
        String name, 
        int groupCounts
    ): super(name: name, 
            groupCounts = groupCounts);
}
```

---

## Interface

- Dart에서의 인터페이스 선언은 클래스 선언과 동일하게 `class` 키워드로 한다.
- 인터페이스의 인스턴스화를 막고 싶다면 `class` 키워드 앞에 `abstract` 키워드를 붙이면 된다.

```dart
// Interface
abstract class GroupInterface {
    String name;
    
    GroupInterface(this.name);
    
    void sayName() {}
}

// Implements
class BoyGroup implements GroupInterface {
    String name;
    
    BoyGroup(this.name);
    
    void sayName() {
        print('이름은 ${name}입니다.');
    }
}
```

---

## Generic

- 다른 프로그래밍 언어와 동일하다. (ex: Java)

```dart
void main() {
    Lecture<String> lec1 = Lecture('123', 'lec1');
    lec1.printIdType();
    
    Lecture<int> lec2 = Lecture(123, 'lec2');
    lec2.printIdType();
}

class Lecture<T> {
    final T id;
    final T name;
    
    Lecture(this.id, this.name);
    
    void printIdType() {
        print(id.runtimeType);
    }
}
```

