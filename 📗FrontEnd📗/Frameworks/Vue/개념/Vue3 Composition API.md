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

<br>

그리고, 이 ref는 참조를 생성하는데 DOM 요소에 대한 참조가 아닌, 값을 참조해 템플릿에서 사용 가능하게 합니다.

이 값은 아무런 값이나 생성하는 것아 아닌, 반응형 값을 생성하기 때문에 이 값을 바꾸면,

Vue도 인식하고 감시할 수 있어서 값이 바뀌거나 템플릿에 바인딩되면 Vue는 DOM에서 템플릿을 업데이트 합니다.

<br>

이제 위에서 말했듯 ref는 값을 생성하니까 그 값을 변수나 상수에 저장하면 **반응형 값이** 됩니다.

그리고, setup()은 템플릿에서 사용할 구성 요소를 작성 후, 항상 객체를 반환합니다.

이 객체는 실제 값을 바인딩 하거나 사용할 수 있습니다.



```javascript
<script>
import { ref } from 'vue';

export default {
	// 이런 옵션들은 기존 Vue2와 동일함
	component: [],
	props: [],

	// Composition API
	setup() {
		// ref에 저장하는 값은 value가 됨
		const userName = ref('Maximilian');


		return {
			userName: uName;
		};
		
	}
}
</script>
```

<br>

**주의할 점**

setup() 함수는 컴포넌트의 시작 프로세스 이전에 적용되므로 기존 Vue2 Option API를 사용할때,

자주 사용하던 this 키워드는 못쓰게 되었고 프로퍼티에도 접근할 수 없습니다.

왜냐면 컴포넌트가 실행되기 전에 실행되는 프로세스 중 하나가 setup() 이기 때문입니다.

<br>

이제 **반응형 값**이라는게 무슨 의미인지 타이머를 설정해서 알아보겠습니다.

타이머 내의 함수에서 ref의 값을 Max로 바꿔주었습니다.

```javascript
<script>
import { ref } from 'vue';

export default {
	// 이런 옵션들은 기존 Vue2와 동일함
	component: [],
	props: [],

	// Composition API
	setup() {
		// ref에 저장하는 값은 value가 됨
		const userName = ref('Maximilian');

		// 2초가 지나고 변화를 감지해 DOM 업데이트
		setTimeOut(function() {
			userName.value = 'Max';
		}, 2000);

		return {
			userName: uName;
		};
		
	}
}
</script>
```

<br>

즉 setup 함수에서 ref를 활용한 경우 Vue가 자동으로 변화를 감지하고 DOM을 업데이트 합니다.

---

## Setup 함수 바꾸기

많은 컴포넌트에서 컴포지션 API를 사용하는 경우, 이전 섹션에 따라 내보낸 객체에 `setup()`메서드를 추가하면 성가실 수 있습니다. 

특히`export default { ... }`을 추가하고 컴포넌트의`<template>` 에서 사용할 수 있는 값을 반환해야 해서 그렇습니다.

<br>

Vue.js는 이를 대체할 구문을 제공합니다. 

`setup()` 메서드를 수동으로 추가하지 않고 `<script setup>`을 사용할 수 있습니다.

다음과 같은 코드를:

```javascript
<script>
import { ref } from 'vue';

export default {
	// 이런 옵션들은 기존 Vue2와 동일함
	component: [],
	props: [],

	// Composition API
	setup() {
		// ref에 저장하는 값은 value가 됨
		const userName = ref('Maximilian');

		// 2초가 지나고 변화를 감지해 DOM 업데이트
		setTimeOut(function() {
			userName.value = 'Max';
		}, 2000);

		return {
			userName: uName;
		};
		
	}
}
</script>
```

<br>

다음으로 대체 가능 합니다.

```javascript
<script setup>
import { ref } from 'vue';

const uName = ref('Maximilian');

setTimeOut(function() {
	uName.value = 'Max';
}, 2000);
</script>
```

<br>

` script setup`과 `setup()` 메서드 중 어느 것을 사용하든 여전히 같은 방식으로 작동합니다.

---

## Reactive Object

위의 코드처럼 상수로 어떠한 값들을 선언해 보았습니다.

이번엔 반응형 객체를 만들어서 출력해보고 그 내부 동작과정을 학습해 보겠습니다.

```javascript
<template>  
  <section class="container">  
    <h2>{{ user.name }}</h2>  
    <h3>{{ user.age }}</h3>  
  </section>  
</template>

<script setup>  
import { ref } from 'vue'  
  
// const name = ref('Maximilian');  
// const age = ref(31);  
  
const user = ref({  
  name: 'Maximilian',  
  age: 31  
})  
  
  setTimeout(function() {  
    user.value.name = 'Max'  
    user.value.age = 32  
  }, 2000)  
</script>
```

<br>

위 코드처럼 ref의 값으로 객체를 전달하면 Vue가 객체 내부의 변화를 파악할 수 있도록 객체는 프록시로 래핑 됩니다.

setup 함수가 객체를 반환하고, 내부적으로 미가공된 ref 객체를 받으며 객체 내부 반응성을 인지합니다.

그리고 새 값이 지정되거나 템플릿에서 사용될 때를 알기 때문입니다.

하지만 이렇게 객체를 다룰 경우 객체만을 위해 만들어진 Reactive를 사용하는 것이 더 좋습니다.

<br>

**Reactive 사용**

Reactive는 ref와 비슷하지만, 객체 전용으로 만들어졌습니다.

Ref는 어떤 값이던지 다 받을 수 있었지만 reactive() 함수는 값으로 **객체**만을 이용합니다.

<br>

Reactive는 객체를 프록시로 래핑해서 반응형으로 만들어 객체를 사용할 수 있게 해줍니다.

즉, value 프로퍼티로 객체를 래핑하지 안기 때문에,

`user.value.name` 부분에서 value를 거치지 않고 `user.name`으로 사용이 가능하다는 의미입니다.

```javascript
<template>  
  <section class="container">  
    <h2>{{ user.name }}</h2>  
    <h3>{{ user.age }}</h3>  
  </section>  
</template>  
  
<script setup>  
import { reactive } from 'vue'  
  
// const name = ref('Maximilian');  
// const age = ref(31);  
  
const user = reactive({  
  name: 'Maximilian',  
  age: 31  
})  
  
  setTimeout(function() {  
    user.name = 'Max'  
    user.age = 32  
  }, 2000)  
</script>
```

<br>

#### Reactivity - Advanced

isRef() = Ref 값이 반응형인지 확인
isReactive() = 객체가 반응형인지 확인
toRefs() = 파라미터로 들어온 반응형 객체 내부에 중첩된 값을 반응형으로 만듬 (즉, Ref로 변환)

---

## Comoisition API - methdos & computed & watcher

### Method -> General Function

이번엔 기존 Option API에서 사용하던 methods를 Composition API에선 어떻게 사용하는지 알아보겠습니다.

```javascript
<template>  
  <section class="container">  
    <h2>{{ user.name }}</h2>  
    <h3>{{ user.age }}</h3>  
    <button @click="setAge">Change Age</button>  
  </section>  
</template>  
  
<script setup>  
import { reactive } from 'vue'  
  
const user = reactive({  
  name: 'Maximilian',  
  age: 31  
})  
  
function setAge() {  
  user.age = 32  
}  
</script>
```

<br>

사실 methods를 안쓰고 단순히 setup 내부에 함수를 정의하면 되므로 따로 설명이 필요 없는 부분입니다.

<br>

### Computed Property -> Computed Function

연산 프로퍼티를 연산 함수로 바꾸는 방법도 설명이 필요 없기에 코드로 대체합니다.

```javascript
const fullName = computed(function() { return user.firstName + ' ' + user.lastName })
```

<br>

### Watcher

Composition API에서의 Watch는 `watch()`를 사용합니다.

`watch()`의 **첫번째 파라미터**는 이 함수의 의존성을 설정하는 부분이며, 감시자 함수를 실행할 시점을 알려줍니다.

즉 바뀔 값을 감시하는 것이며, 이 첫번쨰 파라미터로는 Reactive한 값이 들어와야 합니다.

<br>

**두번째 파라미터**는 실제 호출 대상인 함수를 지정해야 합니다.

이 함수는 watch에 의해 자동으로 2개의 내부 파라미터를 가지게 됩니다. **(newValue, oldValue)**

이 Value들은 첫번쨰 파라미터의 변경 전/후 의 값을 파라미터로 가지는 겁니다.

```javascript
import { ref, reactive, computed, watch } from 'vue'  
  
// Data Property  
const user = reactive({  
  age: 31,  
  firstName: ref(''),  
  lastName: ref('')  
})  
  
// Computed Function  
const fullName = computed(function() { return user.firstName + ' ' + user.lastName })  
  
// methods -> Function  
function setAge() { user.age = 32 }  
  
// Watcher  
watch(() => user.age, function (newValue, oldValue) {  
  console.log('Old Age : ' + oldValue)  
  console.log('New Age : ' + newValue)  
})
```

<br>

여러개의 값을 감시하고 싶다면 watch 함수의 첫번째 파라미터에 배열을 주고 내부에 Reactive한 값을 넣으면 됩니다.

그럼 동일하게 두번째 파라미터로 자동으로 배열이 되겠죠. 값의 순서는 의존성의 순서를 따라갑니다.

age가 첫번째니 0번쨰 인덱스이고 firstName이 두번째나 1번째 인덱스를 사용합니다.

```javascript
// Watcher  
watch([() => user.age, () => user.firstName], function (newValues, oldValues) {  
  console.log('Old Age : ' + oldValues[0])  
  console.log('New Age : ' + newValues[0])  
  console.log('Old FirstName : ' + oldValues[1])  
  console.log('New FirstName : ' + newValues[1])  
})
```

---

## Script Setup

기존 setup()를 사용하는 것보다 가독성 측면에서 더 뛰어난 Script Setup에서의 다양한 기능들의 사용법 입니다.

변경점만 간단하게 작성합니다.

<br>

```js
<template>
  <div>
    <p>Props value: {{ propsValue }}</p>
    <p>Injected value: {{ injectedValue }}</p>
    <p>Computed value: {{ computedValue }}</p>
    <p>Reactive value: {{ reactiveValue }}</p>
    <button @click="increment">Increment</button>
  </div>
</template>

<script setup>
import { ref, reactive, computed, toRefs, inject, defineProps, defineEmits, provide } from 'vue';

// Props
const props = defineProps({
  propsValue: String,
});

// Provide, 1: 임의 식별자 2: 전달하고자 하는 실제 값  
provide('userAge', user.age)

// Emit
const emit = defineEmits();

// Inject 1: Provide의 첫번째 파라미터
const injectedValue = inject('injectedValue');

// State
const count = ref(0);
const state = reactive({
  reactiveValue: 42,
});

// Computed
const computedValue = computed(() => count.value * 2);

// Methods
const increment = () => {
  count.value++;
  emit('incremented', count.value);
};

// Destructuring props and reactive state
const { propsValue } = toRefs(props);
const { reactiveValue } = toRefs(state);
</script>
```

<br>

1. `props`: `defineProps`를 통해 부모 컴포넌트로부터 전달된 프롭스를 정의합니다.
    
2. `emit`: `defineEmits`를 통해 이벤트를 발생시키는 함수를 정의하고, 이를 통해 부모 컴포넌트로 이벤트를 전달합니다.
    
3. `inject`: `inject` 함수를 사용하여 부모 컴포넌트나 상위 계층에서 제공된 값을 주입받습니다.
    
4. `ref`: `ref` 함수를 사용하여 반응형 변수를 생성합니다.
    
5. `reactive`: `reactive` 함수를 사용하여 반응형 상태 객체를 생성합니다.
    
6. `computed`: `computed` 함수를 사용하여 계산된 속성을 정의하고 사용합니다.
    
7. `toRefs`: `toRefs` 함수를 사용하여 반응형 변수 또는 상태를 단순한 ref로 변환합니다.

<br>

`script setup`을 사용하면 이러한 항목들을 더욱 간단하게 정의하고 활용할 수 있습니다. 

각 항목은 Composition API의 기능을 더 편리하게 사용하도록 도와줍니다.

<br>

|Option API| -> |Composition API|
|---|---|---|
|data() {...}| -> |ref(), reactive()|
|methods: { doSmth() {...} }| -> |function doSmth() {...}|
|computed: { val() {...} }| -> |const val = computed()|
|watch: {...}| -> |watch(dep, (val, oldV) => {})|
|provide: {...} / inject: []| -> |provide(key, val) / inject(key)|

---

## Composition API - LifeCycle Hooks

|Option API| -> |Composition API|
|---|---|---|
|beforeCreate(), create()| -> |불필요 (setuo()이 대신함)|
|beforeMount(), mounted()| -> |onBeforeMount(), onMounter()|
|beforeUpdate(), updated()| -> |onBeforeUpdate(), onUpdated()|
|beforeUnmount(), unmounted()| -> |onBeforeMount(), onUnmounted()|

<br>

**beforeCreate, create()**

Option API와는 다르게 Composition API는 LifeCycle Hook을 컴포넌트 구성에 추가하지 않습니다.

내부적으로 Vue에서 함수를 불러오고 Setup에서 그 함수를 호출하죠.

기본적으로 setup은 beforeCreate, created가 실행되는 시점에 실행되기 때문입니다.

즉, setup 함수가 2개의 Lifecycle Hook을 자동으로 실행시켜 줍니다.

<br>

beforeCreate(), create()를 제외하고 나머지 LifyCycle 함수들은 전부 앞에 `on`만 붙고 사용법이 비슷합니다.