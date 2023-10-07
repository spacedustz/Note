## RTSP to HLS

**다운로드**

https://ffmpeg.org/download.html

<br>

**환경변수 설정**

`setx PATH "%PATH%;경로"`

<br>

**버전 확인**

ffmpeg -version

<br>

**Sample RTSP**

rtsp://210.99.70.120:1935/live/cctv001.stream

---

## EC2 Setting

**RPM 기반**

```bash
cd /usr/local/bin 
mkdir ffmpeg 
cd ffmpeg 
wget https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.2.1-amd64-static.tar.xz 
tar xvf ffmpeg-4.2.1-amd64-static.tar.xz 
mv ffmpeg-4.2.1-amd64-static/ffmpeg . 
ln -s /usr/local/bin/ffmpeg/ffmpeg /usr/bin/ffmpeg
```