## 📘 RabbitMQ Dead Letter Exchange & TTL 설정

RabbitMQ는 기본적으로 메시지가 예상치 못하게 처리될 수 없을 경우 다시 Queue로 보내는 Re-Queuing을 수행합니다.

하지만 계속 동일한 에러로 메세지를 처리할 수 없을 경우, 이 메세지는 계속 Queue에 담기고 에러도 계속 생기는 루프가 될 것입니다.

<br>

RabbitMQ는 기본적으로 Delayed Message 기능을 지원하지 않으므로 플러그인을 설치하고 RabbitMQ를 재시작 해줍니다.

플러그인 설치, 서비스 재시작은 **관리자 권한 CMD**를 열어서 RabbitMQ가 설치된 디렉토리의 sbin 폴더 내부에서 진행해야 합니다.

```bash
# RabbitMQ Delayed Message Exchange 플러그인 설치
rabbitmq-plugins enable rabbitmq_delayed_message_exchange

# RabbitMQ 재시작
rabbitmq-service.bat stop
rabbitmq-service.bat start
```

<br>

**Message가 Dead Letter가 되는 3가지 조건**

- Requeue False로 설정되어 있는 Consumer가 reject/nack 응답을 통해서 거절한 Message.
    - Requeue True로 설정되어 있는 Consumer가 reject/nack 응답을 통해서 거절한 Message는, Message가 존재했던 Queue에 다시 Requeue되고 DLX 기능은 동작하지 않습니다.
- Per-message TTL (Time to Leave)이 만료한 Message.
- Queue가 가득차서 버려진 Message.

Dead Letter가 된 Message의 "x-death" Header에는 Message가 Dead Letter가 된 이유 및 관련 정보가 저장되어 있습니다.

<br>

**"x-death" Header에 저장되어 있는 주요 정보**

- reason : Message가 Dead Letter가 된 이유.
- time : Message가 Dead Letter가 시간.
- count : 동일한 reason, 동일한 queue에서 Message가 Dead Letter가 된 횟수.
- queue : Message가 Dead Letter가 되기전에 존재했던 Queue.
- exchange : Dead Letter가 된 Message를 마지막으로 처리한 Exchange. 여러번 DLX에 의해서 처리된 Message의 경우 DLX 정보가 저장되어 있을 수 있습니다.

<br>

이를 방지하고자 특정 횟수 이상의 Error가 발생한 메세지를 Dead Letter Exchange로 보내,

적절한 Error Handling 과정을 거치도록 설계해야 합니다.

<br>

**Dead Letter Exchange 란?**
- Dead Letter Exchange(DLX)란 처리할 수 없는 메시지를 전달하는 Exchange를 의미합니다.

**TTL (Time to Live) 란?**
- 메시지가 특정 Queue에 머무를 수 있는 시간을 설정할 수 있는 값입니다.
- Ququq별로 TTL 시간 세팅값은 각 어플레케이션 환경별로 개발자가 세팅할 수 있습니다.

<br>

예를 들어, 

`계속 Error가 발생한 메시지` & `특정 시간 Queue에 머무른 메시지`들을 Dead Letter Exchange에 쌓고 Admin에게 푸시 알림이 보내 Error Handling 과정을 거치도록 설계할 수 있습니다.



대충 Flow를 그려보고 해당 그림처럼 RabbitMQ의 Exchange와 Queue를 설정해보겠습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/dlx.png)

<br>

**Exchange (DLX) 생성**
- Exchange 생성 방법은 저번 글에서 포스팅 했으니 단순히 x.pics, x.pics.dlx 라는 이름의 아무 옵션이 안달린 2개의 Exchange를 만들어 줍니다.

<br>

**Queue (DLQ) 생성**
- 정상적인 데이터를 받을 q.pics 큐와 DLQ인 q.pics.dlx 큐를 만드는데 큐를 만들기 전 Arguments 부분에 설정해야 할 것이 있습니다.
- Argument 부분에 거부되거나 버려진 메시지(Dead Letter)에 대한 처리를 Key:Value 형식으로 `x-dead-letter-exchange : x.pics.dlx`로 설정해줍니다. 
- 이렇게 설정하면 버려지거나 거부된 메시지는 `x.pics.dlx` Exchange로 들어가게 됩니다.
- 그리고 DQL인 `q.pics.dlx`에서 `x.pics.dlx`와 바인딩 해주면서 Argument로 `x-dead-letter-routing-key : 설정할값`으로 Routing Key를 이욯애 바인딩 합니다.

---
## 📘 Client

지난번 MQTT Client를 만들때 썼던 코드인데 아래 코드에서 Stomp Client의 Subscribe 옵션인 `connectHeaderWithAutoConfirm` 변수를 봅시다.

StompHeader에 `x-queue-type`, `x-message-ttl` 등 RabbitMQ에서 설정한 Queue의 옵션들과 매핑 & 적용할 수 있습니다.

예를 들어, RabbitMQ 웹 관리 콘솔에서 Queue에 `x-message-ttl`을 적용했으면 이 클라이언트 코드에서도 적용을 해줘야 합니다.

만약 웹 관리 콘솔에 설정된 값을 클라이언트에서 헤더로 안넣어주면 Stomp 소켓이 열리지 않게 됩니다.

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