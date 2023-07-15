## **💡 Github Actions**

<br>

### **동작 과정**

- Github Repository 변화 감지 (push 트리거 등)
- Github Actions 작동
- Github Actions에서 빌드 결과물 생성
- S3로 전송 & 저장
- Github Actions에서 AWS CodeDeploy에 배포 명령
- CodeDeploy가 EC2에 Deploy & Run

------

## **💡 배포**  

준비사항

1. Github Actions 생성
2. S3 버킷 & 정적 웹 호스팅 비활성화 & Public Access 차단 해제
3. AWS Code Deploy
4. EC2 생성

<br>

### **Github Actions 생성 & 설정**

- java with gradle -> start commit
- repo -> settings - secrets/actions -> new repository secret
- AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY 등록

<br>

키 추가 완료

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions.png) 

------

### **gradle.yml 수정** 

- Build with Gradle 부분을 설정하여 직접 빌드 방식으로 빌드 진행

```yaml
name: Java CI with Gradle

on:
  push:
    branches: [ "main" ]

permissions:
  contents: read
  
env:
  S3_BUCKET_NAME: deploy011-bucket-replicaset

jobs:
  build:

    runs-on: centos

    steps:
    - uses: actions/checkout@v3
    - name: Set up JDK 11
      uses: actions/setup-java@v3
      with:
        java-version: '11'
        distribution: 'temurin'
    - name: Build with Gradle
      run: ./gradlew build
  
   # - name: Build with Gradle
   #   uses: gradle/gradle-build-action@67421db6bd0bf253fb4bd25b31ebb98943c375e1
   #   with:
   #     arguments: build
    
    # build한 후 프로젝트를 압축합니다.
    - name: Make zip file
      run: zip -r ./main.zip .
      shell: bash
    
    # Access Key와 Secret Access Key를 통해 권한을 확인합니다.
    # 아래 코드에 Access Key와 Secret Key를 직접 작성하지 않습니다.
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY }} # 등록한 Github Secret이 자동으로 불려옵니다.
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }} # 등록한 Github Secret이 자동으로 불려옵니다.
        aws-region: ap-northeast-2
    
    # 압축한 프로젝트를 S3로 전송합니다.
    - name: Upload to S3
      run: aws s3 cp --region ap-northeast-2 ./main.zip s3://$S3_BUCKET_NAME/main.zip
```

<br>

CI 성공

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions2.png)

<br>

S3로 빌드 결과물 자동 전송 완료

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions3.png)

------

### **AWS CodeDeploy & 배포그룹 생성**

CodeDeploy (인스턴스 내에 CodeDeploy-Agent 설치가 되어있어야함)

- 어플리케이션 - 생성 - 배포그룹 생성
- IAM & Instance Tag 지정, LoadBalancer 비활성화

<br>

어플리케이션 & 배포그룹 생성

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions4.png)

------

### **gradle.yml & appspec.yml & deploy.sh 작성**

```bash
    # gradle.yml에 추가
    # CodeDeploy에게 배포 명령을 내립니다.
    - name: Code Deploy
      run: >
        aws deploy create-deployment --application-name main
        --deployment-config-name CodeDeployDefault.AllAtOnce
        --deployment-group-name main-group
        --s3-location bucket=$S3_BUCKET_NAME,bundleType=zip,key=main.zip
```

<br>

```yaml
# appspec.yml

version: 0.0
os: linux
files:
  - source:  /
    destination: /root
    overwrite: yes

permissions:
  - object: /
    pattern: "**"
    owner: root
    group: root

hooks:
  ApplicationStart:
    - location: scripts/deploy.sh
      timeout: 60
      runas: root
```

<br>

```bash
#!/bin/bash

# deploy.sh

BUILD_JAR=$(ls /root/main/build/libs/main1-0.0.1-SNAPSHOT.jar)
JAR_NAME=$(basename $BUILD_JAR)

echo "> 현재 시간: $(date)" >> /root/main/deploy.log

echo "> build 파일명: $JAR_NAME" >> /root/main/deploy.log

echo "> build 파일 복사" >> /root/main/deploy.log
DEPLOY_PATH=/root/seb41_main_011
cp $BUILD_JAR $DEPLOY_PATH

echo "> 현재 실행중인 애플리케이션 pid 확인" >> /root/main/deploy.log
CURRENT_PID=$(pgrep -f $JAR_NAME)

if [ -z $CURRENT_PID ]
then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다." >> /root/main/deploy.log
else
  echo "> kill -9 $CURRENT_PID" >> /root/main/deploy.log
  sudo kill -9 $CURRENT_PID
  sleep 5
fi


DEPLOY_JAR=$DEPLOY_PATH$JAR_NAME
echo "> DEPLOY_JAR 배포"    >> /root/main/deploy.log
sudo nohup java -jar $DEPLOY_JAR >> /root/main/deploy.log 2>/root/main/deploy_err.log &
```

------

### **EC2 인스턴스 생성 (Elastic IP 설정)**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions5.png)

------

### **보안그룹 포트 오픈**

- 3306 - DB Connection Endpoint
- 3000 - React Connection Endpoint 1
- 3001 - React Connection Endpoint 2
- 8080 - Spring Boot Endpoint
- 22 - SSH Endpoint
- 6379 - RDS Endpoint
- 5000 - Docker Private Registry Endpoint

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions6.png)

------

### **Github SSH Key 등록**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions7.png) 

------

### **EC2 내부 패키지 설치**

<br>

#### **JDK 설치**

- amazon-linux-extra install -y openjdk11

 <br>

#### **GIT 설치**

- yum -y install git

 <br>

#### **AWS CLI 설치**

- curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip["](https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip") -o "awscliv2.zip"
- unzip awscliv2.zip
- sudo ./aws/install

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions8.png) 

------

#### **CodeDeploy Agent 설치**

- yum -y update
- yum -y install gcc (C Compiler)
- gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
- curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -  -> import gpg key 
- curl -sSL [https://get.rvm.io](https://get.rvm.io/) | bash -s stable (rvm 설치 스크립트)
- source /etc/profile.d/rvm.sh (시스템 환경변수 & rvm 정보 업데이트)
- rvm reload
- rvm requirements run (rvm 의존성 패키지 설치)
- rvm list known
- rvm install [version] (2.7)
- rvm list
- rvm use [version] --default
- ruby -v
- gem install aws-sdk (Ruby용 sdk 설치)
- wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
- chmod +x install
- ./install auto > /tmp/logfile
- service codedeploy-agent status

<br>

Code Deploy Agent 설치

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions9.png) 

------

### **IAM Role 생성**

- AmazonS3FullAccess
- AmazonEC2RoleforAWSCodeDeploy
- AWSCodeDeployRole
- AmazonSSMFullAccess
- AmazonEC2FullAccess
- IAM Role 과 IAM UserGroup의 태그 연결하기

<br>

추가한 정책 목록

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions10.png)

<br>

신뢰정책에 내 리전의 codedeploy 서비스 추가

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions11.png)

<br>

EC2에 IAM Role 연결

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/actions12.png)