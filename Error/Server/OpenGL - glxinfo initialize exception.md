## 📘 해결해야 할 문제

>  **문제 1 - Remote SSH GUI Rendering 실패**

회사 일을 하다가 영상 분석 서버(Ubuntu)를 Remote로 GUI를 연결하려고 했으나 CLI만 연결되는 현상이 있었습니다.

이 부분은 Ubuntu Desktop을 설치하고 원격을 연결하려고 할 때 발생하였는데,

여러 방법들을 시도해 보다가 Tiger VNC를 사용하기로 하였습니다.

<br>

> **문제 2 - OpenGL Rendering 실패**

아래 Tiger VNC 세팅 과정을 통해서 NVIDIA, Cuda Toolkit, OpenGL이 전부 인식이 잘됨에도 불구하고,

Remote로 GUI를 연결 후  Docker Container를 실행하였으나

컨테이너 내부의 OpenGL이 렌더링되지 않는 에러인 `glfw Error: 65544` 에러가 나왔습니다.

이것의 해결방법은 VNC Client에서 OpenGL Rendering에 필요한 DISPLAY 권한을 주면 됩니다.

- `xhost +Local:*`

<br>

> **Server Info**

- Ubuntu 22.04 LTS

---

## 📘 **TigerVNC**

이번엔 연결한 Remote GUI에서 OpenGL을 인식 못하고 키보드가 안먹는 문제가 있어,

원래 서버의 OpenGL 4.5버전을 그대로 인식하게 하고 싶어서 알아 보았습니다.

<br>

>  **Tiger VNC와 Xorg, D-bus 패키지들을 설치**

```bash
sudo apt -y install pkg-config xserver-xorg-dev tigervnc-standalone-server dbus-X11
```

<br>

> **/etc/X11/xorg.conf 파일명 변경 후 재부탕**

- `mv /etc/X11/xorg.conf /etc/X11/xorg.conf.org`

<br>


> **/home/{User명}/.vnc/xstartup 파일 생성**

```bash
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
vncconfig -iconic &
"$SHELL" -l << 'EOF2'
export XDG_SESSION_TYPE=x11
export GNOME_SHELL_SESSION_MODE=ubuntu
setxkbmap -layout us
dbus-launch --exit-with-session gnome-session --session=ubuntu
EOF2
```

<br>

>  **/etc/systemd/system/vncserver@.service -> Systemd에 서비스 등록**

- 처음에 Service의 타입을 `forking`으로 했었지만 `simple`로 바꾸니 서비스 시작이 안되던게 해결됨
- ExecStart 옵션에 -localhost no를 사용해 원격 접속 허용
- 파일명의 `vncserver@` 뒤에 무조건 "." 을 붙여야 합니다.

```bash
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=simple
User=skw
PAMName=login
PIDFile=/home/%u/.vnc/%H%i.pid
ExecStartPre=/bin/bash -c '/usr/bin/vncserver -kill :%i > /dev/null 2>&1 || :'
ExecStart=/usr/bin/vncserver :%i -geometry 1440x900 -localhost no -alwaysshared -fg
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
```

- 위 파일 등록 후 데몬 리로드 및 시작 프로그램 등록

```bash
systemctl daemon-reload
systemctl enable vncserver@1.service
```

<br>

>  **VNC Client 연결 - SSH Tunneling**

이제 모든 문제를 해결 했으니 원격을 연결하고 싶은 서버에서 SSH 터널링을 해주고 VNC로 연결해줍니다.

```bash
ssh -L 5901:127.0.0.1:5901 -N -f -l {User명} {원격지IP}
```

<br>

> **SSH 터널링 후 VNC Viewer에 `localhost:디스플레이 번호` 로 연결 후 Xhost 액세스를 허용**

```bash
xhost +Local:*
```

<br>

> **DISPLAY 환경변수 설정**

```bash
echo "export DISPLAY=:1" >> ~/.bashrc
```

<br>

> **Docker 실행 옵션 추가**

아래는 제가 사용하는 도커 실행 시 옵션들인데

여기서 이번에 추가한 옵션들만 설명 하겠습니다.

- `-v /var/lib/dbus/machine-id:/var/lib/dbus/machine-id:ro` :  로컬의 D-bus ID 볼륨 마운팅
- `-v /tmp/.X11-unix:/tmp/.X11-unix` : Unix 디스플레이 임시 파일을 로컬의 임시파일과 볼륨 마운팅
- `/etc/xdg:/etc/xdg` : 로컬의 xdg를 컨테이너의 xdg로 볼륨 마운팅
- `--net=host` : 도커 브릿지 네트워크가 아닌 호스트의 네트워크 사용 (`$DISPLAY` 인식시키기 위해 필수)
- `-e DISPLAY=:1` : 저는 1번 Display를 사용중이기 때문에 1번으로 지정 하였습니다.
- `--runtime nvidia` : Container Runtime 엔진은 Nvidia로 설정 해 줍니다.

```bash
docker run      
-v /home/dains/Desktop/CVEDIA-Linux-5.8/models:/opt/cvedia-rt/assets/models 
-v /home/dains/Desktop/CVEDIA-Linux-5.8/output:/opt/cvedia-rt/output 
-v /home/dains/Desktop/CVEDIA-Linux-5.8/persist:/opt/cvedia-rt/persist 
-v /home/dains/Desktop/CVEDIA-Linux-5.8/httpcache:/opt/cvedia-rt/httpcache 
-v /home/dains/Desktop/CVEDIA-Linux-5.8/licenses:/opt/cvedia-rt/licenses 
-v /home/dains/Desktop/CVEDIA-Linux-5.8/instances:/opt/cvedia-rt/instances 
-v /home/dains/Desktop/CVEDIA-Linux-5.8/persist:/opt/cvedia-rt/persist 
-v /dev:/dev:ro 
-v /etc/timezone:/etc/timezone:ro 
-v /etc/machine-id:/etc/machine-id:ro 
-v /var/lib/dbus/machine-id:/var/lib/dbus/machine-id:ro 
-v /lib/firmware:/lib/firmware:ro 
-v /sys/firmware:/sys/firmware:ro 
-v /etc/xdg:/etc/xdg 
-v /tmp/.X11-unix:/tmp/.X11-unix 
--net=host 
-e CVEDIA_RT_CMD="./cvediart" 
-e TZ=Etc/UTC 
--runtime nvidia 
-e LIBGL_ALWAYS_INDIRECT=1 
-e DISPLAY=:1 
-e QT_X11_NO_MITSHM=1 
--rm -it
-e RUN_UI=1 
-e RUN_DEBUG=0 
-e MM_OPT=mimalloc 
-e RUN_STANDALONE=1 
-e GST_DEBUG=1 
-e IS_CMD=0 
-e IS_JETSON=0 
-e IS_QUALCOMM=0 
-e IS_HAILO=0 
-e IS_ROCKCHIP=0 
-e SKIP_QUALCOMM=0 
-e SKIP_ROCKCHIP=0 
-e SKIP_HAILO=0 
-e SKIP_LD_PRELOAD=0 
-e USE_NXW_PLUGIN=0 
-e QUICK_START=0 
-e NXW_TAG=nxw 
-e GST_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/gstreamer-1.0     
-e LIBGL_DEBUG=verbose     
-e TRACY_NO_INVARIANT_CHECK=1     
-e RUN_MQTT=0     
-e ADSP_LIBRARY_PATH=/opt/lib     
-e REDIST_VERSION=2023.12.01 
--name cvedia-rt_f95b28f77a 
--hostname cvedia-rt_f95b28f77a  
-p 8080:8080 
-p 8554:8554 
-p 8889:8889 
-p 12349:12349/udp     
cvedia/public:runtime-x86_64-public-2023.5.8
```

<br>

>  **OpenGL, CUDA ToolKit, NVIDIA Graphic Driver 버전 확인**

위 과정들을 거치고 아래 명령어들로 버전 확인, GUI Tool 실행 시 에러 없이 전부 잘 실행되었습니다.

- `glfinfo | grep "OpenGL version"` : OpenGL 버전 확인
- `nvcc --version` : CUDA ToolKit 버전 확인
- `nvidia-smi` : NVIDIA 인식 확인

<br>

>  **vncserver 사용법**

```bash
## VNC 디스플레이 인스턴스 생성
vncserver :1

## VNC 인스턴스 종료
vncserver -kill :1

## VNC 인스턴스 리스트
vncserver -list
```

---
## 📘 각종 오류 해결 방법

>  **만약 VNC 인스턴스를 종료했는데도 새 인스턴스 시작이 안된다면 적용 해볼 방법들**

- `/tmp/.X11-unix` 경로 아래에 X1, X2 등등 임시파일 삭제
- `/tmp/.X2-lock` 하위에 파일들 삭제

<br>

> **VNC 클라이언트로 접속 시 로그인 세션이 잠길 때**

- `~/.Xauthority` 파일 삭제 후 vnc 인스턴스 kill -> 재시작
- `loginctl unlock-sessions`

---
## 📘 전체 스크립트

```bash
## TigerVNC & D-bus & Xorg 패키지 설치
sudo apt -y install tigervnc-standalone-server dbus-x11 pkg-config xserver-xorg-dev

## xorg.conf 파일명 변경
sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.org

## xstartup 스크립트 생성
sudo vncserver -list
sudo touch /home/skw/.vnc/xstartup
sudo chmod 755 /home/skw/.vnc/xstartup

cat > /home/dains/.vnc/xstartup << 'EOF'
#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
vncconfig -iconic &
"$SHELL" -l << 'EOF2'
export XDG_SESSION_TYPE=x11
export GNOME_SHELL_SESSION_MODE=ubuntu
setxkbmap -layout us
dbus-launch --exit-with-session gnome-session --session=ubuntu
EOF2
EOF

## DISPLAY 환경변수 등록
echo "export DISPLAY=:1" >> ~/.bashrc
source ~/.bashrc

## VNC Server Systemd 서비스 등록
sudo touch /etc/systemd/system/vncserver@.service
sudo chmod 755 /etc/systemd/system/vncserver@.service

cat > /etc/systemd/system/vncserver@.service << EOF
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=simple
User=skw
PAMName=login
PIDFile=/home/%u/.vnc/%H%i.pid
ExecStartPre=/bin/bash -c '/usr/bin/vncserver -kill :%i > /dev/null 2>&1 || :'
ExecStart=/usr/bin/vncserver :%i -geometry 1440x900 -localhost no -alwaysshared -fg
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable vncserver@1
reboot
```