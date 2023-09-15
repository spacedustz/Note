## CloudFront + Application LoadBalancer

### ALB 전용 보안그룹 생성

Application LoadBalancer용 보안그룹을 먼저 만듭니다.

HTTPS 프로토콜의 포트인 443을 모든 소스에 열어줍니다.

<br>

### EC2 보안그룹 포트 오픈

EC2의 보안그룹에는 HTTP 포트인 80을 열고 소스에 ALB의 보안그룹을 넣어줍니다.

그리고 SSH 포트를 열고 소스는 내 IP를 선택합니다.

<br>

### NAT Gateway 생성

NAT Gateway 생성 화면의 서브넷 항목에 EC2의 서브넷 그룹을 넣어주고 Public을 선택합니다.

그 후 밑에 탄력적 IP 할당을 눌러 NAT Gateway를 생성합니다.

그리고 Private Subnet의 라우팅 테이블에 NAT Gateway를 설정합니다.

ex: `대상: 0.0.0.0 , 대상2: nat-<hash>`

<br>

### ALB 생성

Application LoadBalancer로 선택하고 이름은 임의로 지어줍니다.

`계획` 부분에서 인터넷 연결 선택, `IP 주소 유형` 에는 IPv4를 선택해줍니다.

`네트워크 매핑` 부분에 `VPC` 는 EC2와 같은 VPC를 선택해주고 아래 매핑 부분에 4개의 서브넷을 전부 체크해줍니다.

