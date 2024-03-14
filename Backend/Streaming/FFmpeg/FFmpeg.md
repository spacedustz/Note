## 📘 FFpmeg Low Ratency

FFmpeg을 이용해 RTSP를 HLS로 스트리밍을 하는데 지연시간이 너무 길어 옵션들을 만지다가,

최대한 Low Ratency를 달성하기 위해 알아본 글 입니다.

<br>

>  **지연시간이 발생하는 이유**

HLS는 일반적으로 **설계상 지연시간**이 존재합니다. (일반적으로 2~30초) 

왜일까요?

- 일반적으로 플레이어는 2~4개의 세그먼트를 캐시합니다. (8~16초 지연)
- 플레이어가 항상 재생목록을 다시 로드하기 때문에 (최대 4초 지연) 또 다른 세그먼트가 지연됩니다.
- 인코더는 항상 하나의 세그먼트를 처리중 입니다. (또 4초 지연)
- 그리고 클라이언트 측 RTSP 인코딩과 서버의 업로드/전송 시간으로 인해 지연됩니다. (1~4초 지연)

이러면 최소 30초 정도의 딜레이가 발생합니다.

<br>

>  **지연 시간을 줄이는 방법**

**세그먼트 크기 줄이기 - `hls_time` 옵션**

- 이 방법을 사용하면 더 많은 파일을 생성해야 합니다.
- 재생 목록 파일(m3u8)을 더 자주 업데이트 해야합ㅂ니다.
- 더 많은 오버헤드가 발생합니다.
- 기본값은 2이며, 2~6초를 권장합니다.

<br>

**세그먼트 개수 줄이기 - `hls_list_size` 옵션**

- m3u8 재생목록에 들어가는 세그먼트 파일(.ts)의 개수를 줄이는 옵션입니다. 

<br>

**하드웨어 가속**

- 알아보는 중

---

## 📘 FFmpeg Options

>  **설정값**

- hls_time = 2
- hls_list_size = 2
- hls_flags = delete_segments+append_list
- start_number = 1
- hls_playlist_type = event

<br>

>  `-hls_flags delete_segments`

- 이 플래그는 처리된 세그먼트 파일들을 지속적으로 삭제합니다. 
- 그렇게 함으로써 사용자가 재생을 시작할 때 오래된 세그먼트 대신 최신 세그먼트부터 재생하게 할 수 있습니다.  

<br>

>  `-hls_flags append_list`

- HLS v4 이상에서 사용할 수 있는 이 플래그는 기존 재생 목록에 세그먼트를 추가만 하며, 이것은 항상 최신 세그먼트부터 재생하게 할 때 유용합니다.  

<br>

>  `-hls_playlist_type event`

- 이 옵션은 라이브 스트리밍에 적합한 event 타입의 재생 목록을 생성합니다. vod (Video On Demand)와 달리, event 타입은 새로운 세그먼트가 추가될 때 기존의 세그먼트를 유지하게 해서 실시간으로 업데이트되는 재생 목록을 제공합니다.  

<br>

>  `-hls_list_size 0`

- 이 옵션은 재생 목록에 모든 세그먼트를 유지하도록 설정합니다. 
- 그러나 실시간 스트리밍에는 유용하지 않을 수 있으며, 대신 적절한 크기(예: -hls_list_size 3 또는 5)로 설정하여 최근 세그먼트만 유지하게 할 수 있습니다.  

<br>

>  `-hls_time`

- 이 옵션으로 각 세그먼트의 지속 시간을 설정할 수 있으며, 이는 세그먼트의 길이를 결정합니다. 
- 세그먼트 길이를 짧게 설정하면(예: 2초), 재생이 더 빨리 최신으로 시작될 수 있습니다.  

```bash
ffmpeg -i rtsp://your_rtsp_stream_address -codec copy -flags -global_header -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments+append_list -hls_playlist_type event stream.m3u8
```

<br>

>  **설명**

* RTSP 스트림을 입력으로 받습니다.  
* 비디오와 오디오 코덱을 변환하지 않고 복사합니다 (-codec copy).  
* HLS 포맷으로 출력합니다 (-f hls).  
* 각 세그먼트의 길이를 2초로 설정합니다 (-hls_time 2).  
* 재생 목록에서 최대 3개의 세그먼트를 유지합니다 (-hls_list_size 3).  
* 처리된 세그먼트를 삭제하고 재생 목록에 세그먼트를 추가만 하여 최신 상태를 유지합니다 (-hls_flags delete_segments+append_list).  
* 재생 목록 타입을 event로 설정하여 라이브 스트리밍에 적합하게 합니다 (-hls_playlist_type event).  
* 재생 목록 파일 이름을 stream.m3u8로 설정합니다.  
* 위 설정을 사용하면, 사용자가 재생을 시작할 때 최신 콘텐츠를 먼저 볼 수 있도록 HLS 스트림이 구성됩니다.  

<br>

> **지연시간 낮은 옵션**

```python
ffmpeg -nostdin -flags low_delay -rtsp_transport tcp -i <rtsp_stream> -pix_fmt bgr24 -an -vcodec rawvideo -f rawvideo -
```

---
## Spring Boot

- Spring Boot에서 Local에 설치된 FFmpeg에 명령을 내리는 HLS 프로젝트 코드 중 일부를 가져왔습니다.
- Windows / Linux 일때 CMD 명령이 다릅니다.

**Process Service**

```java
@Service  
@Slf4j  
public class ProcessService {  
    @Value("${ffmpeg.option.hls.time}")  
    private int hlsTime;  
  
    @Value("${ffmpeg.option.hls.list.size}")  
    private int hlsListSize;  
  
    @Value("${ffmpeg.option.hls.flags}")  
    private String hlsFlags;  
  
    @Value("${ffmpeg.option.start.number}")  
    private String startNumber;  
  
    @Value("${hls.file.path}")  
    private String hlsFilePath;  
  
    //private Map<String, Process> processMap = new ConcurrentHashMap();  
    private static final String OS = System.getProperty("os.name").toLowerCase();  
  
    /**  
     * HLS Converter 시작(FFMPEG 프로세스 시작)  
     *     * @param cameraId  
     * @param instanceName  
     * @param ip  
     * @param port  
     * @throws IOException  
     */  
    public int startHlsConverter(final Integer cameraId, final String instanceName, final String ip, final Integer port) throws IOException {  
        //Process process = processMap.get(cameraId);  
        int started = 0;  
        log.info("StartHLS - CameraId : {}, instanceName : {}, ip : {},  port : {}", cameraId, instanceName, ip, port);  
  
        boolean ifFfmpegProcessRunning = this.isFfmpegProcessRunning(ip.trim(), port, instanceName.trim());  
        log.info("StartHLS - 프로세스 실행 상태 - {}", ifFfmpegProcessRunning);  
  
        //if (process == null || !process.isAlive()) {  
        if (!ifFfmpegProcessRunning) {  
            try {  
                File file = new File(hlsFilePath + cameraId);  
                File[] files = file.listFiles();  
  
                if (files != null) {  
                    log.info("기존 폴더 존재");  
                    for (File f : files) {  
                        if (f.isDirectory()) {  
                            // 디렉토리 내의 서브 디렉토리 삭제  
                            deleteDirectory(f);  
                            log.info("디렉터리, 파일 삭제");  
                        } else {  
                            // 파일 삭제  
                            f.delete();  
                        }  
                    }  
                }  
  
                if (!file.exists()) {  
                    log.info("디렉터리에 파일이 존재하지 않음, 파일 생성 : {}", (hlsFilePath + cameraId));  
                    file.mkdirs();  
                } else {  
                    log.info("디렉터리에 파일이 존재함, 파일 삭제 : {}", (hlsFilePath + cameraId));  
                    file.delete();  
  
                    try {  
                        Thread.sleep(1000);  
                    } catch (InterruptedException e) {  
                        log.warn("StartHLS - Thread Interrupted : {}", e.getMessage());  
                        Thread.currentThread().interrupt(); // 다시 인터럽트 플래그 설정  
                    }  
                    file.mkdirs();  
                    log.info("Start HLS - 파일 & 폴더 생성 완료");  
                }  
            } catch (Exception e) {  
                log.warn("StartHLS - 파일 & 폴더 생성 에러 : {}, {}", (hlsFilePath + cameraId), e.getMessage());  
            }  
  
            StringBuilder cmd = new StringBuilder();  
  
            cmd.append("ffmpeg -i rtsp://").append(ip).append(":").append(port).append("/").append(instanceName);  
            cmd.append(" -c:v copy -c:a copy");  
            cmd.append(" -hls_time ").append(hlsTime);  
            cmd.append(" -hls_list_size ").append(hlsListSize);  
            cmd.append(" -hls_flags ").append(hlsFlags);  
            cmd.append(" -hls_allow_cache 0");  
            cmd.append(" -fflags nobuffer");  
            cmd.append(" -strict experimental");  
            cmd.append(" -avioflags direct");  
            cmd.append(" -fflags discardcorrupt");  
            cmd.append(" -flags low_delay ");  
            cmd.append(" -start_number ").append(startNumber).append(" ");  
            cmd.append(hlsFilePath).append(cameraId).append(File.separator).append("output.m3u8");  
  
            log.info("FFmpeg CMD : {}", cmd.toString());  
  
            Process process;  
            if (OS.contains("win")) {  
                process = Runtime.getRuntime().exec(cmd.toString());  
            } else {  
                process = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", cmd.toString()});  
            }  
            BufferedReader errStream = new BufferedReader(new InputStreamReader(process.getErrorStream()));  
            String line;  
  
            while ((line = errStream.readLine()) != null) {  
                log.debug(line);  
            }  
  
            boolean result = false;  
  
            try {  
                result = process.waitFor(1000, TimeUnit.MILLISECONDS);  
            } catch (Exception e) {  
                log.warn("StartHLS - Process WaitFor Exception : {}", e.getMessage());  
            }  
  
            log.info("FFmpeg 프로세스 시작. - {}", result);  
            started = 1;  
  
            //processMap.put(instanceName.trim(), process);  
        } else {  
            log.debug("StartHLS - FFmpeg 프로세스 실행 중");  
        }  
  
        return started;  
    }  
      
    /**  
     * FFMPEG 프로세스가 실행 중인지 확인 
     *     * @param ip  
     * @param port  
     * @param instanceName  
     * @return  
     */  
    private boolean isFfmpegProcessRunning(final String ip, final Integer port, final String instanceName) {  
        boolean isRunning = false;  
        String command = "";  
  
        if (OS.contains("win")) {  
            command = "powershell.exe $currentId = (Get-Process -Id $PID).Id; Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -like '*ffmpeg -i rtsp://" + ip + ":" + port + "/" + instanceName + "*' -and $_.ProcessId -ne $currentId } | Select-Object ProcessId";  
            log.info("Check FFmpeg - OS : Windows");  
        } else {  
            command = "ps -ef | grep ffmpeg | grep rtsp://" + ip + ":" + port + "/" + instanceName + " | grep -v grep | awk '{print $2}'";  
            log.info("Check FFmpeg - OS : Linux");  
        }  
  
        log.info("Check FFmpeg - Command : {}", command);  
  
        try {  
            Process process;  
            if (OS.contains("win")) {  
                // 윈도우에서는 powershell 명령을 직접 실행  
                process = Runtime.getRuntime().exec(command);  
            } else {  
                // 리눅스에서는 /bin/sh를 통해 명령 실행  
                process = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", command});  
            }  
  
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));  
  
            String line = reader.readLine();  
            if (line != null && !line.trim().isEmpty()) {  
                log.debug("Check FFmpeg - 실행 중 : {}", line);  
                isRunning = true;  
            }  
  
            process.waitFor(3000, TimeUnit.MILLISECONDS);  
        } catch (Exception e) {  
            log.warn("Check FFmpeg - Exception : {}", e.getMessage());  
            e.printStackTrace();  
        }  
  
        return isRunning;  
    }
    
```