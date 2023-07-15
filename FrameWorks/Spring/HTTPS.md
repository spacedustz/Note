## **💡 사설 CA 발급 + HTTPS 적용**

우분투, OpenSSL 사용 X
Centos에는 인증서 발급을 위한 nss-tools가 이미 설치 되있으므로 설치 불필요
AWS 보안그룹 -> 사용할 포트 오픈

<br>

### **인증서 발급 & Application HTTP -> HTTPS 적용**

**✅ AWS 인스턴스 생성 & pem -> ppk 변환**

AWS Instance pem -> ppk 변환

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/https.png) 

<br>

**✅ EC2 인스턴스 보안그룹에 이어 2중 방화벽 firewalld 설치**

AWS Instance ssh 연결, yum update, yum-utils, wget, firewalld 설치

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/https2.png) 

<br>

**✅ 방화벽 포트, 서비스 오픈**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/https3.png) 

<br>

**✅ 포트, 서비스 적용 확인**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/https4.png) 

<br>

**✅ wget을 이용하여 mkcert 파일 download, 파일 권한 변경**

mksert파일 wget, 권한 변경

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/https5.png) 

<br>

**✅ 보안상 제약이 있는 외부(PC방)의 환경에서 실습 진행중 파일 전송 막힘**

PC방의 22번 포트 막혀있음+ 방화벽 접근 불가 + OpenSSH 설치도 안됨

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/https6.png) 

<br>

포트도 막힘

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/https7.png) 

<br>

**✅ SFTP를 이용하여 파일 전송에 성공**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/https8.png) 

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/https9.png) 

<br>

**✅ Application의 application.yml 파일 내부에서 인증서 지정을 통한 HTTPS 적용 완료**

application.yml 파일 내부 cert 설정

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/https10.png) 