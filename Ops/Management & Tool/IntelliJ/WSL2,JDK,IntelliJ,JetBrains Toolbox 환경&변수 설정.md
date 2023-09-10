## **💡 WSL2 설치**

- WSL을 사용함으로써 서브운영체제에 대한 손쉬운 접근성
- OpenJDK를 설치하고 사용을 위해 환경변수 설정을 함으로써 프로그램 동작방식의 이해
- JetBrains ToolBox 라는 손쉬운 IDE 업데이트 툴을 알게 됨 

<br>

### **✅ 윈도우 버전 확인 20H2 이상 (낮은 버전이라면 윈도우 업데이트로 해결가능)**

MS Store에서 Windows Terminal 검색&설치

설치된 Terminal 관리자 권한 실행

<br>

### **✅ Linux용 Windows의 Subsystem , VirtualMachinePlatform 기능 사용 설정**

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart 입력

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int.png)

<br>

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart 입력 후 PC reboot

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int2.png)

<br>

### **✅ Linux Kernel Update Package 설치**

https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

<br>

### **✅wsl default version 2로 설정**

wsl --setdefault-version 2 입력하여 default 버전 2로 설정

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int3.png) 

<br>

### **✅ MS Store -> Ubuntu Download**

(개인적으로 22.04.1 LTS 버전 받았음) 후 열기버튼 클릭

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int4.png) 

<br>

보기 편하게 PC 네임을 skw로 변경

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int5.png) 

<br>

터미널에서 wsl -l -v 로 버전확인 후 우분투 열기

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int6.png) 

------

## **💡 Zulu Open JDK Download (11 LTS Ver.)**

**https://www.azul.com/downloads/?version=java-11-lts&os=windows&architecture=x86-64-bit&package=jdk**

다운로드 후 cmd - java & javac 입력

------

## **💡 Google - IntelliJ 검색후 Community Ver Download (설정)**

4개 항목 체크

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int7.png) 

<br>

실행후 New Project - Name작성 - Create를 하면 이런화면이 됨.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int9.png) 

<br>

src 우클릭 - New - Java Class

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int8.png) 

<br>

Class 명으로 Main 을 입력하자

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int10.png) 

<br>

Main Class 생성 화면

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int11.png) 

<br>

Hello World 를 출력하는 코드를 작성하고 우측 상단 실행 버튼 클릭하면 정상 출력이 되며 IntelliJ 완료

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int12.png) 

------

## **💡 JetBrains Toolbox 설치 **

**https://www.jetbrains.com/lp/toolbox/**

IDE 업데이트 툴 설치 완료

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int13.png) 

------

## **💡 JDK를 사용하기 위한 Windows 환경변수 설정**



**Win+S - 시스템 환경 변수 편집 - 고급 - 환경변수 - 시스템변수(S) 의 새로만들기**

**변수 이름 : JAVA_HOME**

**변수 값: C:\Program Files\Zulu\zulu-11**

<br>

만들어진 JAVA_HOME 변수

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int14.png) 

<br>

밑에 보면 Path가 생성됐다. 편집 클릭

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int15.png) 

<br>

새로만들기 - %JAVA_HOME%\bin 경로 추가 해주자

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int16.png) 

<br>

처음 시스템 변수에 새 변수를 추가할때와 동일하게 CLASSPATH도 추가해주기

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int17.png) 

<br>

cmd - path 입력하여 내가 추가한 환경변수가 출력되는지 확인하면 학습 세팅 완료

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/int18.png) 