## Vue CLI

> **npm run serve** 명령에 오류가 발생하는 경우

**Windows**

```json
"scripts": {
	"serve": "set NODE_OPTIONS=--openssl-legacy-provider && vue-cli-service serve",
	"build": "set NODE_OPTIONS=--openssl-legacy-provider && vue-cli-service build",
	"lint": "set NODE_OPTIONS=--openssl-legacy-provider && vue-cli-service lint"
},
```

<br>

**Mac or Linux**

```json
"scripts": {
	"serve": "export NODE_OPTIONS=--openssl-legacy-provider && vue-cli-service serve",
	"build": "export NODE_OPTIONS=--openssl-legacy-provider && vue-cli-service build",
	"lint": "export NODE_OPTIONS=--openssl-legacy-provider && vue-cli-service lint"
},
```

<br>

> Node.js LTS 버전 설치

<br>

> Vue CLI 설치

```bash
npm install -g @vue/cli

# 프로젝트를 시작할 디렉토리로 이동
vue create {App-Name}
```

