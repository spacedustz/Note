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

`setup()` 함수를 사용하여 로직을 번들로 만들어 컴포넌트 구성 객체에 추가하는 방식

```javascript
// Composition API
setup() {
const name = ref('Max');
function doSmth() { ... }
return { name, doSmth };
}
```

<br>

템플릿 코드나 v-if, 데이터 바인딩 같은 기능들은 Vue 2-3 모두 똑같고 컴포넌트 구성 객체의 코드 설정만 바꾸는것이 Composition API라고 할 수 있습니다.

즉, 기존의 컴포넌트 로직을 구성하는 

- data
- methods
- computed
- watch

옵션을 Composition의 setup() 함수로 대체 가능하다는 점입니다.

<br>

추가적으로 Vue의 Lifecycle 함수들도 약간의 변경이 있는데 이건 나중에 배워보도록 하고,

컴포넌트를 구성하는 기존의 Option API의 변경점부터 배워보겠습니다.

---

## Data -> Refs

위에 말했듯이 Composition API는 Property, emits 등과 같은 다른 기능들은 똑같고,

컴포넌트를 구성하는 방법만이 바뀌었을 뿐입니다.

그 중 기존 Option API 에서의 Data를 Ref로 대체하는 방법을 배워보겠습니다.

<br>

**App.vue**

다양한 요소를 불러올 수 있게 해주는 중요한 구문인 ref를 Import 해줍니다.

이 ref는 기존 Option API에서의 data를 대체합니다.

그리고, 이 ref는 참조를 생성하는데 DOM 요소에 대한 참조가 아닌, 값을 참조해 템플릿에서 사용 가능하게 합니다.

이 값은 암

```javascript
<script>
import { ref } from 'vue';

export default {
	// 이런 옵션들은 기존 Vue2와 동일함
	component: [],
	props: [],

	// Composition API
	setup() {
		ref();
	}
}
</script>
```