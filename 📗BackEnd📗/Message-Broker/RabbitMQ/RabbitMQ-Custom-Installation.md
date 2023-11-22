## 📘 Rabbitmq-Custom-Installation

RabbitMQ의 기본 설치 폴더 및 로깅을 위한 파일들을 Custom한 위치로 변경해서 설치해야할 때 필요한 프로세스입니다.

<br>

> 📌 **플랫폼 별 Conf 파일 위치**

[RabbitMQ Configuration 공식 문서](https://www.rabbitmq.com/configure.html)

|**Platform**|**Default Configuration File Directory**|**Example Configuration File Paths**|
|---|---|---|
|Generic binary package|`$RABBITMQ_HOME/etc/rabbitmq/`|`$RABBITMQ_HOME/etc/rabbitmq/rabbitmq.conf`, `$RABBITMQ_HOME/etc/rabbitmq/advanced.config`|
|Debian and Ubuntu)|/etc/rabbitmq/|/etc/rabbitmq/rabbitmq.conf, /etc/rabbitmq/advanced.config|
|RPM-based Linux|/etc/rabbitmq/|/etc/rabbitmq/rabbitmq.conf, /etc/rabbitmq/advanced.config|
|Windows)|%APPDATA%\RabbitMQ\|%APPDATA%\RabbitMQ\rabbitmq.conf, %APPDATA%\RabbitMQ\advanced.config|
|MacOS Homebrew Formula|`${install_prefix}/etc/rabbitmq/`, and the Homebrew cellar prefix is usually /usr/local|`${install_prefix}/etc/rabbitmq/rabbitmq.conf`, `${install_prefix}/etc/rabbitmq/advanced.config`|

<br>

윈도우 환경에서 `advanced.config`, `rabbit.conf(만들어야 함)` 두개의 설정을 사용할 수 있는데,

`conf` 파일은 기본적인 설정을 저장하고, `advanced.config` 파일은 고급 설정을 저장합니다.

<br>

`conf` 파일에는 다음과 같은 기본적인 설정이 포함되어 있습니다.

- 로그 파일의 위치
- 로그 레벨
- 로그 파일의 유지 기간
- TCP 포트 번호
- AMQP 포트 번호
- 웹 관리 콘솔의 URL

`advanced.config` 파일에는 다음과 같은 고급 설정이 포함되어 있습니다.

- 큐의 최대 메시지 수
- 큐의 최대 메시지 크기
- 브로커의 메모리 사용량
- 클러스터의 설정
- 암호화 설정
- 보안 설정
<br>

📕 **내용 추가**

- 공식 문서를 계속 보다가 `advanced.config`를 사용하는 방식은 `Deprecated` 되었으니 `conf 파일`을 사용하는 방식을 추천하는 글을 봄
- 그러므로 `advanced.config`에 대한 내용은 지우고 conf 파일에 대한 내용만 아래 내용에 있음
- 원래 성능 파라미터 관련 옵션은 `advanced.config`에 작성 했었는데 conf 파일에 쓰는 걸로 병합함

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/rabbit-deprecated.png)


<br>

**📕 내용 수정 & 추가**

Queue에 쌓인 Message의 영속성(Persistent & Delivery Mode)을 지정하는 방식 변경

- Topic Message의 Persistent Header를 수정해서 설정하는 방법 대신 Quorum Queue를 사용하는 것으로 변경
- RabbitMQ 3.11 부터 Quorum Queue 사용 시 Message의 Persistent 옵션이 기본으로 Delivery Mode 2가 되고 메모리 저장이 아닌 디스크 저장 방식
- Quorum Queue의 대표적인 장점은 **고가용성**이라서 RabbitMQ 클러스터의 노드를 증설하고 RabbitMQ 노드 간 통신 및 동기화 작업 필요
- Client(React)에서 Stomp의 헤더에 autoConfirm의 값을 true로 넘겨야 소켓 연결이 안끊김
- Client (React) 코드에 Quorum Queue의 Auto Confirm 헤더 추가함

---
## 📘 1. Erlang OTP 설치

RabbitMQ를 설치하기 전 Erlang을 설치해야 하는데, 설치는 **관리자 권한**으로 설치해야 합니다.

Erlang을 설치하는 이유는 RabbitMQ가 Erlang으로 만들어져 있기 때문입니다.

관리자 권한이 아니라면 윈도우 서비스에서 RabbitMQ를 검색할 수 없게 됩니다.

<br>

[Erlang OTP 설치](https://erlang.org/download/otp_versions_tree.html)

설치 페이지로 이동해서 원하는 버전의 **win64** 버튼을 클릭해 다운로드 후 설치합니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/erlang.png)

---

## 📘 2. RabbitMQ 설치

Erlang을 **관리자 권한**으로 설치 했으면 이제 RabbitMQ를 설치합니다.

<br>

RabbitMQ도 **관리자 권한**으로 설치합니다.

[RabbitMQ 설치](https://www.rabbitmq.com/install-windows.html)

링크로 이동해서 마우스 스크롤을 내리다보면 아래 사진 부분이 나오는데 Download 부분에 있는 다운로드 링크를 클릭해 설치합니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/rabbit.png)

<br>

**시스템 환경 변수 설정**

1. 윈도우 검색창에 **시스템 환경**까지만 검색하면 **시스템 환경 변수 편집** 메뉴가 나옵니다.

2. 클릭해서 열어주고 제일 하단의 **환경 변수(N)** 를 클릭합니다.

3. 2개의 탭 중 **시스템 변수(S)** 부분에서 스크롤을 내려 **Path**를 찾아서 더블클릭 합니다.

4. **새로 만들기**를 눌러서 RabbitMQ가 설치된 폴더 내부의 bin 폴더를 지정하고 추가해줍니다. (ex: C:\Program Files\RabbitMQ Server\rabbitmq_server-3.12.4\sbin)

<br>

**윈도우 서버 재시작 시 RabbitMQ 자동 실행(윈도우 서비스 등록) 설정**

1. 윈도우 CMD를 **관리자 권한**으로 엽니다.
2. 환경변수로 등록한 RabbitMQ의 sbin 폴더로 이동해줍니다.
3. 아래 명령어들을 차례대로 입력합니다.

```shell
rabbitmq-service.bat install
sc config RabbitMQ start=auto
```

<br>

> 만약 Erlang OTP 버전을 바꾸려고 Erlang OTP만 재설치 하는 경우

- 윈도우 레지스트리 편집기로 진입합니다.
- HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RabbitMQ 로 이동합니다.
- RabbitMQ 폴더의 ImagePath의 값에 Erlang 폴더 버전만 변경해줍니다.

---

## RabbitMQ 서버 초기 설정

테스트를 위해 윈도우 Local 환경에서 진행합니다.

<br>

**RabbitMQ 기본 사용 포트**

- eqmd: 4369
- Erlang Distributuin: 25672
- AMQP TLS : 5671, 5672
- 관리자 웹 콘솔 : 15672
- MQTT : 1883, 8883
- RabbitMQ Socket Port : 15674

<br>

**로그 파일 위치**

- C:\Users\계정명\AppData|Roaming\RabbitMQ\log

<br>

**RabbitMQ Conf 파일 생성 위치**

- C:\Program Files\RabbitMQ Server\rabbitmq_server-3.12.4\etc\rabbitmq\rabbitmq.conf

<br>

**윈도우 CMD창을 열어 아래 명령어를 입력하여 RabbitMQ를 실행합니다.**

```shell
rabbitmq-server
```

<br>

**RabbitMQ 관리자 페이지를 GUI로 보기 위한 플러그인, MQTT 플러그인, Web Socket 설치**

- rabbitmq_management : 웹 관리 콘솔 플러그인
- rabbitmq_mqtt : MQTT 플러그인
- rabbitmq_web_mqtt : 웹 소켓 연결을 지원하는 MQTT 플러그인
- rabbitmq_web_stomp : 웹 소켓 플러그인

```shell
rabbitmq-plugins enable rabbitmq_management
rabbitmq-plugins enable rabbitmq_mqtt
rabbitmq-plugins enable rabbitmq_web_mqtt
rabbitmq-plugins enable rabbitmq_web_stomp
```

<br>

**RabbitMQ 관리자 페이지, MQTT, Rabbit Socket 포트 떠있는지 (Listening) 확인**

```bash
netstat -ano | findstr :15672 # 관리자 콘솔 포트
netstat -ano | findstr :1883 # MQTT 포트
netstat -ano | findstr :15674 # Rabbit Socket 포트
```

<br>

**RabbitMQ 관리자 페이지 접속 (인터넷 주소창에 입력)**

- Default 로그인 ID : guest
- Default 비밀번호 : guest

```
http://localhost:15672
```

---

## RabbitMQ Exchange & Queue & Binding 설정

Publish/Subscribe 패턴을 구현하기 위해 Exchange의 타입을 Topic으로 설정합니다.

Topic Exchange는 Binding Key 패턴이 일치하는 Queue에만 선택적으로 데이터를 전송합니다.

<br>

Topic Exchange는 `*`와 `#`을 이용해 와일드 카드를 표현할 수 있습니다.

- `*` : 단어 하나 일치
- `#` : 0 또는 1개 이상의 단어 일치

<br>

**Exchange 생성**
- Name: Exchange 이름
- Type : 보통 "Topic"을 선택 (MQTT Topic Routing에 가장 적함함)
- Durable 설정 (Transient로 설정 시 RabbitMQ 재시작 하면 Exchange가 사라집니다.)
- Add Exchange

<br>

**Queue 생성**
- Type : Default for Virtual Host (저는 Quorum Queue를 사용 하였습니다)
- Name: Queue 이름
- Durable 설정 (Transient로 설정 시 RabbitMQ 재시작 하면 Queue가 사라집니다.)
- Add Queue

<br>

**Exchange <-> Queue 바인딩**
- Queue 탭으로 이동 후 만든 큐의 이름 클릭
- 하단의 Bindings 섹션에서 Bind from an Exchange 옵션 선택
- From Exchange 필드에 앞서 만든 Exchange의 이름 입력
- Routing Key 필드에 MQTT Topic 입력 ( MQTT 데이터를 내보내는 곳에서 설정한 토픽으로 설정)
- Bind 클릭

<br>

> 😯 **Default Exchange로 들어오는 데이터를 직접 만든 Exchange로 데이터 라우팅**

RabbitMQ의 Default Binding 정책 때문에 Topic타입의 Exchange는 기본으로 만들어져 있는 `amq.topic` Exchange로 갑니다.

그래서 Default Exchange로 들어오는 데이터를 위에서 직접 만든 Exchange로 데이터가 넘어가게 설정(바인딩)해줘야 합니다.

- amq.topic Exchange로 들어가서 만든 **Exchange(Queue가 아님)** 와 바인딩을 해줍니다.
- amq.topic Exchange의 Binding 섹션에서 **To Exchange**를 선택하고 Routing Key로 `#`을 입력해서 기본 Exchange -> 만든 Exchange로 데이터가 넘어가게 해줍니다.

<br>

[RabbitMQ Topolozy 구성 좋은 글 발견함](https://medium.com/@supermegapotter/rabbitmq-topology-guide-8427ebbe927f)

<br>

>  😯 **Queue에 쌓인 메시지를 RabbitMQ를 재기동 했을 때에도 보존하고 싶을 경우**

**~~1번 방법~~ (안먹힘)**

- 사용중인 Queue에 들어가서 Add Binding 섹션을 찾습니다.
- 바인딩은 동일하게 하되 Arguments에 Message의 TTL은 -1로 설정해주면 메시지가 계속 보존됩니다. **(참고로 TTL의 단위는 milli second)**
- 만약 큐에 저장되는 메시지 수나 크기에 대한 제한도 없애려면 `x-max-length-bytes` 옵션도 `-1`로 설정하고 바인딩 하면 됩니다.

<img src="https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/rabbit-ttl.png" width="110%">

<br>

**2번 방법 (이 방법 사용했음)**

- Queue를 만들때 Quorum Queue로 생성합니다.
- **Exchange와 바인딩 해줍니다**
- RabbitMQ 3.11 버전부터 쿼럼 큐의 메세지 저장방식의 Default는 디스크 저장입니다.
- C:\Users계정명\AppData\Roaming\RabbitMQ\db\클러스터이름\quorum 에 데이터가 쌓입니다.
- 단 Quorum Queue는 Confirm 방식이기 떄문에 Client(React)에서 autoConfirm 옵션을 True로 설정해야 합니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/rabbit-alive.png)

<br>

**3번 방법 : Publisher Confirm**

`Publisher Confirm` 방식은 메시지가 RabbitMQ에  성공적으로 다돌했음을 보장하는 매커니즘입니다.

이 기능은 메시지를 발행하는 Producer 측에서 사용되며 프로듀서가 RabbitMQ에 메시지를 보낸 후, 

RabbitMQ가 메시지를 받았음을 알리는 확인(Acknowledgment)를 프로듀서에게 보내는 방식입니다.

<br>

- 1번 방법: 메시지를 Publish 할 때 Header에 `persistent : true` 옵션을 걸면 Message의 Delivery Mode가 2가 되며 메시지는 영속성을 가집니다.
- 2번 방법 : Python Pika 라이브러리의 `pika.BlockingConnection(pika.ConnectionParameters('localhost)).confirm_delivery()`` 함수를 사용하는 방식이 있습니다.

<br><br>

위의 설정을 마무리 하면 RabbitMQ는 설정한 Topic으로 발행된 MQTT 메시지를 수신할 준비가 됩니다.

이렇게 설정한 큐는 React + TypeScript 앱(MQTT Client)이 해당 Topic을 Subscribe하기 시작하면,

그때부터 해당 Topic으로 발행(Publish)되는 모든 MQTT 메시지를 받을 수 있습니다.

<br>

이제 MQTT Producer에서 MQTT를 내보낼때 Topic을 설정하고 내보내면 RabbitMQ의 Exchange를 거쳐, Routing Key에 맞는 Queue에 MQTT 데이터가 쌓입니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/rabbitqueue.png)


---
## 📘 기본 설정 파일 위치 변경

[RabbitMQ-Logging 공식 문서](https://www.rabbitmq.com/logging.html#log-outputs)

[RabbitMQ-환경변수 공식 문서](https://www.rabbitmq.com/configure.html#customise-environment)

<br>

> **📕 만약 기존 RabbitMQ가 설치된 상태에서 Configuration을 직접 설정하고 싶을 경우**

- 기존 RabbitMQ 삭제하고 아래 내용 중 `😊 RabbitMQ 기준 경로 (RABBITMQ_BASE) 변경` 까지만 진행하고 다시 Rabbit을 설치하고 진행해야 합니다.
- 왜냐하면 이미 설치된 상태에서 환경 변수를 바꿔줘도 안 먹히기 때문에 저도 재 설치 후 변수가 잘 적용되었습니다.

<br>

> **😊 Windows 환경에서 RabbitMQ의 Default Log, Config, Data의 기본 위치, 파일은 아래와 같습니다.**

- 로그 :  `C:\Users\사용자명\AppData\Roaming\RabbitMQ\log` 디렉터리에 저장됩니다. 
- 데이터 : `C:\Users\사용자명\AppData\Roaming\RabbitMQ\db` 디렉터리에 저장됩니다.
- Config 파일 : `C:\Users\사용자명\Appdata\Roaming\RabbitMQ\advanced.config` 파일을 사용합니다.

<br>

기본 경로를 사용해도 되지만 데이터,로그,설정 파일은 별도의 디렉터리에 관리하는게 편하니 바꿔보겠습니다.

<br>

> **😊 사용할 방법**

- 적용할 환경변수를 설정하는 배치파일을 **지정된 파일명 (rabbitmq-env.conf.bat)** 으로 생성
- `$RABBITMQ_BASE` 변수에 파일이 있는 경로를 저장합니다.
- 기본 경로를 변경함으로써 환경변수 설정 파일이 없어도 지정된 경로에서 실행
- Log나 DB등의 경로를 지정하지 않아도 해당 경로에 생성됩니다.

<br>

> **😊 RabbitMQ 기준 경로 (RABBITMQ_BASE) 변경**

- RabbitMQ의 데이터를 저장할 디렉터리 생성 (ex: E:\Data\RabbitMQ)
- 환경 변수 2개를 추가 해줍니다.
- 윈도우의 시스템 환경 변수 편집 으로 들어갑니다.
- **시스템 변수**가 아닌 **사용자 변수**에 **새로만들기**를 눌러줍니다.

<br>

|변수 이름|변수 값|
|---|---|
|`RABBITMQ_BASE`|RabbitMQ의 데이터를 저장할 경로 `(ex: E:\Data\RabbitMQ)`|
|`RABBITMQ_CONFIG_FILES`|RabbitMQ의 데이터를 저장할 경로 + conf 파일 이름 `(ex:E:\Data\RabbitMQ\rabbit.conf)`|

<br>

환경 변수 추가 후 RabbitMQ 서버를 실행 해보면, `E:\Data\RabbitMQ` 폴더에 log, db 폴더가 생기고 로그 파일과 데이터들이 잘 생긴 걸 확인 할 수 있습니다.

**Config Files**가 None이 나오는 이유는, 아직 Conf 파일을 작성 안 했기 때문입니다. Conf 파일은 좀 더 뒤에서 작성해 보겠습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/rabbit-log.png)

<br>

> **😊 RabbitMQ 환경 변수 윈도우 배치 파일 생성**

환경 변수 파일 (.bat 파일)을 작성합니다.

환경변수로 등록한 `E:\Data\RabbitMQ` 디렉터리 하위에 `rabbitmq-env-conf.bat` 배치파일을 작성합니다.

**REM**은 키워드 주석이므로 스크립트 실행 시 무시됩니다.

그 외는 노드이름, Config 파일 위치 지정, 로그 파일이 저장될 위치 지정, 데이터 파일이 저장될 위치를 지정해줍니다.

```shell
REM rabbitmq-env-conf.bat
 
REM Node Name
SET NODENAME=rabbit@root
 
REM Config file location
SET CONFIG_FILE=E:\Data\RabbitMQ
 
REM MNESIA DB data file location
SET MNESIA_BASE=E:\Data\RabbitMQ\db
 
REM Log file location
SET LOG_BASE=E:\Data\RabbitMQ\log
```

<br>

`RABBITMQ_BASE`를 통해 환경 설정을 하면 **지정된 경로**에 **지정된 파일명**으로 환경설정 파일들을 생성해야하는 단점이 있는데, 

아래와 같이 설정하면 파일명과 경로도 마음대로 지정할 수 있고, 아래 두개의 변수가 우선순위가 더 높기 때문에 가능합니다.
 
- `set RABBITMQ_CONF_ENV_FILE=E:/Data/RabbitMQ/skw-rabbitmq-env-prod.bat`
- `set RABBITMQ_CONFIG_FILE=E:/Data/RabbitMQ/skw-rabbitmq-prod.conf`

<br>

위 배치 스크립트에서 로그,데이터 파일은 생성 됐지만, Conf 파일은 경로 지정만 하고 아직 작성을 안 했으니 Conf 파일도 작성해봅시다.

<br>

> **😊 RabbitMQ Configuration 파일 생성 & 설정**

일단 로그 설정만 적용되게 하고 성능 관련 파라미터는 나중에 테스트 후 추가 하겠습니다.

_※ 로그 파일의 보존 기간을 설정하는 `log.file.max.age`는 변수 명이 안 먹혀서 임시로 주석 처리 해 놓았습니다._

```bash
# ----- 로그 설정 -----

#로그 파일 형식 지정
log.file.formatter = plaintext

# 로그 파일명 지정
log.file = E:\Data\RabbitMQ\log\rabbit.log

# 로그 레벨 지정
log.file.level = debug

# 로그 로테이트 (매일 자정에 새로운 로그 파일 생성)
log.file.rotation.date = $D0

# 로그 파일 유지 개수
log.file.rotation.count = 7

# 로그 파일 보존 기간 설정 (단위: Second)
#log.file.max.age = 30000

# ----- 성능 관련 파라미터 설정 -----
```

<br>

아래 사진과 같이 Conf 파일이 잘 인식되고, 로그 파일도 지정한 위치에 잘 생긴 것을 볼 수 있습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/rabbit-log2.png)

<br>

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/rabbit-log3.png)
