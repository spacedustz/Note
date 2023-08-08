## Vue 3 Composition API

지금까지 배운 Option API에서는 data, methods, computed property, watcher등을 사용했습니다.

Composition API란 컴포넌트를 작성하는 2가지 방법 중 하나일뿐 Option API 보다 무조건 좋은건 아닙니다.

<br>

**Composition API를 사용하는 이유**

- Option API는 필요한 데이터 프로퍼티, 함수, 연산 프로퍼티 등등이 각 컴포넌트마다 전부 다 분산되있거나 중복 로직이 발생
- Option API는 컴포넌트 로직의 재사용이 까다롭다.

<br>

**Option API**

로직을 여러가지 옵션 (data, methods 등)에 나누어 놓는 방식

```javascript
// Option API
data() {
	return {
		name: 'Max'
	};
},

methods: { 
	do Smth() 
}
```

<br>

**Composition API**

로직을 번들로 만들어 컴포넌트 구성 객체에 추가하는 방식

```javascript
// Composition API
setup() {
const name = ref('Max');
function doSmth() { ... }
return { name, doSmth };
}
```