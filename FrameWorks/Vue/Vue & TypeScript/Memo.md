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

components, view 하위 파일 다 지우고, router/index.tx에서 import된 컴포넌트 다 제거

<br>

**.eslintrc.js 파일 설정 추가**

```
module.exports = {  
  root: true,  
  env: {  
    node: true,  
  },  
  extends: [  
    "plugin:vue/vue3-essential",  
    "eslint:recommended",  
    "@vue/typescript/recommended",  
    "plugin:prettier/recommended",  
  ],  
  parserOptions: {  
    ecmaVersion: 2020,  
  },  
  rules: {  
    "no-console": process.env.NODE_ENV === "production" ? "warn" : "off",  
    "no-debugger": process.env.NODE_ENV === "production" ? "warn" : "off",

		// 여기부터
    "no-unused-vars": "off",  
    "prettier/prettier": [  
      "error",  
      {  
        endOfLine: "auto",  
      },
      {  
			  useTabs: false,  
			},
    ],  
    // 여기까지 추가
  },  
};
```

