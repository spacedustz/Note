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

