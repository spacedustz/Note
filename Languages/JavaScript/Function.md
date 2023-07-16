## Function

함수의 정의는 다른 언어들과 동일하기 때문에 기본적인 함수 설명은 생략

<br>

### 함수 파라미터 기본값 설정

Kotlin의 Default Parameter와 유사한 구조입니다.

파라미터가 2개 있는 함수에 1개의 파라미터만 전달하게 되면,

값을 할당받지 못한 파라미터는 Undefined 할당됩니다.

<br>

하지만 Undefined를 할당시키기 보다 함수를 선언할 때 기본값을 설정해주는게 더 좋습니다.

```javascript
function showMessage(from, text = "No Text Given") {
	alert(from + ": " + text);
}

showMessage("Kim"); // 결과값 : Kim: No Text Given
```

<br>

파라미터에 값을 전달해도 그 값이 Undefined와 `엄격히(Strict)` 일치한다면 기본값이 할당됩니다.

```javascript
showMessage("Kim", undefined); // Kim: No Text Given
```

<br>
파라미터 기본값에 함수를 넣을수도 있습니다.

아래 코드에서 text 파라미터에 값이 들어오지 않았을 경우 anotherFun의 반환값이 text의 값이 되도록 설정했습니다.

```javascript
function showMessage(from, text = anotherFun()) {
}
```

<br>

### 파라미터 기본값을 설정하는 또 다른 방법

개발을 하다보면 가끔 함수 선언 시가 아닌, 함수 선언 후 함수 내부에서 기본값을 설정하는 것이 적절한 경우가 있습니다.

이런 경우 함수를 호출할 때 파라미터를 Undefined와 비교하여 파라미터가 전달되었는지를 확인하면 됩니다.

- if 문을 사용한 방법
- || 연산자를 이용한 방법
- Nullish 병합 연산자를 이용한 방법

```javascript
/* if 문을 사용한 방법 */
funtion showMessage(text) {
	if (text === undefined) {
		text = '빈 문자열';
	}

	alert(text);
}

showMessage(); // 출력값 = 빈 문자열



/* || 연산자를 이용한 방법 */
funtion showMessage(text) {
	text = text || '빈 문자열';
}

showMessage(); // 출력값 = 빈 문자열



/* Nullish 병합 연산자를 이용한 방법 */
funtion showCount(count) {
	alert(count ?? "Unknown");
}

showCount(0); // 0
showCount(null); // Unknown
showCount() // Unknown
```

---

## 함수 표현식

자바스크립트는 함수를 특별한 종류의 값으로 취급합니다. 다른 언어에서처럼 "특별한 동작을 하는 구조"로 취급되지 않습니다.

즉 함수를 Expression(식)으로도 사용할 수 있다는 말이 됩니다.

아래 코드는 변수를 선언하는 것처럼 함수가 변수에 할당된 코드입니다.

```javascript
let sayHi = funtion() {
	alert("Hello");
};
```

<br>

#### 위 함수 표현식 끝에 ';'이 붙는 이유
-   `if { ... }`, `for { }`, `function f { }` 같이 중괄호로 만든 코드 블록 끝엔 `;`이 없어도 됩니다.
-   함수 표현식은 `let sayHi = ...;`과 같은 구문 안에서 값의 역할을 합니다. 코드 블록이 아니고 값처럼 취급되어 변수에 할당되죠. 모든 구문의 끝엔 세미 콜론 `;`을 붙이는 게 좋습니다. 함수 표현식에 쓰인 세미 콜론은 함수 표현식 때문에 붙여진 게 아니라, 구문의 끝이기 때문에 붙여졌습니다.

<br>

그리고 자바스크립트에서 함수는 값으로 표현될 수 있기 떄문에 함수의 코드 자체를 출력할 수도 있습니다.

```javascript
function sayHi() {
	alert("Hello");
}

alert(sayHi); // 함수 코드 출력
```

<br>

마지막 줄에서 `sayHi`옆에 괄호가 없기 때문에 함수는 실행되지 않습니다. 어떤 언어에선 괄호 없이 함수 이름만 언급해도 함수가 실행됩니다. 하지만 자바스크립트는 괄호가 있어야만 함수가 호출됩니다.

자바스크립트에서 함수는 값입니다. 따라서 함수를 값처럼 취급할 수 있습니다. 위 코드에선 함수 소스 코드가 문자형으로 바뀌어 출력되었습니다.

함수는 `sayHi()`처럼 호출할 수 있다는 점 때문에 일반적인 값과는 조금 다릅니다. 특별한 종류의 값이죠.

<br>

하지만 그 본질은 값이기 때문에 값에 할 수 있는 일을 함수에도 할 수 있습니다.

변수를 복사해 다른 변수에 할당하는 것처럼 함수를 복사해 다른 변수에 할당할 수도 있습니다.

```javascript
// 함수 생성
funtion sayHi() {
	alert("Hello");
}

let func = sayHi; // 함수 복사

func(); // 복사한 함수 실행, 출력값 : Hello
sayHi(); // 원래 함수도 정상 실행, 출력값 : Hello
```

<br>

1.  `(1)`에서 함수 선언 방식을 이용해 함수를 생성합니다. 생성한 함수는 `sayHi`라는 변수에 저장됩니다.
2.  `(2)` 에선 `sayHi`를 새로운 변수 `func`에 복사합니다. 이때 `sayHi` 다음에 괄호가 없다는 점에 유의하시기 바랍니다. 괄호가 있었다면 `func = sayHi()` 가 되어 `sayHi` _함수_ 그 자체가 아니라, _함수 호출 결과(함수의 반환 값)_ 가 `func`에 저장되었을 겁니다.
3.  이젠 `sayHi()` 와 `func()`로 함수를 호출할 수 있게 되었습니다.

---

## CallBack Function

함수를 값처럼 전달하는 예시, 함수 표현식에 관한 예시를 좀 더 살펴보겠습니다.

<br>

매개변수가 3개 있는 함수, `ask(question, yes, no)`를 작성해보겠습니다. 각 매개변수에 대한 설명은 아래와 같습니다.

- `question` = 질문
- `yes` = "Yes"라고 답한 경우 실행되는 함수
- `no` = "No"라고 답한 경우 실행되는 함수

<br>

함수는 반드시 `question(질문)`을 해야 하고, 사용자의 답변에 따라 `yes()` 나 `no()`를 호출합니다.

```javascript
function ask(question, yes, no) {
	if (confirm(question)) yes() 
	else no();
}

function showOk() { alert("동의합니다."); }
function showCnacle() { alert("취소하셨습니다."); }

ask("동의하십니까?", showOk, showCancle);
```

<br>

**함수 `ask`의 인수, `showOk`와 `showCancel`은 _콜백 함수_ 또는 _콜백_이라고 불립니다.**

함수를 함수의 인수로 전달하고, 필요하다면 인수로 전달한 그 함수를 "나중에 호출(called back)"하는 것이 콜백 함수의 개념입니다. 위 예시에선 사용자가 "yes"라고 대답한 경우 `showOk`가 콜백이 되고, "no"라고 대답한 경우 `showCancel`가 콜백이 됩니다.

<br>

아래와 같이 익명 함수와 함수 표현식을 사용하면 코드 길이가 짧아집니다.

익명 함수에 대한 설명은 생략하겠습니다.

```javascript
function ask(question, yes, no) {
	if (confirm(question)) yes()
	else no();
}

ask(
	"동의하십니까?",
	function() { alert("동의합니다."); },
	function() { alert("취소하셨습니다."); }
);
```