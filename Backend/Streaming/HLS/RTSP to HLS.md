## 📘 RTSP to HLS

OS환경은 Windows 기준으로 개발 하였습니다.

브라우저에서 지원이 안되는 RTSP를 FFmpeg을 이용해 HLS로 변환하여 브라우저에서 실시간 영상을 스트리밍 합니다.

<br>

> 😯 **Windows FFmpeg Link**

https://ffmpeg.org/download.html

<br>

> 😯 **설치 후 시스템 환경변수 설정**

`setx PATH "%PATH%;{ffpmeg 경로}"`

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

Task Executor 와 Resource Handler / Cors / WebClient 설정을 해줍니다.

<br>

> 📌 **AppConfig**

- 어플리케이션에서 사용할 스레드 수를 짐작해서 설정해 줍니다.

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
        executor.setThreadNamePrefix("Executor-");  
        executor.initialize();  
  
        return executor;  
    }  
  
    @Bean  
    public WebClient webClient() {  
        return WebClient.builder().build();  
    }  
}
```

<br>

> 📌**CorsConfig**

- Resource Handler / Cors Mapping을 해줍니다. (설명 생략)

```java
@Configuration  
public class CorsConfig implements WebMvcConfigurer {  
    @Value("${hls.file.path}")  
    private String hlsFilePath;  
  
    // "file:/home/user/videos/" 디렉토리의 리소스를 "/videos/**" 경로로 서비스  
    @Override  
    public void addResourceHandlers(ResourceHandlerRegistry registry) {  
        registry.addResourceHandler("/videos/**")  
                .addResourceLocations("file:"+hlsFilePath);  
    }  
  
    @Override  
    public void addCorsMappings(CorsRegistry registry) {  
        registry.addMapping("/**")  // 모든 경로에 대해  
                .allowedOrigins("*")  // 허용할 원본  
                .allowedMethods("GET", "POST", "PUT", "DELETE")  // 허용할 HTTP 메서드  
                .allowedHeaders("Header1", "Header2", "Header3")  
                .exposedHeaders("Header1", "Header2")  
                //.allowCredentials(true)  
                .maxAge(3600);  // 1시간 동안 pre-flight 응답을 캐시  
    }  
}
```

---
## 📘 DTO

> 📌 **Streaming DTO**

RTSP를 FFmpeg 명령으로 변환하기 위한 정보를 받는 DTO입니다.

```java
@Getter  
public class StreamingDto {  
    @NotNull  
    private Integer cameraId; // DB에 저장된 CameraID  
    @NotNull  
    private String instanceName; // RTSP Topic  
  
    @NotNull  
    private String ip;  
  
    @NotNull  
    private Integer port;  
  
    @NotNull  
    private String command; // start & stop  
  
    @NotNull  
    private String apiKey; // API 호출을 위한 키  
}
```

<br>

> 📌 **Instance DTO**

인스턴스를 주기적으로 헬스체크하는 Thread에서 Rest API 요청을 위해 필요한 인스턴스 정보입니다.

```java
@Data  
@JsonInclude(JsonInclude.Include.NON_NULL)  
public class InstanceDto {  
    @JsonProperty("instance_name")  
    private String instanceName;  
  
    @JsonProperty("solution")  
    private String solution;  
  
    @JsonProperty("solution_name")  
    private String solutionName;  
  
    @JsonProperty("solution_path")  
    private String solutionPath;  
  
    @JsonProperty("solution_version")  
    private String solutionVersion;  
  
    @JsonProperty("state")  
    private int state;  
  
}
```

---
## 📘 Controller

- startConvert() : IP와 Command(start/stop)을 URI Parameter로 보내면
- control() : Control API에 StreamingDTO의 형식대로 API 요청을 하면 FFmpeg 변환 프로세스를 시작합니다.

```java
@RestController  
@RequestMapping("/api/hls")  
@RequiredArgsConstructor  
@Slf4j  
public class HlsConstroller {  
  private final ProcessService processService;  
  
  @Value("${api.key}")  
  private String apiKey;  
  /**  
   * HLS 스트리밍  
   *  
   * @return  
   */  
  @GetMapping("/stream")  
  public ResponseEntity<Resource> streamHls() {  
    File videoFile = new File("output.m3u8");  
    Resource videoResource = new FileSystemResource(videoFile);  
  
    return ResponseEntity.ok(videoResource);  
  }  
  
  /**  
   * ffmpeg 상태 체크  
   *  
   * @param ip  
   * @param port  
   * @param instanceName  
   * @return  
   */  
  @GetMapping("/check")  
  public String hlsCheck(@RequestParam(value = "ip") String ip,  
                         @RequestParam(value = "port") String port,  
                         @RequestParam(value = "instanceName") String instanceName){  
  
    String ok = "{\"code\": 0, \"msg\": \"Active\"}";  
    String nok = "{\"code\": -1, \"msg\": \"InActive\"}";  
  
    Integer portNumber = Integer.valueOf(port);  
    boolean result = processService.isFfmpegProcessRunning(ip, portNumber, instanceName);  
    if(result){  
      return ok;  
    }  
    return nok;  
  }  
  
  /**  
   * HLS Converter 제어(시작/종료)  
   *   * @param request  
   * @return  
   */  
  @PostMapping("/control")  
  public String controlHls(@Valid @RequestBody HlsControlDto request) {  
    String ok = "{\"code\": 0, \"msg\": \"Success\"}";  
    String nok = "{\"code\": -1, \"msg\": \"Failure\"}";  
    int result = 0;  
  
    try{  
      if(!StringUtils.hasText(request.getApiKey()) || !apiKey.trim().equals(request.getApiKey().trim())){  
        log.error("controlHls|invalid key|{}|{}", request.toString());  
  
        return nok;  
      }  
  
      if(request.getCommand().equalsIgnoreCase("start")) {  
        result = processService.startHlsConverter(request.getCameraId(), request.getInstanceName(), request.getIp(), request.getPort());  
  
        if(result == 1){  
          ok = "{\"code\": 1, \"msg\": \"Success\"}";  
        }else{  
          ok = "{\"code\": 0, \"msg\": \"Success\"}";  
        }  
      }else if(request.getCommand().equalsIgnoreCase("stop")){  
        processService.stopHlsConverter(request.getInstanceName(), request.getIp(), request.getPort());  
      }else{  
        log.error("controlHls|unknown command|{}|{}", request.toString());  
  
        return nok;  
      }  
    } catch (Exception e) {  
      log.error("controlHls|exception|{}|{}", e.getMessage(), request.toString());  
  
      e.printStackTrace();  
  
      return nok;  
    }  
  
    return ok;  
  }  
  
  @GetMapping("/file/exist/{cameraId}")  
  public String fileExist(@PathVariable Integer cameraId) {  
    String ok = "{\"code\": 0, \"msg\": \"Success\"}";  
    String nok = "{\"code\": -1, \"msg\": \"Failure\"}";  
    boolean fileExist = false;  
  
    try{  
        if(cameraId == null){  
        log.error("fileExist|invalid cameraId|{}", cameraId);  
  
        return nok;  
      }  
  
      fileExist = processService.hlsFileExist(cameraId);  
  
      if(fileExist){  
        return ok;  
      }else{  
        return nok;  
      }  
    } catch (Exception e) {  
      log.error("fileExist|exception|{}|{}", fileExist, e.getMessage());  
  
      e.printStackTrace();  
  
      return nok;  
    }  
  }  
}
```

---
## 📘 Service

> 📌 **Rest API Service**

- getInstance() : 인스턴스 헬스체크를 위해 인스턴스에 GET 요청을 보내기 위한 함수입니다.
- portInstance() : 헬스체크 로직 내에서 인스턴스가 Running 중이 아니라면 실행시키는 API 요청 함수입니다.
- requestStreaming() : FFmpeg을 이용하여 RTSP를 HLS로 변환 명령을 실행시키는 함수입니다.

```java
@Slf4j  
@Service  
@RequiredArgsConstructor  
public class RestApiService {  
    private final WebClient webClient;  
  
    @Value("${api.key}")  
    private String apiKey;  
  
    private String uri = "http://localhost:5000/api/hls/control";  
  
  
    public Mono<String> getInstance(final String uri) throws Exception{  
  
        return webClient.get()  
                .uri(uri)  
                .retrieve()  
                .bodyToMono(String.class);  
    }  
  
    /**  
     * POST 요청(URI 는 / 부터 시작해야 함)  
     * @param uri  
     * @param data  
     * @return  
     */  
    public Mono<String> postInstance(final String uri, final Object data) throws Exception{  
        return webClient.post()  
                .uri(uri)  
                .bodyValue(data)  
                .retrieve()  
                .bodyToMono(String.class);  
    }  
  
    public void requestStreaming(String ip, String command) {  
        String[] cameras = {  
                "1-260-01 8554",  
                "1-260-04 8555",  
                "1-294-01 8556",  
                "1-294-02 8557",  
                "1-414-02 8558",  
                "1-414-03 8559",  
                "1-438-02 8560",  
                "1-465-01 8561",  
                "1-465-04 8562"  
        };  
  
        Mono<List<Void>> request = Flux.range(0, cameras.length)  
                .flatMap(i -> {  
                    String[] info = cameras[i].split(" ");  
                    String instance = info[0];  
                    int port = Integer.parseInt(info[1]);  
  
                    StreamingDto dto = new StreamingDto();  
                    dto.setCameraId(i + 1);  
                    dto.setPort(port);  
                    dto.setIp(ip);  
                    dto.setApiKey(apiKey);  
                    dto.setCommand(command);  
                    dto.setInstanceName(instance);  
  
                    return webClient  
                            .post()  
                            .uri(uri)  
                            .contentType(MediaType.APPLICATION_JSON)  
                            .body(BodyInserters.fromValue(dto))  
                            .retrieve()  
                            .bodyToMono(Void.class);  
                }).collect(Collectors.toList());  
  
        Flux.mergeSequential(request)  
                .then()  
                .doOnTerminate(() -> {  
                    if (command.equals("start")) {  
                        log.warn("Request API - FFmpeg 실행 요청 완료");  
                    } else if (command.equals("stop")) {  
                        log.warn("Request API - FFmpeg 중지 요청 완료");  
                    }  
                })  
                .subscribe();  
    }  
}
```

<br>

> 📌 **StreamingService**

컨트롤러로 부터 DTO를 받아 RTSP Topic, InstanceName 등 정보를 이용해 FFmpeg 프로세스를 실행합니다.

여기서 다양한 옵션을 통해 FFmpeg 프로세스의 Low Latency를 위한 튜닝 작업을 합니다.

OS가 Windows일때와 Linux일떄의 CMD 실행 문이 다르니 이 부분을 조심해야 합니다.

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
     * @author 신건우
     * HLS Converter 시작(FFMPEG 프로세스 시작)  
     * @param cameraId  
     * @param instanceName  
     * @param ip  
     * @param port  
     * @throws IOException  
     */  
    public int startHlsConverter(final Integer cameraId, final String instanceName, final String ip, final Integer port) throws IOException {  
        //Process process = processMap.get(cameraId);  
        int started = 0;  
        log.info("Start HLS - CameraId : {}, instanceName : {}, ip : {},  port : {}", cameraId, instanceName, ip, port);  
  
        boolean ifFfmpegProcessRunning = this.isFfmpegProcessRunning(ip, port, instanceName);  
        log.info("Start HLS - 프로세스 실행 상태 - {}", Optional.of(ifFfmpegProcessRunning));  
  
        String filePath = "";  
  
        if (OS.contains("win")) {  
            filePath = hlsFilePath.replace("/", "\\");  
        } else {  
            filePath = hlsFilePath;  
        }  
  
        //if (process == null || !process.isAlive()) {  
        if (!ifFfmpegProcessRunning) {  
            try {  
                File file = new File(filePath + cameraId);  
                File[] files = file.listFiles();  
  
                if (files != null) {  
                    log.info("Start HLS - 기존 폴더 존재");  
                    for (File f : files) {  
                        if (f.isDirectory()) {  
                            // 디렉토리 내의 서브 디렉토리 삭제  
                            deleteDirectory(f);  
                            log.info("Start HLS - 디렉터리, 파일 삭제");  
                        } else {  
                            // 파일 삭제  
                            f.delete();  
                        }  
                    }  
                }  
  
                if (!file.exists()) {  
                    log.info("Start HLS - 디렉터리에 파일이 존재하지 않음, 파일 생성 : {}", (filePath + cameraId));  
                    file.mkdirs();  
                } else {  
                    log.info("Start HLS - 디렉터리에 파일이 존재함, 파일 삭제 : {}", (filePath + cameraId));  
                    file.delete();  
  
                    try {  
                        Thread.sleep(1000);  
                    } catch (InterruptedException e) {  
                        log.warn("Start HLS - Thread Interrupted : {}", e.getMessage());  
                        Thread.currentThread().interrupt(); // 다시 인터럽트 플래그 설정  
                    }  
                    file.mkdirs();  
                    log.info("Start HLS - 파일 & 폴더 생성 완료");  
                }  
            } catch (Exception e) {  
                log.warn("Start HLS - 파일 & 폴더 생성 에러 : {}, {}", (filePath + cameraId), e.getMessage());  
            }  
  
            StringBuilder cmd = new StringBuilder();  
  
            String separator = "";  
            if (OS.contains("win")) {  
                separator = "\\";  
            } else {  
                separator = File.separator;  
            }  
  
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
            cmd.append(" -flags low_delay");  
            cmd.append(" -start_number ").append(startNumber).append(" ");  
            cmd.append(filePath).append(cameraId).append(separator).append("output.m3u8");  
  
            log.info("Start HLS - FFmpeg CMD : {}", cmd);  
  
            Process process;  
            if (OS.contains("win")) {  
                process = Runtime.getRuntime().exec(cmd.toString());  
            } else {  
                process = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", cmd.toString()});  
            }  
  
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getErrorStream()));  
            String line;  
            while ((line = reader.readLine()) != null) {  
//                log.info("ㅁㅁㅁ {}", line);            }  
  
            try {  
                process.waitFor(3000, TimeUnit.MILLISECONDS);  
                log.info("Start HLS - FFmpeg 프로세스 시작");  
            }catch (Exception e){  
                log.warn("error message : {}", e.getMessage());  
            } finally {  
                process.destroy();  
            }  
  
            started = 1;  
            //processMap.put(instanceName.trim(), process);  
        } else {  
            log.debug("StartHLS - FFmpeg 프로세스 실행 중");  
        }  
  
        return started;  
    }  
  
    //public void stopHlsConverter(final Integer cameraId, final String instanceName) throws IOException {  
  
    /** HLS Converter 종료(FFMPEG 프로세스 종료)  
     * @author 신건우
     * @param instanceName  
     * @param ip  
     * @param port  
     * @throws IOException  
     */  
    public void stopHlsConverter(final String instanceName, final String ip, final Integer port) throws IOException {  
        int processId = this.getFfmpegProcessId(ip, port, instanceName);  
  
        if (processId > 0) {  
            String command = "powershell.exe Stop-Process -Id " + processId;  
  
            if (!OS.contains("win")) {  
                command = "kill -9 " + processId;  
            }  
  
            log.debug("stopHlsConverter|instanceName:{}|ip:{}|port:{}|processId:{}|command:{}", instanceName, ip, port, processId, command);  
  
            Process process;  
            if(OS.contains("win")){  
                process  = Runtime.getRuntime().exec(command);  
            }else{  
                process = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", command});  
            }  
  
            try {  
                process.waitFor(3000, TimeUnit.MILLISECONDS);  
            } catch (Exception e) {  
                log.warn("stopHlsConverter|exception1|{}", e.getMessage());  
            }finally {  
                process.destroy();  
            }  
        } else {  
            log.info("stopHlsConverter|ffmpeg process is not running.");  
        }  
    }  
  
    public boolean hlsFileExist(final Integer cameraId) {  
        String filePath = "";  
  
        if (OS.contains("win")) {  
            filePath = hlsFilePath.replace("/", "\\");  
        } else {  
            filePath = hlsFilePath;  
        }  
  
        File file = new File(filePath + cameraId + File.separator + "output.m3u8");  
  
        return file.exists();  
    }  
  
    /**  
     * @author 신건우
     * FFMPEG 프로세스가 실행 중인지 확인한다.  
     * @param ip  
     * @param port  
     * @param instanceName  
     * @return  
     */  
    public boolean isFfmpegProcessRunning(final String ip, final Integer port, final String instanceName) {  
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
  
        Process process = null;  
  
        try {  
            if (OS.contains("win")) {  
                // 윈도우에서는 powershell 명령을 직접 실행  
                process = Runtime.getRuntime().exec(command);  
            } else {  
                // 리눅스에서는 /bin/sh를 통해 명령 실행  
                process = Runtime.getRuntime().exec(new String[]{"/bin/sh", "-c", command});  
            }  
  
            BufferedReader inputStream = new BufferedReader(new InputStreamReader(process.getInputStream()));  
            BufferedReader errorStream = new BufferedReader(new InputStreamReader(process.getErrorStream()));  
  
            String inputLine;  
            while ((inputLine = inputStream.readLine()) != null) {  
                log.info("Check FFmpeg - Input Stream - {}", inputLine);  
                isRunning = true;  
            }  
  
            String errorLine;  
            while ((errorLine = errorStream.readLine()) != null) {  
                log.info("Check FFmpeg - Error Stream - {}", errorLine);  
            }  
  
            process.waitFor(3000, TimeUnit.MILLISECONDS);  
  
        } catch (Exception e) {  
            log.warn("Check FFmpeg - Exception : {}", e.getMessage());  
            e.printStackTrace();  
        }  
  
        return isRunning;  
    }
}
```

---
## 📘 Health Check Thread

카메라 인스턴스의 상태를 1분마다 체크 (Thread.sleep) 하여 상태가 4(Running)이 아니면 다시 실행시키는 백그라운드 데몬 스레드 입니다.

```java
@Slf4j  
@Service  
@RequiredArgsConstructor  
public class InstanceHealthCheck extends Thread {  
    private final RestApiService restApiService;  
    private final TaskExecutor executor;  
    private final ObjectMapper mapper;  
    //    private String[] instanceName = {"1-260-01", "1-260-04", "1-294-01", "1-294-02", "1-414-02", "1-414-03", "1-438-02", "1-465-01", "1-465-04"};  
    private String[] instanceName = {"Tripwire-Test"};  
    private String server = "http://localhost:8080/";  
  
    @PostConstruct  
    public void init() {  
        this.InstanceConnection();  
    }  
  
    @Override  
    public void run() {  
        while (true) {  
  
            Arrays.stream(instanceName).forEach(name -> {  
                try {  
                    String uri = server + "api/instance/get?instance_name=" + name;  
                    String result = restApiService.getInstance(uri).block();  
                    InstanceDto[] instanceDtoArray = mapper.readValue(result, InstanceDto[].class);  
  
                    if (instanceDtoArray != null && instanceDtoArray.length > 0) {  
                        Arrays.stream(instanceDtoArray).forEach(instance -> {  
  
                            if (instance.getState() == 4) {  
                                return;  
                            }  
  
                            if (instance.getState() == 0 || instance.getState() == 1 || instance.getState() == 3 || instance.getState() == 5) {  
  
                                String startUri = server + "api/instance/start";  
  
                                InstanceDto reqBody = new InstanceDto();  
                                reqBody.setInstanceName(instance.getInstanceName());  
                                reqBody.setSolution(instance.getSolution());  
  
                                try {  
                                    String requestBody = mapper.writeValueAsString(reqBody);  
                                    restApiService.postInstance(startUri, requestBody).block();  
                                    log.info("[{}] Instance Start", reqBody.getInstanceName());  
                                } catch (Exception e) {  
                                    log.error("{} Instance Start with An Exception : {}, {}",reqBody.getInstanceName(), e.getMessage(), e.getCause());  
                                }  
                            }  
                        });  
                    }  
  
                    log.info("[Instance Health Check] - 정상");  
                } catch (Exception e) {  
                    log.warn("Instance 서버가 오프라인 입니다.");  
                }  
            });  
  
            try {  
                Thread.sleep(60000);  
            } catch (InterruptedException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
  
    private void InstanceConnection() {  
        executor.execute(() -> {  
            InstanceHealthCheck thread = new InstanceHealthCheck(restApiService, executor, mapper);  
            thread.setDaemon(true);  
            executor.execute(thread);  
        });  
    }  
}
```

<br>

![](./1.png)

---
## 📘 View

Library : hls.js

단순히 비디오 9개를 붙여서 HLS를 실행하는 코드라서 설명은 생략합니다.

```html
<!DOCTYPE html>  
<html lang="en">  
<head>  
    <meta charset="UTF-8">  
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  
    <title>HLS Streaming</title>  
    <!-- hls.js 라이브러리 추가 -->  
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>  
    <link rel="stylesheet" type="text/css" href="hls.css">  
</head>  
<body>  
<div class="video-container">  
    <video id="video1" width="640" height="360" controls></video>  
    <video id="video2" width="640" height="360" controls></video>  
    <video id="video3" width="640" height="360" controls></video>  
    <video id="video4" width="640" height="360" controls></video>  
    <video id="video5" width="640" height="360" controls></video>  
    <video id="video6" width="640" height="360" controls></video>  
    <video id="video7" width="640" height="360" controls></video>  
    <video id="video8" width="640" height="360" controls></video>  
    <video id="video9" width="640" height="360" controls></video>  
</div>  
<script>  
    // 함수로 스트리밍 로직 분리  
    function startStreaming(videoElement, videoSource) {  
        if (Hls.isSupported()) {  
            var hls = new Hls();  
            hls.loadSource(videoSource);  
            hls.attachMedia(videoElement);  
            hls.on(Hls.Events.MANIFEST_PARSED, function () {  
                videoElement.play();  
            });  
        }  
        // 브라우저가 기본적으로 HLS를 지원하는 경우  
        else if (videoElement.canPlayType('application/vnd.apple.mpegurl')) {  
            videoElement.src = videoSource;  
            videoElement.addEventListener('loadedmetadata', function () {  
                videoElement.play();  
            });  
        }  
    }  
  
    document.addEventListener('DOMContentLoaded', function () {  
        // 비디오 요소와 소스 배열  
        var videos = [  
            { element: document.getElementById('video1'), source: 'http://127.0.0.1:5000/videos/1/output.m3u8' },  
            { element: document.getElementById('video2'), source: 'http://127.0.0.1:5000/videos/2/output.m3u8' },  
            { element: document.getElementById('video3'), source: 'http://127.0.0.1:5000/videos/3/output.m3u8' },  
            { element: document.getElementById('video4'), source: 'http://127.0.0.1:5000/videos/4/output.m3u8' },  
            { element: document.getElementById('video5'), source: 'http://127.0.0.1:5000/videos/5/output.m3u8' },  
            { element: document.getElementById('video6'), source: 'http://127.0.0.1:5000/videos/6/output.m3u8' },  
            { element: document.getElementById('video7'), source: 'http://127.0.0.1:5000/videos/7/output.m3u8' },  
            { element: document.getElementById('video8'), source: 'http://127.0.0.1:5000/videos/8/output.m3u8' },  
            { element: document.getElementById('video9'), source: 'http://127.0.0.1:5000/videos/9/output.m3u8' },  
        ];  
  
        // 각 비디오를 스트리밍 시작  
        videos.forEach(function (videoInfo) {  
            startStreaming(videoInfo.element, videoInfo.source);  
        });  
  
        document.addEventListener('keydown', function(event) {  
            if (event.key === 'Enter') {  
                videos.forEach(function (videoInfo) {  
                    videoInfo.element.play();  
                })  
            }  
        })  
    });  
</script>  
</body>  
</html>
```

```css
.video-container {  
    display: grid;  
    grid-template-columns: repeat(3, 1fr);  
    gap: 10px; /* 각 비디오 사이의 간격 조정 가능 */}  
  
.video-container video {  
    width: 100%;  
    height: auto;  
}
```

---
## 📘 실행

Controller의 request API를 이용해 FFmpeg을 실행해 RTSP를 변환해서 브라우저에 HLS를 재생합니다.

노트북의 GPU 사양이 안좋기 때문에 1개의 비디오만 돌려보겠습니다.

Request URI : `http://localhost:5000/api/hls/request?ip={ip}&command=start`

<br>

FFmpeg을 실행하는 로직은 프로세스의 응답을 WaitFor 하기 때문에 백그라운드(&)로 API를 요청 해줍니다.

Bash -> `curl -X GET http://localhost:5000/api/hls/request?ip={ip}&command=start &`

<br>

![](./2.png)

<br>

실행 후, 프로세스를 확인 해보면 9개의 FFmpeg 변환 프로세스가 떠있습니다.

지금은 테스트로 1개의 비디오만 연결했기 때문에 실제론 1개만 변환중이고,

브라우저에서 재생을 시키면 잘 변환되어 스트리밍 됩니다.

<br>

세그먼트 파일(.ts)과 재생리스트 파일(.m3u8) 파일도 잘 생기는걸 볼 수 있습니다.

![](./3.png)