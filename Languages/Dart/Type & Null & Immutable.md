## Java와 비슷한 점

### Type

- 문장 끝에 `;`를 붙인다.
- 타입을 명시할 때 타입 먼저 명시하는 점이 비슷하다.

<br>

### Immutable

- 불변 선언 키워드를 `final, const`로 사용하고 타입 생략이 가능하다. (var의 역할도 한다는 의미)

---

## Kotlin과 비슷한 점

### Type

- 타입 추론 키워드인 `var`를 사용 가능하다.
- `${}`로 변수를 넣을 수 있다.

<br>

### Null

- `?`를 활용한 Nullable 처리가 동일하다.
- `!`를 활용한 Non-Nullable 사용, 코틀린은 `!!` 인것과 비교해도 비슷하다.

---

## 새로 알아야 할 점

### Type

- Boolean값은 bool 타입으로 선언한다.
- String 타입의 변수는 `' '`으로 감싼다.
- runtimeType()으로 해당 타입을 반환한다.
- `dynamic` 타입 존재, var과 비슷하지만 변수의 타입 자동변환도 가능하다.

<br>

### Null

- `??=` 키워드는 값이 Null일때 오른쪽 값으로 대입하겠다는 의미이다.

<br>

### Immutable

- `final, const` 키워드는 불변을 선언할 때 사용한다.
- `final`은 컴파일 타임에 값을 몰라도 되지만, `const`는 컴파일 타임 시 값을 알고 있어야 한다.

<br>

### Date

- DateTime.now() 사용