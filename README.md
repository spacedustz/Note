# 📚 공부 노트 📚

---

# 🐱 Backend

<details>
<summary><strong>내용 보기</strong></summary>

### 🧙‍♀️ Spring

<br>

**Spring AOP**

- [API Verification 공통화](./Backend/Spring/AOP/Spring%20AOP%20-%20API%20Verification%20공통화.md)

<br>

**Transaction**

  - [AOP Transaction & Distributed Transaction](./Backend/Spring/Transaction/AOP-Distributed-Transaction.md)

<br>

**QueryDSL**

  - [QueryDSL (Kotlin)](./Backend/Spring/QueryDSL/Kotlin)
  - [QueryDSL (Java)](./Backend/Spring/QueryDSL/Java)

<br>

**Push & WebHook Alarm**

  - [Slack WebHook 연동](./Backend/WebHook/Slack/Slack%20Web%20Hook%20연동.md)
  - [Discord WebHook 연동](./Backend/WebHook/Discord/Discord%20Bot%20연동.md)

<br>

**Spring WebFlux**

  - [Reactive - Reactive Programming](./Backend/Spring/Reactive/WebFlux/Reactive.md)
  - [Reactive - Project Reactor & Marble Diagram & Scheduler & Operator](./Backend/Spring/Reactive/WebFlux/Reactor/Reactor-Marble-Scheduler.md)
  - [WebClient - Spring WebClient](./Backend/Spring/Reactive/WebClient/Spring%20WebClient.md)

<br>

**WebSocket**

  - [Spring WebSocket - Stomp](./Backend/Spring/WebSocket/WebSocket%20-%20Stomp.md)
  - [Spring WebSocket - 순수 WebSocket API](./Backend/Spring/WebSocket/WebSocket.md)

<br>

**Spring Cloud**

  - [Spring Cloud - Cloud Config Server/Client 구성](./Backend/Spring/Cloud/Cloud-Config/Spring%20Cloud%20Config.md)
  - [Spring Cloud - API Gateway](./Backend/Spring/Cloud/Cloud-Gateway/Cloud-Gateway.md)
  - [Spring Cloud Sleuth + Zipkin을 이용한 분산 로그 추적](./Backend/Spring/Trace/Zipkin/Zipkin.md)

<br>

**Global Exception Handling**

  - [Global Exception Handling](./Backend/Spring/Utils/Exception/Global%20Exception%20Handling.md)

<br>

**Security + OAuth2 + SMTP**

  - [Security 구현](./Backend/Spring/Security/Spring%20Security/Spring%20Security.md)
  - [Google OAuth2 적용](./Backend/Spring/Security/Google%20OAuth2/Google%20OAuth2.md)
  - [Facebook OAuth2 적용](./Backend/Spring/Security/Facebook%20OAuth2/Facebook%20OAuth2.md)
  - [이메일 인증 기능 구현(Google SMTP & Redis)](./Backend/Spring/Security/Email/비밀번호%20찾기%20&%20재설정%20기능%20구현(Google%20SMTP).md)

<br>

**File I/O**

  - [Recursive를 이용한 파일 삭제](./Backend/IO/File-IO.md)

<br>

**Utils**

  - [Swagger API 문서화](./Backend/Spring/Utils/Swagger/Swagger%20API.md)
  - [Spring ehCache & DevTools](./Backend/Spring/Utils/Spring%20ehCache%20&%20DevTools.md)
  - [Jar 실행 옵션](./Backend/Spring/Deploy/Jar%20Start%20Option.md)
  - [Logback 설정](./Backend/Spring/Deploy/Logback.md)
  - [Publish Maven Local](./Backend/Spring/Utils/Publish/Publish%20Maven%20Local.md)

<br>

**Error**

  - [HikariCP - Thread Starvation & Clock Leap Detection](./Error/Spring/Thread-Starvation/HikariCP%20-%20Thread%20Starvation.md)
  - [WebClient - DataBufferLimitException 해결 (WebClient Buffer를 늘리지 않는 방법)](./Error/Spring/DataBufferLimit/DataBufferLimitException%20-%20Webflux%20버퍼%20크기%20제한%20초과.md)

<br>

### 🧙‍♀️ Multi-Threading & Concurrency

- [🐱 Repository 방문하기 🐱](https://github.com/spacedustz/Performance-Optimization)

<br>

### 🧙‍♀️ Design Pattern & 성능 최적화

- [Producer-Consumer 패턴 with RabbitMQ](./Backend/Design-Pattern/Producer-Consumer/Producer%20Consumer%20Pattern.md)
- [트리순회(MPTT) 방식을 이용한 조회 성능 최적화](./Backend/Spring/Performance-Optimization/MPTT.md)
- [CQRS Pattern](./Backend/Design-Pattern/CQRS-Pattern/CQRS-Pattern.md)

<br>

### 🧙‍♀️ Message Queue

- [RabbitMQ 기본 Pub/Sub 구현](./Backend/Message-Queue/RabbitMQ/기본구조/RabbitMQ%20-%20PubSub.md)
- [RabbitMQ Basic Consume 방식 구현](./Backend/Message-Queue/RabbitMQ/Basic-Consume/RabbitMQ%20-%20Basic%20Consume.md)
- [RabbitMQ Clustering](./Backend/Message-Queue/RabbitMQ/Clustering/Clustering.md)
- [RabbitMQ Dead Letter Exchange & TTL 설정](./Backend/Message-Queue/RabbitMQ/Dead-Letter-Exchange/RabbitMQ-Dead%20Letter%20Exchange-TTL.md)
- [RabbitMQ 성능 파라미터](./Backend/Message-Queue/RabbitMQ/성능파라미터/성능%20파라미터.md)

<br>

- [Apache Kafka 구현 - Producer & Consumer](./Backend/Message-Queue/Kafka/Kafka.md)

<br>

### 🧙‍♀️ Streaming

- [Live Streaming 이해하기](./Backend/Streaming/Live-Streaming/Live%20Streaming%20이해하기.md)
- [FFmpeg 기본 사용법](./Backend/Streaming/FFmpeg/FFmpeg.md)
- [GStreamer Pipeline](./Backend/Streaming/GStreamer/Gstreamer.md)
- [FFmpeg을 이용한 RTSP Stream -> HLS 변환(실시간 스트리밍)](./Backend/Streaming/HLS/RTSP%20to%20HLS.md)
- [RTSP Steam 영상 녹화 스케쥴러](./Backend/Streaming/Recording/Recording%20RTSP%20Stream%20to%20mp4.md)

<br>

### 🧙‍♀️ Test

- [Apache Jmeter - 처리량 측정 & 테스트](./Backend/Test/Apache-Jmeter/Apache%20Jmeter.md)

<br>

### 🧙‍♀️ Error

**Spring**

- [HikariCP - Thread Starvation & Clock Leap Detection](./Error/Spring/Thread-Starvation/HikariCP%20-%20Thread%20Starvation.md)

<br>

**Jenkins**

- [Jenkins - Credential & Web Hook Error](./Error/Jenkins/Jenkins%20-%20Credential%20&%20Web%20Hook%20Error.md)

<br>

**MySQL**

- [Mysql - Global Transaction Identifier Error (GTID)](./Error/MySQL/MySQL%20-%20Global%20Transaction%20Identifier%20Error%20(GTID).md)

<br>

**Server**

- [Ubuntu - OpenGL Initialize Exception](./Server/Error/OpenGL%20-%20glxinfo%20initialize%20exception.md)
- [Ubuntu Nouveau Kernel Driver 제거](./Server/Error/Ubuntu%20-%20Nouveau%20Kernel%20Driver%20제거.md)
- [NVIDIA-SMI GPL-incompatible module Error](./Server/Error/NVIDIA/NVIDIA-SMI%20GPL-incompatible%20module%20Error.md)

</details>

---

# 🐱 Frontend

<details>
<summary><strong>내용 보기</strong></summary>

### 🧙‍♀️ React

- [Yarn 기반 프로젝트 생성](./Frontend/React/Yarn%20사용법.md)
- [React 핵심 개념들](./Frontend/React/React.md)
- [React Markdown을 이용한 글쓰기 기능 개발](./Frontend/React/Markdown/Markdown.md)
- [Zustand 상태 관리](./Frontend/React/Zustand.md)
- [Kakao Map API](./Frontend/React/Map/Kakao/KakaoMap.md)

<br>

### 🧙‍♀️ Flutter

**위젯**

- [Stateless & Stateful Widget](./Frontend/Flutter/Widget/State/Stateless-Stateful.md)
- [Route - 경로 & 화면 매핑](./Frontend/Flutter/Widget/Route/Route.md)
- [Column & Row & Expanded Widget](./Frontend/Flutter/Widget/Row-Column-Expanded/Column-Row-Expanded.md)
- [Container & SizeBox Widget](./Frontend/Flutter/Widget/Container-SizeBox/Container-SizeBox.md)
- [Elevated Button & List View Widget](./Frontend/Flutter/Widget/ElevateButton-ListView/ElevatedButton-ListView.md)
- [Text Field Widget(입력값 받기)](./Frontend/Flutter/Widget/TextField/TextField.md)

<br>

**상태 관리**

- [setState - Update Widget & Re-draw UI](./Frontend/Flutter/State/SetState/SetState.md)
- [Value Notifier - 더 간단하고 명확한 상태 관리](./Frontend/Flutter/State/Value-Notifier/Value-Notifier.md)

<br>

**Navigation & Routing**

- [Navigating Screen & Argument(Object) 전달](./Frontend/Flutter/Navigation/Navigator-Object/Navigator-Object.md)
- [Navigation Bar & TapBar & Drawer](./Frontend/Flutter/Navigation/Bar-Drawer/Bar-Drawer.md)

</details>

---

# 🐱 Server

<details>
<summary><strong>내용 보기</strong></summary>

### 🧙‍ Kubernetes

- [경량 쿠버네티스 k3s 구축 - Ubuntu 22.04 LTS](./Server/Kubernetes/k3s/Ubuntu-k3s-Installation.md)
- [k8s 기본 Objects](./Server/Kubernetes/k8s)

<br>

### 🧙‍♀️ CI & CD

> **Jenkins Declarative Pipeline 방식 Blud/Green 무중단 배포**

Nginx + AWS Application Load Balancer(ALB)를 이용한 트래픽 로드밸런싱과,

Blue, Green Docker Container로의 Proxy 방향 전환을 통한 Jenkins Declarative Pipeline 방식의 무중단 배포 구현

- [Jenkins Declarative Pipeline 구축하기 1](./Server/CI%20&%20CD/Jenkins/Declarative%20Pipeline%20방식/Jenkins-Declarative-1.md)

- [Jenkins Declarative Pipeline 구축하기 2](./Server/CI%20&%20CD/Jenkins/Declarative%20Pipeline%20방식/Jenkins-Declarative-2.md)

<br>

> **Jenkins FreeStyle CI & CD**

Nginx Reverse Proxy를 이용한 내부망 Docker Jenkins Container에 배포 Trigger 전달

- [Jenkins CI & CD](./Server/CI%20&%20CD/Jenkins/FreeStyle%20방식/Jenkins%20CI%20&%20CD%20+%20Nginx%20Reverse%20Proxy.md)

<br>

### Metric Visualization

- [Prometheus & Grafana - Monitoring System](./Server/Metrics/Grafana/Grafana.md)

<br>

### Nginx Contents Server

- [Nginx - Static Contents Server](./Server/Nginx/Nginx%20File%20Server.md)

<br>

### 🧙‍♀️ Script

**Windows**

- [[Script File] TimeConditionBatch.bat](./Server/Script/Windows/TimeConditionBatch.bat) - 특정 시간대에만 특정 프로그램들을 실행하고 헬스체크를 수행하는 배치파일


<br>

**Linux**


- [[Script File] GPU-Driver.sh](./Server/Script/Linux/GPU-Driver.sh) - Nvidia Driver, Cuda Tool Kit, OpenGL 세팅 스크립트
- [[Script File] Remove-Nouveau.sh](./Server/Script/Linux/Remove-Nouveau-Kernel-Driver.sh) - Nvidia Driver와 충돌나는 Nouveau 커널 드라이버 제거 스크립트
- [[Script File] Redhat-Default-Setting.sh](./Server/Script/Linux/Redhat-Default-Setting.sh) - Reahat Enterprise 서버 기본 세팅 스크립트
- [[Script File] Ubuntu-Default-Setting.sh](./Server/Script/Linux/Ubuntu-Default-Settings.sh) - Ubuntu 22.04 LTS 버전 서버 기본 세팅 스크립트
- [[Script File] Run-FFmpeg.sh](./Server/Script/Linux/Run-FFmpeg.sh) - x개의 FFmpeg 프로세스 실행 및 .ts파일, .m3u8파일 생성 스크립트

<br>

### 🧙‍♀️ Network

- [Global Private Network 구성 - ZeroTier](./Server/Network/Zerotier.md)

<br>

### 🧙‍♀️ Remote GUI

- [Tiger VNC를 이용한 Remote GUI 환경 구축](./Server/Remote/TigerVNC.md)

<br>

### 🧙‍♀️ Utils

- [Docker-Compose](./Server/Container/Docker-Compose.md)
- [Docker Data Path 수정](./Server/Container/Docker-Data-Path-수정.md)
- [Ubuntu Desktop GUI 응답없을떄 GUI Repair 방법](./Server/Utils/GUI%20Repair.md)
- [Linux Shell Script 작성 시 타 운영체재 개행 치환](./Server/Utils/개행%20제거.md)
- [NTP - 시간 동기화](./Server/Utils/시간동기화/시간%20동기화.md)
- [좀비 프로세스 죽이기](./Server/Utils/좀비%20프로세스%20죽이기.md)
- [Ubuntu LTS 버전별 IP 변경](./Server/Utils/Ubuntu%20버전별%20IP%20변경.md)
- [주기적인 CronTab 실행](./Server/Utils/Cron/CronTab.md)
- [Linux Server Spec 확인](./Server/Utils/Server%20Spec%20확인.md)
- [디렉토리 용량 파악](./Server/Utils/용량확인.md)
- [LVM Volume 증설](./Server/Utils/LVM-논리불륨-증설.md)
- [CIFS-Mount](./Server/Redmine/CIFS-Mount.md)

</details>

---

# 🐱 Database

<details>
<summary><strong>내용 보기</strong></summary>

### 🧙‍♀️ MySQL

- [Global Transaction Identifier - Firebase to AWS RDS 데이터 이전](./Database/MySQL/GTID/GTID.md)

<br>

### 🧙‍♀️ MariaDB

- [MariaDB 기본 명령어](./Database/MariaDB/기본%20명령어.md)
- [Table Range Partitioning](./Database/MariaDB/Range%20Partitioning.md)

<br>

### 🧙‍♀️ Redis

- [Redis 기본 사용법](./Database/Redis/Redis%20기본%20사용법.md)
- [Redis Publish & Subscribe Pattern (RabbitMQ)](./Database/Redis/PubSub/Pub%20&%20Sub%20Pattern%20(Spring%20Data%20Redis%20+%20React%20TypeScript).md)

<br>

### 🧙‍♀️ Mongo DB

- [MongoDB 기본 사용법](./Database/MongoDB/기본%20사용법/MongoDB%20기본%20사용법.md)

</details>

---

# 🐱 Languages

<details>
<summary><strong>내용 보기</strong></summary>

### 🧙‍♀️ MarkUp & Style Sheet

- [자주 쓰는 Tag & WireFrame](./Languages/MarkUp%20&%20StyleSheet/1/1.%20자주쓰는%20HTML&CSS와%20WireFrame.md)
- [FlexBox - Layout 설계](./Languages/MarkUp%20&%20StyleSheet/2/2.%20Flexbox.md)
- [ARGB & BootStrap](./Languages/MarkUp%20&%20StyleSheet/3/3.%20ARGB와%20BootStrap.md)

<br>

### 🧙‍♀️ Java

- [Windows Power Shell 명령어 실행](./Languages/Java/CMD/Java에서%20Windows%20Power%20Shell%20명령어%20실행.md)

<br>

### 🧙‍♀️ Python

- [Python 개발 환경 세팅](./Languages/Python/개발환경세팅.md)
- [Server Health Check Script](./Languages/Python/Health-Check.md)

<br>

### 🧙‍♀️ JavaScript

- [Optional Channing](./Languages/JavaScript/Optional%20Channing.md)
- [Stomp.js - WebSocket Subscribe](./Languages/JavaScript/WebSocket.md)

<br>

### 🧙‍♀️ TypeScript

- [TypeScript 기본 문법 정리](./Languages/TypeScript/기본문법.md)

</details>

---

# 🐱 Algorithm

<details>
<summary><strong>내용 보기</strong></summary>

- [알고리즘 기본 개념](./Algorithm/기본개념/알고리즘-기본개념.md)
- [Dynamic Programming](./Algorithm/Dynamic%20Programming/Dynamic%20Programming.md)
- [DFS & BFS](./Algorithm/DFS%20&%20BFS.md)
- [Flood Fill Algorithm](./Algorithm/Flood%20Fill.md)

<br>

**정렬**
- [Sort - 정렬](Algorithm/Sort/Sort.md)

<br>

**탐색**
- [Sequential Search - 순차 탐색](./Algorithm/탐색/순차탐색.md)
- [Binary Search - 이진 탐색](./Algorithm/탐색/이진탐색.md)
- [BST - 이진 탐색 트리](./Algorithm/탐색/이진탐색트리/이진%20탐색%20트리.md)
- [BBST - 2-3-4 트리](./Algorithm/탐색/2-3-4트리/2-3-4%20트리.md)
- [Red-Black Tree](./Algorithm/탐색/Red-Black-Tree/Red-Black%20Tree.md)
- [B-Tree](./Algorithm/탐색/B-Tree/B-Tree.md)

</details>

---

# 🐱 Tools

<details>
<summary><strong>내용 보기</strong></summary>

### 🧙‍♀️ Git

- [전체 Commit Author 변경 & Commit 되돌리기](./DevTools/Git/전체%20Commit%20Author%20변경%20&%20커밋%20되돌리기.md)
- [Git Tag 사용법](./DevTools/Git/Tag.md)
- [MacOS Settings](./DevTools/MacOS/MacOS%20Settings.md)
- [Obsidian Settings](./DevTools/Obsidian/Obsidian%20Settings.md)

</details>

---