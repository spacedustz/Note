## reduce()

`reduce`는 배열의 메서드로, 배열의 각 요소를 순회하며 주어진 리듀서 함수를 적용하여 배열을 단일 값으로 줄입니다. 

`reduce`는 배열의 누적 처리 작업에 매우 유용하며, 복잡한 데이터 구조의 변환, 집계, 누적 등에 사용됩니다.

<br>

```ts
array.reduce(callback(accumulator, currentValue[, index[, array]])[, initialValue])
```

- **callback**: 배열의 각 요소에 대해 실행할 함수.
    - **accumulator**: 누산기. 콜백의 반환 값은 누산기에 할당되며 다음 순회에 전달됩니다.
    - **currentValue**: 처리할 현재 요소.
    - **index** (선택적): 처리할 현재 요소의 인덱스.
    - **array** (선택적): `reduce`를 호출한 배열.
- **initialValue** (선택적): `accumulator`의 초기값. 주어지지 않은 경우 배열의 첫 번째 요소가 초기값으로 사용됩니다.

<br>
### 예시:

배열의 모든 수를 합산:

```ts
const numbers = [1, 2, 3, 4, 5]; const sum = numbers.reduce((acc, cur) => acc + cur, 0); console.log(sum); // 15
```

<br>

배열의 요소별 출현 횟수 카운트:

```ts
const fruits = ["apple", "banana", "apple", "orange", "banana"];  
const count = fruits.reduce((acc, fruit) => {  
  acc[fruit] = (acc[fruit] || 0) + 1;  
  return acc;  
}, {});  
  
console.log(count);  // { apple: 2, banana: 2, orange: 1 }
```

<br>

### 주의 사항:

- `initialValue`를 제공하지 않으면 `reduce`는 배열의 두 번째 요소부터 시작합니다. 이 때, 첫 번째 요소가 `accumulator`의 초기값으로 사용됩니다. 배열이 비어 있으면 오류가 발생하므로 항상 초기값을 제공하는 것이 안전합니다.
- `reduce`는 배열의 요소를 왼쪽에서 오른쪽으로 처리합니다. 오른쪽에서 왼쪽으로 처리하려면 `reduceRight`를 사용하세요.