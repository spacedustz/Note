## Redux

리액트에서 리덕스를 사용하기 위해서 필요한 패키지를 먼저 설치합니다. 

```
npm i @reduxjs/toolkit react-redux
```

<br>

타입스크립트를 위해서 해당 패키지가 필요하지 않은가 생각할 수 있지만 

react-redux 7.2.3버전부터 해당 패키지를 포함하고 있기 때문에 이후 버전은 설치할 필요가 없습니다.

```
npm i @types/react-redux
```

<br>

**Store** 

- 전체 저장소( 상태 ) 가 들어가 있습니다.
- 하나의 프로젝트는 하나의 스토어를 권장하지만,
- 필요하다면 여러개도 가능은 합니다. 

**Reducer** 

- 변화를 일으키는,  그리고 초기값을 지정하는 공간입니다.
- 필요에 따라 여라가지 Reducer가 들어갑니다. 

**Hooks** 

- Dispatch나 Selecter를 쉽게 사용하기 위한 커스텀 훅을 작성할 것입니다. 
- 이쪽은 Redux관련 Hook만 들어가는 것이 아닌 필요에 따라 다양하게 활용합니다.

<br>

>**Redux 사용해보기**

**store/index.ts**

아직 Reducer를 만들지 않았기 때문에 들어가는 것은 없고, 

RootState와 AppDispatch는 Hooks에서 사용될 Dispatch와 Selector에 사용할 타입입니다.

```tsx
import { configureStore } from "@reduxjs/toolkit";  
  
export const store = configureStore({  
    reducer: {},  
});  
  
export type RootState = ReturnType<typeof store.getState>;  
export type AppDispatch = typeof store.dispatch;
```

<br>

**hooks/index.ts**

```tsx

```