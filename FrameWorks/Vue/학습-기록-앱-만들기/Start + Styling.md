## Learning Resource + Styling

App.vue는 Root Component이기 때문에 Template에 최대한 MarkUp이 없게 만들어야 합니다.

Data 프로퍼티에 더미 데이터 배열을 만들고 그 데이터를 Stored-Resource로 넘겨주고,

Stored-Resource는 배열을 받고 순회 하면서 데이터를 Learning-Resource로 바인딩합니다.

<br>

Style 부분은 전역 스타일 설정은 왠만하면 App.vue에 지정하고 나머지 컴포넌트들에는 scoped style을 적용하였습니다.

---

**App.vue**


```javascript
<template>  
  <ul>  
    <stored-resources  
        :resources="storedResources"  
    ></stored-resources>  
  </ul>  
</template>  
  
<script>  
import StoredResources from "@/components/Learing-Resources/StoredResources";  
  
export default {  
  components: { StoredResources },  
  
  data() {  
    return {  
      storedResources: [  
        {  
          id: 'official-guide',  
          title: 'Official Guide',  
          description: 'The Official Vue.js Documentation',  
          link: 'https://vuejs.org'  
        },  
        {  
          id: 'google',  
          title: 'Google',  
          description: 'The Official Google Documentation',  
          link: 'https://google.org'  
        },  
      ]  
    };  
  },  
}  
</script>  
  
<style>  
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');  
  
* {  
  box-sizing: border-box;  
}  
  
html {  
  font-family: 'Roboto', sans-serif;  
}  
  
body {  
  margin: 0;  
}  
</style>
```

<br>

**LearningResource.vue**

```javascript
<template>  
  <li>  
    <div>  
      <header>  
        <h3>{{ title }}</h3>  
        <button>Delete</button>  
      </header>  
    </div>  
  
    <p>{{ description }}</p>  
  
    <nav>  
      <a :href="link">View Resource</a>  
    </nav>  
  </li>  
</template>  
  
<script>  
export default {  
  props: ['title', 'description', 'link'],  
  
}  
</script>  
  
<style scoped>  
li {  
  margin: auto;  
  max-width: 40rem;  
}  
  
header {  
  display: flex;  
  justify-content: space-between;  
  align-items: center;  
}  
  
h3 {  
  font-size: 1.25rem;  
  margin: 0.5rem 0;  
}  
  
p {  
  margin: 0.5rem 0;  
}  
  
a {  
  text-decoration: none;  
  color: #ce5c00;  
}  
  
a:hover,  
a:active {  
  color: #c89300;  
}  
</style>
```

<br>

**StoredResources.vue**

```javascript
<template>  
  <ul>  
    <learning-resource  
        v-for="res in resources"  
        :key="res.id"  
        :title="res.title"  
        :description="res.description"  
        :link="res.link"  
    ></learning-resource>  
  </ul>  
</template>  
  
<script>  
import LearningResource from "@/components/Learing-Resources/LearningResource";  
  
export default {  
  components: { LearningResource },  
  
  props: ['resources'],  
}  
</script>  
  
<style scoped>  
ul {  
  list-style: none;  
  margin: 0;  
  padding: 0;  
  margin: auto;  
  max-width: 40rem;  
}  
</style>
```

<br>

**결과물**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/learing.png)

---

## UI Components

이제 UI 컴포넌트들 만들어보겠습니다.

BaseCard라는 컴포넌트를 만들고 scoped 스타일링을 적용해서 원하는 HTML 요소에 slot을 달면 적용됩니다.

<br>

**BaseCard.vue**

```javascript
<template>  
  <header>  
    <h1>{{ title }}</h1>  
  </header>  
</template>  
  
<script>  
export default {  
  props: ['title'],  
}  
</script>  
  
<style scoped>  
header {  
  width: 100%;  
  height: 5rem;  
  background-color: #640032;  
  display: flex;  
  justify-content: center;  
  align-items: center;  
}  
  
header h1 {  
  color: white;  
  margin: 0;  
}  
</style>
```

<br>

그리고 전에 작성한 LearningResource.vue 파일의 div 태그를 base-card 태그로 바꿔주면 Card의 CSS가 적용됩니다.

```javascript
<template>  
  <li>  
    <base-card>  
      <header>  
        <h3>{{ title }}</h3>  
        <button>Delete</button>  
      </header>  
      <p>{{ description }}</p>  
      <nav>  
        <a :href="link">View Resource</a>  
      </nav>  
    </base-card>  
  </li>  
</template>  
  
<script>  
export default {  
  props: ['title', 'description', 'link'],  
  
}  
</script>
```

<br>

그리고, 이 UI 컴포넌트는 LearningResource 컴포넌트 뿐만 아니라 다른 컴포넌트에서도 사용할 것이므로,

Local 컴포넌트가 아닌 Global 컴포넌트로 등록 할겁니다.

**main.js**

```javascript
import { createApp } from 'vue';  
  
import App from './App.vue';  
import BaseCard from './components/UI/BaseCard.vue';  
  
const app = createApp(App)  
  
app.component('base-card', BaseCard);  
  
app.mount('#app');
```

<br>

**Card UI가 적용된 모습**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/card.png)

<br>

## Layout Components

이제 Layout Component인 Header 컴포넌트를 만들어 보겠습니다.

저번에 말했듯이 App.vue에는 어떠한 마크업도 들어가게 하지 않기 위해 레이아웃의 Header도 별도의 Wrapper 컴포넌트로 만듭니다.

<br>

Title에 해당하는 데이터를 BaseHeader에서 props로 가져와서 간단하게 title값만 바인딩 하였고,

원래 App.vue에 들어갈 title을 BaseHeader 컴포넌트로 대체하였습니다.

<br>

 **BaseHeader.vue**

```javascript
<template>  
  <header>  
    <h1>{{ title }}</h1>  
  </header>  
</template>  
  
<script>  
export default {  
  props: ['title'],  
}  
</script>  
  
<style scoped>  
header {  
  width: 100%;  
  height: 5rem;  
  background-color: #640032;  
  display: flex;  
  justify-content: center;  
  align-items: center;  
}  
  
header h1 {  
  color: white;  
  margin: 0;  
}  
</style>
```

<br>

 **App.vue**

```javascript
<template>  
  <base-header title="학습 기록"></base-header>  
  <stored-resources :resources="storedResources"></stored-resources>  
</template>  
  
<script>  
import StoredResources from "@/components/Learing-Resources/StoredResources";  
import BaseHeader from "@/components/Layouts/BaseHeader";  
  
export default {  
  components: { StoredResources, BaseHeader },  
  
  data() {  
    return {  
      storedResources: [  
        {  
          id: 'official-guide',  
          title: 'Official Guide',  
          description: 'The Official Vue.js Documentation',  
          link: 'https://vuejs.org'  
        },  
        {  
          id: 'google',  
          title: 'Google',  
          description: 'The Official Google Documentation',  
          link: 'https://google.org'  
        },  
      ]  
    };  
  },  
}  
</script>
```

<br>

**결과물**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/header.png)

---

## Base Button Components

학습 기록 앱에 쓰일 기본 버튼 Component를 추가해보겠습니다.

<br>

props중 type 프로퍼티는,

버튼의 타입을 받아서 타입마다 다른 CSS를 적용할 수 있게 Style을 해두었습니다. (ex: 마우스를 올릴 시 다른 CSS 적용)

mode 프로퍼티는 CSS의 Class 명을 받아서 mode에 바인딩 해줍니다.

그리고, 버튼에 들어갈 컨텐츠는 당연히 외부에서 받아야 하므로 slot으로 받습니다.

<br>

**BaseButton.vue**

```javascript
<template>  
  <button :type="type" :class="mode">  
    <slot></slot>  
  </button>  
</template>  
  
<script>  
export default {  
  props: ['type', 'mode']  
}  
</script>  
  
<style scoped>  
button {  
  padding: 0.75rem 1.5rem;  
  font-family: inherit;  
  background-color: #3a0061;  
  border: 1px solid #3a0061;  
  color: white;  
  cursor: pointer;  
}  
  
button:hover,  
button:active {  
  background-color: #270041;  
  border-color: #270041;  
}  
  
.flat {  
  background-color: transparent;  
  color: #3a0061;  
  border: none;  
}  
  
.flat:hover,  
.flat:active {  
  background-color: #edd2ff;  
}  
</style>
```

<br>

그리고, 이 기본 버튼도 다른 컴포넌트들에서 계속 사용할 것이기 떄문에 전역 컴포넌트로 등록해줍니다.

**main.js**

```javascript
import { createApp } from 'vue';  
  
import App from './App.vue';  
import BaseCard from './components/UI/BaseCard.vue';  
import BaseButton from "@/components/UI/BaseButton";  
  
const app = createApp(App)  
  
app.component('base-card', BaseCard);  
app.component('base-button', BaseButton);  
  
app.mount('#app');
```

<br>

그리고 기존 LearningResource 컴포넌트에서도 버튼을 사용하고 있으니, 여기서도 BaseButton 태그로 변경해줍니다.

**LearningResource.vue**

```javascript
<template>  
  <li>  
    <base-card>  
      <header>  
        <h3>{{ title }}</h3>  
        <base-button>Delete</base-button>  
      </header>  
      <p>{{ description }}</p>  
      <nav>  
        <a :href="link">View Resource</a>  
      </nav>  
    </base-card>  
  </li>  
</template>
```

<br>

이제 버튼의 UI가 변경되었습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/button.png)

버튼의 테두리가 마음에 안든다면 base-button을 호출하는 속성으로 mode="flat"을 주면 해결됩니다.

---

## 동적 컴포넌트 및 속성 풀스루

저번에 추가한 App.vue의 더미데이터를 지우고 사용자가 직접 리소스를 입력하고, 배열에 추가하는 로직을 만들어보겠습니다.

그러려면 제목, 설명, 링크를 작성할 수 있는 입력 폼이 필요합니다.

그리고, 버튼을 만들어서 학습을 기록한 목록과 다른 화면을 전환할 수 있게 동적 컴포넌트를 만들겠습니다.

<br>

기존 App.vue에 있던 더미 데이터를 TheResources.vue 파일을 만들어 더미 데이터를 옮기고,

이 데이터와 컴포넌트를 이용해 버튼을 누르면 화면 간 전환하는 로직을 짭니다.

그리고, storedResources를 TheResource로 옮기면서 provide/inject를 써서 StoredResource에도 주입해줍니다.

<br>

그리고, 커스템 버튼에 클릭 이벤트를 쓰면 base-button의 root 요소까지 전파됩니다.

<br>

**TheResources.vue**

```javascript
<template>  
  <base-card>  
    <base-button @click="setSelectedTab('stored-resources')">목록 보기</base-button>  
    <base-button @click="setSelectedTab('add-resource')">학습 추가</base-button>  
  </base-card>  
  <component :is="selectedTab"></component>  
</template>  
  
<script>  
import BaseCard from "@/components/UI/BaseCard";  
import BaseButton from "@/components/UI/BaseButton";  
import TheResources from './StoredResources.vue';  
import AddResource from './AddResource.vue';  
  
export default {  
  components: { BaseButton, BaseCard, TheResources, AddResource },  
  
  data() {  
    return {  
      selectedTab: 'stored-resources',  
      storedResources: [  
        {  
          id: 'official-guide',  
          title: 'Official Guide',  
          description: 'The Official Vue.js Documentation',  
          link: 'https://vuejs.org'  
        },  
        {  
          id: 'google',  
          title: 'Google',  
          description: 'The Official Google Documentation',  
          link: 'https://google.org'  
        },  
      ]  
    };  
  },  
  
  methods: {  
    setSelectedTab(tab) {  
      this.selectedTab = tab;  
    }  
  },  
  
  provide() {  
    return {  
      resources: this.storedResources  
    };  
  },  
}  
</script>  
  
<style scoped>  
  
</style>
```

<br>

이제 탭 간 전환은 완료했고 현재 선택된 탭이 어느 탭인지 구분이 안가니 탭에 강조 표시도 넣어주겠습니다.

해당 버튼이 클릭 되지 않았을 때는 기본 버튼의 색깔이 적용되고, 클릭 했을때는 강조 표시가 될 것입니다.

Computed Property를 만들어 버튼을 클릭 했을때 적용될 CSS Class를 조건을 걸어서 동적으로 바인딩합니다.

**TheResource.vue**

```javascript
<template>  
  <base-card>  
    <base-button  
        @click="setSelectedTab('stored-resources')"  
        :mode="storedResButtonMode">목록 보기</base-button>  
    <base-button  
        @click="setSelectedTab('add-resource')"  
        :mode="addResButtonMode">학습 추가</base-button>  
  </base-card>  
  <component :is="selectedTab"></component>  
</template>

...

computed: {  
  storedResButtonMode() {  
    return this.selectedTab === 'stored-resources' ? null : 'flat';  
  },  
  addResButtonMode() {  
    return this.selectedTab === 'add-resource' ? null : 'flat';  
  }  
},
```

<br>

**결과물**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/tab.png)

---

## Resource Form

지금까지 더미 데이터를 이용해 Resource를 만들었지만 이제부터 Form을 이용해 사용자로부터 입력을 받아서 Form을 제출해, Resource를 배열에 동적으로 추가해보겠습니다.

<br>

하나의 div마다 입력 값을 정해주고 제목, 내용(3줄), 링크를 입력할 수 있는 공간과 제출 버튼을 만들어 주었습니다.

```javascript
<template>  
  <base-card>  
    <form>  
      <!-- Title -->  
      <div class="form-control">  
        <lable for="title">제목</lable>  
        <input  
          type="text"  
          id="title"  
          name="title"  
        />  
      </div>  
      <!-- Description -->  
      <div class="form-control">  
        <lable for="description">설명</lable>  
        <textarea  
        id="description"  
        name="description"  
        rows="3"  
        ></textarea>  
      </div>  
      <!-- Title -->  
      <div class="form-control">  
        <lable for="link">링크</lable>  
        <input  
            type="url"  
            id="link"  
            name="link"  
        />  
      </div>  
      <!--Submit Button -->  
      <div>  
        <base-button type="submit">학습 추가</base-button>  
      </div>  
    </form>  
  </base-card>  
</template>  
  
<script>  
import BaseCard from "@/components/UI/BaseCard";  
import BaseButton from "@/components/UI/BaseButton";  
export default {  
  components: {BaseButton, BaseCard}  
}  
</script>  
  
<style scoped>  
label {  
  font-weight: bold;  
  display: block;  
  margin-bottom: 0.5rem;  
}  
  
input,  
textarea {  
  display: block;  
  width: 100%;  
  font: inherit;  
  padding: 0.15rem;  
  border: 1px solid #ccc;  
}  
  
input:focus,  
textarea:focus {  
  outline: none;  
  border-color: #3a0061;  
  background-color: #f7ebff;  
}  
  
.form-control {  
  margin: 1rem 0;  
}  
</style>
```

<br>

**Form 양식 적용**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/form.png)

<br>

이제 입력은 받았으니 입력값을 배열에 넣어서 출력해보겠습니다.

AddResource에서 Custom Event를 발생시켜 상위 컴포넌트로 수신하게 해도 되지만, 

AddResource 컴포넌트가 동적으로 등록되어 있기 때문에 이 방법은 어렵습니다.

일단 AddResource 컴포넌트에 입력값을 가져올 수 있도록 ref 속성을 사용해줍니다.

**AddResource.vue**

```html
<form>  
  <!-- Title -->  
  <div class="form-control">  
    <lable for="title">제목</lable>  
    <input  
      type="text"  
      id="title"  
      name="title"  
      ref="titleInput"  
    />  
  </div>  
  <!-- Description -->  
  <div class="form-control">  
    <lable for="description">설명</lable>  
    <textarea  
    id="description"  
    name="description"  
    rows="3"  
    ref="descInput"  
    ></textarea>  
  </div>  
  <!-- Title -->  
  <div class="form-control">  
    <lable for="link">링크</lable>  
    <input  
        type="url"  
        id="link"  
        name="link"  
        ref="linkInput"  
    />  
  </div>  
  <!--Submit Button -->  
  <div>  
    <base-button type="submit">제출</base-button>  
  </div>  
</form>
```

<br>

그래서 이번에도 provide/inject를 써서 주입해보겠습니다.

주입하기 전에 TheResource.vue에서 최종 리소스들을 관리하므로 리소스 추가 함수를 작성하겠습니다.

그리고, 하위 컴포넌트로 주입해주기 위해 provide에도 함수를 포인팅 해줍니다.

**TheResources.vue**

```javascript
methods: {  
  setSelectedTab(tab) {  
    this.selectedTab = tab;  
  },  
  addResource(title, description, url) {  
    const newResource = {  
      id: new Date().toISOString(),  
      title: title,  
      description: description,  
      link: url  
    };  
    // 배열의 맨앞에 추가 (unshift)
    this.storedResources.unshift(newResource);  
    // 리소스를 추가할때마다 탭이 바뀌게 함  
    this.selectedTab = 'stored-resources';  
  }  
},  
  
provide() {  
  return {  
    resources: this.storedResources,  
    addResource: this.addResource  
  };  
},
```

<br>

그리고 이제 TheResource의 함수를 inject 받고 form에 함수를 포인팅 해주면 양식 제출이 되고 리스트에 나옵니다.

**AddResource.vue**

```javascript
<form @submit.prevent="submitData">

...

inject: ['addResource'],  
  
methods: {  
  submitData() {  
    const enteredTitle = this.$refs.titleInput.value;  
    const enteredDesc = this.$refs.descInput.value;  
    const enteredLink = this.$refs.linkInput.value;  
  
    this.addResource(enteredTitle, enteredDesc, enteredLink);  
  }  
}
```

<br>

**결과물**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/form2.png)

---

## Custom Dialog를 이용한 Overlay

사용자에게 입력값을 Form으로 받아 배열에 추가 후 출력하는것 까지 했었습니다.

그런데 이 입력폼은 공백을 제출해도 추가가 되게 되어 있기 때문에 입력값에 대한 검증을 해야 합니다.

이때 이용할 방법으로는 저번에 배웠던 Dialog를 이용한 검증을 수행하는겁니다.

<br>

그럼 입력폼을 받는 컴포넌트인 AddResource에 검증 함수를 만들어야겠죠.

<br>

**BaseDialog.vue**

```javascript
<template>  
  <div></div>  
  <dialog open>  
    <header>  
      <slot name="header">  
        <h2>{{ title }}</h2>  
      </slot>  
    </header>  
  
    <!-- Dialog의 주 컨텐츠 -->  
    <section>  
      <slot></slot>  
    </section>  
  
    <!-- 사용자가 클릭할 버튼 표시 -->  
    <menu>  
      <slot></slot>  
    </menu>  
  </dialog>  
</template>  
  
<script>  
export default {  
  props: {  
    title: {  
      type: String,  
      required: false  
    }  
  },  
}  
</script>  
  
<style scoped>  
div {  
  position: fixed;  
  top: 0;  
  left: 0;  
  height: 100vh;  
  width: 100%;  
  background-color: rgba(0, 0, 0, 0.75);  
  z-index: 10;  
}  
  
dialog {  
  position: fixed;  
  top: 20vh;  
  left: 10%;  
  width: 80%;  
  z-index: 100;  
  border-radius: 12px;  
  border: none;  
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.26);  
  padding: 0;  
  margin: 0;  
  overflow: hidden;  
}  
  
header {  
  background-color: #3a0061;  
  color: white;  
  width: 100%;  
  padding: 1rem;  
}  
  
header h2 {  
  margin: 0;  
}  
  
section {  
  padding: 1rem;  
}  
  
menu {  
  padding: 1rem;  
  display: flex;  
  justify-content: flex-end;  
  margin: 0;  
}  
  
@media (min-width: 768px) {  
  dialog {  
    left: calc(50% - 20rem);  
    width: 40rem;  
  }  
}  
</style>
```

<br>

**main.js**

그리고 이 Dialog도 전역적으로 사용할테니 main.js에 컴포넌트를 추가해줍니다.

```javascript
import { createApp } from 'vue';  
  
import App from './App.vue';  
import BaseCard from './components/UI/BaseCard.vue';  
import BaseButton from "@/components/UI/BaseButton";  
import BaseDialog from "@/components/UI/BaseDialog";  
  
const app = createApp(App)  
  
app.component('base-card', BaseCard);  
app.component('base-button', BaseButton);  
app.component('base-dialog', BaseDialog);  
  
app.mount('#app');
```