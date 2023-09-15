## VScode 세팅



### Flutter SDK 설치

- https://docs.flutter.dev/get-started/install
- 적당한 위치에 압축 풀고 bin 폴더들어가서 디렉터리 경로 복사
- 시스템 환경 변수 추가 : Path에 새로 만들기로 Flutter 환경변수 추가
- cmd : flutter --version 입력후 잘나오면 설치 완료됨



### Android Studio & Amulator (AVD) 추가

- [안드로이드 스튜디오](https://developer.android.com/studio?gclid=CjwKCAjwp_GJBhBmEiwALWBQk6-xiJF39C4rHp-IVq4RfCcX9xFWoTJuDF8s0B6H0_X5GSq6eS6hwhoC9I8QAvD_BwE&gclsrc=aw.ds)  다운로드
- Create New Project
- 새 프로젝트 상단에 AVC Manager 클릭
- Create Virtual Device 클릭
- Phone - Pixel 3 XL - Next - Q Download - Next - Finish

<br>

### VScode

- Extensions: Install Extensions 설치
- Flutter 설치
- Flutter: New Application Project
- Flutter: Launch Emulator 선정 (Pixel or Nexus)
- 선정 후 Run -> Run Without Debugging 실행