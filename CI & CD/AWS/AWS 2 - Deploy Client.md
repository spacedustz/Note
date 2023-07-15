## **💡 클라이언트 배포**

<br>

**준비사항**

- 3 버킷 생성
- (로컬) npm install

<br>

**S3 버킷 생성**

- Public Access 차단 해제 & ACL비활성화 -> 생성

<br>

**npm 설치 (로컬환경)**

- 가지고있는 nvm스크립트 실행

<br>

NVM 설치 스크립트 받아서 설치

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd16.png)

<br>

nvm install -lts&nbsp; or&nbsp; nvm install 15&nbsp; -> nodejs 설치

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd17.png) 

<br>

npm install -> 의존성 모듈 설치

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd18.png) 

------

### **환경변수 설정**

- mv .env.example .env
- 인스턴스 ip + port 작성
- nvm run build

<br>

.env.example -> .env로 변경

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd19.png) 

<br>

.env 파일 내에 환경변수 설정

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd20.png) 

<br>

nvm run build 실행

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd21.png) 

<br>

빌드가 완료되면 build 디렉토리가 생긴다

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd22.png) 

------

### **S3 설정 변경**

- 정적 웹 사이트 호스팅 On
- 버킷에 파일 업로드
- Public Access 차단 해제
- 버킷 정책 생성 ARN = arn:aws:s3:::[Bucket_name]/* 후 생성된 json 형태의 정책 삽입

<br>

S3 Bucket 설정 - 정적 웹호스팅 설정에 index.html 추가

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd23.png) 

<br>

WSL을 사용 안하므로 SCP or SFTP를 이용하여 S3 Bucket에 Build 내의 파일들 업로드

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd24.png)

<br>

Bucket에 데이터 업로드 성공

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd25.png)

<br>

Bucket의 Public Access를 허용해주자

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd26.png) 

<br>

Bucket 정책 생성 ARN = arn:aws:s3:::[Bucket_name]/* 후 생성된 json 형태의 정책 삽입

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd27.png)

<br>

Bucket의 정적 웹사이트 접속

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd28.png)