## Zustand 상태 관리

**redux 대신  zustand를 사용하는 이유**

- 간단하고 unopinionated함
- 훅을 상태 소비의 주요한 수단으로 사용함
- 컨텍스트 프로바이더가 필요 없음
- [렌더링 없이 값 변화를 컴포넌트에 알릴 수 있음](https://github.com/pmndrs/zustand#transient-updates-for-often-occurring-state-changes)

<br>

**왜 context 대신  zustand를 사용하나요?**

- 적은 상용구
- 값이 바뀔 때만 렌더링함. (기본 deepEqual)
- 중앙화된 액션 베이스 상태 관리

<br>

**Zustand 설치**

```bash
npm i zustand
```

<br>

**Store 생성**

Zustand Store를 생성할때 `create()` 함수를 사용합니다.

```ts
import {create} from 'zustand';  
  
// Item  
interface Item {  
    id: string  
    description: string  
    completed: boolean  
}  
  
// ItemList  
interface ItemList {  
    items: Item[]  
    addItem: (description: string) => void  
}  
  
  
export const useItem = create<ItemList>((set) => ({  
    items: [],  
    addItem: (newItems: Item[]) => set({items: newItems})  
}))
```

<br>

**컴포넌트 바인딩**

어디서나 훅을 사용할 수 있고, Providers가 불필요하며, 상태를 선택하면  변경사항에 따라 컴포넌트가 리렌더링 됩니다.

```tsx
import { useItem } from "../../store/zustand/ItemStateZustand";  
import React from "react";  
  
interface TestProps {  
    description: string  
}  
  
const TestItem: React.FC<TestProps> = ({description}) => {  
    const { items, addItem } = useItem;  
  
    const onClickAdd = () => {  
        // 기존 아이템 배열 복사  
        const copyItems = [...items];  
  
        // 기존 배열에 Item 추가  
        copyItems.push({  
            id: Math.random().toString(36).substring(2, 11),  
            description,  
            completed: false  
        })  
  
        // 새로운 상태 지정  
        addItem(copyItems)  
    }  
  
    return (  
        <div>  
            <button onClick={() => onClickAdd}>Add Item</button>  
        </div>  
    )  
}  
  
export default TestItem;
```

<br>

