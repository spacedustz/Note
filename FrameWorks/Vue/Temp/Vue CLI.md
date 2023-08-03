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
# Manual로 선택
vue create {App-Name}

npm run serve
```

vue create로 프로젝트를 생성했으면 `npm install`을 할 필요없이 내부적으로 이미 실행이 되었기 때문에

`node_modules` 디렉토리가 이미 생성이 되어있다.

<br>

> 프로젝트 생성 완료

- package.json : 스프링에서 build.gradle 같은 파일로 의존성을 설정하거나 라이브러리를 불러올 수 있다.

