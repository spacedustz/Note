## EC2 <-> LoadBalancer 연동

Application LoadBalancer를 EC2와 연동합니다.

HTTPS를 적용하기 전 HTTP로 먼저 테스트하기 위해 생성합니다.

HTTPS는 프로덕트를 본격적으로 이전할때 인증서와 함꼐 적용해보겠습니다.

HTTPS Redirect 방법은 나중에 글 올릴게염

<br>

일단 로드밸런싱 알고리즘을 Default인 Round Robin 방식으로 쓰다가 추후 요구사항 변경시, 

LOR 알고리즘이나 커스텀한 알고리즘으로 변경할 수 있는지도 알아봐야 합니다.
<br>

### Target Group 생성

Target Group의 Routing Algorithm은 기본적으로 Round Robin 방식입니다.

- Instance 타입 -> 내 EC2 인스턴스 할당
- HTTP: 8080 으로 지정


### LoadBanancer용 보안그룹 생성

**인바운드**
- 8080 - 0.0.0.0
- 8080 - EC2 보안그룹
- 443 - 0.0.0.0
<br>

**아웃바운드**
- All - 0.0.0.0

<br>

### EC2 보안그룹에 LoadBalancer 보안그룹 추가

- 8080 - LoadBalancer 보안그룹
- 22 - EC2 자기 자신 IP

<br>

### LoadBalancer 생성

- Application LoadBalancer 선택
- `scheme`: Interner-facing 선택
- `IP address type` : IPv4
- `VPC` : EC2의 VPC와 동일한 VPC 선택
- `Mappings` : 4개의 AZ 모두 선택
- `Security Group` : 위에서 만든 로드밸런서용 보안그룹 할당
- `Listener` : HTTPS 적용 전 테스트 용도이므로 임시로 HTTP : 8080 할당
- 생성

<br>

### 연결 확인

Jenkins CICD로 돌아가는 Spring Boot 컨테이너의 포트는 8080입니다.

EC2-IP:8080이 아닌 로드밸런서의 DNS name:8080 으로 접속이 되면 성공이며 로드밸런서 모니터링 지표에 요청이 잡힙니다.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb40.png)
