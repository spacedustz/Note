## **💡** Proxy

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/os_proxy.png) 

<br>

### **Forward Proxy**

- 클라이언트와 가까이 있는 서버로 클라이언트를 대신해 서버에 요청 전달
- 주로 캐시서버로 사용
- 클라이언트의 정보 숨김

<br>

### **Reverse Proxy**

- 서버를 대신해서 응답을 클라이언트로 전달
- 트래픽 로드밸런싱
- 서버 정보 숨김

------

## **💡 Load Balancer**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/os_loadbalancer.png)

- Scale-Up
  - 서버의 하드웨어 성능을 높이는 방법
- Scale-Out
  - 서버의 개수를 늘려 부하분산

<br>

### **로드밸런서의 종류**

- L2 - Mac 주소 기반 로드밸런싱
- L3 - IP 주소 기반 로드밸런싱
- L4 - IP & Port기반 로드밸런싱
- L7 - 클라이언트 요청 기반 로드밸런싱

------

## **💡** **AWS Auto Scaling**

<br>

### **장점**

- 동적 스케일링
  - 사용자의 요구에 따라 리소스의 동적 스케일링
- 로드 밸런싱
  - 오토스케일링된 서버에 동적인 부하 분산
- 타겟 트래킹
  - 특정 타겟을 지정하여 오토스케일링 관리를 할 수 있으며 인스턴스의 수 조정 가능
- 헬스체크
  - EC2 인스턴스에 문제가 생기면 자동으로 새 인스턴스로 교체

<br>

### **Scaling 유형**

- 인스턴스 레벨 유지
  - 필요한 인스턴스의 개수 지정 후 개수에 맞게 오토스케일링
- 수동 스케일링
  - 기존 그룹의 크기 수동 조정, 비효율적
- 일정별 스케일링
  - 특정일의 트래픽 증가에 따른 일정별 스케일링 주기 설정
- 동적 스케일링
  - 트래픽에 동적으로 대응하여 스케일링 그룹의 크기 조정

------

## **💡 WAS (Web Application Server)**

<br>

### **Tomcat - Open Source**

- Apache에서 개발, 서블릿 컨테이너만 존재하는 웹 어플리케이션 서버
- 자바 서블릿 컨테이너의 공식 구현체
- 독립적 실행, 다른 웹서버와 호환성 좋음
- Spring Boot에 기본으로 내장되어있음

<br>

### **Jetty - Open Source**

- 이클립스 재단 개발, HTTP 서버 & 자바 서블릿 컨테이너이다
- 타 WAS에 비해 가볍고 빠르며, 어플리케이션에 탑재 가능
- 소형 장비 & 프로그램에 적합

<br>

### **Nginx - Open Source / [Download](https://nginx.org/en/download.html)**

- 서블릿 컨테이너나 웹 어플리케이션 서버가 아닌 **웹 서버**
- 대규모 트래픽 핸들링이 가능한 고성능 웹서버
- 비동기 이벤트 기반 고성능 & 동시성
- 높은 효율의 로드밸런싱
- 리버스 프록시로 사용 가능
- 클라이언트 - 서버 사이에서 무중단 배포

<br>

🎃 Nginx Proxy 설정 - **nginx.conf**

```yaml
server {
      listen       80; # (Mac OS) 8080 포트에서 80번 포트로 변경합니다.
...
      location / {
            ...
            proxy_pass http://localhost:8080; # 요청을 8080 포트로 넘깁니다.
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
      }
}
```

<br>

🎃 Nginx Load Balancer 설정 - [Nginx Load Balancing Docs](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/)

- 사전에 스프링부트 서버 2대 실행

```yaml
http {
   upstream backend {
      server localhost:18080;
      server localhost:18081;
   }
   location / {
      proxy_pass http://backend;
   }
}
```

------

## **💡 VPC (Virtual Private Cloud)**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/os_vpc.png)

VPC는 클라우드 내 Private한 공간을 제공함으로써,
Public & Private 클라우드를 논리적으로 분리할 수 있다 = 서브넷 분리

<br>

### **VPC 가용영역**

- VPC 생성
- VPC Subnet은 리전별로 네트워크 분리하여 사용
- 첫 생성한 VPC의 Subnet prefix보다 높은 값을 줄 수 없음 ex) /16 - > /14 = X

<br>

### **CIDR**

- 도메인간 라우팅 기법
- /16 /18 /20 /24 /28 로 네트워크 블록을 표시
- 기존의 정해진 Network Address & Host Address를 사용 할 필요가 없어짐

<br>

### **Subnet**

- 네트워크 분리
- Public Subnet - > 공용망
- Private Subnet - > 내부망
- VPN Only - > IDC - 기업

<br>

### **Routing Table**

- 패킷의 전송경로 & 목적지 정보
- 지점간 시작 & 끝 지점
- 모든 네트워크는 무조건 하나 이상의 라우팅 테이블을 가져야함