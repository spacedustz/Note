## Styled-Component

`styled-components`는 React에서 사용되는 CSS-in-JS 라이브러리입니다. 이 라이브러리를 사용하면 JavaScript 코드 내에서 CSS 스타일을 작성할 수 있습니다.

기존의 CSS 스타일링 방식은 별도의 CSS 파일을 생성하고 클래스 이름을 통해 스타일을 적용하는 방식이었습니다. 

하지만 `styled-components`를 사용하면 컴포넌트 자체에 스타일을 적용할 수 있어서, 컴포넌트와 관련된 스타일 코드를 한 곳에서 관리할 수 있게 됩니다.

<br<

`styled-components`를 사용하여 정의한 컴포넌트는 일반적인 React 컴포넌트와 동일한 방식으로 사용됩니다. 

다만, 해당 컴포넌트에 적용된 스타일은 `styled-components`가 자동으로 생성한 고유한 클래스 이름으로 적용됩니다.

예를 들어, 아래와 같이 `styled.div` 함수를 사용하여 `<div>` 요소에 스타일을 적용할 수 있습니다.


```tsx
interface CircleProps {  
    color?: string;  
    size?: string;  
}  

// div Styled Component
const Circle = styled.div<CircleProps>`  
    width: 5rem;    
    height: 5rem;    
    background: ${props => props.color || 'black'};  
    border-radius: 50%;    
    ${props => props.size &&   
    css`  
    width: 10rem;    
    height: 10rem;  
    `}  
`;  
  
const App: React.FC = () => {  
  
    const onSubmit = (form: { name: string; description: string; }) => {  
        console.log(form);  
    }  
  
    return (  
        <ContextProvider>  
            <div>  
                <RefInput/>  
                <ReactiveFC/>  
            </div>  
  
            <div>  
                <Counter/>  
                <CounterForm onSubmit={onSubmit}/>  
            </div>  
  
            <div>  
                <ReducerContext>  
                    <CounterReducer/>  
                    <Circle color="blue" size={false}/>  
                </ReducerContext>  
            </div>  
        </ContextProvider>  
    );  
}  
  
export default App
```

