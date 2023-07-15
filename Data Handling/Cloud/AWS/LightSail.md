## 💡 AWS LightSail

아마존 Lightsail은 AWS에서 만든 **가상 프라이빗 서버 (VPS)** 이다.

- 가상머신(compute)
- SSD기반 스토리지
- Networking
- 로드밸런서
- DNS관리
- 고정IP
- OS
- 개발플랫폼(MEAN, Node.js 등)
- 어플리케이션(Wordpress, Nginx, GitLab, Redmine 등) 등 

모두 포함하고 있어 **웹서비스를 빠르고 쉽게 구축**하는데 특화되어 있는 서비스 이다.

그리고 무엇보다 EC2, RDB 등 개별 서비스를 따로 설정해서 사용하는 것보다 이 Lightsail 하나의 서비스로 웹서버를 운용하는데 **매우 저렴**하다.

<br>

**VPS(Virtual private server) 란?**
하나의 물리 서버를 여러 개의 가상 서버로 쪼개어 사용하는 것을 의미 한다.
그렇게 쪼개어진 가상 서버를 여러 명의 클라이언트가 나누어 쓰는 구조이다.
따라서 하나의 물리서버를 다른 이들과 공유하는 개념이기는 하지만 각자 독립적인 서버 공간을 가지는 것이 가능하다.
다만, 하나의 물리서버에서 컴퓨팅 리소스들을 모든 사용자와 공유하기 때문에 만약 한 사용자가 너무 많은 리소스를 점유할 경우 RAM, CPU 등에 큰 영향이 간다는 단점이 존재한다.

<br>

그리고 규모가 커진다면 확장도 쉽게 할 수 있고, Lightsail에서 만들고 설정한 Instance를 Snapshot을 통해 EC2로 쉽게 마이그레이션 할 수 있도록 되어 있다.

---

### Lightsail의 서비스 제한 목록

- 계정당 최대 20개의 인스턴스 유지
- 5개의 고정 IP (EIP)
- 총 3개의 DNS 존
- 총합 20TB의 블록스토리지(디스크) 연결
- 5개의 로드 밸런서
- 최대 20개 인증서

---

## LightSail 구축

[LightSail 링크](https://signin.aws.amazon.com/signin?redirect_uri=https%3A%2F%2Flightsail.aws.amazon.com%2Fls%2Fwebapp%2Fhome%2Finstances%3Fstate%3DhashArgs%2523%26isauthcode%3Dtrue&client_id=arn%3Aaws%3Aiam%3A%3A015428540659%3Auser%2Fparksidewebapp&forceMobileApp=0&code_challenge=69Yi6pRImKi4Wu0Yw0lHhKeqQurohxpj-nUYTvvl8QI&code_challenge_method=SHA-256)

- **인스턴스** :본인이 지금 가지고 있는 컴퓨팅 목록 (EC2)
- **데이터베이스** : 데이터베이스 서비스 (RDB). 가격은 15$ 첫 달 무료부터 115$까지 다양하다.
- **네트워킹** : 고정 아이피, DNS 영역 생성 , 그리고 로드 밸런서 생성을 관리한다.
  - 고정 IP : 인스턴스에서 신규로 만들면 1회용 (재시작 시 다른 아이피 부여) 아이피를 부여받는다 그걸 고정 아이피로 잡아준다.
  - DNS 영역 생성 : 도메인, 서브도메인을 관리할 수 있다. [무료, Route 53 연결 가능]
  - 로드밸런서 : 만약 A,B서버가 있는데, 만약, A가 과부하가 되고 B는 여유롭면 B의 자원을 끌어다 쓸수록 할 수 있다
- **스토리지** : 인스턴스에 용량이 부족한 경우 블록 단위로 추가 용량을 끌어다 사용 가능하다.
- **스냅샷** : 인스턴스를 통째로 백업이 가능하다. 자동으로 백업이 가능하게 스케쥴러를 설정할 수도 있다.

<br>

### 인스턴스 생성

- 리전 선택
- 플랫폼 / 블루프린트 선택
- SSH Pem Key 생성 / 등록
- 플랜 선택 / 인스턴스 생성

---

### 고정 IP & 방화벽 규칙 추가

- 인스턴스 -> ... -> 관리 -> 네트워킹 -> 고정 IP 생성
- 방화벽 포트 추가

---

### 도메인 연결

Route 53이 아닌 LightSail로만 DNS를 등록하는 방법

- 홈 -> 네트워킹 -> DNS 영역 생성
- 구입한 도메인 입력 후 생성
- 네임서버 복사해둠
- 생성한 DNS -> 관리 메뉴