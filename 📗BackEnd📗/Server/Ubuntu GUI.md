
Server 버전 Ubuntu 22.04 LTS를 설치하고 GUI 설치

```bash
apt-get -y update && apt-get -y upgrade
apt-get -y install --no-install ubuntu-desktop (최소 설치)
apt-get -y install ubuntu-desktop

## 추가 패키지 설치
apt-get -y install indicator-appmenu-tools (hud service not connected 오류 해결)  
apt-get -y install indicator-session ( 계정, 세션 아이콘 추가 )  
apt-get -y install indicator-datetime ( 상단 메뉴 시간 추가 )  
apt-get -y install indicator-applet-complete ( 볼륨 조절 아이콘 추가 )

system reboot
```