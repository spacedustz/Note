## **💡 Git Project + 칸반보드**

**칸반보드의 장점**

- 진행중인 업무의 시각화
- WIP 제한을 통한 효율적인 작업 처리
- 업무 흐름 관리
- 진행중인 업무 제한
- 팀 정책 설정 (WIP제한, 티켓 생성권한, 소통원칙 등)

<br>

### **Github Repository의 필수 파일**

- README.md
  - 프로젝트명, 핵심기능 및 소개, 팀원 소개
- **.**gitignore
  - Git의 관리대상에서 벗어남, 개인의 Secret Token이나, 공유가 불필요한 설정파일 등을 파일에 명시
- LICENSE
  - Public인 코드에 라이센스를 명확하게 표기해야함

<br>

### **프로젝트 관리에 활용가능한 Github 기능**

- Issue
  - 프로젝트에 새 기능 제안 & 버그 리포트 등 프로젝트에서의 이슈를 의미하며, 칸반 티켓처럼 사용
  - 아이디어 공유 & 피드백 & 태스트 & 버그 관리 용도로 사용
  - ex)
    - 제목 & 본문 작성
    - Assigness : 태스크를 맡을 인원 지정
    - Labels : 라벨 지정
    - Projects : 프로젝트 지정
    - Milestone : Milestone 지정
  - Issue Temlate Card (이슈 Form 생성)
    - Repo Settings 하단 Features - Issues - Set up Templates
- Milestone
  - 이정표 역할, 태스크 카드(Issue)를 그룹화하는데 사용함
  - 연결된 카드가 종료되면 Milestone 마다 업데이트된 진행 상황 확인 가능
  - 이 기능을 통해 이슈의 추적 & 진행상황을 한눈에 파악 가능
  - ex)
    - Repo - Issue - Milestione - Create
    - title : Milestone의 이름
    - Due date : Milestone의 마지막 날
    - 계획에 알맞은 개수만큼 Milestone과 Task를 만들어서 관리
- Pull Request
  - 내가 작업한 내용을 main branch에 merge 할 수 있는지 확인하는 작업
  - PR에서 커밋한 코드에 리뷰를 달 수있는 기능도 포함
  - 코드 리뷰 가능
- Project
  - 이 기능을 활용하여 칸반 보드 생성 & 칸반으로 업무의 흐름 관리
  - 작업 계획 & 트래킹에 적합
  - ex)
    - Repo - Project - Add Project
    - Table & Board 선택 후 Create
    - 생성 후, Settings - Project Name 설정
    - 좌측 Manage Access 권한 설정 & 팀원 초대
    - Issue & PR 연결 (기존 생성된 item 모두 추가)
    - 각 이슈의 상태 & 그룹 설정 가능