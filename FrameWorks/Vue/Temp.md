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
Vue.createApp().component().mount()
```

컴포넌트는 기본적으로 Custom HTML 요소이고 2개의 파라미터를 받는다.

첫번쨰 파라미터는 식별자를 받으며, 무조건 `-` 과 두 단어로 이어진 Custom HTML Tag를 받는다.

그 이유는 기존의 HTML은 모두 한 단어로 이루어져 있기 떄문에 충돌을 방지하게 위해서이다.

<br>

두번째 파라미터는 객체를 받는다.

이 두번째 파라미터는 component()를 호출한 Vue 앱과 연결된다.