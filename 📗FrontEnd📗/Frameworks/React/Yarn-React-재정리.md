## 📘 Yarn 사용법

> 📕 **Node.js 설치 * nvm lts 설치**

- Node.js 설치
- nvm install lts
- nvm use x.x.x

<br>

> 📕 **Yarn 명령어**

|Description|Command|
|--|--|
|**Yarn 설치**|npm instann yarn --global|
|**패키지 설치**|yarn add {package}|
|**패키지 로드**|yarn|
|**Dev 패키지 설치**|yarn add --dev {package}|
|**Global 패키지 설치**|yarn global add {package}|
|**패키지 삭제**|yarn remove {package}|
|**Dev 패키지 삭제**|yarn remove {package}|
|**Global 패키지 삭제**|yarn global remove {package}|
|**업데이트**|yarn upgrade|
|**패키지 업데이트**|yarn upgrade {package}|

---

## 📘 Yarn React Settings

- Yarn + Vite + React + TypeScript

<br>

> 📕 **프로젝트 생성**

- yarn create vite {project-name} --template react-ts
- TypeScript + SWC
- yarn dev or yarn vite (프로젝트 실행)

<br>

> 📕 **Default Export가 없는 모듈에서 Default Import 허용**

**tsconfig.json 파일**

Linting 부분에`"allowSyntheticDefaultImports": true`


<br>

> 📕 **vite.config.ts** : 서버 포트 변경

```ts
// https://vitejs.dev/config/  
export default defineConfig({  
  plugins: [react()],  
  server: {  
    port: 3000  
  }  
})
```

---

```tsx
const Intro: React.FC<[]> = () => {  
    return (  
        <div>백엔드 개발자 신건우입니다.</div>  
    );  
}  
  
export default Intro;
```