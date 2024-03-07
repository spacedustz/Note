> **환경 세팅 스크립트**

```bash
## TigerVNC & D-bus & Xorg 패키지 설치
sudo apt -y install tigervnc-standalone-server dbus-x11 pkg-config xserver-xorg-dev

## Xorg Conf 파일 이름 변경
sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.org

## xstartup 스크립트 생성
sudo vncserver -list
sudo touch /home/dains/.vnc/xstartup
sudo chonw dains:dains /home/dains/.vnc/xstartup

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

sudo chmod 755 /home/dains/.vnc/xstartup

## DISPLAY 환경변수 등록
echo "export DISPLAY=:1" >> ~/.bashrc
source ~/.bashrc


## VNC Server Systemd 서비스 등록
sudo touch /etc/systemd/system/vncserver@.service
sudo chmod 777 /etc/systemd/system/vncserver@.service

cat > /etc/systemd/system/vncserver@.service << EOF
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=simple
User=dains
PAMName=login
PIDFile=/home/%u/.vnc/%H%i.pid
ExecStartPre=/bin/bash -c '/usr/bin/vncserver -kill :%i > /dev/null 2>&1 || :'
ExecStart=/usr/bin/vncserver :%i -geometry 1920x1080 -localhost no -alwaysshared -fg
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo rm -rf /tmp/.X11-unix/*
sudo rm -rf /tmp/.X2-lock

reboot
```

<br>

## VNC Client

>  **VNC Client 연결 - SSH Tunneling**

이제 모든 문제를 해결 했으니 원격을 연결하고 싶은 서버에서 SSH 터널링을 해주고 VNC로 연결해줍니다.

```bash
ssh -L 5901:127.0.0.1:5901 -N -f -l {User명} {원격지IP}
```

<br>

> **SSH 터널링 후 VNC Viewer에 `localhost:디스플레이 번호` 로 연결 후 Xhost 액세스 허용**

```bash
xhost +Local:*
```


---
## 각종 오류 해결 방법

>  **만약 VNC 인스턴스를 종료했는데도 새 인스턴스 시작이 안된다면 적용 해볼 방법들 - VNC Server**

- `/tmp/.X11-unix` 경로 아래에 X1, X2 등등 임시파일 삭제
- `/tmp/.X2-lock` 하위에 파일들 삭제

<br>

> **VNC 클라이언트로 접속 시 로그인 세션이 잠길 때 - VNC Server**

- `~/.Xauthority` 파일 삭제 후 vnc 인스턴스 kill -> 재시작
- `loginctl unlock-sessions`

<br>

> **OpenGL Rendering 안될 때 - VNC Client**

- `xhost +Local:*`
