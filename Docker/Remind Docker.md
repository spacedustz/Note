## **💡 Docker**

<br>

| 준비1. 집 PC에 설치되있던 vmware kubernetes cluster 삭제(vmware의 서버 시스템 파일/마운트 깨짐,네트워크 지멋대로 오류) |
| ------------------------------------------------------------ |
| 준비2. 앞으로 사용할 가상머신 oracle virtualbox로 변경 (서버 이식성,안정성,귀찮음 ↑) |
| 준비3. oracle virtual box 사용법 익히기 (구글링)             |
| 준비4. 새 가상머신 oracle virtualbox에 쿠버네티스 클러스터 다시 만들기 (master 1 / node 2) 3대 서버로 진행 |
| 준비5. 가상머신 ova,image는 외장 SSD에 설치                  |

<br>

### **컨테이너 run**

(create=생성,start=시작,attach=진입) / 컨테이너 살려두고 빠져나오기

![img](../../Framework/img/docker.png)  

<br>

### **컨테이너 생성만하기**

create / 컨테이너 시작 / 컨테이너 내부진입

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker.png) 

<br>

### **실행중인 컨테이너 확인 명령 / 컨테이너 정보 확인** 

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker2.png)

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker3.png) 

<br>

### **컨테이너 명 변경 (rename)**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker4.png) 

<br>

### **컨테이너 정지 , 컨테이너 삭제를 위한 id 확인 , 컨테이너 중지 / 이미지 삭제 / 삭제확인**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker5.png) 

<br>

### **새 컨테이너에 Web 서버 설치 후 노출 (web= 18080 -> 80 포워딩)**

- docker run d --privileged --name skw-test -p 192.168.56.100:18080:80 centos:7 /sbin/init
- docker exec -it skw-test /bin/bash

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker6.png)  

<br>

### **컨테이너 내부**

- yum -y update && yum -y install httpd net-tools firewalld
- systemctl start httpd && systemctl enable httpd && firewall-cmd --permanent --add-service=http && firewall-cmd --permanent --add-port=80/tcp && firewall-cmd --reload && netstat -lntp | grep 80

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker7.png)  

- 로컬 PC(192.168.218.0 대역) 에서 도커의 호스트 운영체제인 192.168.56.100:18080 웹 접속

apache의 테스트페이지 출력

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker8.png) 

<br>

저번에 Mock-up구현할때 만들었던 html 파일을 윈도우 -> 로컬가상머신으로 복사

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker9.png) 

<br>

로컬가상머신 -> 컨테이너 내부의 /var/www/html로 복사후 index.html로 파일명 수정

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker10.png)

<br>

apache 테스트 페이지로 구성되있었던 웹페이지가 내가 만든 html파일의 구조로 변경된것을 볼 수 있다

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker11.png) 