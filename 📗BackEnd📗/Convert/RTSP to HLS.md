## 📘 RTSP to HLS

> 😯 **Window 기반 설치**

https://ffmpeg.org/download.html

<br>

> 😯 **환경변수 설정**

`setx PATH "%PATH%;경로"`

<br>

> 😯 **버전 확인**

ffmpeg -version

<br>

> 😯 **Sample RTSP**

rtsp://210.99.70.120:1935/live/cctv001.stream

---

## EC2 Setting

**RPM 기반 FFmpeg & Java 17 설치**

```bash
#!/bin/bash

# FFmpeg 설치
cd /usr/local/bin 
mkdir ffmpeg 
cd ffmpeg 
wget https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.2.1-amd64-static.tar.xz 
tar xvf ffmpeg-4.2.1-amd64-static.tar.xz 
mv ffmpeg-4.2.1-amd64-static/ffmpeg . 
ln -s /usr/local/bin/ffmpeg/ffmpeg /usr/bin/ffmpeg

# Java 17 설치
yum install -y java-17-amazon-corretto-headless
```

<br>

**Debian 기반**

```bash
apt -y install ffmpeg
```

