## 📘 MQTT Client 설정

MQTT Client는 React + TypeScript 환경에서 진행합니다.

RabbitMQ와의 Socket 통신을 위해 @stomp/stompjs 패키지를 설치해줍니다.

<br>

> 📌 **RabbitMqWebSocketHandler.tsx**

이제 프론트엔드 서버인 React에 MQTT Client 코드를 작성합니다.

웹 소켓을 열고 RabbitMQ의 웹 소켓 플러그인의 포트인 15674,15675 둘중 하나에 `ws://URL/ws`로 연결해줍니다.

나머지 코드는 Exchange와 Queue & Topic에 대한 설정입니다.

<br>
**Quorum Queue를 사용했으므로 Stomp Client Header에 `autoConfirm 옵션을 true`로 설정해주었습니다.**

Exchange & Queue에 맞는 Routing Key와 Topic을 설정하고 출력하는 컴포넌트를 작성했습니다.

Subscribe 해제는 별도의 버튼을 만들었는데, 이유는 RabbitMQ에서 데이터의 영속성 테스트를 할때 편하게 하려고 만들었습니다.

```tsx
import React, { useEffect, useState } from 'react';  
import { Client, StompHeaders } from '@stomp/stompjs';  
  
interface RabbitMqWebSocketHandlerState {  
    messages: string[];  
    subscribed: boolean;  
    client: Client;  
}  
  
const RabbitMqWebSocketHandler: React.FC<RabbitMqWebSocketHandlerState> = () => {  
    const [messages, setMessages] = useState<string[]>([]);  
    const [subscribed, setSubscribed] = useState(false);  
    const [client, setClient] = useState<Client>();  
  
    // Life Cycle Hooks  
    useEffect(() => {  
        subscribeToQueue();  
        return () => {  
            unSubscribeFromQueue();  
        };  
    }, []);  
  
    // 구독 함수  
    const subscribeToQueue = () => {  
        const client = new Client({  
            brokerURL: 'ws://localhost:15674/ws',  
  
            // RabbitMQ 관리 콘솔 인증 정보  
            connectHeaders: {  
                login: 'guest',  
                passcode: 'guest',  
            },  
            debug: (str: string) => {  
                console.log(str);  
            },  
        });  
  
        // Stomp Client Header - AutoConfirm, Message TTL 옵션 추가  
        const connectHeadersWithAutoConfirm: StompHeaders = {  
            ...client.connectHeaders,  
            'x-queue-type': 'quorum',  
            'x-message-ttl': 200000,  
            autoConfirm: true,  
        };  
  
        // Quorum Queue Subscribe  
        client.onConnect = () => {  
            console.log('Socket Connected');  
            // 1번째 파라미터로 Queue 이름, 2번째는 콜백 함수  
            client.subscribe('q.frame', (frame) => {  
                    const newMessage = `Test - Message: ${frame.body}`;  
                    setMessages((prevMessages) => [...prevMessages, newMessage]);  
                },  
                {  
                    id: 'Test-Subscribe',  
                    ...connectHeadersWithAutoConfirm,  
                });  
            setSubscribed(true);  
        };  
  
        // 오류 메시지의 세부 정보 출력  
        client.onStompError = (frame) => {  
            console.error('STOMP error', frame.headers['message']);  
            console.log('Error Details:', frame.body);  
        };  
  
        setClient(client);  
        client.activate();  
    };  
  
    // 구독 해제 함수, 버튼을 클릭하면 구독을 해제함  
    const unSubscribeFromQueue = () => {  
        if (client) {  
            client.unsubscribe('Test-Subscribe');  
            setClient(null);  
            setSubscribed(false);  
        }  
    };  
  
    return (  
        <div>  
            <h2>RabbitMQ Listener</h2>  
            <ul>  
                {messages.map((message, index) => (  
                    <li key={index}>  
                        <p>{message}</p>  
                    </li>  
                ))}  
            </ul>  
            {!subscribed ? (  
                <button onClick={subscribeToQueue}>Subscribe</button>  
            ) : (  
                // 구독 중일 때 해지 버튼  
                <button onClick={unSubscribeFromQueue}>Unsubscribe</button>  
            )}  
        </div>  
    );  
};  
  
export default RabbitMqWebSocketHandler;
```

<br>

RabbitMQ의 소켓 포트인 15674 포트를 확인해보면 양방향으로 Established 된것을 확인 할 수 있습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/socket.png)

<br>

프론트엔드 서버의 URL로 들어가보면 웹 소켓을 통해 실시간으로 데이터가 계속 들어옵니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/connectsocket.png)

<br>

간단하게 MQTT 데이터를 RabbitMQ를 통해 Queue로 받아서 프론트엔드에서 실시간 통신을 해보았습니다.

---
## 📘 Topic Message Persist(데이터 영속성) 테스트

Topic Message가 RabbitMQ 재기동 했을시 사라지지 않고, 추가 데이터도 잘 받아지는지 확인하였습니다.

- Subscriber (React) 중지
- MQTT -> RabbitMQ로 쿼럼 큐에 데이터 쌓임
- RabbitMQ 재기동 -> 데이터 살아있음
- Subscriber ON (큐에 쌓인 데이터 전체 출력 완료)
- 다시 MQTT 데이터 추가로 내보내기
- Subscriber (React) 에 정상 도착

<br>

아래 사진을 보면, 

MQTT 영상 분석 데이터 중 Frame ID가 260에서 끊겼다가 추가 데이터 전송 후 다시 0으로 시작하는 것을 볼 수 있습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/rabbit-test.png)

<br>

테스트는 완료했으니 다음 글에서는 데이터를 백엔드에서 받고, 

RabbitMQ <-> Backend와 실시간 통신을 해서 실시간으로 받은 데이터를 프론트엔드에서 RestAPI로 가져와서 

실시간으로 그래프가 변하는 Scatter 차트를 만들어 보겠습니다.