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

모든 방법에 대해 알아야 하기 때문에 이번 