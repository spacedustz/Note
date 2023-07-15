## HTTP -> HTTP v1 마이그레이션

진행 순서

- 서버 엔드포인트 업데이트
- 전송 요청의 승인 업데이트
  - ADC를 사용한 사용자 인정 정보 제공
  - 수동으로 사용자 인증 정보 제공
  - 사용자 인증 정보를 사용한 액세스 토큰 발급
- 전송 요청의 페이로드 업데이트
  - 예시: 간단한 알림 메시지
  - 예시: 여러 플랫폼 타겟팅
  - 예시: 플랫폼 재정의로 맟춤설정
  - 예시: 특정 기기 타겟팅

<br>

**HTTP v1의 장점**

- 액세스 토큰을 통한 보안성 강화
- 플랫폼에 따른 메시지 맟춤 설정
- 새 클라이언트 플랫폼 버전을 위한 확장성 강화

---

## 서버 엔드포인트 업데이트

<br>

HTTP v1 API의 엔드포인트 URL은 다음과 같은 면에서 기존 엔드포인트와 다릅니다.

- 경로에 `/v1`로 버전이 지정됩니다.
- 경로에 `/projects/myproject-ID/` 형식으로 앱의 Firebase 프로젝트 ID가 포함됩니다. Firebase Console의 [일반 프로젝트 설정](https://console.cloud.google.com/project/_/settings/general/?hl=ko) 탭에서 이 ID를 확인할 수 있습니다.
- [`send`](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages/send?hl=ko) 메서드를 `:send`로 명시적으로 지정합니다.

HTTP v1의 서버 엔드포인트를 업데이트하려면 전송 요청 헤더의 엔드포인트에 
이러한 요소를 추가하세요.

<br>

#### 이전

```http
POST https://fcm.googleapis.com/fcm/send
```

#### 이후

```http
POST https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send
```

**참고:** 일반적인 마이그레이션 경로에서 FCM v1 API가 기본적으로 사용 설정되어야 합니다. 

엔드포인트 연결 오류가 발생하면 'Firebase Cloud Messaging API'가,

[Google Cloud Console](https://console.developers.google.com/apis/dashboard?project=_&hl=ko)의 API 및 서비스 목록에 사용 설정되어 있는지 다시 확인합니다.

---

## 전송 요청의 승인 업데이트

HTTP v1 전송 요청의 경우 기존 요청에서 사용하는 서버 키 문자열 대신 OAuth 2.0 액세스 토큰이 필요합니다.

 Admin SDK를 사용하여 메시지를 보내는 경우 라이브러리에서 토큰이 자동으로 처리됩니다. 

원시 프로토콜을 사용하는 경우 이 섹션에 설명된 대로 토큰을 가져와서 

헤더에 `Authorization: Bearer <valid Oauth 2.0 token>`으로 추가합니다.

<br>

#### 이전

```yaml
Authorization: key=AIzaSyZ-1u...0GBYzPu7Udno5aA
```

#### 이후

```yaml
Authorization: Bearer ya29.ElqKBGN2Ri_Uz...HnS_uNreA
```

<br>

서버 환경의 세부정보에 따라 다음 전략을 조합하여 Firebase 서비스에 대한 서버 요청을 승인합니다.

- Google 애플리케이션 기본 사용자 인증 정보(ADC)
- 서비스 계정 JSON 파일
- 서비스 계정에서 생성된 수명이 짧은 OAuth 2.0 액세스 토큰

<br>

**애플리케이션이 Compute Engine, Google Kubernetes Engine, App Engine 또는 **

**Cloud Functions(Firebase용 Cloud Functions 포함)에서 실행되는 경우** 

- 애플리케이션 기본 사용자 인증 정보(ADC)를 사용합니다. 

ADC는 기존의 기본 서비스 계정을 사용하여 요청을 승인하기 위한 사용자 인증 정보를 가져오며

GOOGLE_APPLICATION_CREDENTIALS 환경 변수를 통해 유연한 로컬 테스트를 지원합니다. 

승인 과정을 최대한 자동화하기 위해 ADC를 Admin SDK 서버 라이브러리와 함께 사용하세요.

<br>

**애플리케이션이 Google 이외의 서버 환경에서 실행되는 경우**

- Firebase 프로젝트에서 서비스 계정 JSON 파일을 다운로드해야 합니다. 

비공개 키 파일이 포함된 파일 시스템에 액세스할 수 있다면 GOOGLE_APPLICATION_CREDENTIALS 환경 변수를 

사용하여 수동으로 가져온 사용자 인증 정보로 요청을 승인할 수 있습니다. 

이러한 파일에 액세스할 수 없으면 코드에서 서비스 계정 파일을 참조해야 합니다. 

이때 사용자 인증 정보가 노출될 위험이 있으므로 매우 주의해야 합니다.

---

### ADC를 사용한 사용자 인증 정보 제공

Google 애플리케이션 기본 사용자 인증 정보(ADC)는 다음 순서에 따라 사용자 인증 정보를 확인합니다.

1. ADC는 GOOGLE_APPLICATION_CREDENTIALS 환경 변수가 설정되었는지 확인합니다. 
   이 변수가 설정된 경우 ADC는 변수가 가리키는 서비스 계정 파일을 사용합니다.
2. 환경 변수가 설정되지 않은 경우 ADC는 Compute Engine, Google Kubernetes Engine, App Engine, Cloud Functions가 이러한 서비스에서 실행되는 애플리케이션에 제공하는 기본 서비스 계정을 사용합니다.
3. ADC에서 위 사용자 인증 정보 중 어느 하나라도 사용할 수 없는 경우 시스템에 오류가 발생합니다.

<br>

다음 Admin SDK 코드 예시에서는 이 전략을 설명합니다. 예시에서는 애플리케이션 사용자 인증 정보를 명시적으로 지정하지 않습니다. 

그러나 환경 변수가 설정되어 있거나 애플리케이션이 Compute Engine, Google Kubernetes Engine, 

App Engine, Cloud Functions에서 실행 중인 경우 ADC는 사용자 인증 정보를 암묵적으로 찾을 수 있습니다.

```java
FirebaseOptions options = FirebaseOptions.builder()
    .setCredentials(GoogleCredentials.getApplicationDefault())
    .setDatabaseUrl("https://<DATABASE_NAME>.firebaseio.com/")
    .build();

FirebaseApp.initializeApp(options);
```

---

### 수동으로 사용자 인증 정보 제공

Firebase 프로젝트는 앱 서버 또는 신뢰할 수 있는 환경에서 Firebase Server API를 호출하는 데 사용할 수 있는 Google [서비스 계정](https://console.firebase.google.com/project/_/settings/serviceaccounts/adminsdk?hl=ko)을 지원합니다. 로컬에서 코드를 개발하거나 온프레미스에 애플리케이션을 배포하는 경우 이 서비스 계정을 통해 가져온 사용자 인증 정보를 사용하여 서버 요청을 승인할 수 있습니다.

서비스 계정을 인증하고 Firebase 서비스에 액세스하도록 승인하려면 JSON 형식의 비공개 키 파일을 생성해야 합니다.

**서비스 계정의 비공개 키 파일을 생성하려면 다음 안내를 따르세요.**

1. Firebase Console에서 **설정 > [서비스 계정](https://console.firebase.google.com/project/_/settings/serviceaccounts/adminsdk?hl=ko)**을 엽니다.
2. **새 비공개 키 생성**을 클릭한 다음 **키 생성**을 클릭하여 확인합니다.
3. 키가 들어 있는 JSON 파일을 안전하게 저장합니다.

서비스 계정을 통한 승인 시 다음과 같은 2가지 방법을 사용하여 애플리케이션에 사용자 인증 정보를 제공할 수 있습니다. **GOOGLE_APPLICATION_CREDENTIALS 환경 변수를 설정**하거나 **코드에서 서비스 계정 키 경로를 명시적으로 전달**하는 것입니다. 

그러나 보안을 위해 첫 번째 방법을 강력하게 권장합니다.

**환경 변수를 설정하는 방법은 다음과 같습니다.**

GOOGLE_APPLICATION_CREDENTIALS 환경 변수를 서비스 계정 키가 포함된 JSON 파일의 파일 경로로 설정합니다. 이 변수는 현재 셸 세션에만 적용되므로 새 세션을 열면 변수를 다시 설정합니다.

Linux 또는 macOS

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/service-account-file.json"
```

PowerShell:

```shell
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\Users\username\Downloads\service-account-file.json"
```

위 단계를 완료하면 애플리케이션 기본 사용자 인증 정보(ADC)가 암묵적으로 사용자 인증 정보를 확인할 수 있으므로 Google 이외의 환경에서 테스트 또는 실행할 때 서비스 계정의 사용자 인증 정보를 사용할 수 있습니다.

---

### 사용자 인증 정보를 사용한 액세스 토큰 발급

원하는 언어의 [Google 인증 라이브러리](https://github.com/googleapis?q=auth)와 함께 Firebase 사용자 인증 정보를 사용하여 수명이 짧은 OAuth 2.0 액세스 토큰을 발급합니다.

```java
private static String getAccessToken() throws IOException {
  GoogleCredentials googleCredentials = GoogleCredentials
          .fromStream(new FileInputStream("service-account.json"))
          .createScoped(Arrays.asList(SCOPES));
  googleCredentials.refreshAccessToken();
  return googleCredentials.getAccessToken().getTokenValue();
}
Messaging.java
```

액세스 토큰이 만료되면 토큰 갱신 메서드가 자동으로 호출되어 업데이트된 액세스 토큰이 발급됩니다.

FCM에 대한 액세스를 승인하려면 `https://www.googleapis.com/auth/firebase.messaging` 범위를 요청하세요.

<br>

**HTTP 요청 헤더에 액세스 토큰을 추가하는 방법은 다음과 같습니다.**

`Authorization` 헤더의 값으로 토큰을 `Authorization: Bearer <access_token>` 형식으로 추가합니다.

```java
URL url = new URL(BASE_URL + FCM_SEND_ENDPOINT);
HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();
httpURLConnection.setRequestProperty("Authorization", "Bearer " + getAccessToken());
httpURLConnection.setRequestProperty("Content-Type", "application/json; UTF-8");
return httpURLConnection;
```

---

## 전송 요청 페이로드 업데이트

FCM HTTP v1에서 JSON 메시지 페이로드의 구조에 중대한 변화가 있습니다. 

이러한 변화를 통해 기본적으로 여러 클라이언트 플랫폼에 수신될 때 메시지가 올바르게 처리될 수 있을 뿐만 아니라 

플랫폼별로 보다 유연하게 메시지 필드를 맞춤설정하거나 '재정의'할 수 있습니다.

<br>

### 예시: 간단한 알림 메시지

다음은 `title`, `body`, `data` 필드만 있는 매우 간단한 알림 페이로드를 비교한 것으로, 기존 페이로드와 HTTP v1 페이로드의 근본적인 차이점을 보여줍니다.

#### 이전

```json
{
  "to": "/topics/news",
  "notification": {
    "title": "Breaking News",
    "body": "New news story available."
  },
  "data": {
    "story_id": "story_12345"
  }
}
```

#### 이후

```json
{
  "message": {
    "topic": "news",
    "notification": {
      "title": "Breaking News",
      "body": "New news story available."
    },
    "data": {
      "story_id": "story_12345"
    }
  }
}
```

---

### 예시: 여러 플랫폼 타겟팅

여러 플랫폼 타겟팅을 사용 설정하기 위해 기존 API는 백엔드에서 재정의를 수행했습니다. 

반면 HTTP v1은 플랫폼 간의 차이점을 분명하게 만들고 개발자에게 이러한 차이점을 보여주는 플랫폼별 키 블록을 제공합니다. 

이를 통해 다음 샘플에 나와 있는 것처럼 요청 하나로 언제든지 여러 플랫폼을 타겟팅할 수 있습니다.

#### 이전

```json
// Android
{
  "to": "/topics/news",
  "notification": {
    "title": "Breaking News",
    "body": "New news story available.",
    "click_action": "TOP_STORY_ACTIVITY"
  },
  "data": {
    "story_id": "story_12345"
  }
}
// Apple
{
  "to": "/topics/news",
  "notification": {
    "title": "Breaking News",
    "body": "New news story available.",
    "click_action": "HANDLE_BREAKING_NEWS"
  },
  "data": {
    "story_id": "story_12345"
  }
}
```

#### 이후

```json
{
  "message": {
    "topic": "news",
    "notification": {
      "title": "Breaking News",
      "body": "New news story available."
    },
    "data": {
      "story_id": "story_12345"
    },
    "android": {
      "notification": {
        "click_action": "TOP_STORY_ACTIVITY"
      }
    },
    "apns": {
      "payload": {
        "aps": {
          "category" : "NEW_MESSAGE_CATEGORY"
        }
      }
    }
  }
}
```

---

### 예시: 플랫폼 재정의로 맞춤설정

HTTP v1 API를 사용하면 메시지의 크로스 플랫폼 타겟팅이 단순해지는 것 외에도 플랫폼별 메시지를 유연하게 맞춤설정할 수 있습니다.

#### 이전

```json
// Android
{
  "to": "/topics/news",
  "notification": {
    "title": "Breaking News",
    "body": "Check out the Top Story.",
    "click_action": "TOP_STORY_ACTIVITY"
  },
  "data": {
    "story_id": "story_12345"
  }
}
// Apple
{
  "to": "/topics/news",
  "notification": {
    "title": "Breaking News",
    "body": "New news story available.",
    "click_action": "HANDLE_BREAKING_NEWS"
  },
  "data": {
    "story_id": "story_12345"
  }
}
```

#### 이후

```json
{
  "message": {
    "topic": "news",
    "notification": {
      "title": "Breaking News",
      "body": "New news story available."
    },
    "data": {
      "story_id": "story_12345"
    },
    "android": {
      "notification": {
        "click_action": "TOP_STORY_ACTIVITY",
        "body": "Check out the Top Story"
      }
    },
    "apns": {
      "payload": {
        "aps": {
          "category" : "NEW_MESSAGE_CATEGORY"
        }
      }
    }
  }
}
```

---

### 예: 특정 기기 타겟팅

HTTP v1 API로 특정 기기를 타겟팅하려면 `to` 키 대신 `token` 키에서 기기의 현재 등록 토큰을 제공합니다.

#### 이전

```json
  { "notification": {
      "body": "This is an FCM notification message!",
      "time": "FCM Message"
    },
    "to" : "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1..."
  }
```

#### 이후

```json
{
   "message":{
      "token":"bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...",
      "notification":{
        "body":"This is an FCM notification message!",
        "title":"FCM Message"
      }
   }
}
```

a
