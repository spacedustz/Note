## 💡 Mac Settings

### Download Flutter SDK

[Link](https://docs.flutter.dev)

- Get Started - Install - MacOS - Download Zip - Uncompress
- 원하는 폴더로 이동 (난 Documents - SDK에 저장)
- cd ./Documents/SDK/flutter/bin
- vi ~/.zshrc (bash Shell인 경우 ~/.bash_profile)
- export PATH="$PATH:/Users/space/Documents/SDK/flutter/bin"
- echo $PATH & which flutter

<br>

### Download Xcode iOS Build Tool

- AppStore - Download Xcode
- sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
- sudo xcodebuild -runFirstLaunch
- sudo xcodebuild -license
- agree
- open -a Simulator
- 아이폰 시뮬레이터 켜지면 성공



### Android Setup

[Link](https://developer.android.com/studio)

- Android Studio - Plugins - Install Flutter
- Restart Android Studio
- new Flutter Project
- 점3개 클릭 - Documents/SDK/Flutter 폴더 선택 - Open
- 프로젝트 생성
- 우측 상단 AVD Manager - Create Virtual Device
- Pixel 2 - Tiramisu SDK - Next
- Android Studio - Preference - Android SDK - SDK Tools
- 아래 4개 항목에 `-`표시

Android SDK Build-Tools 33-rc1

Android SDK Command-line Tolls (latest) <- 이건 체크 표시로 업데이트 해주자

Android Emulator

Android SDK Platform-Tolls

- 세팅용으로 만든 프로젝트 삭제
- 터미널
- flutter doctor (안드로이드 에러 시 : flutter doctor--android-licenses)

Doctor를 실행했을때 아래 항목들이 정상적으로 실행이 되어야 한다.

- Flutter
- Android toolchain
- Xcode
- Android Studio

<br>

### CocoaPods 설치

- brew install cocoapods

<br>

### Android Studio Project 다시 생성

- ios - Runner - info.plist 파일 우측 상단 Open iOS module in Xcode 클릭 (Xcode 실행)
- Runner - signing & Capabilities - Team - Add Accounts - Apple Login

Runner에 Apple Login을 하면 실제 기기와 연동이 된다.

---

## 💡 Windows Settings

### Download Flutter SDK

[Link](https://docs.flutter.dev)

- Get Started - Install - Windows - Download Zip - Uncompress
- 원하는 폴더로 이동 (난 Documents - SDK에 저장)
- Git 설치
- PowerShell - Flutter SDK 설치 원하는 폴더로 이동
- git clone https://github.com/flutter/flutter.git -b stable
- cd flutter/bin
- pwd (path 복사)
- 시스템 환경 변수 편집 - Path - New - 복사한 pwd Path 붙여넣기
- PowerShell 재실행
- flutter doctor

<br>

### Flutter Doctor 체크리스트

**Android Studio**

- [Download Visual Studio-Community](https://visualstudio.microsoft.com/downloads/)
- Visual Studio Installer 실행 - Modify 탭 - 아래 항목들 체크 후 Modify 클릭
   `Desktop Development with C++`,
  `MSVC v142 - V5 2019 C++ x64/x86 build tools`,
  `CMake tools for Windows`,
  `Windows 10 SDK`
- 다운로드 받은 후 다시 flutter doctor를 입력해 Visual Studio 체크가 됐는지 확인
- PowerShell 재실행 - flutter doctor 입력하여 Visual Studio 체크 잘 된지 확인

<br>

**Android toolchain**

- [Download Android Studio](https://developer.android.com/studio)
- flutter docer 재확인 후 필요한 부분 진행
- Android Studio 실행 - More Actions - SDK Manager - Android SDK - SDK Tools
- `Android SDK Command-line Tools (latest)` (체크),
  `Google USB Driver` (실제 기기와 연동하고 싶은 경우 체크),
  `Intel Emulator Accelerator (인텔 모델 사용중인 경우 체크)
- Apply 클릭하여 설치
- PowerShell 재실행 flutter doctor 실행 후 라이센스 문제가 뜨면 아래 명령어 입력
- `flutter doctor --android-licenses`
- PowerShell 재실행 flutter doctor 실행후 문제 전부 해결된거 확인
- 다시 Android Studio - Plugins - Flutter 설치 - Restart IDE
- new Flutter Project 생성 - Path 설정 **(bin 폴더가 아닌 flutter 폴더로 지정)**
- Android Studio - 우측 상단 Device Manager - Create Device - Pixel XL - Download Tiramisu SDK
- Tiramisu 클릭 - Next - Finish - 실행

---

## 💡 Kotlin 최신버전으로 변경

Flutter 2.10.2 버전 기준으로 간혹 Kotlin 버전과 관련된 에러가 나는 경우 아래 내용 진행

- android/build.dradle 파일 오픈
- buildscript 부분의 `ext.kotlin_version`을 최신버전으로 변경
- [Kotlin 최신버전 확인 링크]( https://kotlinlang.org/docs/releases.html#release-details)
- Android Studio 아래 Termanal을 열어서 flutter clean 실행 - 프로젝트 재실행

<br>

### Android Studio Cache 삭제

- File > Invalidate Caches 클릭
- 프로젝트 재실행

<br>

### 다른 대안

- [Flutter 버전 다운그레이드](https://docs.flutter.dev/development/tools/sdk/releases) 2.8.1 버전을 올바른 OS 버전으로 다운로드
- 기존 Flutter SDK 삭제하고 새로 받은 SDK로 대체
- Flutter SDK를 업데이트 하지말고 2.8.1 버전을 사용해서 프로젝트 실행

---

## 💡각종 Error 해결 방법

flutter doctor를 실행한 후 Unable to find Bundled Java Version 에러가 날경우

<br>

**Windows**

- `C:\Program FIles\Android\Android Studio` 에서 jbr 폴더의 내용을 jre로 복붙

<br>

**Mac**

- Terminal 
- `cd /Applications/Android\ Studio.app/Contents`
- `ln -s jbr jre`

<br>

### CocoaPods not installed

- App Store에서 XCode 실행을 먼저 진행. 
- 진행이 완료되면 XCode를 실행해서 초기화작업 진행
- Mac 환경설정하기 강의에서 보여준 것과 같이 brew를 재설치한 후 cocoapods 재설치

<br>

### Android SDK 버전 에러

<img src="https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/android sdk version error.png" alt="img" style="zoom: 80%;" /> 

안드로이드 에뮬레이터 또는 실제 기기에서 프로젝트를 실행할때 위처럼 SDK 버전 에러가 날 경우 매우 쉽게 문제를 해결 할 수 있습니다. 

안드로이드 SDK 최소 버전을 설정하는 문제로 특정 플러그인이 최소 버전을 강제하는 경우가 있고 플러그인이 업데이트 될때마다 최소 버전이 상향 될 수 있습니다.

<br>

메세지에 적혀있는대로 {프로젝트 폴더}/android/app/build.gradle 위치로 이동한 후 android 아래 defaultConfig 아래 minSdkVersion에 에러 메세지에 적혀있는 버전을 입력해주면 됩니다.

<br>

 아마 기본으로 flutter.minSdkVersion등 숫자가 입력돼있지 않거나 더 높은 버전 또는 낮은 버전이 입력 돼 있을겁니다.

버전 값을 변경해주고 다시 실행하면 손쉽게 에러를 해결 할 수 있습니다.