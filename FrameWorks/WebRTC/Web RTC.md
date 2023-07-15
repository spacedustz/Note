## **💡 Web RTC**  

**Web Real-Time Communication 이란?**

<br>

별도의 플러그인 설치 없이 실시간으로 미디어(Audio, Video, File, Text 등) 를
서버를 거치지 않고 Peer To Peer 전송을 가능하게 해주는 오픈소스 웹 기술

WebRTC의 구현 방식은 Mesh, SFU, MCU 방식이 있으며 하기 내용은 Mesh 방식으로 진행

<br>

### **구조**

- **Signaling Server**
  - Peer 끼리 연결을 위한 SessionControl Messages, Error Messages, Codec, bandwith 등
    다양한 정보를 SDP 프로토콜을 이용하여 전달하는 **Signaling** 프로세스를 처리하는 서버
  - Client와 Signaling은 양방향 **WebSocket 통신**을 사용함
- **Stun Server (Session Traversal Utilities for NAT)**
  - 위의 Peer - Peer 간 통신은 Signaling Server로 가능하고, 공인IP를 알려주는 Stun Server가 필요하다
  - Stun Server는 수 많은 오픈소스가 있으므로 직접 구현을 하는것보다 가져와서 쓰는게 효율적
  - 단순히 IP만 알려주는 용도의 서버기 때문에 무료 Stun Server 적극 추천
- **Turn Server (Traversal Using Relays Around NAT)**
  - Peer 중 방화벽 & 내부망을 사용하는 Symetric NAT 환경이라면,
    Symetric NAT 제한을 우회할 수 있게 해주는 역할을 함
  - Peer 간 통신 채널 중계를 하며, **WebRTC**의 가장 큰 특징중 하나인 **Peer To Peer 방식**을 벗어남
  - 즉, Local, Public 둘 다 연결을 못할경우 Turn 서버를 사용하며,
    왠만해선 위의 경우는 없으므로 통상 사용을 안함
  - COTURN 오픈소스를 활용해 Turn Server 구축 추천
- **Media Server**
  - Mesh 방식
    - Media Server가 필요없지만 Peer 수가 늘어나면 Client Side의 과부하 급격하게 증가
    - 1:1 연결 & 소규모 연결에 적합
    - Signaling만 필요하므로 서버의 부하가 적고, Peer 간 직접 연결로 인한 실시간성 보장
  - MCU & SFU 방식 공통
    - 각각의 Peer는 Media Server에게 미디어 스트림을 보내고 Media Server는 트래픽을 관리하여
      각각의 Peer 에게 재 배포해주는 MultiMedia MiddleWare이다 
  - MCU (Multi-Point Control Unit) 방식
    - Server - Client 간 Peer 연결, 높은 컴퓨팅 파워 요구됨
    - Peer To Peer 방식 X , Media Server에서 혼합 & 가공처리를 하여 수신측으로 전달
    - 실시간성 ↓ , 구현의 어려움
  - SFU (Selective Forwarding Unit) 방식
    - 각각의 Peer 간 미디어 트래픽을 중계하는 Media Server 사용, Peer To Peer X
    - 1:N & 소규모 N:M에 적합, 실시간성 보장
    - Mesh 방식에 비해 느리고 서버의 부하 증가