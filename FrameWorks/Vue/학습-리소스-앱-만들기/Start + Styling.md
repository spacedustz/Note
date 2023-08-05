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

## ㅇ