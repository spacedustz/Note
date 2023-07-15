## Docker Network

컨테이너 내부의 네트워크 인터페이스는 기본적으로 `eth0`과 `lo` 가 있다.

이 IP는 컨테이너 재시작 시 변경될 수 있고 내부망에서만 쓸 수 있는 IP이다.

<br>

그리고, 컨테이너 시작 시 마다 외부 연결을 위한 `veth` 네트워크가 호스트의 네트워크에  **컨테이너의 수 만큼 생긴다**.

또, 컨테이너의 외부망 연결을 위한 `docker0` 브릿지 네트워크도 존재한다.

<br>

`docker0` 브릿지는 각 `veth	` 인터페이스와 바인딩되어 호스트의 eth0과 연결을 해주는 역할을 한다.

즉, `컨테이너 eth0` -> `veth` -> `docker0` -> `로컬`의 경로로 외부 통신을 하는셈이다.

---

### 도커의 임베디드 네트워크 드라이버

- bridge
- host
- none
- cantainer
- overlay
- Third-Party (flannel, weave)

---

### 도커 네트워크 사용법

서브넷과 IP 대역이 일치해야 한다.

```shell
# 도커 네트워크 생성
docker network create \
--driver=bridge \
--subnet=172.72.0.0/16
--ip-range=172.72.0.0/24
--gateway=172.72.0.1
my-network

# 도커 네트워크 연결 해제
docker network disconnect my-network {container-name}

# 도커 네트워크 연결 성공
docker network connect my-network {container-name}

# 컨테이너에 커스텀 브릿지 네트워크 할당
docker run -it \
--name my-container \
--net my-network \
centos:latest
```

