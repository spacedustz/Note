## 💡FCM 단체 메세지 실패 시 처리 방안

어드민 페이지에는 단체메시지 전송기능이 존재한다.

이 때 유저를 제외하지 않고 보내기 기능을 사용하면 Firebase Messaging의 Topic 기능을 사용하므로
전송의 실패 여부는 전체 성공 / 전체 실패로만 나뉘게 된다

반면 유저를 제외하고 보내기 기능을 사용하면 유저의 Token (userToken 하에 있다)를 기반으로 별개의 메시지를 전달하기 때문에 성공하는 메시지와 실패하는 메시지가 나뉘게 된다.

<br>

**FirebaseMessaging 클래스의 sendAll() 메서드**

- BatchResponse 타입을 반환하는 메서드를 사용해야 전체 전송시에도 개별 성공 & 실패 출력 가능
- 예외는 전체 실패로 뜨고 부분적 실패는 BatchResponse 타입의 반환값을 가짐

**FirebaseMessaging 클래스의 sendMulticast() 메서드**

- 내부적으로 sendAll API를 사용해 지정된 모든 대상에게 전송
- BatchResponse.getResponses()를 호출해 얻은 응답 목록은
  MulticastMessage의 토큰 순서에 해당함
- 예외는 전체 실패로 뜨고 부분적 실패는 BatchResponse 타입의 반환값을 가짐

```java
public interface BatchResponse {

  @NonNull
  List<SendResponse> getResponses();

  int getSuccessCount();

  int getFailureCount();
}

```

---

## 💡 Flow

<br>

### 1. sendTopicMessage() - FcmService

- topic: String
- title: String
- body: String
- type: String
- id: String
- mute: Boolean

<br>

1. FirebaseMessaging 인스턴스화
2. Notification
3. ApsAlert
4. 2 Aps(default & mute)
5. 2 ApnsConfig(default & mute)
6. 2 AndroidNotification(default & mute)
7. 2 AndroidConfig(default & mute)
8. 2 Message (mute is true or false)
9. send Message

---

### 2. sendTokenMessage() - FcmService

- token: String
- title: String
- body: String
- type: String
- id: String
- uid: String?
- mute: Boolean

<br>

1. FirebaseMessaging 인스턴스화
2. Notification
3. ApsAlert
4. 2 Aps(default & mute)
5. 2 ApnsConfig(default & mute)
6. 2 AndroidNotification(default & mute)
7. 2 AndroidConfig(default & mute)
8. 2 Message (mute is true or false)
9. send Message

---

### 3. pushMessaging - AdminService

- type: String
- data: MessageDTO
- uid: String
- sido: String
- sigungu: String
- dong: String

<br>

Type에 따라 메시지 전송

1. total (Topic Message)
   - 전체 메시지 전송 (토큰값 포함 X)
2. individual (Token Message)
   - 개인 메시지 전송
3. geometryElse (Token Message)
   - geometry 위치 기반 메시지 전송
4. dog & cat (Token Message)
   - animal 타입에 따른 메시지 전송
5. multi
   - 
6. else
   - 메시지 전송 실패

---

CreateTopicMessage

```kotlin
        var tokens = listOf("1", "2", "3", "4")
        var messages : MutableList<Message> = mutableListOf()

        for (token in tokens) {
            messages.add(

            )
        }

        var response = messaging.sendAll(messgeas)

        var message : Message =
                if (mute)
                    Message.builder()
                        .setNotification(notification)
                        .setApnsConfig(muteApnsConfig)
                        .setAndroidConfig(muteAndroidConfig)
                        .putData("type", type)
                        .putData("id", id)
                        .setToken(token)
                        .build()
                else
                    Message.builder()
                            .setNotification(notification)
                            .setApnsConfig(apnsConfig)
                            .setAndroidConfig(androidConfig)
                            .putData("type", type)
                            .putData("id", id)
                            .setToken(token)
                            .build()

        var messageIdString : String? = try {
            messaging.send(message)
        } catch (e : Exception) {
            log.error("메시지 전송 실패 : $e")
            null
        }

        if (messageIdString != null) {
            // 메시지 아이디 분리
            try {
                var messageIdToken = messageIdString.split("/")

                if (messageIdToken.size == 4) {
                    messageService.saveMessage(
                            id = messageIdToken[3],
                            title = title,
                            body = body,
                            data = id,
                            type = type,
                            userUID = "",
                            uid = uid,
                    )
                }
            } catch (e : Exception) {
                log.error("FCM 메시지 저장 실패 - $e")
            }
```

---

임시 저장

```kotlin
    fun sendTokenMessage(token : String, title : String, body : String, type : String, id : String, uid : String?, mute : Boolean) : String? {

        var messaging = FirebaseMessaging.getInstance()

        var notification : Notification = Notification.builder()
                .setTitle(title)
                .setBody(body)
                .build()

        // iOS 설정
        var apsAlert : ApsAlert = ApsAlert.builder()
                .setTitle(title)
                .setBody(body)
                .build()

        var aps : Aps = Aps.builder()
                .setSound("default")
                .setAlert(apsAlert)
                .setContentAvailable(true)
                .setMutableContent(true)
                .build()

        var muteAps : Aps = Aps.builder()
                .setAlert(apsAlert)
                .setContentAvailable(true)
                .setMutableContent(true)
                .build()

        var apnsConfig : ApnsConfig = ApnsConfig.builder()
                .setAps(aps)
                .build()

        var muteApnsConfig : ApnsConfig = ApnsConfig.builder()
                .setAps(muteAps)
                .build()


        // 안드로이드 관련 설정
        var androidNotification = AndroidNotification.builder()
                .setTitle(title)
                .setBody(body)
                .build()

        var muteAndroidNotification = AndroidNotification.builder()
                .setTitle(title)
                .setBody(body)
                .setChannelId("SILENCE")
                .setPriority(AndroidNotification.Priority.DEFAULT)
                .build()

        var androidConfig : AndroidConfig = AndroidConfig.builder()
                .setNotification(androidNotification)
                .setPriority(AndroidConfig.Priority.HIGH)
                .build()

        var muteAndroidConfig : AndroidConfig = AndroidConfig.builder()
                .setNotification(muteAndroidNotification)
                .setPriority(AndroidConfig.Priority.HIGH)
                .build()

        var tokens = listOf("1", "2", "3", "4")
        var messages: MutableList<Message> = mutableListOf()

        for (token in tokens) {

            var message  =
                if (mute)
                    Message.builder()
                        .setNotification(notification)
                        .setApnsConfig(muteApnsConfig)
                        .setAndroidConfig(muteAndroidConfig)
                        .putData("type", type)
                        .putData("id", id)
                        .setToken(token)
                        .build()
                else
                    Message.builder()
                        .setNotification(notification)
                        .setApnsConfig(apnsConfig)
                        .setAndroidConfig(androidConfig)
                        .putData("type", type)
                        .putData("id", id)
                        .setToken(token)
                        .build()

            messages.add(message)
        }

        // 알림 발송
        val result = messaging.sendAll(messages)

        // 요청 응답 처리
        if (result.failureCount > 0) {
            var responses: MutableList<SendResponse> = result.responses
            var failedTokens: MutableList<String> = mutableListOf()

            for (response in 0..responses.size) {
                if (responses.get(response).isSuccessful) {
                    failedTokens.add(failedTokens.get(tokens.get()))
                }
            }
        }


        var messageIdString : String? = try {
            messaging.sendAll(messages)
        } catch (e : Exception) {
            log.error("메시지 전송 실패 : $e")
            null
        }

        if (messageIdString != null) {
            for (id in messageIdString) {

                var ids = id.toString()

                if (id != null) {
                    // 메시지 아이디 분리
                    try {
                        var messageIdToken = ids.split("/")

                        if (messageIdToken.size == 4) {
                            messageService.saveMessage(
                                id = messageIdToken[3],
                                title = title,
                                body = body,
                                data = ids,
                                type = type,
                                userUID = "",
                                uid = uid,
                            )
                        }
                    } catch (e: Exception) {
                        log.error("FCM 메시지 저장 실패 - $e")
                    }
                }
            }
        }
        return null
    }
```

