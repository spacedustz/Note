## **💡 AWS 환경이 아닐경우 & AWS 환경일 경우**

<br>

**AWS 환경이 아닐 경우**

- jdk11.tar.gz 다운
- tar xvfz openjdk-11+28_linux-x64_bin.tar.gz
- vi /etc/profile (환경변수 잡아주기)
- source /etc/profile

```bash
# java
export JAVA_HOME=/JAVA 설치경로/jdk-11
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar
```

<br>

**AWS CLI 환경일 경우**

- curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip["](https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip") -o "awscliv2.zip"
- unzip awscliv2.zip
- sudo ./aws/install

------

## **💡 AWS**

<br>

### **IAM Role 생성**

- AmazonS3FullAccess
- AmazonEC2RoleforAWSCodeDeploy
- AWSCodeDeployRole
- AmazonSSMFullAccess
- AmazonEC2FullAccess

<br>

추가한 정책 목록

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd.png)

<br>

신뢰정책에 내 리전의 codedeploy 서비스 추가

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd2.png)

<br>EC2에 IAM Role 연결

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd3.png)

------

### **보안그룹 포트 오픈**

- 3306 - DB Connection Endpoint
- 8080 - Spring Boot Endpoint
- 22 - SSH Endpoint
- 6379 - RDS Endpoint
- 5000 - Docker Private Registry Endpoint

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd4.png)

------

### **EC2 인스턴스 생성 (Elastic IP 설정)**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd5.png)

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

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd6.png) 

<br>

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

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd7.png) 

<br>

#### **Docker & Docker Compose 설치**

- yum -y install docker
- systemctl start docker && systemctl enable docker && systemctl status docker
- usermod -aG docker ec2-user

<br>

Docker 설치

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd8.png)

- curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
- chmod +x /usr/local/bin/docker-compose
- docker-compose up -d --build (Dockerfile이 작성된 상태인 경우)

<br>

Docker-compose 설치

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd9.png)

<br>

#### **DB 컨테이너 생성**

- docker run -d -p 3306:3306 --name maindb -e MYSQL_DATABASE=mainproject -e MYSQL_ROOT_PASSWORD=password mysql:latest
- docker ps

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd10.png)

<br>

#### **Dockerfile 작성 (로컬환경)**

- Dockerfile 작성
- docker build --tag={dockerhub-accounts}/main:1.0.0 --force-rm=true .
- docker push {dockerhub-accounts}/main:1.0.0-beta (Docker Hub에 Push)

<br>

Dockerfile

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd11.png)

- AWS 환경으로 돌아와서
- docker pull {dockerhub-accounts}/main:1.0.0-beta
- docker run -d -p 8080:8080 -t {dockerhub-accounts}/main:1.0.0-beta

------

### **AWS CodeDeploy & CodePipeline 설정**

<br>

### **CodeDeploy**

인스턴스 내에 CodeDeploy-Agent 설치가 되어있어야함

- 어플리케이션 - 생성 - 배포그룹 생성
- IAM & Instance Tag 지정, LoadBalancer 비활성화

<br>

### **CodePipeline**

- 파이프라인 생성 - 소스공급자(Github version 2)
- Github 연결

------

## **💡 Github SSH Key 등록**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd12.png) 

------

## **💡 appspec.yml & buildspec.yml 작성**

```yaml
# appspec.yml

version: 0.0
os: linux

files:
  - source: /
    destination: /root/build

hooks:
  BeforeInstall:
    - location: server_clear.sh
      timeout: 3000
      runas: root
  AfterInstall:
    - location: initialize.sh
      timeout: 3000
      runas: 3000
  ApplicationStart:
    - location: server_start.sh
      timeout: 3000
      runas: root
  ApplicationStop:
    - location: server_stop.sh
      timeout: 3000
      runas: root
```

<br>

```yaml
# buildspec.yml

version: 0.2

phases:
  install:
    runtime-versions:
      java: corretto11
  build:
    commands:
      - echo Build Starting on `date`
      - cd server
      - chmod +x ./gradlew
      - ./gradlew build
  post_build:
    commands:
      - echo $(basename ./server/build/libs/*.jar)
artifacts:
  files:
    - server/build/libs/*.jar
    - server/scripts/**
    - server/appspec.yml
  discard-paths: yes
```

<br>

```bash
#!/usr/bin/env bash
chmod +x /home/ubuntu/build/**

#!/usr/bin/env bash
rm -rf /home/ubuntu/build

#!/usr/bin/env bash
cd /home/ubuntu/build
sudo nohup java -jar DeployServer-0.0.1-SNAPSHOT.jar > /dev/null 2> /dev/null < /dev/null &

#!/usr/bin/env bash
sudo pkill -f 'java -jar'
```

<br>

script 파일들

![img](https://blog.kakaocdn.net/dn/m6WbO/btrWH197UiH/4AHkUprKYTlrD2QO113hM1/img.png) 

------

## **💡 git clone or sftp를 이용한 서버 배포 & 실행**

<br>

./gradlew :base-api:clean :base-api:bootJar

서버 실행

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd13.png)

------

## **💡 서버 실행 Shell Script 작성**

```bash
#!/bin/bash

# EC2 내 Spring Boot 실행 스크립트

# 서버가 실행중이면 프로세스 종료
ps -ef | grep "main_11-0.0.1-SNAPSHOT.jar" | grep -v grep | awk '{print $2}' | xargs kill -9 2> /dev/null

# 종료 이력 파악 후 적절한 문구 출력
if [ $? -eq 0 ];then
    echo "Successfully Stopped"
else
    echo "Application is Not Running"
fi

# 어플리케이션 재 실행
echo "Application Restarted!"
echo $1

# 어플리케이션 백그라운드 실행
nohup java -jar /root/main/server/build/libs/main_11-0.0.1-SNAPSHOT.jar > /dev/null 2>&1 &
```

------

## **💡 수동 실행 -> 스크립트를 이용한 자동 서버 실행 (Optional)**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd14.png)

<br>

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd15.png)