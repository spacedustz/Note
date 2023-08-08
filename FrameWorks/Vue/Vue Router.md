## Vue Router

**Vue Router 패키지 설치**

```
npm i vue-router@next --save
```

<br>

그리고 main.ts 파일에 Router를 Import 해줍니다.

```javascript
import { createApp } from 'vue';  
import { createRouter } from 'vue-router';  // Import Router
  
import App from './App.vue';  
  
const app = createApp(App)  
  
const router = createRouter({  
    routes: []  
});  
  
app.mount('#app');
```

<br>

위 코드에서 router 변수에 createRouter() 라는 함수를 사용했습니다.

이 함수의 첫번째 파라미터로는 객체를 받고, 이 객체는 두가지 중요한 옵션을 설정할 수 있습니다.

**첫번째 옵션은 `routes` 입니다.**

<br>
이 `routes` 옵션에서 라우터에 등록하고자 하는 모든 URL을 등록합니다.

<br>

**두번째 옵션은 `history` 옵션입니다.**

`history` 옵션은 라우팅 히스토리 관리 방법을 지정할 수 있습니다.

ex 1) 사용자가 다른 곳을 클릭하면 다른 페이지로 넘어가고, 그 페이지가 브라우징 히스토리에 등록되도록 하는 방식입니다.

ex2) 사용자가 뒤로 가기 버튼을 누를 때는 히스토리를 통해 라우터가 이전 페이지를 알 수 있습니다.

<br>

먼저 vue-router의 createWebHistory 함수를 import 해 줍니다.

```javascript
import { createRouter, createWebHistory } from 'vue-router';
```

<br>

그리고 history 옵션에 createWebHistory 함수를 호출합니다.

```javascript
const router = createRouter({  
    routes: [],  
    history: createWebHistory(),  
});
```

<br>

**다시 `routes` 옵션으로 돌아와서**

`routes`는 어떤 URL에 대해 어떤 Vue 컴포넌트가 로드 되었는지를 알리는 역할을 합니다.

만약 Teams, Users 2개의 URL이 있다면 클릭했을떄 각자의 URL에 맞는 컴포넌트가 표시 되도록 하는겁니다.

<br>

`routes` 배열에는 자바스크립트 객체를 전달해야 합니다.

그리고 이 객체에는 `path`, `component` 옵션이 있으며 `path`부분은 도메인의 뒷 URL을 가르키며,

`component`는 해당 URL로 접속했을때 어떤 컴포넌트를 사용할건지에 대한 옵션입니다.

```javascript
const router = createRouter({  
    routes: [  
        { path: '/teams', component: TeamsList },  
        { path: '/users', component: UsersList }  
    ],  
    history: createWebHistory(),  
});

app.use(router);
```

<br>

이제 Vue App이 Vue Router에 대해 인식을 하게 됩니다.

하지만인식만 했을뿐 어디로 로드해야 하는지는 아직 정해주지 않았습니다.

이럴때 Vue 라우터에게 렌더링 위치를 알려주는 특수한 컴포넌트가 하나 있죠. `<router-view>`입니다.

```html
<router-view></router-view>
```

<br> 

이 특수 컴포넌트는 Vue Router를 쓸떄만 사용 가능합니다.

바로 이 위치로 컴포넌트가 로드 되어야 한다고 Vue App에게 알리는 PlaceHolder의 역할을 합니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/router.png)


이제 위에서 router 상수를 통해 main.js 파일에서 선택합니다.

이렇게 라우팅을 통해 컴포넌트를 로드하면 Global/Local 컴포넌트를 추가 등록할 필요가 없습니다.

---

## Router Link

Route 등록은 이제 끝났으니 Navigation에서 URL마다 설정해주던 커스텀 이벤트를 삭제하고,

`router-link`를 사용하여 특정 URL에 접속할 시 등록된 라우터 설정에서 지정한 컴포넌트로 이동하게 변경해줍니다.

```html
<router-link to="/teams"></router-link>
```

<br>



