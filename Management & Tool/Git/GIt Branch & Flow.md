## **💡 Git Branch**  

**Branching이란?**

새로운 기능 개발 시, 기존 메인 코드를 건드리지 않고 적용할 수 있는 버전 관리 기법

<br>

### **Git Branch**

- 브랜치 생성
  - git checkout -b [branch_name] [상위 branch]
  - or
  - git switch -c sub
- 브랜치 스위치
  - git switch [branch_name] & git checkout [branch_name]
- 브랜치 병합
  - 로컬에서의 merge 
    - 필요에 따른 여러번의 git commit 후
    - git switch main
    - git merge sub
  - Pull Request를 통한 merge
    - sub 브랜치에서 작업 후 push
    - merge
- 브랜치 삭제
  - git branch -d [branch_name]
  - git branch -D [branch_name] (merge 되지 않은 브랜치 삭제)
- 브랜치 이동
  - git checkout [branch_name]
  - git checkout -f [branch_name]  <- Local의 변경사항을 전부 버리고 이동

<br>

### **기타 git 명령어**

- **유저 정보 설정**
  - git config --global user.name
  - git config --global user.email
- **초기화**
  - git init
- **스테이징 & 커밋**
  - git status
  - git add [file]
  - git reset [file]
  - git diff
  - git diff --staged
  - git commit -m " "
- **비교 & 검사**
  - git log branch2**..**branch1
    - branch 2에 없는 branch 1의 모든 커밋 히스토리 표시
  - git log --follow [file]
    - 해당 파일의 모든 변경사항 커밋 표시
  - git diff branch2**...**branch1
    - branch 1에는 있고 branch 2에 없는것의 변경내용 표시
- **공유 & 업데이트**
  - git remote add [alias] [url]
    - 특정 repo 별칭 지정해서 추가
  - git fetch [alias]
    - 해당 별칭의 repo의 모든 브랜치 & 데이터 클론
  - git merge [alias]/[branch]
    - remote를 현재 작업중인 브랜치와 병합
  - git push [alias] [branch]
    - 로컬의 커밋을 remote로 전송
- **임시 저장**
  - git stash
    - 수정 & 스테이지된 사항을 스택에 임시저장 후 현재 작업 내역에서 지움
  - git stash list
    - 임시 저장 목록 표시
  - git stash apply
    - 임시저장 -> 현재 작업 복귀
  - git stath pop
    - 임시저장 -> 현재 작업 복귀 후 스택에서 삭제
  - git stash drop
    - 스택에 저장된 임시 삭제

---

## **💡 Git Flow**  

Git Brancing 전략 중 가장 많이 사용하는 전략이며,
대규모 개발 프로젝트를 제작하여 하나의 소프트웨어 버전을 명확히 나누고
다양한 버전을 배포해야 하는 개발 환경에 적합함

<br>

- 개발 현장의 상황에 맞는 Git Flow 선택
- Github Flow, Gitlab Flow 등이 있음
- Git Flow를 단순화한 Coz' Git Flow로 연습 권장

<br>

### **Coz' Git Flow - Coz' Git Flow는 중요 브랜치인 main,dev 브랜치가 있다.**

- main Branch
  - 언제든 상용화 할 수 있는 브랜치
  - 완성된 기능
  - 웹에서의 공개적인 통신 가능
  - 최소한의 보안 충족
- dev Branch
  - 개발중인 브랜치
  - 개발에 참여한 모든 인원의 결과를 합쳐서 확인 할 수 있을 정도로 준비가 된 상태여야 함
  - 팀원의 코드리뷰를 받고 진행하는것이 정석
- feature Branch
  - 보조 브랜치
  - 기능 개발, 리팩토링, 문서, 단순 오류 수정 등 다영한 작업 기록을 위한 브랜치