# 개인 공부 메모장

---

## 📚 Database

### MariaDB

- [MariaDB 기본 명령어](./Database/MariaDB/기본%20명령어.md)
- [Table Range Partitioning](./Database/MariaDB/Range%20Partitioning.md)

<br>

### Redis

- [Redis 기본 사용법](./Database/Redis/Redis%20기본%20사용법.md)

---

## 📚 Backend

### Message Queue

- [RabbitMQ 기본 Pub/Sub 구현](./Backend/Message-Queue/RabbitMQ/기본구조/RabbitMQ%20-%20PubSub.md)
- [RabbitMQ Basic Consume 방식 구현](./Backend/Message-Queue/RabbitMQ/Basic-Consume/RabbitMQ%20-%20Basic%20Consume.md)
- [RabbitMQ Clustering](./Backend/Message-Queue/RabbitMQ/Clustering/Clustering.md)
- [RabbitMQ Dead Letter Exchange & TTL 설정](./Backend/Message-Queue/RabbitMQ/Dead-Letter-Exchange/RabbitMQ-Dead%20Letter%20Exchange-TTL.md)
- [RabbitMQ 성능 파라미터](./Backend/Message-Queue/RabbitMQ/성능파라미터/성능%20파라미터.md)

<br>

### Streaming

- [Live Streaming 이해하기](./Backend/Streaming/Live-Streaming/Live%20Streaming%20이해하기.md)
- [FFmpeg 기본 사용법](./Backend/Streaming/FFmpeg/FFmpeg.md)
- [GStreamer Pipeline](./Backend/Streaming/GStreamer/Gstreamer.md)
- [FFmpeg을 이용한 RTSP Stream -> HLS 변환 스트리밍](./Backend/Streaming/HLS/RTSP%20to%20HLS.md)

<br>

### File I/O

- [Recursive를 이용한 파일 삭제](./Backend/IO/File-IO.md)

<br>

### Test

- [Apache Jmeter - 처리량 측정 & 테스트](./Backend/Test/Apache-Jmeter/Apache%20Jmeter.md)

---

## 📚 Server

### Script

📂 **Windows**

|File|Description|
|---|---|
|[TimeConditionBatch.bat](./Server/Script/Windows/TimeConditionBatch.bat)|특정 시간대에만 특정 프로그램들을 실행하고 헬스체크를 수행하는 배치파일|


<br>

📂 **Linux**

|File|Description|
|---|---|
|[GPU-Driver.sh](./Server/Script/Linux/GPU-Driver.sh)|Nvidia Driver, Cuda Tool Kit, OpenGL 세팅 스크립트|
|[Remove-Nouveau.sh](./Server/Script/Linux/Remove-Nouveau-Kernel-Driver.sh)|Nvidia Driver와 충돌나는 Nouveau 커널 드라이버 제거 스크립트|
|[Redhat-Default-Setting.sh](./Server/Script/Linux/Redhat-Default-Setting.sh)|Reahat Enterprise 서버 기본 세팅 스크립트|
|[Ubuntu-Default-Setting.sh](./Server/Script/Linux/Ubuntu-Default-Settings.sh)|Ubuntu 22.04 LTS 버전 서버 기본 세팅 스크립트|
|[Run-FFmpeg.sh](./Server/Script/Linux/Run-FFmpeg.sh)|x개의 FFmpeg 프로세스 실행 및 .ts파일, .m3u8파일 생성 스크립트|

<br>

📂 **Jenkins**

Jenkins Declarative Pipeline & Docker & Nginx를 이용한 Blue/Green 무중단 배포 스크립트

|File|Description|
|---|---|
|[Jenkins Instance Setting](./Server/Script/Jenkins/Server.sh)|Jenkins Server Instance Settings|
|[Dockerfile](./Server/Script/Jenkins/Dockerfile)|OpenJDK 이미지 베이스로 Container 실행|
|[Docker-HA.sh](./Server/Script/Jenkins/Docker-HA.sh)|Jenkins 배포 시 blue/green 컨테이너 중 미실행 중인 곳에 새 버전 릴리즈 후 로드밸런싱 프록시 타겟 변경 / 기존 실행 컨테이너 중지|
|[jenkinsfile](./Server/Script/Jenkins/jenkinsfile)|Git Commit 시 태그 이름중 특정 단어가 들어간 커밋에만 배포 적용 (이파일에선 "cicd" 키워드 사용)|
|[nginx.conf](./Server/Script/Jenkins/nginx.conf)|Blue / Green 컨테이너 포트인 8080/8081에 대한 트래픽 로드밸런싱 수행|
|[service-url.inc](./Server/Script/Jenkins/service-url.inc)|Service URL 지정 (nginx.conf 내에 include 됨)|


<br>

### Network

- [Global Private Network 구성 - ZeroTier](./Server/Network/Zerotier.md)

<br>

### Remote

- [Tiger VNC를 이용한 Remote GUI 환경 구축](./Server/Remote/TigerVNC.md)

<br>

### Utils

- [Ubuntu Desktop GUI 응답없을떄 GUI Repair 방법](./Server/Utils/GUI%20Repair.md)
- [Linux Shell Script 작성 시 타 운영체재 개행 치환](./Server/Utils/개행%20제거.md)
- [NTP - 시간 동기화](./Server/Utils/시간동기화/시간%20동기화.md)
- [좀비 프로세스 죽이기](./Server/Utils/좀비%20프로세스%20죽이기.md)
- [Ubuntu LTS 버전별 IP 변경](./Server/Utils/Ubuntu%20버전별%20IP%20변경.md)

---

## 📚 Tools

### Git

- [전체 Commit Author 변경 & Commit 되돌리기](./DevTools/Git/전체%20Commit%20Author%20변경%20&%20커밋%20되돌리기.md)
- [Git Tag 사용법](./DevTools/Git/Tag.md)

---

## 📚 Algorithm

- [알고리즘 기본 개념](./Algorithm/알고리즘-기본개념.md)
- [정렬](./Algorithm/정렬알고리즘/정렬%20알고리즘.md)