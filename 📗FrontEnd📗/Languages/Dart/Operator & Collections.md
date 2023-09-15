**Java & Kotlin과 동일한 내용은 안쓰고 새로운 내용만 작성**

---

## Operator

- 일반 연산자 & 복합대입 연산자 모두 자바&코틀린과 동일하다.
- 타입 비교 시, 코틀린과 같이  `is` 키워드를 사용한다.
- 그 반대는 `is!` 로 사용한다.
- 논리 연산자도 타 언어와 동일하다.

---

## List

- 타 언어와 대부분 동일하다.
- List<int> 처럼 Primitive Type을 넣어 사용도 가능함
- 리스트 인덱싱도 동일하다.

```dart
List<int> list = [1, 2, 3, 4, 5]
```

---

## Map

- Map의 Key에 해당하는 Value 값 가져오기 -> `map[Key]`
- 값을 넣을때는 put()을 쓰지 않고 바로 `map[새로 넣을 Key] = 새로 넣을 값`으로 넣는다.
- 값을 변경할때도 `map[변경할 Key] = 새로 넣을 값`으로 값을 수정할 수 있다.
- 값을 지울때는 `map.remove(Key 값)`으로 지우기가 가능하다.
- `keys`, `values`를 통해 키 값만 가져오거나, 값만 가져올 수 있다.

```dart
Map<String, String> map = {
  'A' : 'a',
  'B' : 'b'
};
```

---

## Set

- add(), remove().contains() 등도 동일하다.

```dart
final Set<String> names = {
  'Code Factory',
  'Flutter'
}
```

