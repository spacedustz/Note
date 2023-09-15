## **💡 RDS 생성**

### **RDS Console**

RDS 콘솔 - DB 생성

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd29.png)

<br>

Free Tier 선택

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd30.png)

<br>

계정 설정

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd31.png)

<br>

인스턴스 타입 t2.micro로 설정

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd32.png)

<br>

Public Access 허용

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd33.png)

<br>

보안그룹 Default, 포트 = 임의설정

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd34.png)

<br>

초기 DB 네임 설정 - DB 생성

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd35.png) 

------

## **💡 RDS 연결**

RDS 연결 시,
DB인스턴스의 ID,PW & 포트 & 엔드포인트 주소가 필요함

<br>

### **연결**

RDS콘솔 - DB인스턴스의 엔드포인트 주소 확인

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd36.png)

<br>

로컬 서버의 방화벽 13306 포트 오픈

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd37.png)

- 로컬 서버 -> mysql -u [Master_Name] --host [Endpoint] -P [Port] -p
- 접속이 안될 시, RDS 인스턴스의 보안그룹 인바운드 포트 오픈 

<br>

DB 접속

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd38.png) 

------

## **💡 Main 서버 설정**

application.properties 수정

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd39.png)

<br>

### **application.properties 수정 후**

- ./gradlew clean && ./gradlew build 실행
- 서버 실행
- S3 Bucket Endpoint 접속

<br>

RDS DB 연결 성공

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd40.png)