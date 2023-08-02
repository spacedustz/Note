## Vue LifeCYcle

1. createApp({})
2. beforeCreate()
3. created() - 4번으로 가는 과정 사이에서 템플릿 컴파일이 일어남
4. beforeMount()
5. mounted() - 이때부터 화면에 보이기 시작
6. Mounted Vue Instance

<br>

## If Data Changed

1. beforeUpdate()
2. updated()

<br>

## Instance Unmounted

1. beforeUnmount()
2. unmounted()

---
## Vue Hooks

- beforeCreate()
- created()
- beforeMount()
- mounted() - 이때부터 Vue 앱이 화면에 마운트됨