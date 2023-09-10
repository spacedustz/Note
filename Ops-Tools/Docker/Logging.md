## Logging

도커는 컨테이너의 표준출력(stdout)과 에러(stderr)를 별도의 Metadata 파일로 컨테이너 내부에 저장한다.

저장 경로는 컨테이너 내부의 `/var/lib/docker/containers/{container-id}/{container-id}-json.log` 의 경로로 저장된다.

아래 명령어는 도커 컨테이너 내부의 로그를 출력하는 기본적인 명령어와 옵션들이다.

```bash
# 컨테이너 내부 로그 출력
$ docker logs {container-name}

# 컨테이너 내부 로그 끝 2줄만 출력
$ docker logs {container-name} --tail 2

# 컨테이너 내부 로그의 특정 시간대 검색 (유닉스 시간대 기준)
$ docker logs {container-name} --sinse

```

---

## 로그를 출력하는 다양한 옵션

`--tail 2` : 로그의 끝에서 2줄 출력
`--head 2` : 로그의 처음부터 2줄 출력
`--sinse` : 유닉스 시간을 입력해 특정 시간 이후 로그 기록
`-f` : 로그의 스트림 출력
`-t` : 로그의 타임 스탬프
`--log-opt --max-size` : 로그파일의 사이즈 지정
`--log-opt --max-file` : 로그 파일의 개수 지정
`--log-driver` : 로그 드라이버 지정 가능 (default = json)

---

## 로그 드라이버의 종류
- syslog
- journald
- fluentd
- awslogs

---

## Syslog

기본적으로 로컬 호스트의 syslog에 저장되며 OS 마다 syslog의 위치가 상이하다.
- Debian 계열 : /var/log/syslog
- Redhat 계열 : /var/log/messages
- Ubuntu 16.04 & coreOS : journalctl -u docker.service
<br>
Syslog를 외부서버에 설치해 로그를 외부로도 보낼 수 있다.
그 방법으로는 `rsyslog`를 써서 중앙 컨테이너로 로그를 저장하는 예시를 아래에서 보자.
서버, 클라이언트 총 2개의 가상머신이 있다고 가정한다.

<br>

### 서버에서 rsyslog 컨테이너 생성

```bash
$ docker run -it -h rsyslog --nama LogContainer -p 514:514 -p 514:514/udp centos:latest
```

<br>

### 서버의 rsyslog 컨테이너 내부에 rsyslog.conf 파일의 syslog 서버를 구동시키는 옵션 주석해제

```bash
$ vi /etc/rsyslog.conf

#Provides UDP syslog reception
$ModLoad imudp
$UDPServer Run 514

:wq

# rsyslog 재기동
$ service rsyslog restart
```

<br>

### 클라이언트에서 로그 컨테이너 생성과 동시에 서버의 로그 컨테이너와 태그 지정
**태그는 로그가 생성될 때 함께 저장될 태그이며 로그를 분류하는데에 좋다.**


```bash
$ docker run -it \
$ --log-driver=syslog \
$ --log-opt syslog-address=tcp://{Server-IP}:514 \
$ --log-opt tag="LogContainer" \
$ centos:latest
```

<br>

### 서버에서 syslog 파일 확인을 하면 로그가 전송된 것을 알 수 있다.

```bash
$ tail /var/log/syslog
```

<br>

`--log-opt syslog-facillity`를 사용하면 로그가 저장될 파일도 바꿀수 있다.
facillity는 로그를 생성하는 주체에 따라 로그를 다르게 저장하는 것으로, 여러 어플리케이션에서 수집되는 로그를 분류하는 방법이다.
<br>
기본적으로 daemon으로 설정되어 있지만
- kern
- user
- mail
등 다른 facillity를 사용할 수 있다.
facillity 옵션을 쓰면 rsyslog 컨테이너 내부에 facillity 별로 로그파일이 따로 생성된다.

---

## fluentd

각종 로그를 수집하고 저장하는 오픈소스 도구로서, 
도커 엔진 기반 컨테이너의 로그를 fluentd를 통해 저장할 수 있도록 공식적으로 제공하는 플러그인이다.

<br>

fluentd의 데이터 포맷도 json이며 수집되는 데이터를 AWS, S3, HDFS, MongoDB등 다양한 곳에 저장할 수 있다.

<br>

다음 예시는 fluentd와 MongoDB를 연동해 데이터를 저장하는 방법을 보여준다.
Docker Server -> fluentd -> MongoDB 의 Flow이며, 각각의 가상머신이 있다고 가정한다.

<br>

### MongoDB 머신에서 MongoDB 컨테이너 생성

```bash
$ docker run -d --name MongoContainer -p 27017:27017 mongo:latest
```

<br>

### fluentd 머신의 로컬에 다음 내용을 저장한다.

```bash
<source>
  @type forward
</source>

<match docker.**>
  @type mongo
  database nginx
  collection access
  host {MongoDB-Server-IP}
  port 27017
  flush_interval 10a
  user root
  password password
```

<br>

### fluentd 컨테이너 생성

```bash
$ docker run -d --name FluentdContainer -p 24224:24224 \
$ -v ${pwd}/fluentd.conf:/fluentd/etc/fluent.conf \
$ -e FLUENTD_CONF=fluent.conf \
$ fluentd:latest
```
