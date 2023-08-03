## Vue LifeCYcle

> Create

1. createApp({})
2. beforeCreate()
3. created() - 4번으로 가는 과정 사이에서 템플릿 컴파일이 일어남
4. beforeMount()
5. mounted() - 이때부터 화면에 보이기 시작
6. Mounted Vue Instance

<br>

> If Data Changed

1. beforeUpdate()
2. updated()

<br>

> Unmount

1. beforeUnmount()
2. unmounted()

---
## Vue Hooks

이 Hook들은 Vue 앱의 데이터 객체 내부에서 사용 가능하다.

> Create

- beforeCreate()
- created()
- beforeMount()
- mounted() - 이때부터 Vue 앱이 화면에 마운트됨, 내부적 초기화, 데이터 처리 완료

<br>

> Update

- beforeUpdate()
- updated() - 이때부터 변경사항이 반영

<br>

> Unmount

- beforeUnmount()
- unmounted()

---

## Vue Component

```javascript
Vue.createApp({
	data() ...
	
}).component('second-app', {
	data() ...
	template: `
		HTML 코드 복붙
		`

}).mount()
```

컴포넌트는 기본적으로 Custom HTML 요소이고 2개의 파라미터를 받는다.

첫번쨰 파라미터는 식별자를 받으며, 무조건 `-` 과 두 단어로 이어진 Custom HTML Tag를 받는다.

그 이유는 기존의 HTML은 모두 한 단어로 이루어져 있기 떄문에 충돌을 방지하게 위해서이다.

<br>

두번째 파라미터는 객체를 받는다.

이 두번째 파라미터는 component()를 호출한 Vue 앱과 캡슐화가 되고, 서로 통신을 하지 않기 떄문에 동일한 프로퍼티가 있어도 충돌이 나지 않는다.

<br>

그리고 이 컴포넌트도 결국 새로운 Vue App이기 때문에 당연히 자체 템플릿도 마운트 해줘야 합니다.

메인 Vue에서 사용하던 HTML 템플릿을 전부 가져와서 template의 백틱 사이에 복붙해줍니다.

그리고 다시 HTML로 가서 컴포넌트의 식별자인 `<second-app></second-app>`을 넣어주면 됩니다.

<br>

이제 저 커스텀 태그로 인해 수 많은 미니 Vue App의 복제와 캡슐화를 할 수 있습니다.

하지만 위처럼 문자열 형식으로 템플릿을 작성하는 것은 좋지 않습니다.

모든 방법에 대해 알아야 하기 때문에 이번 방법을 알아보았습니다.

<br>

이렇게 컴포넌트의 기본적인 사용법을 배웠지만 앞으로 컴포넌트 부분에서 학습할 것이 더 많습니다.

---

## 여러 App과 Component

HTML 페이지의 여러 독립적은 부분을 제어하는 여러 Vue App으로 작업하는 경우, `createApp()`을 여러번 호출하여 여러앱을 만듭니다.

반면, SPA로 구축하는 경우 일반적으로 하나의 **Root App**으로 작업하고 여러 컴포넌트로 UI를 구축합니다.

<br>

왜일까요?

<br>

**Vue 앱은 서로 독립적**이므로 **서로 통신할 수 없기 때문**입니다. 

통신할 수 있게 하는 비공식적인 방법이 존재할 수 있지만, 앱 간에 데이터를 공유하고 

앱 B에서 문제가 발생하는 경우 앱 A에서 업데이트하는 마땅한 공식적인 방법이 없습니다.

<br>

반면에 곧 배우게 될 **컴포넌트**는 컴포넌트 간에 데이터를 교환할 수 있는 **특정 통신 메커니즘을 제공**합니다. 

따라서 여러 컴포넌트를 포함하는 하나의 루트 앱으로 작업하는 경우 하나로 연결된 UI를 구축할 수 있다는 것을 곧 학습으로 알 수 있습니다.

---

## Vue Props

같은 컴포넌트를 사용할 때 서로 다른 데이터를 출력하기 위한 개념이자 일종의 Custom HTML 속성이다.

Vue App에 Props를 정의할 때는 카멜케이스, HTML내 Custom Tag에 Props를 정의할떈 케밥케이스 (- 를 이용함)를 사용한다.

Props는 Data 프로퍼티와 동일하게 취급되며 배열을 값으로 가진다.

```javascript
props: [
	'name',
	'phoneNumber',
	'emailAddress'
]
```

<br>

```html
<friend-contact name="a" phone-number="1" email-address="a@a.com"></friend-contact>
<friend-contact name="b" phone-number="2" email-address="b@b.com"></friend-contact>
```

<br>

또, Props는 Immutable하기 때문에 단방향 데이터 플로우에 위반하면 Vue App이 실행되지 않습니다.

즉, Custom HTML Tag에서 데이터를 변경하면 안되고 부모인 Vue App에서 변경 후 Custom HTML 로 반영해야 합니다.

그러기 위해선 Data 프로퍼티를 만들어서 초기값을 Props의 프로퍼티로 지정 후