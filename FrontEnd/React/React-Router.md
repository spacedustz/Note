## React-Router

**react-router 설치**

```bash
npm i react-router-dom
```

<br>

`BrowserRouter`는 브라우저의 주소창과 상호작용하여 라우팅을 처리합니다. `Route` 컴포넌트는 경로(path)와 해당 경로에 맞는 컴포넌트를 설정합니다. `Switch` 컴포넌트는 여러 개의 `Route` 중 첫 번째 매칭되는 경로만 보여주도록 도와줍니다.

위 예제에서 `/` 경로에 대한 요청은 `Home` 컴포넌트가 보여지고, `/about` 경로에 대한 요청은 `About` 컴포넌트가 보여집니다. 그리고 어떤 경로와도 매칭되지 않으면(`NotFound`) 해당하는 페이지가 없다는 내용이 표시됩니다.

라우터 관련 기능들은 주소창의 URL 변경이나 링크 클릭과 같은 상호작용에 따라 자동으로 작동하며 적절한 페이지(컴포넌트)를 보여줍니다.

추가적으로, 각 페이지(컴포넌트) 내부에서 현재 URL 정보나 라우팅 파라미터 등에 접근하고 싶다면 React Router의 훅인 `useParams`, `useLocation`, 그리고 `useHistory` 등을 활용할 수 있습니다.

```tsx
import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';

// 페이지 컴포넌트 임포트 (예시)
import Home from './pages/Home';
import About from './pages/About';
import NotFound from './pages/NotFound';

const App: React.FC = () => {
  return (
    <Router>
      <Switch>
        <Route exact path="/" component={Home} />
        <Route path="/about" component={About} />
        <Route component={NotFound} />
      </Switch>
    </Router>
  );
}

export default App;
```

위 코드의 첫번째 Route 태그에 있는 `exact`는 정확히 일치하는 URL일 때만 라우팅 한다는 의미이며,

홈 화면에 설정을 해 놓아야 홈 화면과 다른 컴포넌트들이 동시에 출력 되는 문제를 방지할 수 있습니다.

`<Switch>`는 React Router에서 제공하는 컴포넌트로, 여러 개의 `<Route>` 중에서 첫 번째로 매칭되는 경로만 렌더링하도록 도와주는 역할을 합니다.