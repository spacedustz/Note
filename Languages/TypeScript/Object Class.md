### Object.keys

`Object.keys` 메서드는 주어진 객체의 자기 자신의 열거 가능한 속성들의 이름들을 배열로 반환합니다.

<br>

예시:

```ts
const obj = {     a: 1,     b: 2,     c: 3 };  const keys = Object.keys(obj); // ["a", "b", "c"]
```

<br>

타입스크립트에서는 `Object.keys`의 반환 타입이 `string[]`입니다. 그러나 종종 개발자들은 특정 객체의 키만 반환받기를 원할 수 있습니다. 이 경우 타입 단언을 사용할 수 있습니다.

```ts
const keys = Object.keys(obj) as (keyof typeof obj)[];
```

---
### Object.values

`Object.values` 메서드는 주어진 객체의 자기 자신의 열거 가능한 속성들의 값들을 배열로 반환합니다.

<br>

예시:

```ts
const obj = {     a: 1,     b: 2,     c: 3 };  const values = Object.values(obj); // [1, 2, 3]
```

타입스크립트에서는, `Object.values`가 반환하는 배열의 타입은 객체의 값들의 타입에 따라 결정됩니다. 만약 객체의 모든 값이 동일한 타입이면, 반환되는 배열의 타입도 그와 동일합니다.

<br>

### 주의 사항:

`Object.keys`와 `Object.values`는 객체의 자신의 속성만을 열거합니다. 이것은 프로토타입 체인에 있는 속성들은 열거하지 않는다는 의미입니다.

또한, 이 두 메서드는 주어진 객체의 속성이 열거 가능한 경우에만 작동합니다. `enumerable` 속성이 `false`로 설정된 객체의 속성은 반환되는 배열에 포함되지 않습니다.