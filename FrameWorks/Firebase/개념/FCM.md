## 💡 FCM

출처

 https://donghun.dev/Firebase-Cloud-Messaging

<br>

참조 사이트

https://app.diagrams.net/ 

https://firebase.google.com/docs/cloud-messaging/send-message?hl=ko#send-messages-to-specific-devices-legacy 

---

### FCM이란 무엇인가?

- **FCM**은 **Firebase Cloud Messaging**의 약자로, 무료로 메시지를 안정적으로 전송할 수 있는 교차 플랫폼 메시징 솔루션이다.
- 모든 사용자에게 알림 메세지를 전송할 수도 있고, 그룹을 지어 메시지를 전송할 수도 있다.
- Friebase의 서비스는 요금 정책에 따라, 이용할 수 있는 범위가 다르지만 FCM은 요금 정책에 구분 없이 무료로 사용하는 것이 가능하다.

### 왜 FCM을 사용해서 Push 메시지를 보낼까?

- FCM이 어떤 것인지는 알겠으나, 왜 FCM을 사용해서 메세지를 전송하는지에 대해서 궁금증을 가지게 되어 찾아보았다.
  - 기존에는 iOS, Android, Web 등의 플랫폼에서 Push 메시지를 보내기 위해서는 각 플랫폼 환경(APNS, GCM)별로 개발해야 하는 불편함이 있었다.
  - 하지만 FCM은 교차 플랫폼 메시지 솔루션이기 때문에 FCM을 이용해서 개발을 진행하면, 플랫폼에 종속되지 않고 Push 메시지를 전송할 수 있다.
  - 즉, 위에서 얘기한 문제를 해결할 수 있는 좋은 대안이 된다.
- FCM을 이용했을 때 얻을 수 있는 이점은 위에서 확인할 수 있다. 하지만 근본적으로 클라우드 메시징 서비스를 이용해서 Push 메시지를 보내는 이유는 무엇일까? 서버 단에서 직접 로직을 처리해도 상관 없지 않을까? 라는 생각이 들어서 이와 관련된 내용을 찾아보았다.
  - 관련된 내용을 찾던 와중에 좋은 예시를 찾게 되어서 그 내용을 인용하고자 한다.
  - B라는 사람에게 어떠한 메시지를 전달하는 데 있어서, 아래와 같은 두 가지 상황을 생각해보자.
  - 첫번째 상황은 A가 B에게 메시지를 전달하기 위해, 어플리케이션을 열어서 메시지를 보내면, A의 메시지는 해당 어플리케이션의 서버를 거쳐서 B에게 도달하게 되는 상황이다.
    - A -> 어플리케이션 서버 -> B
  - 두번째 상황은 어플리케이션을 통해서 서비스를 제공하는 회사에서 B에게 마케팅을 위한 메시지를 보내기 위해서 어플리케이션 서버를 통해서 B에게 메시지를 보내는 상황이다.
    - 어플리케이션 서버 -> B
  - 위 두 가지 상황에 대해서 B가 실시간으로 메시지를 받기 위해서 B는 서버에 계속 접속해 있어야 한다. 이것을 실제로 구현한다면, 많은 배터리와 네트워크 사용으로 인해 문제가 생길 수 있다.
  - 클라우드 메시징 서비스를 이용하면, 위 문제를 어느정도 해결할 수 있다. 클라우드 메시징 서버를 중간에 둠으로써, 사용자는 낮은 배터리와 네트워크의 사용만으로도 메세지를 실시간으로 송수신 처리를 할 수 있기 때문이다.
    - A -> 어플리케이션 서버 -> 클라우드 메시징 서버 -> B
    - 대략 위와 같은 형태로 작업을 처리하게 된다.
  - 위와 같은 이유로 대부분의 어플리케이션 서비스들은 클라우드 메시징 서버를 경유해서, 실시간으로 유저들에게 메시지를 전송해주고 있다.

### FCM의 주요 특징

- 메세지 타입
  - FCM의 메세지 타입은 알림 메시지와 데이터 메시지로 구분할 수 있다.
  - 보통 알림 메세지와 데이터 메시지를 같이 혼용해서 사용한다.
    - 예를 들어, 휴대폰 푸시 알림 메세지는 알림 메세지를 이용하고, 알림 메세지를 클릭 하였을 때 앱 내 특정 페이지로 이동이나, 어떠한 액션은 데이터 메세지를 통해서 이뤄진다.

|  메세지 종류  | 알림 가능 여부 |              알림 저장 개수               |    알림 처리 방법     |
| :-----------: | :------------: | :---------------------------------------: | :-------------------: |
|  알림 메시지  |      가능      | 여러 알림을 저장하나, OS 환경마다 다르다. | 앱이 백그라운드 일 때 |
| 데이터 메시지 |      가능      |             1개의 알림만 저장             | 앱이 포그라운드 일 때 |

- 타켓팅
  - 단일 기기, 기기 그룹, 주제를 구독한 기기 3가지 방식으로 클라이언트 앱에 메시지를 배포할 수 있다.

|   종류    | 대상수 |          설명           |
| :-------: | :----: | :---------------------: |
| 단일 기기 |  1개   |  하나의 기기(앱 기준)   |
| 기기 그룹 |  20개  | 알림 키에 허용되는 그룹 |
| 주제 구독 | 1000개 | 등록 토큰에 구독된 기기 |

- 클라이언트 앱에서 메시지 전송
  - FCM을 이용하면 앱 서버에서 클라이언트 앱으로 다운 스트림 메세지를 보낼 수 있을 뿐만 아니라, 클라이언트 앱에서 앱 서버로도 업 스트림 메세지를 보낼 수 있다.
  - 하지만 클라이언트 앱에서 앱 서버로 업 스트림 메세지를 보내기 위해서는 선행 조건이 필요하다. 그 부분은 밑에서 설명한다.

### FCM의 동작 원리

크게 송신자, FCM Backend Server, 수신자로 구분한다.

<img src="https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/fb.png" alt="img" style="zoom:67%;" /> 

*[FCM 공식 문서](https://firebase.google.com/docs/cloud-messaging?hl=ko) 사진 참조.*

- 송신자는 주로 앱 서버, HTTP 프로토콜을 사용하는 서버, Firebase Console GUI 등이 될 수 있고, 수신자는 우리가 흔히 사용하는 iOS 또는 Android 운영체제를 사용하는 모바일 기가 될 수 있다.

- FCM Backend 서버는 실질적으로 앱 서버에서 요청을 받아서 메세지를 처리하는 서버에 해당된다.

- FCM 클라우드 메시지의 흐름

  - HTTP 프로토콜을 사용할 경우, FCM 클라우드 메시지가 처리되는 과정을 그림으로 나타내보면 다음과 같다.

  ![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/fb2.png)

  *[FCM 구조 관련 블로그](http://zeany.net/31?category=666373) 사진 참조.*

  - 앱 서버에서 FCM Backend 서버에 클라이언트 앱에 보내고자 하는 메세지를 담은 정보와, 서버의 인증 정보 클라이언트의 토큰을 담아서 HTTP POST를 요청을 보낸다.
  - 요청을 받은 FCM Backend 서버는 요청을 통해 받은 메시지의 이상 유무에 따라 앱 서버에 적절한 응답을 보낸다.
  - 이후 FCM Backend 서버에서 여러가지(우선 순위, 클라이언트 앱과의 통신 가능 여부 등)을 고려하여 매세지를 클라이언트 앱에 보낸다.
  - 클라이언트 앱에서는 받은 메세지를 적절하게 처리하고 응답 메세지를 FCM Backend 서버로 보내게 된다.
  - 요약하면, 앱 서버에서 FCM Backend 서버에 메시지 요청을 보내고, FCM Backend 서버는 사용자 기기에서 실행되는 클라이언트 앱에 메시지를 보내게 된다.

- 한 마디로 제대로 된 메시지만 만들어 주면 그것을 실제 기기로 전달하는 것은 FCM Backend에서 처리해줄 것이란 얘기다.

- 단, 위의 플로우 대로 메시지를 전송하려면 반드시 선행되어야 하는 작업이 있는데, 당연하겠지만 메시지를 수신할 클라이언트는 자신의 정보를 FCM Backend 서버에 등록해야 한다는 점이다.

  - 클라이언트는 자신의 정보(토픽, 디바이스 정보)를 FCM Backend 서버에 등록해야 한다.
  - 메시지를 전송할 주체(앱 서버)는 등록된 정보를 획득해야 하며, 해당 정보로 다운 스트림 메시지를 전송한다.

### FCM을 사용하기 위한 서버 환경 구성.

- FCM을 사용하기 위해 FCM Backend 서버와 통신을 위한 어플리케이션 서버를 구축하기 위해선 다음 3가지 규칙을 지켜야 한다.
- FCM Backend 서버에 FCM에서 지정한 형식의 메시지 요청을 보낼 수 있어야 한다.
- **지수 백오프**를 사용하여 요청을 처리하고 다시 보낼 수 있어야 한다.
  - *지수 백오프 : 요청이 실패할 때마다 다음 요청까지의 유휴시간 간격을 n배씩 늘리면서 재요청을 지연시키는 알고리즘이다.
    - 임의 지연을 사용하여 연쇄 충돌을 방지하기 위해서 사용한다.
- **서버 승인 사용자의 인증 정보**와 **클라이언트의 등록 토큰**을 안전하게 저장 할 수 있어야 한다.
  - 서버 승인 사용자의 인증 정보 : 메시지를 보낼 앱 서버가 인증된 서버라는 것을 증명하는 정보.
  - 클라이언트의 등록 토큰 : 메시지를 보내고자 하는 디바이스의 정보.

### FCM Backend 서버와 통신을 위한 앱 서버의 옵션 선택사항.

- FCM Backend 서버와 상호 작용할 방법을 결정해야 한다.
- Firebase Admin SDK
  - Node.js, Java, Python, C#, Go 등의 프로그래밍 언어 지원.
  - 기기에서 주제 구독 및 구독 취소가 가능하고, 다양한 타켓 플랫폼에 맞는 메세지 페이로드 구성.
  - 나머지 옵션과는 다르게, 초기화 작업만 잘 진행하면 인증 처리를 자동으로 수행한다.
  - FCM에서 가장 권장하는 옵션이다.
- FCM HTTP v1 API
  - 가장 최신 프로토콜로서 보다 안전한 승인과 유연한 교차 플랫폼 메시징 기능 제공.
- 기존의 HTTP 프로토콜
- XMPP 서버 프로토콜
  - 클라이언트 애플리케이션에서 업스트림 메시징을 사용하려면 이 옵션을 선택해야 한다.
  - 위에서 얘기했던 FCM의 마지막 특징인 업스트림 메시징을 사용하려면, 다른 선택지 없이 이 옵션을 선택해야 한다.

### Sample Code

- 내가 작성한 샘플 코드의 경우, FCM을 서버단에서 사용할 경우의 샘플 코드이고, 언어 및 프레임워크는 Java와 Spring이다.
- 초기 Dependency 설정. (FirebaseFirebase 의존성 추가.

```xml
<dependency>
    <groupId>com.google.firebase</groupId>
    <artifactId>firebase-admin</artifactId>
    <version>6.8.1</version>
</dependncy>
```

- SDK 초기화.
  - SDK 초기화를 진행할 때 Firebase 인증 처리를 해줘야 하는데, 먼저 Firebase 프로젝트 생성 후, 거기 설정에서 키를 발급받아야 한다.
  - 본인의 경우 GCP의 서비스 계정 그룹 안에 Firebase가 이미 등록되어 있어서, GCP Credential로 인증 처리를 해주었다.

```java
private FirebaseApp createFirebaseApp() {
    FirebaseOptions options = null;
    ClassPathResource resource = 
        new ClassPathResource(gcpCredentialFile);
    try (InputStream is = resource.getInputStream()) {
        options = new FirebaseOptions.Builder()
                .setCredentials(GoogleCredentials.fromStream(is))
                .setDatabaseUrl("https://[My-Database-URL]
                                            .firebaseio.com")
                .build();
    } catch (IOException e) {
        log.error(e.getMessage());
    }

    return FirebaseApp.initializeApp(options);
}
```

- 특정 기기에 대한 메세지 전송
  - 다음과 같은 Sample Code를 통해서 특정 사용자에게 메시지를 Push 할 수 있다.

```java
private void sendToToken(Push push) throws FirebaseMessagingException {
    Message message = Message.builder()
            .setNotification(Notification.builder()
                    .setTitle("[광고] 테스트 광고")
                    .setBody("테스트 내용")
                    .build())
            // Device를 특정할 수 있는 토큰.
            .setToken(push.getRegistrationToken())
            .build();

    String response = FirebaseMessaging.getInstance().send(message);
    log.debug("Successfully sent message: " + response);
}
```

- 여러 기기에 대한 메세지 전송
  - 다음과 같은 Sample Code를 통해서 여러 기기에 메시지를 보낼 수 있다.
  - 현재는 내 디바이스의 토큰 밖에 없어서 다음과 같이 작성하였지만, List에 토큰 ID만 잘 담아서 MulticastMessage에 설정만 해주면 문제 없이 동작한다.

```java
private void multipleSendToToken(Push push) 
                                    throws FirebaseMessagingException {
    List<String> tokenList = IntStream.rangeClosed(1, 30).mapToObj(index 
            -> push.getRegistrationToken()).collect(Collectors.toList());

    MulticastMessage message = MulticastMessage.builder()
            .setNotification(Notification.builder()
                .setTitle("[많은 양의 메세지] 알람입니다.")
                .setBody("많은 알람에 당황하지 마세요.")
                .build())
            .addAllTokens(tokenList)
            .build();

        
    BatchResponse response = FirebaseMessaging.getInstance()
                                                .sendMulticast(message);
    if (response.getFailureCount() > 0) {
        List<SendResponse> responses = response.getResponses();
        List<String> failedTokens = new ArrayList<>();
        for (int i = 0; i < responses.size(); i++) {
            if (!responses.get(i).isSuccessful()) {
                failedTokens.add(tokenList.get(i));
            }
        }

        System.out.println("List of tokens that caused failures: " 
                                                        + failedTokens);
    }
}
```

- 특정 주제 구독 및 주제 구독자에게 메세지 전송
  - 다음 Sample Code를 통해서 특정 기기를 특정 주제에 구독시킬 수 있다.
  - 구독하고자 하는 주제가 현재 존재하지 않는다면 FCM Backend에서 새롭게 생성해주고, 존재한다면 해당 주제에 구독처리가 된다.
  - 물론 주제 구독이 가능하기 때문에, 구독 취소 또한 가능하다.
    - 밑에서 사용하는 subscribeToTopic 메소드를 unsubscribeFromTopic으로 변경하면 구독 취소도 FCM Backend에 요청할 수 있다.
  - 여기서 주의해야 할 점은 원인을 정확하게 파악하진 못했지만, 주제의 이름은 한글일 경우 Invalid topic name이라는 에러가 발생하게 된다.
  - 그 이후에 해당 주제에 구독된 클라이언트 기기에 메세지를 전송할 수 있다.
  - 그리고 한 기기는 여러 주제에 구독할 수 있고, 여러 주제에 구독했다면 구독한 주제별로 보내는 메세지를 모두 받게 된다.
  - 예를 들어, 구글과 애플이란 주제 두 개를 구독했다면, 두 주제에 해당하는 메세지를 모두 받게 된다.

```java
private void sendSubscribeTopic(Push push) 
                                throws FirebaseMessagingException {
    List<String> registrationTokens = 
                Collections.singletonList(push.getRegistrationToken());

    TopicManagementResponse response = FirebaseMessaging.getInstance()
            .subscribeToTopic(Collections.singletonList
                        (push.getRegistrationToken()), "Apple News");

    System.out.println(response.getSuccessCount() + 
                " tokens were subscribed successfully");

    Message message = Message.builder()
            .setNotification(Notification.builder()
                    .setTitle("[Apple News] IPhone SE 출시 임박!!!")
                    .setBody("빠르게 사전 예약 하세요. 주문이 폭주하고 있습니다.")
                    .build())
            .setTopic("Apple News")
            .build();

    String response2 = FirebaseMessaging.getInstance().send(message);
    log.debug("Successfully sent message: " + response2);
}
```

- 일괄 메시지 전송
  - 하나의 메세지를 많은 사람들에게 보낼 수 있을 뿐만 아니라, 다양한 메세지를 다양한 사람들에게 일괄 전송하는 것도 가능하다.
  - 밑의 Sample Code는 특정 기기의 클라이언트와, 주제를 구독한 기기에게 성격이 다른 메세지를 일괄 전송하고 있다.

```java
private void multipleEachOtherSend(Push push) 
                        throws FirebaseMessagingException {
    List<Message> messages = Arrays.asList(
            Message.builder()
                    .setNotification(Notification.builder()
                            .setTitle("[한국전기공사] 공과금 수납 일자 오늘까지..")
                            .setBody("오늘까지 수납이 되지 않을 경우, 
                                                        전기가 끊길 수 있습니다.")
                            .build())
                    .setToken(push.getRegistrationToken())
                    .build(),
            Message.builder()
                    .setNotification(Notification.builder()
                            .setTitle("[배달의 민족] 모두에게 드리는 특별한 쿠폰")
                            .setBody("음식 종류에 상관없이 모두 3000원 할인")
                            .build())
                    .setTopic("배달의 민족")
                    .build()
    );

    BatchResponse response = FirebaseMessaging.getInstance()
                                                .sendAll(messages);
    System.out.println(response.getSuccessCount() + 
                                " messages were sent successfully");
}
```

