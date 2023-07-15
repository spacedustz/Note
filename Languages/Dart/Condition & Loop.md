**Java & Kotlin과 동일한 내용은 안쓰고 새로운 내용만 작성**

---

## If & Switch

- If문은 자바와 동일하다.
- Switch문도 Java와 같이 case: , default 동일하게 사용한다.

---

## Loop

### For

- 자바의 For문과 코틀린의 in For문 둘 다 가능하다.

```dart
List<int> numbers = [1, 2, 3, 4, 5]

for (int i=0; i< numbers.length; i++) {
  total += numbers[i]
}

for (int number in numbers) {
  total += number;
}
```

<br>

### While

- While, do-While 모두 자바와 동일하다.

---

## Break & Continue

- 다른 언어와 동일하다.

---

## Enum

- Enum도 자바와 동일하다.

```dart
enum Status{a,b,c}
```

