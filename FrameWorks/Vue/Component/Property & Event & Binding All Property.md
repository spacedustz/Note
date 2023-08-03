프로퍼티/이벤트 폴스루 및 모든 프로퍼티 바인딩하기

<br>

다음 두 가지 심화 개념을 알아보겠습니다.

- **폴스루 프로퍼티**
    
- **컴포넌트의 모든 프로퍼티 바인딩하기**

<br>
#### **폴스루 프로퍼티**

등록하지 않은 프로퍼티를 컴포넌트 내부에 설정하거나 등록하지 않은 이벤트를 컴포넌트 내부에서 수신할 수 있습니다.

예를 들어:

**BaseButton.vue**

1. <template>  
2.   <button>
3.     <slot></slot>
4.   </button>
5. </template>

7. <script>export default {}</script>

이 버튼 컴포넌트(기본 스타일을 가진 버튼을 설정하기 위한 목적으로 사용 가능)에는 등록될 **특별한 프로퍼티가 없습니다**.

1. <base-button type="submit" @click="doSomething">Click me</base-button>

`BaseButton` 컴포넌트에서 `type`프로퍼티 또는 커스텀 `click`이벤트가 정의되거나 사용되지 않았습니다.

**그런데도 이 코드는 작동할 것입니다.**

Vue에는 **"폴스루" 프로퍼티(및 이벤트)** 지원이 내장되어 있기 때문이죠.

커스텀 컴포넌트 태그에 추가된 프로퍼티 및 이벤트는 **자동으로** 해당 컴포넌트의 템플릿에 있는 **루트 컴포넌트로 넘어갑니다**. 위의 예에서는 `BaseButton`컴포넌트의 `<button>`에 `type`과 `@click`이 추가됩니다.

내장된 `$attrs` 프로퍼티(예: `this.$attrs`)에서 이러한 폴스루 프로퍼티에 액세스할 수 있습니다.

이것은 모든 프로퍼티와 이벤트를 개별적으로 정의하고 싶지 않은 "유틸리티" 컴포넌트 또는 순수한 프리젠테이션 컴포넌트를 구축하는 데 편리할 수 있습니다.

나중에 컴포넌트 강의 프로젝트("학습 리소스 앱")에서 **실제 사례를 보게 될 것**입니다.

폴스루에 대한 자세한 내용은 [https://v3.vuejs.org/guide/component-attrs.html](https://v3.vuejs.org/guide/component-attrs.html)에서 확인할 수 있습니다.

  

#### **모든 프로퍼티 바인딩**

프로퍼티와 관련된 또 다른 내장 기능/동작이 있습니다.

다음 컴포넌트가 있다고 가정해봅시다.

**UserData.vue**

1. <template>
2.   <h2>{‌{ firstname }} {‌{ lastname }}</h2>
3. </template>

5. <script>
6.   export default {
7.     props: ['firstname', 'lastname']
8.   }
9. </script>

다음과 같이 **사용할 수 있습니다**.

1. <template>
2.   <user-data :firstname="person.firstname" :lastname="person.lastname"></user-data>
3. </template>

5. <script>
6.   export default {
7.     data() {
8.       return {
9.         person: { firstname: 'Max', lastname: 'Schwarz' }
10.       };
11.     }
12.   }
13. </script>

그러나 프로퍼티로 설정하려는 프로퍼티를 포함하는 객체가 있는 경우 **코드를 조금 더 간결하게 작성**할 수 있습니다.

1. <template>
2.   <user-data v-bind="person"></user-data>
3. </template>

5. <script>
6.   export default {
7.     data() {
8.       return {
9.         person: { firstname: 'Max', lastname: 'Schwarz' }
10.       };
11.     }
12.   }
13. </script>

  

`v-bind="person"`을 사용하면`person`내부의 **모든 키-값 쌍**을 컴포넌트에 **프로퍼티로 전달**합니다. 물론`person`이 **JavaScript 객체**이어야 합니다.

이는 **순전히 선택 사항**이지만, 여러분에게 도움이 될 수 있는 작은 편의 기능입니다.