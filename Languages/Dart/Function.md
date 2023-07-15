**Java & Kotlin과 동일한 내용은 안쓰고 새로운 내용만 작성**

---

## Function

반환 타입이 없는 `void`와 함수의 반환 타입을 명시해야 하는 점은 자바와 동일하다.

<br>

Dart 함수에서 사용가능한 기능들

- Optional Parameter
- Named Parameter
- Arrow Function
- typedef 키워드

---

### Optional Parameter

- **Optional Parameter**라는 개념은 파라미터에 `[ ]`로 감싸줌으로써 Builder의 역할을 한다.
- `[ ]`안에 `?`를 넣어줌으로써 Nullable 처리를 할 수 있는데 아래 예시는 int 예시이다.
- 그러므로 `[ ]` 안에 Default 값을 넣어줌으로써 해결할 수 있다.
- 아래 Optional Parameter의 예시를 보자.

```dart
void main() {}
  addNumbers(10);
  addNumbers(20);
}

// Optional Parameter를 사용한 함수
addNumbers(int x, [int y = 20, int z = 30]) {
  int sum = x + y + z;
  print(sum);
}
```

<br>

### Named Parameter

- 이름이 있는 파라미터 (순서가 중요하지 않다.)
- Named Parameter가 있는 함수 호출 시 `x: 10` 처럼 호출이 가능하다.
- 순서가 바뀌어도 동일하게 작동한다.

```dart
void main() {
  addNumbers(x: 10, y:20, z:30);
  addNumbers(z:1, x:2, y:3);
}

addNumbers({required int x, required int y, required int z}) {
  int sum = x + y + z;
  print(sum);
}
```

- Named Parameter 함수에 Optional Parameter를 같이 사용하는 법은 간단하다.
- 파라미터에 `required` 키워드만 빼주면 된다.

```dart
addNumbers(
  {required int x, required int y, int z}) {
  int sum = x + y + z;
  print(sum);
}
```

<br>

### Position & Named & Optional Parameter 같이 사용

```dart
addNumbers(int x, {required int y, int z = 30}) {
  int sum = x + y + z;
  print(sum);
}
```

<br>

### Arrow Function

함수 Body를 안쓰고 바로 `=>` 키워드로 리턴되는 값의 식을 써줬다.

```dart
int addNumbers(int x, {required int y, int z = 30}) => x + y + z;
```

<br>

### typedef

- 리턴 타입과 파라미터의 시그니처가 같은 함수
- 동일한 기능의 다양한 함수들의 블루프린트 같은 역할을 한다. (개인적인 생각)

```dart
void main() {
  // 결과값 : 60
  Operation operation = add;
  int result = opration(10, 20, 30);
  print(result);
  
  // 결과값 : -40
  operation = sub;
  int result2 = opration(10, 20, 30);
  print(result2);
}

// Opration 타입의 typedef 함수 선언
typedef Operation = int Function(int x, int y, int z);

// 리턴 타입과 파라미터의 시그니처가 같은 함수 1
int add(int x, int y, int z) => x + y + z;

// 리턴 타입과 파라미터의 시그니처가 같은 함수 1
int sub(int x, int y, int z) =? x - y - z;
```

- 위의 방법보다 보통 파라미터에 typedef를 넣어 사용한다.

```dart
int calculate(int x, int y, int z, Operation operation) {
  return operation(x, y, z);
}
```

