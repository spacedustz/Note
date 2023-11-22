## 📘 Rabbitmq-Custom-Installation

> **플랫폼 별 Conf 파일 위치**

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
