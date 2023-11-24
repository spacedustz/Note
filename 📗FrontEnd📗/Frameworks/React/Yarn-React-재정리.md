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

## 📘 패키지 설치

- Styled-Component

```shell
# Styled-Component
yarn add styled-components
yarn add --dev @types/styled-components
```

---
## 📘 React Component 만들어보기

src 디렉터리 밑에 components 디렉터리를 만들고 Intro.tsx 파일을 만들어 아래와 같이 작성해줍니다.

```tsx
const Intro: React.FC<[]> = () => {  
    return (  
        <div>백엔드 개발자 신건우입니다.</div>  
    );  
}  
  
export default Intro;
```

<br>

그리고 App.tsx에 만든 컴포넌트를 등록해주면 끝입니다.

```tsx
import Intro from "./components/Intro";  
  
function App() {  
  
  return (  
      <Intro />  
  )  
}  
  
export default App
```

---

## 📘 Styled-Component 사용해보기

src/components/style 하위에 StyledCircle.tsx 파일을 만들어 주고 App.tsx에 추가해주면 끝입니다.

```tsx
import styled, {css} from "styled-components";  
  
// Circle  
interface CircleProps {  
    color?: string;  
    size?: string;  
}  
  
const StyledCircle = styled.div<CircleProps>`  
    width: 5rem;    height: 5rem;    background: ${props => props.color || 'black'};  
    border-radius: 50%;    ${props => props.size &&  
    css`  
    width: 10rem;    height: 10rem;  
    `}  
`;  
  
export default StyledCircle;
```

---
