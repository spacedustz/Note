## 📘 RTSP to HLS

이번 RTSP -> HLS 변환은 AWS EC2 환경에서 진행합니다.

<br>

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

## 📘 EC2 Setting

> 😯 **RPM 기반 FFmpeg & Java 17 설치**

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

> 😯 **Debian 기반 FFmpeg 설치**

```bash
apt -y install ffmpeg
```

---

## 📘 Config

Task Executor 와 Resource Handler / Cors 설정을 해줍니다.

```java
@EnableAsync  
@Configuration  
public class AppConfig {  
    @Value("${task.executor.core.pool.size}")  
    private int corePoolSize;  
  
    @Value("${task.executor.max.pool.size}")  
    private int maxPoolSize;  
  
    @Value("${task.executor.queue.capacity}")  
    private int queueCapacity;  
  
    // Thread Pool 설정  
    @Bean  
    public TaskExecutor executor() {  
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();  
        executor.setCorePoolSize(corePoolSize);  
        executor.setMaxPoolSize(maxPoolSize);  
        executor.setQueueCapacity(queueCapacity);  
        executor.setThreadNamePrefix("Estimation-");  
        executor.initialize();  
  
        return executor;  
    }  
}
```