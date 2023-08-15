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

## Vuex 사용

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

위 코드는 Composition API 기반으로 작성했으며, main app에 저장한 State 객체의 프로퍼티인

counter를 활용해 아무런 inject 없이 컴포넌트들 전역에서 제약 조건 없이 편하게 사용이 가능합니다.

<br>

이 예시는 아주 작은 어플리케이션이고, 이런 경우엔 데이터 프로퍼티가 더 효과적일 수 있으나,

Global State를 활용하는 방법에 대해 알아보고자 간단한 프로젝트를 만들어서 만들어 보았습니다.

---

## Vuex - Mutation

데이터를 변경하는 더 나은 방법에 대해 알아보겠습니다.

위에서 `store.state.counter` 이런 방식으로 호출하면 상태 변화 메커니즘에 대한 명확한 정의가 없습니다.

즉, 현재 상태에서 어디서든지 상태(데이터)를 변화시킬 수 있다는 의미입니다.

<br>

위에서 본것처럼 컴포넌트에서 **직접적으로** Store에 접근하고 있지만,

이상적인 방향은 **직접** 접근하는 방식이 아닌 Vuex의 내장된 개념인 변형(Mutation)을 사용하는게 좋습니다.

이 Mutation은 상태를 업데이트 하는 로직을 가지고 있습니다.

이는 컴포넌트 내부에 있으며, **직접** 상태를 바꾸는 대신 Mutation을 Trigger 합니다.

<br>

Mutation을 Trigger 함으로써 모든 컴포넌트는 같은 방식으로 동작한다는 걸 보장합니다.

<br>

**main app**

컴포넌트마다 상태를 변경하는 함수를 각각 작성하는 것보다,  Option API의 methods 처럼

상태를 변경하는 함수를 main app에 정의해 놓습니다.

```js
// 상태 객체를 반환하는 함수, App당 1개의 store만 가질 수 있음  
const store = createStore({  
    state() {  
        // 이 반환 객체를 어플리케이션 전체와 관련된 데이터를 보유함  
        return {  
            counter: 0  
        };  
    },  
  
    // 상태를 변경하는 Mutation    
    mutations: {  
        // 현재 상태를 파라미터로 받음  
        increment(state) {  
            state.counter = state.counter + 1;  
        }  
    }  
});
```

<br>

**App.vue**

이제 다른 모든 컴포넌트에서 아래 형식으로 Mutation을 가져와 동일한 상태 변형 함수를 사용할 수 있습니다.

```js
// Mutation의 이름을 commit에 넣어 Mutation을 불러옴
function addOne() { store.commit('increment'); }
```

<br>
#### Payload를 이용한 Mutation에 데이터 전달

특정 Mutation은 파라미터를 요구하는 것도 있습니다.

---

## Vuex - Getters

```js
// 상태 객체를 반환하는 함수, App당 1개의 store만 가질 수 있음  
const store = createStore({  
    state() {  
        // 이 반환 객체를 어플리케이션 전체와 관련된 데이터를 보유함  
        return {  
            counter: 0  
        };  
    },  
  
    // 상태를 변경하는 Mutation    mutations: {  
        // 현재 상태를 파라미터로 받음  
        increment(state) {  
            state.counter = state.counter + 1;  
        }  
    },  
    getters: {  
        // 상태, getters 2개의 파람터를 받을 수 있음  
        finalCounter(state) {  
            return state.counter * 2;  
        },  
        normalizedCounter(_, getters) {  
           const finalCounter = getters.finalCounter;  
  
           if (finalCounter < 0) return 0;  
           if (finalCounter > 100) return 100;  
  
           return finalCounter;  
        }  
    }  
});
```

<br>

```js
store.getters.finalCounter;
```

---

## Actions을 이용한 비동기 코드 실행

Vuex에서 제공하는 핵심 기능중 하나가 코드의 비동기 실행 기능입니다.

<br>

이때, Mutation의 문제는 항상 동기 방식이며, 비동기 방식은 허용되지 않습니다.

따라서 Mutation이 실행 되면, 중단없이 단계별로 실행되면서 상태는 즉시 바뀌어야 합니다.

이유는 모든 Mutation이 최신 State를 받아야만 하기 때문에 이러한 방식이 강제됩니다.

<br>

이럴떄 Actions을 사용합니다.

동작 방식은 컴포넌트에서 Actions를 트리거하고 이 트리거된 Actions는 Mutation을 Commit 합니다.

Actions는 비동기 방식을 지원하기 때문에 컴포넌트와 Mutation 사이에 넣는 것은 일반적으로 좋은 사용 방식입니다.

컴포넌트에서 직접 Mutation을 Commit해도 되지만 Mutation에 실수로 비동기 코드를 넣는 것을 방지해주기 위함입니다.

<br>

그렇다면 2초를 기다린 후 실행하려면 어떻게 해야 할까요? 

예를 들어 HTTP 요청을 보내고 응답을 기다리는 상황이 있을 수 있으니 Mutation을 2초 후 실행한다고 가정하겠습니다.

일단 Actions도 main app에 추가 해봅시다.

```js
// 상태 객체를 반환하는 함수, App당 1개의 store만 가질 수 있음  
const store = createStore({  
    state() {  
        // 이 반환 객체를 어플리케이션 전체와 관련된 데이터를 보유함  
        return {  
            counter: 0  
        };  
    },  
  
    // 상태를 변경하는 Mutation    
    mutations: {  
        // 현재 상태를 파라미터로 받음  
        increment(state) {  
            state.counter = state.counter + 1;  
        },  
        increase(state, payload) {  
            state.counter = state.counter + payload.value;  
        }  
    },  
    getters: {  
        // 상태, getters 2개의 파람터를 받을 수 있음  
        finalCounter(state) {  
            return state.counter * 2;  
        },  
        normalizedCounter(_, getters) {  
            const finalCounter = getters.finalCounter;  
  
            if (finalCounter < 0) return 0;  
            if (finalCounter > 100) return 100;  
  
            return finalCounter;  
        }  
    },  
    actions: {  
        // 파라미터로 context라는 객체를 받는다.  
        increment(context) {  
            setTimeout(function () {  
                context.commit('increment');  
            }, 2000);  
        },  
        // 이 Actions은 Dispatch 함수에 추가된 Payload를 받는다.  
        increase(context, payload) {  
          context.commit('increase', payload);  
        }  
    }  
});
```

<br>

위 코드에서,

Actions의 함수는 기본적으로 context 라는 객체를 파라미터로 받으며, 이 context를 호출할 수 있는 commit 함수가 있습니다.

이 commit 함수는 Mutation을 파라미터로 받으며, 추가 파라미터도 Payload, 값 등 받을 수 있습니다.

<br>

이제 컴포넌트에서 직접 Mutation을 Commit 하는게 아니라 Actions을 사용해 보도록 하죠.

Actions를 사용할 땐 dispatch() 함수를 사용하며 이 함수는 2개의 파라미터를 dispatch 할 수 있고, commit 함수와 많이 비슷합니다.

첫번째 파라미터는 Actions의 이름, 두번째 파라미터는 Payload or 하나의 파라미터 구분을 사용합니다.

<br>

아래 코드의 파라미터 구분에 있는 value가 increase Actions의 payload로 전달됩니다.

그리고 이 payload는 Mutation에 전달됩니다.

```js
function addOne() {  
  // Mutation의 이름을 commit에 넣어 Mutation을 불러옴 - X  // Actions로 변경  
  store.dispatch({  
    type: 'increase',  
    value: 10  
  });  
}
```

---

## Vuex - Action Context

Actions의 context 파라미터에 대해 좀 더 자세히 알아보겠습니다.

context 자체를 로그로 찍어보면

- commit
- dispatch
- getters
- rootGetters
- rootState
- state
- __proto__

등등이 있습니다.

<br>

여기서 Dispatch는 작업 내부에서 다른 작업을 전달할 수 있습니다. (ex: SenddHTTP Request, Error Handling)

즉, 요청이 성공하면 성공 액션을 트리거하고, 오류가 발생하면 오류 처리 액션을 트리거 할 수 있습니다.

HTTP Request에 대한 결과에 대한 반응으로 다른 작업들을 전달하는 하나의 액션을 만들수도 있죠.

<br>

Getters를 사용하여 Getter에서 얻는 특정 값을 가져올 수도 있습니다.

Getters를 이용하는 것으로 충분하기 않을 때에는 State도 직접적으로 사용할 수 있습니다.

**하지만 Actions 내부에서 State를 조작해서는 안되며, 항상 Mutations을 사용해야 합니다.**

---

## Vuex - Mapper Helper

