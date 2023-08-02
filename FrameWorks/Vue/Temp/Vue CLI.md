## Vue CLI

> **npm run serve** 명령에 오류가 발생하는 경우

**Windows**

```
1. "scripts": {
2. "serve": "set NODE_OPTIONS=--openssl-legacy-provider && vue-cli-service serve",
3. "build": "set NODE_OPTIONS=--openssl-legacy-provider && vue-cli-service build",
4. "lint": "set NODE_OPTIONS=--openssl-legacy-provider && vue-cli-service lint"
5. },
```