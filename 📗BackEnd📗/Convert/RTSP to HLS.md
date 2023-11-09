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

Task Executor 와 Resource Handler / Cors / WebClient 설정을 해줍니다.

> 📌 **AppConfig**

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

Control API에 StreamingDTO의 형식대로 API 요청을 하면 FFmpeg 변환 프로세스를 시작합니다.

```java
@Slf4j  
@RestController  
@RequestMapping("/api/hls")  
@RequiredArgsConstructor  
public class StreamingController {  
    private final StreamingService streamingService;  
  
    @Value("${api.key}")  
    private String apiKey;  
  
    // org.springframework.core.io.Resource  
    @GetMapping("/stream")  
    public ResponseEntity<Resource> streamHls() {  
        File file = new File("output.m3u8");  
        Resource resource = new FileSystemResource(file);  
  
        return ResponseEntity.ok(resource);  
    }  
  
    @PostMapping("/control")  
    public String controlHls(@Valid @RequestBody StreamingDto request) {  
        String ok = "{\"code\": 0, \"msg\": \"Success\"}";  
        String nok = "{\"code\": -1, \"msg\": \"Failure\"}";  
  
        try {  
            if (!StringUtils.hasText(request.getApiKey()) || !apiKey.trim().equals(request.getApiKey().trim())) {  
                log.error("API Key가 잘못 되었습니다. - {}", request);  
  
                return nok;  
            }  
  
            // Command가 Start or Stop 일때 FFmpeg 프로세스 실행 / 중지  
            if (request.getCommand().equalsIgnoreCase("start")) {  
                streamingService.startConverter(request.getCameraId(), request.getInstanceName(), request.getIp(), request.getPort());  
            } else if (request.getCommand().equalsIgnoreCase("stop")) {  
                streamingService.stopHlsConverter(request.getCameraId(), request.getInstanceName());  
            }  
        } catch (Exception e) {  
            log.error("HLS Controller Exception - {}, {}", e.getMessage(), request.toString());  
            e.printStackTrace();  
  
            return nok;  
        }  
  
        return ok;  
    }  
}
```

---

## 📘 Service

> 📌 **Rest API Service**

인스턴스 헬스체크를 위해 인스턴스에 Rest API 요청을 보내기 위한 서비스입니다.

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
     *     * @param uri  
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

```java
@Slf4j  
@Service  
public class StreamingService {  
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
  
    private Map<Integer, Process> processMap = new ConcurrentHashMap();  
  
    /**  
     * FFmpeg 프로세스 시작  
     * @param cameraId  
     * @param instanceName  
     * @param ip  
     * @param port  
     * @throws IOException  
     * @author 신건우  
     */  
    public void startConverter(final Integer cameraId, final String instanceName, final String ip, final Integer port) throws IOException {  
        Process process = processMap.get(cameraId);  
  
        // FFmpeg에 사용할 명령어를 String Builder를 이용해 작성 합니다.  
        if (process == null || !process.isAlive()) {  
            StringBuilder builder = new StringBuilder();  
            builder.append("ffmpeg -i rtsp://");  
            builder.append(ip);  
            builder.append(":");  
            builder.append(port);  
            builder.append("/");  
            builder.append(instanceName);  
            builder.append(" -c:v copy -c:a copy ");  
            builder.append(" -hls_time ").append(hlsTime);  
            builder.append(" -hls_list_size ").append(hlsListSize);  
            builder.append(" -hls_flags ").append(hlsFlags);  
            builder.append(" -start_number ").append(startNumber);  
            builder.append(" ").append(hlsFilePath).append(cameraId).append(File.separator).append("output.m3u8");  
  
            // 프로세스를 시작하게 할 명령어 입니다.  
            String cmd = builder.toString();  
  
            File file = new File(hlsFilePath + cameraId);  
  
            // 파일이 없으면 생성합니다.  
            if (!file.exists()) file.mkdirs();  
  
            // 명령을 전달하여 프로세스 실행합니다.  
            process = Runtime.getRuntime().exec(cmd);  
  
            BufferedReader errorStream = new BufferedReader(new InputStreamReader(process.getErrorStream()));  
            String line;  
            int exitCode = 0;  
  
            while ((line = errorStream.readLine()) != null) {  
                log.debug(line);  
            }  
  
            try {  
                exitCode = process.waitFor();  
            } catch (Exception e) {  
                log.error("Process Wait For Failed - {}", e.getMessage());  
            }  
  
            // 카메라의 식별자와 프로세스를 Map에 넣습니다.  
            processMap.put(cameraId, process);  
  
            log.info("FFmpeg 변환 프로세스가 시작됩니다. - {}, {}, {}, {}, {}, {}", cameraId, instanceName, ip, port, cmd, process.isAlive());  
  
        } else {  
            log.debug("FFmpeg 변환 프로세스가 이미 실행 중 입니다.");  
        }  
    }  
  
    /**  
     * FFmpeg 프로세스 종료  
     * @param cameraId  
     * @param instanceName  
     * @throws IOException  
     * @author 신건우  
     */  
    public void stopHlsConverter(final Integer cameraId, final String instanceName) throws IOException {  
        Process process = processMap.get(cameraId);  
  
        // 프로세스가 존재하면 종료합니다.  
        if (process != null && process.isAlive()) {  
            process.destroy();  
            process = null;  
  
            File file = new File(hlsFilePath + cameraId);  
  
            // 파일이 존재하면 제거합니다.  
            if (file.exists()) {  
                file.delete();  
            }  
  
            // Map에서 프로세스를 제거합니다.  
            processMap.remove(instanceName);  
  
            log.info("FFmpeg 변환 프로세스가 종료 되었습니다.");  
        } else {  
            log.info("FFmpeg 변환 프로세스가 실행 중이 아닙니다.");  
        }  
    }  
  
    /**  
     * FFmpeg 프로세스 Health Check  
     */    @Scheduled(fixedDelayString = "${ffmpeg.check.interval.millis}")  
    public void checkProcess() {  
        processMap.forEach((cameraId, process) -> {  
            if (process != null) {  
                if (process.isAlive()) {  
                    log.debug("Check FFmpeg - {}번 카메라 변환 프로세스가 실행 중 입니다.", cameraId);  
                } else {  
                    log.debug("Check FFmpeg - {}번 카메라 변환 프로세스가 실행 중이 아닙니다.", cameraId);  
                }  
            }  
        });  
    }  
}
```

---

## 📘 Health Check Thread

```java
@Slf4j  
@Service  
@RequiredArgsConstructor  
public class HealthCheckThread extends Thread {  
    private final RestApiService restApiService;  
    private final TaskExecutor executor;  
    private final ObjectMapper mapper;  
    private String[] instanceName = {"1-260-01", "1-260-04", "1-294-01", "1-294-02", "1-414-02", "1-414-03", "1-438-02", "1-465-01", "1-465-04"};  
    private String server = "http://192.168.0.122:8080/";  
    private static int index = 0;  
  
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
                    String result = restApiService.getRequest(uri).block();  
                    InstanceDto[] instanceDtoArray = mapper.readValue(result, InstanceDto[].class);  
  
                    if (instanceDtoArray != null && instanceDtoArray.length > 0) {  
                        Arrays.stream(instanceDtoArray).forEach(instance -> {  
  
                            if (instance.getState() == 4) {  
                                log.info("Instance 상태 : 실행 중");  
                            }  
  
                            log.info("Instance Status - Name : {}, Info : {}", name, instance.toString());  
  
                            if (instance.getState() == 0 || instance.getState() == 1 || instance.getState() == 3 || instance.getState() == 5) {  
                                index++;  
                                log.debug("총 인스턴스 실패한 횟수 : {}", index);  
  
                                String startUri = server + "api/instance/start";  
  
                                InstanceDto reqBody = new InstanceDto();  
                                reqBody.setInstanceName(instance.getInstanceName());  
                                reqBody.setSolution(instance.getSolution());  
  
                                try {  
                                    String requestBody = mapper.writeValueAsString(reqBody);  
                                    restApiService.postRequest(startUri, requestBody).block();  
  
                                    log.info("Instance Start - Request Body : {}", requestBody);  
                                } catch (Exception e) {  
                                    log.info("Instance Start with An Exception : {}", e.getMessage());  
                                }  
                            }  
                        });  
                    }  
                } catch (Exception e) {  
                    log.warn("Instance Monitoring with An Exception - {}", e.getMessage());  
                }  
            });  
  
            try {  
                Thread.sleep(5000);  
            } catch (InterruptedException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
  
    private void InstanceConnection() {  
        executor.execute(() -> {  
            HealthCheckThread healthCheckThread = new HealthCheckThread(restApiService, executor, mapper);  
            executor.execute(healthCheckThread);  
        });  
    }  
}
```

---
## 📘 View

```html
<!DOCTYPE html>  
<html lang="en">  
<head>  
    <meta charset="UTF-8">  
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  
    <title>HLS Streaming</title>  
    <!-- hls.js 라이브러리 추가 -->  
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>  
</head>  
<body>  
<video id="video1" width="640" height="360" controls></video>  
<video id="video2" width="640" height="360" controls></video>  
<video id="video3" width="640" height="360" controls></video>  
<video id="video4" width="640" height="360" controls></video>  
<video id="video5" width="640" height="360" controls></video>  
<video id="video6" width="640" height="360" controls></video>  
<video id="video7" width="640" height="360" controls></video>  
<video id="video8" width="640" height="360" controls></video>  
<video id="video9" width="640" height="360" controls></video>  
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
            { element: document.getElementById('video1'), source: 'http://127.0.0.1:5002/videos/1/output.m3u8' },  
            { element: document.getElementById('video2'), source: 'http://127.0.0.1:5002/videos/2/output.m3u8' },  
            { element: document.getElementById('video3'), source: 'http://127.0.0.1:5002/videos/3/output.m3u8' },  
            { element: document.getElementById('video4'), source: 'http://127.0.0.1:5002/videos/4/output.m3u8' },  
            { element: document.getElementById('video5'), source: 'http://127.0.0.1:5002/videos/5/output.m3u8' },  
            { element: document.getElementById('video6'), source: 'http://127.0.0.1:5002/videos/6/output.m3u8' },  
            { element: document.getElementById('video7'), source: 'http://127.0.0.1:5002/videos/7/output.m3u8' },  
            { element: document.getElementById('video8'), source: 'http://127.0.0.1:5002/videos/8/output.m3u8' },  
            { element: document.getElementById('video9'), source: 'http://127.0.0.1:5002/videos/9/output.m3u8' },  
        ];  
  
        // 각 비디오 스트리밍 시작  
        videos.forEach(function (videoInfo) {  
            startStreaming(videoInfo.element, videoInfo.source);  
        });  
    });  
</script>  
</body>  
</html>
```