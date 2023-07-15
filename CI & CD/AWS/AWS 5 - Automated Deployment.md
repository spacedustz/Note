## **💡 Automated Deployment**

<br>

### **배포 파이프라인을 구성하는 단계(stage)와 작업(actions)**

- Source단계 : 원격 저장소에 관리되고 있는 소스 코드에 변경이 생길 경우, 감지하고 다음 단계로 전달
- Build단계 : 소스단계에서 받은 코드 컴파일 빌드 테스트 -> 가공 -> 결과물 전달
- Deploy단계 : 전달받은 결과물을 실제 서비스에 반영
  \* 실제 단계와 과정은 상황에 따라 세분화 & 간소화

<br>

### **AWS Development Tool**

- CodeCommit
  - Source단계 구성 시 사용하며, 버전 관리 도구이다
  - 보안에 강점
  - FreeTier이상 사용시 과금
- CodeBuild
  - Build 단계 구성 시 사용하며, 유닛 테스트 & 컴파일 & 빌드 작업을 CLI를 통해 실행
- CodeDeploy
  - Deploy 단계 구성 시 사용하며, 실행중인 서버에 변경사항 적용 가능
  - S3 버킷을 통해 업로드된 static site에 변경 사항 반경
- CodePipeline
  - 파이프라인 구축 서비스
  - 1계정 2파이프라인 제한 (초과 시 과금)

------

## **💡 Install (Centos 7)**

<br>

### **AWS CLI**

- curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
- unzip awscliv2.zip
- ./aws/install
- aws --version

<br>

### **CodeDeploy Agent**

- yum -y update
- yum -y install gcc (C Compiler)
- gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
- curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -  -> import gpg key 
- curl -sSL [https://get.rvm.io](https://get.rvm.io/) | bash -s stable  -> rvm 설치 스크립트
- source /etc/profile.d/rvm.sh  -> 시스템 환경변수 & rvm 정보 업데이트
- rvm reload
- rvm requirements run  -> rvm 의존성 패키지 설치
- rvm list known
- rvm install [version]
- rvm list
- rvm use [version] --default
- ruby -v
- gem install aws-sdk   -> Ruby용 sdk 설치

<br>

Install Ruby

![img](https://blog.kakaocdn.net/dn/bEuGaO/btrSZ3QV8iO/Nq4BUpK7kbs7CjQEPdKZ3k/img.png)

- wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
- chmod +x install
- ./install auto > /tmp/logfile
- service codedeploy-agent status

<br>

Install CodeDeploy

![img](https://blog.kakaocdn.net/dn/OJmuM/btrSYnin8oI/VDzT2qDQA1NO4iEyzDMmk1/img.png) 

------

## **💡 IAM Role 설정**  

기존의 Role에 정책 4개 추가해서 연결

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd45.png)

<br>

신뢰 관계의 Service 수정

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd46.png)

------

## **💡 Client Build 설정**

- [Deploy - AppSpec](https://docs.aws.amazon.com/ko_kr/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html)
- [Build - BuildSpec](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html)
- 스크립트 작성 
  - init -> chmod build/**
  - clear -> rm -rf build
  - start -> nohup [start-server] > /dev/null
  - stop -> pkill -f 'java -jar'
- 프로젝트 Push

------

## **💡 Deploy**

- CodeDeploy Console -> Create Application
- Create Deploy Group -> IAM, Tag 등 지정하여 생성
- Pipeline 생성
- cd /opt/codedeploy-agent/deployment-root/deployment-logs -> 로그파일 위치

------

## **💡 AWS Parameter Store**

환경변수 전달

- AWS Parameter Store 파라미터 생성 
  - name - /prefix/name/key 순으로 작성
    - ex) /spring-boot-aws/skw/spring.datasource.url
  - 값 - 파라미터 속성에 따른 값
    - ex) jdbc:mysql://skw.c0nwl8c1futc.ap-northeast-2.rds.amazonaws.com/test?useSSL=false&chareaterEncoding=UTF-8&serverTimezone=UTC

<br>

### **build.gradle 내용 추가**

```yaml
dependencyManagement { // 블록 추가
	imports {
		mavenBom "org.springframework.cloud:spring-cloud-starter-parent:Hoxton.SR12"
	}
}
```

<br>

### **프로젝트 내 정적 폴더 내부에 bootstrap.yml 작성**

```yaml
aws:
  paramstore:
    enabled: true
    prefix: /spring-boot-aws
    name: skw # 리소스 이름을 작성합니다.
    profileSeparator: _
```