# 개인 공부 메모장

---

# 📚 Langueges

### Java

- [CountDownLatch - Thread Blocking](./Languages/Java/CountDownLatch.md)

- [Concurrency - 1. Process & Thread Scheduling](./Languages/Java/Concurrency/1.%20Process%20&%20Thread%20Scheduling.md)
- [Concurrency - 2. Thread를 생성하는 다양한 방법](./Languages/Java/Concurrency/2.%20Create%20Thread.md)
- [Concurrency - 3. Thread 상속(Inheritance)](./Languages/Java/Concurrency/3.%20Thread%20Inheritance.md)
- [Concurrency - 4. Thread Coordination-Interrupt](./Languages/Java/Concurrency/4.%20Thread%20Interrupt.md)
- [Concurrency - 5. Daemon Thread](./Languages/Java/Concurrency/5.%20Deamon%20Thread.md)
- [Concurrency - 6. Thread.join()을 이용한 실행 순서 제어](./Languages/Java/Concurrency/6.%20Thread%20Join.md)
- [Concurrency - 7. 어플리케이션 성능의 정의](./Languages/Java/Concurrency/7.%20Optimization.md)
- [Concurrency - 8. Image Processing - 성능 최적화(지연시간)](./Languages/Java/Concurrency/8.%20Image%20Processing.md)
- [Concurrency - 9. 어플리케이션 처리량의 정의](./Languages/Java/Concurrency/9.%20Throughput%20Optimization.md)
- [Concurrency - 10. 처리량 최적화 & 성능 테스트(Apache Jmeter)](./Languages/Java/Concurrency/10.%20Throughput%20Optimization%20Test.md)
- [Concurrency - 11. Thread 간 리소스 공유 시 발생할 수 있는 문제](./Languages/Java/Concurrency/11.%20Sharing-Resource.md)
- [Concurrency - 12. Critical Section](./Languages/Java/Concurrency/12.%20Critical%20Section.md)
- [Concurrency - 13. Metrics Capturing을 통한 Atomic Operation 판단](./Languages/Java/Concurrency/13.%20Atomic%20Operation.md)
- [Concurrency - 14. Race Condition과 Data Rade](./Languages/Java/Concurrency/14.%20Race%20Condition%20&%20Data%20Race.md)
- [Concurrency - 15. Coarse-Grained & Fine-Grained Lock](./Languages/Java/Concurrency/15.%20Coarse-Grained%20&%20Fine-Grained%20Lock.md)

<br>

### Python

- [Python 개발 환경 세팅](./Languages/Python/개발환경세팅.md)
- [Server Health Check Script](./Languages/Python/Health-Check.md)

---

# 📚 Backend

### Spring

- [Reactive - Spring WebClient](./Backend/Spring/Reactive/WebClient/Spring%20WebClient.md)
- [Spring Cloud - Cloud Config Server/Client 구성](./Backend/Spring/Cloud/Cloud-Config/Spring%20Cloud%20Config.md)
- [Spring Cloud - API Gateway](./Backend/Spring/Cloud/Cloud-Gateway/Cloud-Gateway.md)
- [Util - Spring ehCache & DevTools](./Backend/Spring/Utils/Spring%20ehCache%20&%20DevTools.md)
- [Util - Jar 실행 옵션](./Backend/Spring/Deploy/Jar%20Start%20Option.md)
- [Util - Logback 설정](./Backend/Spring/Deploy/Logback.md)

<br>

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

# 📚 Frontend

### React

- [React 핵심 개념들](./Frontend/React/React.md)
- [React Markdown을 이용한 글쓰기 기능 개발](./Frontend/React/Markdown/Markdown.md)

---

# 📚 Database

### MariaDB

- [MariaDB 기본 명령어](./Database/MariaDB/기본%20명령어.md)
- [Table Range Partitioning](./Database/MariaDB/Range%20Partitioning.md)

<br>

### Redis

- [Redis 기본 사용법](./Database/Redis/Redis%20기본%20사용법.md)

---

# 📚 Server

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

# 📚 Tools

### Git

- [전체 Commit Author 변경 & Commit 되돌리기](./DevTools/Git/전체%20Commit%20Author%20변경%20&%20커밋%20되돌리기.md)
- [Git Tag 사용법](./DevTools/Git/Tag.md)

---

# 📚 Algorithm

- [알고리즘 기본 개념](./Algorithm/기본개념/알고리즘-기본개념.md)
- [Sort](Algorithm/Sort/Sort.md)
- [Dynamic Programming](./Algorithm/Dynamic%20Programming/Dynamic%20Programming.md)