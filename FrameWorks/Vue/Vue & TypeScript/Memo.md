## Vue 3 & TypeScript

> Boot Strap 설치

- npm i bootstrap bootstrap-vue-3

<br>

**main.ts 파일에 BootStrap Import**

```javascript
import BootstrapVue3 from "bootstrap-vue-3";  
import "bootstrap/dist/css/bootstrap.css";  
import "bootstrap-vue-3/dist/bootstrap-vue-3.css";  
  
createApp(App).use(router).use(BootstrapVue3).mount("#app");
```

<br>

components, view 하위 파일 다 지우고, router/index.tx에서 import된 컴포넌트 다 제거 후 시작

