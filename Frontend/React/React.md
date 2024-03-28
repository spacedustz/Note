## React with TypeScript

React 핵심만 정리합니다. (TypeScript 기반)

<br>

**Solid Foundation**

- Components & JSX
- Props
- State & Events
- Outputting Content
- Styling
- Hooks
- Debugging

<br>

**Advanced Concepts**

- Refs & Portals
- Behind the Scenes
- HTTP Requests
- Side Effects
- Context API
- Authentication
- Advanced Hooks
- Redux
- Unit Testing
- Custom Hook
- Routing
- Next.js
- @stomp/stompjs
- zustand

---

## Project 생성 & 세팅

Browser-Based Setup(CodeSandbox&Similar) 방식은 제외하고 Local Setup 방식으로 프로젝트를 만들어 보겠습니다.

NodeJS를 설치하고 아래 두 방식 중 하나를 선택해 React App을 만듭니다.

<br>

**Create-React-App 방식**

``` bash
# 프로젝트 생성
npm i -g typescript
npx create-react-app [프로젝트 이름]

# 프로젝트 실행
npm start
```

<br>

**Vite 방식**

```bash
# 프로젝트 생성
npm i -g vite typescript
npm create vite@latest

# 프로젝트 실행
npm run dev
```

<br>

**타입스크립트 컴파일러 실행**

```bash
npx tsc [파일명].ts
```

<br>

**vite 기반 리액트 포트 변경**

- `package.json` 파일에서 `"dev": "vite"` 부분을 `"dev": "vite --port [원하는 포트]"` 로 변경

<br>

**tsconfig.json**

Linting 부분에`"allowSyntheticDefaultImports": true`를  사용하면, 기본적으로 default export가 없는 모듈에서도 default import를 허용합니다.

<br>

**추가된 패키지 (필요한 패키지가 생길 때마다 추가 중)**

- axios
- @types/node @types/react @types/react-dom @types/jest
- eslint
- chart.js & react-chartjs-2
- lodash @types/lodash
- chartjs-adapter-moment
- @reduxjs/toolkit react-redux @types/react-redux
- styled-component
- zustant
- stomp@stompjs

---

## Functional Component & Props

**함수형 컴포넌트 작성**

- `const Item` : Item이라는 새로운 상수를 선언합니다. 이 상수는 React의 함수형 컴포넌트를 나타냅니다.
- `React.FC<{items: string[]}>` : 여기서 `React.FC`는 "React Function Component"의 약어로, 이 컴포넌트가 함수형 컴포넌트임을 나타냅니다. `<{items: string[]}>` 부분은 제네릭을 사용하여 해당 컴포넌트의 `props`의 타입을 정의합니다. 즉, 이 컴포넌트는 `items`라는 이름의 prop을 받으며, 그 타입은 문자열의 배열(`string[]`)입니다.
- `(props) => { ... }` : 이것은 화살표 함수(arrow function)입니다. `props`는 이 컴포넌트에 전달된 속성들을 포함하는 객체입니다. 이 경우, `items`라는 속성만을 기대합니다.
- `return (...)` : 함수형 컴포넌트는 JSX를 반환합니다. 여기서는 `<ul>` 태그(리스트)를 반환합니다.
- `{props.items}` : 이 부분은 JSX 내에서 JavaScript 표현식을 삽입하기 위한 문법입니다. 여기서 `props.items`는 문자열의 배열(`string[]`)로 예상됩니다. 그러나 이렇게 배열을 직접 렌더링하면 React는 경고를 발생시킵니다. 이 부분은 아마도 원하는 동작을 수행하지 않을 것입니다. 각 항목을 `<li>` 태그로 감싸주려면 다음과 같이 변경해야 합니다:

```tsx
const Item: React.FC<{ items: string[] }> = (props) => {  
    return (  
        <ul>  
            {props.items.map((item, index) =>  
                <li key={index}>{item}</li>,  
            )}  
        </ul>  
    )  
}  
  
export default Item;
```

<br>

**App.tsx**

함수형 컴포넌트의 타입으로 `string[]`으로 정했으니 해당 컴포넌트에는 무조건 값이 들어가야 합니다.

```tsx
import './App.css'  
import ReactiveVar from "./components/ReactiveVar";  
  
function App() {  
    return (  
        <div>  
            <ReactiveVar items={['A', 'B']} />  
        </div>  
    );  
}  
  
export default App
```

---

## useRef & useState & Event

> **useRef**()

- 함수형 컴포넌트에서 이를 설정 할 때 `useRef` 를 사용하여 설정하는 기능,
- 특정 DOM을 선택할때에도 `useRef`를 사용할 수 있습니다. (ex: 입력칸을 제출하고 화면 포커싱을 다시 입력칸으로 이동시키기)
- TypeScript에서는 `Ref`를 생성하고 `제네릭에 타입을 꼭 명시해야 합니다.`

<br>

`useRef` Hook 은 DOM 을 선택하는 용도 외에도, 다른 용도가 한가지 더 있는데요, 바로, 컴포넌트 안에서 조회 및 수정 할 수 있는 변수를 관리하는 것 입니다.

**`useRef` 로 관리하는 변수는 값이 바뀐다고 해서 컴포넌트가 리렌더링되지 않습니다.**

리액트 컴포넌트에서의 상태는 상태를 바꾸는 함수를 호출하고 나서 그 다음 렌더링 이후로 업데이트 된 상태를 조회 할 수 있는 반면, `useRef` 로 관리하고 있는 변수는 설정 후 바로 조회 할 수 있습니다.

이 변수를 사용하여 다음과 같은 값을 관리 할 수 있습니다.

- `setTimeout`, `setInterval` 을 통해서 만들어진 `id`
- 외부 라이브러리를 사용하여 생성된 인스턴스
- scroll 위치

<br>

> **useState**() - `useState`는 컴포넌트의 상태를 관리하는 Hook입니다.

```tsx
const [num, setNum] = useState(0);
```

`useState`를 사용하는 방법은, 상태의 기본값을 넣어서 호출해주고 배열을 반환합니다..

첫번째 배열의 원소는 **현재 상태**, 두번째 원소는 **Setter 함수**입니다.

<br>

**RefInput.tsx**

- 사용자의 입력값이 Ref에 저장됩니다
- 폼이 제출되면 사용자 입력값을 enteredText로 변수에 담습니다.
- if문으로 검증
- 검증이 통과되면 함수형 컴포넌트의 파라미터인 props의 핸들러를 호출해서 입력값을 넘깁니다.

```tsx
import React, {useRef} from "react";  
  
const Input: React.FC<{onAddItem: (enteredText: string) => void}> = (props) => {  
    // Input Ref  
    const inputRef = useRef<HTMLInputElement>(null);  
  
    // Form 입력 시, Browser Default 방지  
    const submitHandler = (event: React.FormEvent) => {  
        event.preventDefault();  
  
        const enteredText = inputRef.current?.value;  
  
        // Input 검증  
        if (enteredText.trim().length === 0) {  
            // Throw an Error  
            return;  
        }  
  
        props.onAddItem(enteredText);  
    };  
  
    return <form onSubmit={submitHandler}>  
        <label htmlFor="text">Text Here</label>  
        <input type="text" id="text" ref={inputRef} />  
        <button>Add Item</button>  
    </form>  
}  
  
export default Input;
```

<br>

**App.tsx**

`useState`를 생성할때도 타입스크립트에선 제네릭에 상태의 타입을 명시해야 합니다.

- `useState`를 이용해 빈 상태 배열 생성
- RefInput에서 Props으로 넘긴 사용자의 입력값을 addItemHandler로 넘김
- addItemHandler에 사용자의 입력값이 들어오면 새 입력값 객체를 생성하고, setItem으로 상태 배열에 추가합니다.
- 이 때 배열에 바로 추가하는게 아닌 concat 등을 이용해 **새 배열을 반환해야 합니다. (중요)**

```tsx
import './App.css'  
import { useState } from 'react';  
  
import ReactiveFC from "./components/ReactiveFC";  
import Reactive from "./models/data";  
import RefInput from "./components/RefInput";  
  
function App() {  
    // State, RefInput으로 폼 제출하면 여기에 추가 돠어야함  
    const [item, setItem] = useState<Reactive[]>([]);  
  
    const addItemHandler = (text: string) => {  
        const newItem = new Reactive(text);  
  
        // 이전 상태를 기반으로 상태를 업데이터 하려면 함수 형식을 사용해야 함  
        // concat으로 새로운 Item을 추가한 새 배열 반환  
        setItem((pre) => {  
            return pre.concat(newItem);  
        });  
    };  
  
    return (  
        <div>  
            <RefInput onAddItem={addItemHandler} />  
            <ReactiveFC items={item} />  
        </div>  
    );  
}  
  
export default App
```

---

## 항목 삭제

**ReactiveFCItem.tsx**

- `<li>` 태그에 onClick 이벤트를 걸고 props.임의의 이름(함수)를 넣어줍니다.
- 컴포넌트의 FC 파라미터에 `onRemoveItem` 함수를 파라미터로 넣어줍니다.
- 클릭 이벤트니까 `onRemoveItem` 함수의 파라미터로 `event: React.MouseEvent`를 받아도 되지만 Optional이기 때문에 파라미터는 비워도 됩니다.

```tsx
const Item: React.FC<{text: string; onRemoveItem: () => void}> = (props) => {  
  
    return <li onClick={props.onRemoveItem}>{props.text}</li>  
}  
  
export default Item;
```

<br>

**ReactiveFC.tsx**

위의 아이템을 실제로 사용하는 곳에서는 단순히 App.tsx로 동일하게 props를 넘깁니다.

- 단 실제 사용하는 App.tsx에서 itemId를 이용해 단순히 ID를 삭제할거기 때문에 파라미터로 itemId를 넣어줍니다.
- `onRemoveItem={() => props.onRemoveItem(item.id)} ` 이부분에서 `bind(null, item.id)` 방식으로 함수 바인딩을 사용해도 되지만 단순한 화살표 함수를 이용해도 됩니다.

```tsx
import React from "react";  
import Reactive from "../models/data";  
import ReactiveFCItem from "./ReactiveFCItem";  
  
const Item: React.FC<{ items: Reactive[]; onRemoveItem: (itemId: string) => void }> = (props) => {  
    return (  
        <ul>  
            {props.items.map((item) =>  
                <ReactiveFCItem  
                    key={item.id}  
                    text={item.text}  
                    onRemoveItem={() => props.onRemoveItem(item.id)}  
                />  
            )}  
        </ul>  
    )  
}  
  
export default Item;
```

<br>

**App.tsx**

- 하위 컴포넌트가 받을 props인 `onRemoveItemHandler`를 작성합니다.
- 상태는 이전 상태를 기준으로 업데이트 해야 하기 떄문에 파라미터로 pre를 받아줍니다.
- filter를 이용하여 Item의 id 값이 같은것만 삭제합니다.
- `<ReactiveFC items={item} onRemoveItem={removeItemHandler} />` 컴포넌트에 핸들러를 연결해줍니다.

```tsx
import './App.css'  
import { useState } from 'react';  
  
import ReactiveFC from "./components/ReactiveFC";  
import Reactive from "./models/data";  
import RefInput from "./components/RefInput";  
  
function App() {  
    // State, RefInput으로 폼 제출하면 여기에 추가 돠어야함  
    const [item, setItem] = useState<Reactive[]>([]);  
  
    // 아이템 추가 핸들러  
    const addItemHandler = (text: string) => {  
        const newItem = new Reactive(text);  
  
        // 이전 상태를 기반으로 상태를 업데이터 하려면 함수 형식을 사용해야 함  
        // concat으로 새로운 Item을 추가한 새 배열 반환  
        setItem((pre) => {  
            return pre.concat(newItem);  
        });  
    };  
  
    // 아이템 삭제 핸들러  
    // 상태는 이전 상태를 기준으로 업데이트 하기 때문에 pre(전) 상태를 파라미터로 받는다  
    const removeItemHandler = (itemId: string) => {  
        setItem((pre) => {  
            // 삭제하려는 itemId가 이전 상태 배열의 아이템 중 일치하는 item이 있다면 삭제  
            return pre.filter(item => item.id !== itemId)  
        });  
    };  
  
    return (  
        <div>  
            <RefInput onAddItem={addItemHandler} />  
            <ReactiveFC items={item} onRemoveItem={removeItemHandler} />  
        </div>  
    );  
}  
  
export default App
```

---

## useEffect

`useEffect`는 마운트/언마운트/업데이트 시 할 작업을 설정할 수 있는 LifeCycle Hook입니다.

`useEffect`는 2개의 파라미터를 받습니다.

- 1번 파라미터 : 함수(effect)
- 2번 파라미터 : 배열(deps)

<br>

1번째 파라미터는 단순히 실행시킬 함수를 등록하면 됩니다.

2번쨰 파라미터인 배열이 **빈 배열이라면 컴포넌트가 마운트 될 시 에만 적용**이 됩니다.

```tsx
useEffect(() => {
	// 1. 실행할 함수,
	// 2. 빈 배열
});
```

<br>

그리고 **배열에 특정 배열을 넣을 경우**, 해당 배열이 업데이트 될 때만 1번째 파라미터인 함수가 실행됩니다.

```tsx
useEffect(() => {
	// 1. 실행할 함수,
	// 2. 특정 배열
});
```

<br>
**※ cleanup 함수**  

- useEffect 안에서 return 할 때 실행 된다.(useEffcet의 뒷정리를 한다.)
- 만약 컴포넌트가 마운트 될 때 이벤트 리스너를 통해 이벤트를 추가하였다면 컴포넌트가 언마운트 될 때 이벤트를 삭제 해주어야 한다.

그렇지 않으면 컴포넌트가 리렌더링 될 때마다 새로운 이벤트 리스너가 핸들러에 바인딩 될 것이다. 이는 자주 리렌더링 될 경우 메모리 누수가 발생할 수 있다.

```tsx
useEffect(() => {
 // 함수 처리부
 return () => {
	 // cleanup
 }
});
```

---

## useMemo

`useMemo` - 성능 최적화를 위하여 연산된 값을 `useMemo`라는 Hook 을 사용하여 재사용하는 방법을 알아보도록 하겠습니다.

예를 들어 유저의 필드 중 `active: true` 인 것들만 찾아서 렌더링 한다고 했을때 active 값이 true인 사용자를 찾는 예시를 보겠습니다.

```tsx
const countActiveUsers(users: User[]): number {
	console.log('활성화 상태인 사용자 수를 세는중...');
	return users.filter(user => user.active).length;
}
```

위 코드에서 활성 사용자 수를 세는건 users 에 변화가 있을때만 세야되는건데 input 값이 바뀔 때에도

컴포넌트가 리렌더링 되므로 이렇게 불필요할때에도 호출하여서 자원이 낭비되고 있습니다.

<br>

이러한 상황에서 `useMemo`라는 Hook 함수를 사용하여 성능을 최적화 할 수 있습니다.

Memo는 `memoized`를 의미하는데, 이전에 계산한 값을 재사용한다는 의미를 가지고 있습니다.

```tsx
const countActiveUsers(users: User[]): number {
	console.log('활성화 상태인 사용자 수를 세는중...');
	return users.filter(user => user.active).length;
}

const count = useMemo(() => countActiveUsers(users), [users]);
```

`useMemo` 의 첫번째 파라미터에는 어떻게 연산할지 정의하는 함수를 넣어주면 됩니다.

두번째 파라미터에는 deps 배열을 넣어주면 되는데 이 배열 안에 넣은 내용이 바뀌면,

등록한 함수를 호출해서 값을 연산해주고, 만약에 내용이 바뀌지 않았다면 이전에 연산한 값을 재사용하게 됩니다.

---

## useCallback

`useCallback`은 `useMemo`와 비슷한 Hook입니다.

`useMemo`는 특정 결과값을 재사용 할 때 사용하는 반면, `useCallback`은 특정 함수를 재사용 하고 싶을 때 사용합니다.

<br>

예시로 아래의 세 함수 `onCreate, onRemove, onToggle`을 보겠습니다.

```tsx
import React, { useState, useRef } from 'react';  
  
interface User {  
    id: number;  
    username: string;  
    email: string;  
    active?: boolean;  
}  
  
const App: React.FC = () => {  
    const nextId = useRef(1);  
    const [users, setUsers] = useState<User[]>([]);  
    const [inputs, setInputs] = useState({ username: '', email: '' });  
  
    const onCreate = () => {  
        const user: User = {  
            id: nextId.current,  
            username: inputs.username,  
            email: inputs.email  
        };  
        setUsers(prevUsers => [...prevUsers, user]);  
  
        setInputs({  
            username: '',  
            email: ''  
        });  
        nextId.current += 1;  
    };  
  
    const onRemove = (id: number) => {  
        setUsers(prevUsers => prevUsers.filter(user => user.id !== id));  
    };  
  
    const onToggle = (id: number) => {  
        setUsers(prevUsers =>  
            prevUsers.map(user =>  
                user.id === id ? { ...user, active: !user.active } : user  
            )  
        );  
    };  
  
    return (  
        <div>  
            {/* 컴포넌트 JSX 내용 */}  
        </div>  
    );  
};  
  
export default App;
```

위 함수들은 컴포넌트가 리렌더링 될 때 마다 새로 만들어집니다.

함수를 선언하는 것 자체는 사실 메모리도, CPU 도 리소스를 많이 차지 하는 작업은 아니기 때문에 함수를 새로 선언한다고 해서,

그 자체 만으로 큰 부하가 생길일은 없지만, 한번 만든 함수를 필요할때만 새로 만들고 재사용하는 것은 여전히 중요합니다.

그 이유는, 나중에 컴포넌트에서 `props` 가 바뀌지 않았으면 Virtual DOM 에 새로 렌더링하는 것 조차 하지 않고 컴포넌트의 결과물을 재사용 하는 최적화 작업을 할때 함수를 재사용하는것이 필수입니다.

<br>

useCallback 은 이런식으로 사용합니다.

```tsx
import React, { useState, useRef, useCallback } from 'react';  
  
interface User {  
    id: number;  
    username: string;  
    email: string;  
    active: boolean;  
}  
  
interface InputValues {  
    username: string;  
    email: string;  
}  
  
function App() {  

	// ... 나머지 코드

    const onCreate = useCallback(() => {  
        const user: User = {  
            id: nextId.current,  
            username,  
            email,  
            active: true  
        };  
        setUsers(prevUsers => prevUsers.concat(user));  
  
        setInputs({  
            username: '',  
            email: ''  
        });  
        nextId.current += 1;  
    }, [username, email]);  
  
    const onRemove = useCallback(  
        (id: number) => {  
            setUsers(prevUsers => prevUsers.filter(user => user.id !== id));  
        },  
        [users]  
    );  
  
    const onToggle = useCallback(  
        (id: number) => {  
            setUsers(prevUsers =>  
                prevUsers.map(user =>  
                    user.id === id ? { ...user, active: !user.active } : user  
                )  
            );  
        },  
        [users]  
    );  
  
    const count = users.filter(user => user.active).length;  
  
    return (  
        <>  
            {/* 여기에 CreateUser와 UserList 컴포넌트 사용 */}  
            <div>활성사용자 수 : {count}</div>  
        </>  
    );  
}  
  
export default App;
```

주의할 점은, 함수 안에서 사용하는 상태 혹은 props 가 있다면 꼭, `deps` 배열안에 포함시켜야 된다는 것 입니다.

만약에 `deps` 배열 안에 함수에서 사용하는 값을 넣지 않게 된다면, 함수 내에서 해당 값들을 참조할때 가장 최신 값을 참조 할 것이라고 보장 할 수 없습니다.

props 로 받아온 함수가 있다면, 이 또한 `deps` 에 넣어주어야 해요.

사실, `useCallback` 은 `useMemo` 를 기반으로 만들어졌습니다.

다만, 함수를 위해서 사용 할 때 더욱 편하게 해준 것 뿐이지요. 이런식으로도 표현 할 수 있습니다.

---

## useReducer

지금까지는 `useState`를 사용해 상태관리 로직을 컴포넌트 내부에 사용했었습니다.

`useReducer`를 사용하면 상태 관리 로직을 컴포넌트에서 분리시킬 수 있습니다.

즉, 상태 관리만을 위한 파일에 작성 후, import로 불러와서 사용할 수 있다는 의미입니다.

<br>

> **reducer란?**

`Reducer`란 현재 상태와 액션 객체를 파라미터로 받아와서 새로운 상태를 반환해주는 함수입니다.

reducer 에서 반환하는 상태는 곧 컴포넌트가 지닐 새로운 상태가 됩니다.

여기서 `action` 은 업데이트를 위한 정보를 가지고 있습니다. 주로 `type` 값을 지닌 객체 형태로 사용하지만, 꼭 따라야 할 규칙은 따로 없습니다.

```ts
type Action =  
    | { type: 'LOGIN_SUCCESS'; payload: { userId: string } }  
    | { type: 'LOGIN_FAILURE'; payload: { error: string } };  
  
function reducer(state: State, action: Action): State {  
    switch (action.type) {  
        case 'LOGIN_SUCCESS':  
            // 로그인 성공 시 상태 변경 로직  
            // action.payload.userId를 사용하여 상태를 업데이트  
            return nextState;  
  
        case 'LOGIN_FAILURE':  
            // 로그인 실패 시 상태 변경 로직  
            // action.payload.error를 사용하여 상태를 업데이트  
            return nextState;  
  
        default:  
            return state;  
    }  
}
```

<br>

**`State & Action`**

상태의 타입을 나타내며, `Action`은 가능한 모든 액션의 타입을 나타냅니다.

각 액션에 대한 타입과 payload의 타입을 적절히 정의하여 사용하면 됩니다.

<br>

**`Payload`**

액션 객체 안에 포함되는 데이터를 가리키는 용어입니다.

액션은 어떤 종류의 변화가 일어나야 하는지를 나타내는 객체입니다. 그리고 이 액션에 따라 상태(state)를 업데이트하기 위해 필요한 데이터는 `payload`라는 속성에 담겨집니다.

<br>

예를 들어, 사용자가 로그인하는 액션을 생각해보겠습니다.

이 액션은 로그인 성공 또는 실패에 따라 상태를 업데이트해야 할 것입니다.

<br>

위 예시에서 `payload`는 로그인 성공 시에는 `userId`를, 로그인 실패 시에는 `error`를 담고 있습니다.

액션 타입마다 어떤 데이터가 필요한지에 따라 `payload`의 구조가 다를 수 있습니다.

이를 통해 리듀서는 액션에 따른 적절한 상태 업데이트를 수행하게 됩니다.

<br>

**그럼 이제 Reducer를 알았으니 `useReducer`의 사용법을 알아보겠습니다.**

```ts
const [state, dispatch] = useReducer(reducer, initialState);  
```

여기서 `state` 는 컴포넌트에서 사용 할 수 있는 상태를 가르키게 되고, `dispatch` 는 액션을 발생시키는 함수라고 이해하면 됩니다.

이 함수는 다음과 같이 사용합니다: `dispatch({ type: 'INCREMENT' })`.

그리고 `useReducer` 에 넣는 첫번째 파라미터는 reducer 함수이고, 두번째 파라미터는 초기 상태입니다.

```tsx
import React, { useReducer } from 'react';  
  
interface State {  
    // 상태의 타입 정의  
}  
  
type Action =  
    | { type: 'ACTION_TYPE_1'; payload: /* payload의 타입 */ }  
    | { type: 'ACTION_TYPE_2'; payload: /* payload의 타입 */ }  
// 다른 액션들 추가  
  
function reducer(state: State, action: Action): State {  
    switch (action.type) {  
        case 'ACTION_TYPE_1':  
            // ACTION_TYPE_1에 따른 상태 변경 로직  
            // const nextState = ...  
            return nextState;  
  
        case 'ACTION_TYPE_2':  
            // ACTION_TYPE_2에 따른 상태 변경 로직  
            // const nextState = ...  
            return nextState;  
  
        // 다른 case 추가  
  
        default:  
            return state;  
    }  
}  
  
const initialState: State = {  
    // 초기 상태 값  
};  
  
const YourComponent: React.FC = () => {  
    const [state, dispatch] = useReducer(reducer, initialState);  
  
    // ... 컴포넌트의 나머지 코드 ...  
    return (  
        <div>  
            {/* 컴포넌트 JSX 내용 */}  
        </div>  
    );  
};  
  
export default YourComponent;
```

<br>

예시를 적용하면 이런 형태가 됩니다.

```tsx
import React, { useReducer } from 'react';  
  
interface State {  
    count: number;  
}  
  
type Action =  
    | { type: 'increment' }  
    | { type: 'decrement' }  
    | { type: 'reset' };  
  
const initialState: State = { count: 0 };  
  
function reducer(state: State, action: Action): State {  
    switch (action.type) {  
        case 'increment':  
            return { count: state.count + 1 };  
        case 'decrement':  
            return { count: state.count - 1 };  
        case 'reset':  
            return initialState;  
        default:  
            throw new Error('Unhandled action type');  
    }  
}  
  
function Counter() {  
    const [state, dispatch] = useReducer(reducer, initialState);  
  
    return (  
        <div>  
            Count: {state.count}  
            <button onClick={() => dispatch({ type: 'increment' })}>Increment</button>  
            <button onClick={() => dispatch({ type: 'decrement' })}>Decrement</button>  
            <button onClick={() => dispatch({ type: 'reset' })}>Reset</button>  
        </div>  
    );  
}  
  
export default Counter;
```

---

## Custom Hooks

컴포넌트를 만들다보면, 반복되는 로직이 자주 발생합니다. 예를 들어서 input 을 관리하는 코드는 관리 할 때마다 꽤나 비슷한 코드가 반복되죠.

이번에는 그러한 상황에 커스텀 Hooks 를 만들어서 반복되는 로직을 쉽게 재사용하는 방법을 알아보겠습니다.

<br>

프로젝트 src 디렉터리에 `hooks` 디렉터리를 만들고 useInput.ts 파일을 만듭니다.

**Custom Hook을 만들때는 보통 이렇게 `use`라는 키워드로 시작하는 파일을 만들고 그 안에 함수를 작성합니다.**

커스텀 Hooks 를 만드는 방법은 굉장히 간단합니다.

그냥, 그 안에서 `useState`, `useEffect`, `useReducer`, `useCallback` 등 Hooks 를 사용하여 원하는 기능을 구현해주고, 컴포넌트에서 사용하고 싶은 값들을 반환해주면 됩니다.

<br>

**Window.tsx**

예시로 간단한 Custom Hook인 `useWindowWidth`를 작성해보겠습니다. 이 Hook은 현재 창의 너비를 추적하고 반환하는 역할을 합니다.

```tsx
import { useState, useEffect } from 'react';

function useWindowWidth(): number {
  const [windowWidth, setWindowWidth] = useState(window.innerWidth);

  useEffect(() => {
    const handleResize = () => {
      setWindowWidth(window.innerWidth);
    };

    window.addEventListener('resize', handleResize);

    return () => {
      window.removeEventListener('resize', handleResize);
    };
  }, []);

  return windowWidth;
}
```

<br>

**App.tsx**

```tsx
import React from 'react';
import useWindowWidth from './useWindowWidth';

const MyComponent: React.FC = () => {
  const windowWidth = useWindowWidth();

  return <div>Window Width: {windowWidth}px</div>;
}

```

---

## Context API

React에서 Context API란 상위 컴포넌트에서 하위 컴포넌트로 데이터를 전달하기 위한 메커니즘을 제공합니다.

Context API 를 사용하면, 프로젝트 안에서 전역적으로 사용 할 수 있는 값을 관리 할 수 있습니다.

<br>

우선, Context API 를 사용해서 새로운 Context 를 만드는 방법을 알아보겠습니다.

Context 를 만들 땐 다음과 같이 `React.createContext()` 라는 함수를 사용합니다.

```tsx
type ContextObject = {  
    items: Reactive[];  
    addItem: (text: string) => void;  
    removeItem: (id: string) => void;  
}  
  
const UserDispatch = React.createContext<ContextObject>(null);
```

`createContext` 의 파라미터에는 Context 의 기본값을 설정할 수 있습니다. 여기서 설정하는 값은 Context 를 쓸 때 값을 따로 지정하지 않을 경우 사용되는 기본 값 입니다.

<br>

Context 를 만들면, Context 안에 Provider 라는 컴포넌트가 들어있는데 이 컴포넌트를 통해 Context 의 값을 정할 수 있습니다.

이 컴포넌트를 사용할 때는, `value` 라는 값을 설정해주면 됩니다.

```tsx
<UserDispatch.Provider value={dispatch}>...</UserDispatch.Provider>
```

이렇게 설정해주고 나면 Provider 에 의하여 감싸진 컴포넌트 중 어디서든지 우리가 Context 의 값을 다른 곳에서 바로 조회해서 사용 할 수 있습니다.

<br>

**App.tsx**

App.tsx에 많은 이벤트 핸들러와 변수, 함수 등이 있다고 가정하고 전부 MainContext.tsx로 옮깁니다.

그리고 MainContext에 정의된 ContextProvider를 통해 메인 앱에 출력합니다.

ContextProvider 컴포넌트는 바로 아래에서 설명하겠습니다.

```tsx
import './App.css'  
  
import ReactiveFC from "./components/item/ReactiveFC";  
import RefInput from "./components/item/RefInput";  
import ContextProvider from "./components/context/MainContext";  
  
const App: React.FC = () => {  
    return (  
        <ContextProvider>  
            <RefInput />  
            <ReactiveFC />  
        </ContextProvider>  
    );  
}  
  
export default App
```

<br>

**MainContext.tsx**

App.tsx에 있던 핸들러와 아이템 삭제 함수 등을 전부 `ContextProvider` 컴포넌트에 넣었습니다.

그리고, MainContext를 `React.createContext<ContextObject>`의 하위 컴포넌트로 넣어서,

반환할 때 MainContext 컴포넌트에 `props.children`으로 메인 컴포넌트에 넣어줍니다.

<br>

아래 코드는 React 컴포넌트에서 상태 관리와 컨텍스트를 사용하는 방법을 보여줍니다.

1. `ContextObject` 타입 정의: `items` 배열은 `Reactive` 타입의 요소를 가지며, `addItem`와 `removeItem`은 각각 문자열과 아이템 ID를 매개변수로 받는 함수입니다.

2. `MainContext` 생성: `React.createContext<ContextObject>()`를 사용하여 컨텍스트 객체인 `MainContext`를 생성합니다. 초기값으로는 빈 배열을 가진 `items`, 빈 함수(`addItem`, `removeItem`)가 제공됩니다.

3. `ContextProvider`: 이 함수형 컴포넌트는 상태와 이벤트 핸들러를 관리하고, 해당 값을 컨텍스트로 제공합니다.

    - 상태: 초기값으로 빈 배열인 `item`과 함께 useState 훅을 사용하여 선언됩니다.
    - 아이템 추가 핸들러(`addItemHandler`): 새로운 아이템을 생성한 후, 이전 상태 배열에 새로운 아이템을 추가하는 방식으로 상태 업데이트가 이루어집니다.
    - 아이템 삭제 핸들러(`removeItemHandler`): 주어진 아이디와 일치하지 않는 모든 아이템만 남기고 필터링하여 상태 업데이트가 이루어집니다.
    - contextValue: 위에서 정의한 ContextObject 타입에 따라 현재 상태와 핸들러 함수들을 포함하는 객체입니다.
    - `<MainContext.Provider>`: contextValue 값을 MainContext.Provider의 value 속성에 전달하여 자식 컴포넌트에서 해당 값에 액세스할 수 있도록 합니다.
4. ContextProvider 내보내기: ContextProvider 컴포넌트를 외부에서 임포트할 수 있도록 내보냅니다.


<br>

MainContext.Provider 하위에 있는 자식 컴포넌트에서 useContext(MainContext) 훅을 사용하여 items 배열과 addItem, removeItem 함수에 액세스할 수 있습니다.

```tsx
import React, {useState} from 'react';  
import Reactive from "../../models/data";  
  
type ContextObject = {  
    items: Reactive[];  
    addItem: (text: string) => void;  
    removeItem: (id: string) => void;  
}  
  
// Context Hook을 위해 export 필요  
export const MainContext = React.createContext<ContextObject>({  
    items: [],  
    addItem: () => {},  
    removeItem: () => {}  
});  
  
// Context의 요소를 구성하는 함수형 컴포넌트, Context의 상태를 관리함  
const ContextProvider: React.FC<React.PropsWithChildren> = (props) => {  
  
    // State, RefInput으로 폼 제출하면 여기에 추가 돠어야함  
    const [item, setItem] = useState<Reactive[]>([]);  
  
    // 아이템 추가 핸들러  
    const addItemHandler = (text: string) => {  
        const newItem = new Reactive(text);  
  
        // 이전 상태를 기반으로 상태를 업데이터 하려면 함수 형식을 사용해야 함  
        // concat으로 새로운 Item을 추가한 새 배열 반환  
        setItem((pre) => {  
            return pre.concat(newItem);  
        });  
    };  
  
    // 아이템 삭제 핸들러  
    // 상태는 이전 상태를 기준으로 업데이트 하기 때문에 pre(전) 상태를 파라미터로 받는다  
    const removeItemHandler = (itemId: string) => {  
        setItem((pre) => {  
            // 삭제하려는 itemId가 이전 상태 배열의 아이템 중 일치하는 item이 있다면 삭제  
            return pre.filter(item => item.id !== itemId)  
        });  
    };  
  
    const contextValue: ContextObject = {  
        items: item,  
        addItem: addItemHandler,  
        removeItem: removeItemHandler  
    };  
  
    return <MainContext.Provider value={contextValue}>{props.children}</MainContext.Provider>  
};  
  
export default ContextProvider;
```

<br>

**ReactiveFC.tsx**

기존에 props을 받던것을 userContext를 이용해서 컨텍스트를 받아 props을 context로 대체합니다.

```tsx
import React, {useContext} from "react";  
  
import ReactiveFCItem from "./ReactiveFCItem";  
import {MainContext} from "../context/MainContext";  
  
const Item: React.FC = () => {  
    const context = useContext(MainContext)  
  
    return (  
        <ul>  
            {context.items.map((item) =>  
                <ReactiveFCItem  
                    key={item.id}  
                    text={item.text}  
                    onRemoveItem={context.removeItem.bind(null, item.id)}  
                />  
            )}  
        </ul>  
    )  
}  
  
export default Item;
```

<br>

**RefInput.tsx**

기존에 props을 받던것을 userContext를 이용해서 컨텍스트를 받아 props을 context로 대체합니다.

```tsx
import React, {useRef, useContext} from "react";  
import {MainContext} from "../context/MainContext";  
  
const Input: React.FC = () => {  
    const context = useContext(MainContext);  
  
    // Input Ref  
    const inputRef = useRef<HTMLInputElement>(null);  
  
    // Form 입력 시, Browser Default 방지  
    const submitHandler = (event: React.FormEvent) => {  
        event.preventDefault();  
  
        const enteredText = inputRef.current?.value;  
  
        // Input 검증  
        if (enteredText.trim().length === 0) {  
            // Throw an Error  
            return;  
        }  
  
        context.addItem(enteredText);  
    };  
  
    return <form onSubmit={submitHandler}>  
        <label htmlFor="text">Text Here</label>  
        <input type="text" id="text" ref={inputRef} />  
        <button>Add Item</button>  
    </form>  
}  
  
export default Input;
```

---

## HTTP Request

API 연동을 위해 axios를 설치해줍니다.

```bash
npm i axios
```

<br>

**axios의 사용법**

```tsx
import axios from 'axios';

// Get
axios.get('/users/1');

// Post
axios.post('/users', {
	username: 'skw',
	name: 'skw'
});
```

<br>

`useState`와 `useEffect`를 사용하여 컴포넌트가 렌더링되는 시점에 API에 요청을 보내는 예시 코드입니다.

요청에 대한 상태를 관리 할때는 다음과 같이 총 3가지의 상태를 관리해주어야 합니다.

- 요청의 결과
- 로딩 상태
- 에러

아래 코드에서 `useEffect`의 첫번쨰 파라미터로 등록하는 함수는 `async`를 사용할 수 없기 때문에 함수 내부에서 `async`를 사용하는 새로운 함수를 선언해주어야 합니다.

```tsx
import React, { useState, useEffect } from 'react';
import axios from 'axios';

interface User {
  id: number;
  username: string;
  name: string;
}

export default const Users(): React.FC = () => {

  // 초기 상태 설정
  const [users, setUsers] = useState<User[] | null>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const fetchUsers = async (): Promise<void> => {
      try {
        // 요청이 시작할 때 error와 users를 초기화하고, loading 상태를 true로 바꿉니다.
        setError(null);
        setUsers(null);
        setLoading(true);

		// API 요청
        const response = await axios.get<User[]>(
          'https://jsonplaceholder.typicode.com/users'
        );
        setUsers(response.data); // 데이터는 response.data 안에 들어있습니다.
      } catch (e) {
        setError(e as Error);
      }
      setLoading(false);
    };

    fetchUsers();
  }, []);

  if (loading) return <div>로딩중..</div>;
  if (error) return <div>에러가 발생했습니다</div>;
  if (!users) return null;
  
  return (
    <ul>
      {users.map((user: User) => (
        <li key={user.id}>
          {user.username} ({user.name})
        </li>
      ))}
    </ul>
  );
}
```
