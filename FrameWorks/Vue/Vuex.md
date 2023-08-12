## Vues 란?

Global State를 관리하기 위한 Library입니다.

State는 Data로 변환될 수 있으며 일종의 반응형 데이터로도 볼 수 있습니다.

변경될 수 있으며 무언가를 트리거하는 데이터죠.

<br>

하지만 앱의 다양한 컴포넌트에 영향을 주는 데이터인 상태를 관리하는 건 어렵습니다.

그래서 우선 상태를 Global State/LocalState 로 먼저 구분해줍니다.

<br>

### Local State

Local State는 하나의 컴포넌트 내부에서 관리도는 데이터이자 상태입니다.

해당 컴포넌트와 **프로퍼티를 통해 간적접으로 하위 컴포넌트도 영향을 줍니다.**

사용자의 입력값, 어떠한 컨테이너 표시, 숨기는 버튼 등의 예로 활용됩니다.

<br>

### Global State

Global State는 여러 컴포넌트 & 앱 전체에 걸쳐 영향을 주는 데이터이자 상태입니다.

사용자 로그인 여부, 인증 상태 등의 예로 활용됩니다.

---

## Vuex

```
npm install --save vuex@next
```

<br>

**main에 Vuex 추가**

```js
import { createApp } from 'vue';  
import { createStore } from "vuex"; // Import Vuex Store  
  
import App from './App.vue';  
  
// 상태 객체를 반환하는 함수, App당 1개의 store만 가질 수 있음  
const store = createStore({  
    state() {  
        // 이 반환 객체를 어플리케이션 전체와 관련된 데이터를 보유함  
        return {  
            counter: 0  
        };  
    }  
});  
const app = createApp(App);  
  
// Store 사용  
app.use(store);  
app.mount('#app');
```

<br>

**App.vue**

```js
<template>  
  <base-container title="Vuex">  
    <!-- 주입 없이 Global State를 이용해서 데이터 전달 -->  
    <the-counter></the-counter>  
    <button @click="addOne">Add 1</button>  
  </base-container>  
</template>  
  
<script setup>  
import { useStore } from 'vuex'; // Composition에서 Vuex Store를 불러옴  
import BaseContainer from './components/BaseContainer.vue';  
import TheCounter from "@/components/TheCounter";  
  
const store = useStore(); // Vuex  
  
function addOne() {  
  store.state.counter++;  
}  
</script>
```

<br>

**TheCounter.vue**

```js
<template>  
  <h3>{{ counter }}</h3>  
</template>  
  
<script>  
export default {  
  name: "TheCounter"  
}  
</script>  
  
<script setup>  
import { computed } from 'vue';  
import { useStore } from "vuex";  
  
const store = useStore();  
  
const counter = computed(function() { return store.state.counter; })  
</script>
```

<br>

위 코드는 Composition API 기반으로 작성했으며, main app에 저장한 State 객체의 프로퍼티로,

counter를 활용해 아무런 inject 없이 컴포넌트들 전역에서 제약 조건없이 편하게 사용이 가능합니다.

---

## Mutation

데이터를 변경하는 더 낭