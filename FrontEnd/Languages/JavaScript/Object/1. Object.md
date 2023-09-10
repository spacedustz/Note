## Object

자바스크립트에서 객체는 중괄호 `{…}`를 이용해 만들 수 있습니다. 

중괄호 안에는 ‘키(key): 값(value)’ 쌍으로 구성된 _프로퍼티(property)_ 를 여러 개 넣을 수 있는데,

`키`엔 문자형, `값`엔 모든 자료형이 허용됩니다. 프로퍼티 키는 ‘프로퍼티 이름’ 이라고도 부릅니다.

<br>

빈 객체를 만드는 2가지 방법이 있습니다.

- 객체 생성자 문법
- 객체 리터럴 문법

```javascript
let user = new Object(); // 객체 생성자
let user = {}; // 객체 리터럴
```

<br>

보통 객체 선언 시 리터럴 {...} 을 사용합니다.

---

## Literal & Property

자바스크립트의 객체 내부 {...} 안의 프로퍼티들은 Json 처럼 `키 : 값` 쌍으로 구성된 프로퍼티가 들어갑니다.

```javascript
let user = {
	name: "Kim",
	age: 20
};

// 객체 프로퍼티 값 출력
alert(user.name);
alert(user.age);
```

<br>

### Property 삭제

`delete` 연산자를 사용해 객체의 프로퍼티를 삭제할 수 있습니다.

```javascript
delete user.age;
```

<br>

### 여러 단어를 조합한 Property 선언

여러 단어를 조합해 프로퍼티 이름을 만든 경우 프로퍼티 이름을 `""`로 묶어주어야 합니다.

그리고, 여러 단어를 조합한 프로퍼티를 제어할때 **대괄호 표기법**을 사용해야 합니다.

```javascript
let user = {
	name: "Kim",
	age: 20,
	"likes birds": true
}

/* 여러 단어를 조합한 프로퍼티 제어 */
user.["likes birds"] = true; // set property
alert(user["likes birds"]);  // get property
delete user["likes birds"];  // delete property
```

<br>
**변수를 Key로 사용할 수도 있습니다.**

아래 코드의 변수 key는 런타임 시 평가되기 때문에 사용자 입력값 변경 등에 따라 값이 변경될 수 있습니다.

```javascript
let key = "likes birds";

// user["likes birds"] = true 와 같다.
user[key] = true;
```

<br>

어떤 경우든, 평가가 끝난 이후의 결과가 프로퍼티 키로 사용됩니다.

이를 응용하면 코드를 유연하게 작성할 수 있습니다. (점 표기법은 이런 방식 불가능)

```javascript
let user = {
	name: "Kim",
	age: 20
};

let key = prompt("사용자의 어떤 정보를 알고 싶으신가요?", "name");

// 변수로 접근
alert(user[key]); 
```

<br>

**계산된 프로퍼티**

객체를 만들 때 객체 리터럴 안의 프로퍼티 키가 대괄호로 둘러쌓여 있는 경우,

이를 계산된 프로퍼티(Computed Property)라고 부릅니다.

아래 코드는 변수 fruit에서 프로퍼티 이름을 동적으로 받아옵니다.

사용자가 프롬프트 대화상자에 `apple`을 입력했다면 `bag`엔 `{apple: 5}`가 할당되었을 겁니다.

```javascript
let fruit = prompt("어떤 과일을 구매하시겠습니까?", "apple");

let bag = {
	[fruit]: 5
}

// frult 변수에 apple이 할당되었다면 숫자 5 출력
alert(bag.apple);
```

<br>

**단축 프로퍼티**

실무에선 프로퍼티 값을 기존 변수에서 받아와 사용하는 경우가 종종 있습니다.

```javascript
function makeUser(name, age) {
	return {
		name, age
	};
}

let user = makeUser("Kim", 20);
alert(user.name);
```

<br>

한 객체에서 일반 프로퍼티와 단축 프로퍼티를 함께 사용하는 것도 가능합니다.

```javascript
let user = {
	name, // name = name 과 같음
	age: 20
};
```

---

## Const Object 수정

`const`로 선언된 객체는 수정될 수 있습니다. 기본적으로 `const`는 불변 변수를 선언할 때 사용하지만,

객체 그 자체의 값은 고정하지만 객체의 내용은 고정하지 않습니다.

```javascript
const user = {
	name: "Kim"
};

user.name = "Lee";

alert(user.name) // 정상 출력
```

---

## 'in' 연산자를 이용한 Property 존재 여부 확인

다른 언어와 달리 자바스크립트는 존재하지 않는 프로퍼티에 접근하려고 하면 에러가 발생하는게 아닌 `Undefined`를 반환합니다.

이런 특징을 응용하면 프토퍼티 존재 여부를 쉽게 확인할 수 있습니다.

```javascript
let user = {};

// true는 '프로퍼티가 존재하지 않음'을 의미합니다.
alert(user.noSuchProperty === undefined);
```

<br>

문법은 다음과 같습니다.

```javascript
"key" in object
```

<br>

예시:

```javascript
let user = { name: "Kim", age: 20 };

alert("age" in user); // true
alert("blabla" in user); // false
```

<br>

**그럼 ``===`를 활용한 undefined 비교만해도 충번한데 왜 `in` 연산자를 사용할까요?**

대부분의 경우, 일치 연산자를 사용해서 프로퍼티 존재 여부를 알아내는 방법(`"=== undefined"`)은 꽤 잘 동작합니다. 

그런데 가끔은 이 방법이 실패할 때도 있습니다. 이럴 때 `in`을 사용하면 프로퍼티 존재 여부를 제대로 판별할 수 있습니다.

<br>

프로퍼티는 존재하는데, 값에 `undefined`를 할당한 예시를 살펴봅시다.

```javascript
let obj = { test: undefined };

alert(obj.test); // undefined
alert("test" in obj); // true
```

<br>

위 코드에서 `in`을 사용해 프로퍼티 존재유무를 확인하고 있고, 만약 obj 객체에 test 프로퍼티가 없으면 false가 반환되었을 겁니다.

그런데 undefined라는 값이 들어가도 결국 프로퍼티가 존재하니까 true가 반환되는걸 볼 수 있습니다.

`undefined`가 출력되는 경우 중 하나는, 변수는 정의되었으나 값이 할당되지 않은 경우에 출력됩니다.

이 예시의 경우는 값 자체가 `undefined`이기 떄문에 `obj.test` 출력 시 `undefined`가 출력됩니다.

---

## For..In

Kotlin의 반복문과 동일하므로 설명은 생략하고 사용법만 적습니다.

```javascript
let user = {
	name: "Kim",
	age: 20,
	isAdmin: true
};

for (let key in user) {
	alert(key); // 출력값 : name, age, isAdmin
	alert(user[key]); // 출력값: Kim, 20, true
}
```

---

## 객체 정렬 방식

객체와 객체 프로퍼티를 다루다 보면 "프로퍼티엔 순서가 있을까?"라는 의문이 생기기 마련입니다. 반복문은 프로퍼티를 추가한 순서대로 실행될지, 그리고 이 순서는 항상 동일할지 궁금해지죠.

<br>

답은 간단합니다. 객체는 '특별한 방식으로 정렬’됩니다. 정수 프로퍼티(integer property)는 자동으로 정렬되고, 그 외의 프로퍼티는 객체에 추가한 순서 그대로 정렬됩니다. 자세한 내용은 예제를 통해 살펴봅시다.

<br>

아래 객체엔 국제전화 나라 번호가 담겨있습니다.

```javascript
let codes = {
	"49": "독일",
	"41": "스위스",
	"44": "영국",
	"1": "미국"
};

for (let code in codes) {
	alert(code); // 출력 순서 : 1, 41, 44, 49
}
```

<br>

현재 개발 중인 애플리케이션의 주 사용자가 독일인이라고 가정해 봅시다. 나라 번호를 선택하는 화면에서 `49`가 맨 앞에 오도록 하는 게 좋을 겁니다.

<br>

그런데 코드를 실행해 보면 예상과는 전혀 다른 결과가 출력됩니다.

- 미국(1)이 첫 번째로 출력됩니다.
- 그 뒤로 스위스(41), 영국(44), 독일(49)이 차례대로 출력됩니다.

<br>

이유는 나라 번호(키)가 정수이어서 `1, 41, 44, 49` 순으로 프로퍼티가 자동 정렬되었기 때문입니다.

<br>

> **정수 프로퍼티란?**

변형 없이 정수에서 왔다 갔다 할 수 있는 문자열을 의미합니다.

문자열 "49"는 정수로 변환하거나 변환한 정수를 다시 문자열로 바꿔도 변형이 없기 때문에 정수 프로퍼티입니다. 

하지만 '+49’와 '1.2’는 정수 프로퍼티가 아닙니다.

아래 예시에서 Math.trunc는 소수점 아래는 버리고 숫자의 정부수만 반환하며,

1,2번쨰는 정수 프로퍼티지만 3번째는 정수 프로퍼티가 아닙니다.

```javascript
alert(String(Math.trunc(Number("49"))) ); // '49' 출력
alert(String(Math.trunc(Number("+49"))) ); // '49' 출력
alert(String(Math.trunc(Number("1.2"))) ); // '1' 출력
```

<br>

위 예시에서 49를 가장 위에 출력되도록 하려면 나라 번호가 정수로 취급되지 않도록,

각 나라 번호 앞에 `"+49"` 처럼 `+`를 붙여주고 출력을 할때에도 alert 함수 내부 인자에 `+`를 붙여주면 됩니다.