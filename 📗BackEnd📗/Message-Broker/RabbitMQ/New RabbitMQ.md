## 📘 RabbitMQ with MultiThreading

단일 서버의 RabbitMQ  Connection을 맺을때 RabbitConfig를 작성해서 했었는데,

이번에 간단하게 여러서버에 분산된 RabbitMQ를 클러스터링 하지않고 Spring Boot 서버에서 멀티스레딩으로,

각각의 RabbitMQ Connection Factory에 연결을 필요로 하는 일이 생겨서 작성해 봅니다.

<br>

이번에는 Queue에서 바로 데이터를 Receive 하지 않습니다.

- 각 서버당 RabbitMQ Connection을 ConcurrentHashMap에 넣어 연결
- 연결된 RabbitMQ의 Queue 개수에 맞는 RabbitMQ Channel을 생성해 별개의 스레드로 실행하여 데이터 Consume

---

## 📘 Channel Consume

> 📕 **RabbitMQ Channel의 basicConsume()을 이용해 데이터를 받는 이유**

RabbitMQ Channel을 Consume하려면 DeliveryCallBack / CancelCallBack 인터페이스를 구현한 클래스를 `basicConsume()`의 파라미터로 주어야 합니다.

이유는, DeliveryCallBack에서 Channel의 Queue에서 받아온 메시지의 가공을 처리하며,

Consume이 실패한 메시지에 대한 처리는 CancelCallBack 에서 처리하기 때문입니다.

<br>

> 📕 **ConcurrentHashMap 사용 이유**

그리고 각 ConnectionFactory, Connection, Channel들은 **Thread Safe**한 ConcurrentHashMap을 사용합니다.

ConcurrentHashMap을 사용한 이유는 전체 Map에 대한 Lock을 사용하는 것이 아닌, 

세그먼트 별로 Lock을 거는 구조이기 때문에 동기화에 드는 부담을 줄일 수 있습니다.

<br>

즉, 스레드간 경합을 최소화하고 동시성을 높이며 각 세그먼트 간 충돌을 최소화 시키는게 주 이유입니다.

<br>

> 📕 **ApplicationConfig**

Spring WebClient의 Connection TimeOut을 설정해주고,

어플리케이션에서 동시에 실행시킬 CorePoolSize, MaxPoolSize, QueueCapacity를 어플리케이션의 부하량을 측정하게 적절하게 넣어줍니다.

<br>

TaskExecutor를 HealthCheck 로직과 Counting 로직에서 따로 쓸 수 있게 executor를 2개로 분리하였습니다.

```java
/**  
 * @author 신건우  
 * Spring WebClient / Task Exucutor Bean 등록  
 */  
@EnableAsync  
@Configuration  
@RequiredArgsConstructor  
public class ApplicationConfig {  
    private final Props props;  
  
    @Bean  
    public WebClient webClient() {  
        HttpClient httpClient = HttpClient.create()  
                .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 5000)  
                .responseTimeout(Duration.ofMillis(5000))  
                .doOnConnected(i ->  
                        i.addHandlerLast(new ReadTimeoutHandler(5000, TimeUnit.MILLISECONDS))  
                        .addHandlerLast(new WriteTimeoutHandler(5000, TimeUnit.MILLISECONDS)));  
  
        return WebClient.builder()  
                .clientConnector(new ReactorClientHttpConnector(httpClient))  
                .build();  
    }  
  
    @Bean  
    public TaskExecutor executor() {  
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();  
        executor.setCorePoolSize(props.getCorePoolSize());  
        executor.setMaxPoolSize(props.getMaxPoolSize());  
        executor.setQueueCapacity(props.getQueueCapacity());  
        executor.setThreadNamePrefix(props.getNamePrefix());  
        executor.initialize();  
  
        return executor;  
    }  
  
    @Bean  
    public TaskExecutor healthCheckExecutor() {  
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();  
        executor.setCorePoolSize(2);  
        executor.setMaxPoolSize(3);  
        executor.setQueueCapacity(4);  
        executor.setThreadNamePrefix("Health-Check-");  
        executor.initialize();  
  
        return executor;  
    }  
}
```

<br>

> 📕 **RabbitService**

```java
/**  
 * @author 신건우  
 * RabbitMQ Connection 생성과 Queue당 1개의 Channel 생성 후 Channel 당 1개의 스레드 할당  
 */  
@Slf4j  
@Service  
@RequiredArgsConstructor  
public class RabbitService {  
    private final TaskExecutor executor;  
    private final Map<Integer, ConnectionFactory> connectionFactoryMap = new ConcurrentHashMap<>();  
    private final Map<Integer, Connection> connectionMap = new ConcurrentHashMap<>();  
    private final Map<Integer, List<Channel>> channelMap = new ConcurrentHashMap<>();  
    private final Map<Integer, String> queueNameMap = new ConcurrentHashMap<>();  
    private final EventDeliveryCallBack eventDeliveryCallBack;  
    private final EventCancelCallBack eventCancelCallBack;  
    private final Props props;  
  
    @PostConstruct  
    public void init() {  
        log.info("==================== RabbitMQ Connection 초기화 시작 ====================");  
        this.connectRabbitMQ();  
        this.listenEvent();  
        log.info("==================== RabbitMQ Connection 초기화 완료 ====================");  
    }  
  
    // Message Listener  
    public void listen(final Channel channelParam, String queueName) {  
        try {  
            channelParam.basicConsume(queueName, true, eventDeliveryCallBack, eventCancelCallBack);  
        } catch (Exception e) {  
            log.error("[Consume Queue] Consume Failed - Exception : {}, Cause : {}", e.getMessage(), e.getCause());  
        }  
    }  
  
    /* Listen Thread 생성 */    
    private void listenEvent() {  
        List<Channel> channelList = channelMap.get(1);  
  
        for (int i = 0; i < props.getQueues().size(); i++) {  
            EventThread thread = new EventThread(this, channelList.get(i), props.getQueues().get(i));  
            executor.execute(thread);  
        }  
    }  
  
    /* RabbitMQ Connection & Channel 생성 */    
    private void connectRabbitMQ() {  
        // TODO 1: Queue Name을 Map에 넣기  
        for (int i = 0; i < props.getQueues().size(); i++) {  
            queueNameMap.put(i + 1, props.getQueues().get(i));  
            log.info("RabbitMQ Queue 등록 - Queue Name : {}", props.getQueues().get(i));  
        }  
  
        // TODO 2: Connection Factory 생성 (1개만 필요)  
        ConnectionFactory factory = new ConnectionFactory();  
        factory.setHost(props.getHost());  
        factory.setPort(props.getPort());  
        factory.setUsername(props.getUsername());  
        factory.setPassword(props.getPassword());  
  
        connectionFactoryMap.put(1, factory);  
        log.info("RabbitMQ Connection Factory Created - Host : {}, Port : {}", props.getHost(), props.getPort());  
  
        // TODO 3: Connection Factory에서 Connection을 1개만 만들기  
        connectionFactoryMap.forEach((key, connectionFactory) -> {  
            Connection connection = null;  
  
            try {  
                connection = factory.newConnection();  
                connectionMap.put(1, connection);  
                log.info("RabbitMQ Connection Created");  
            } catch (Exception e) {  
                log.error("RabbitMQ Connection 생성 실패 - {}", e.getMessage());  
            }  
  
            // TODO 3-1: 이미 채널이 오픈되어 있다면 채널 종료  
            try {  
                List<Channel> channels = channelMap.get(1);  
  
                if (channels != null && channels.size() > 0) {  
                    channels.stream().forEach(channel -> {  
                        if (channel != null && channel.isOpen()) {  
                            try {  
                                channel.close();  
                            } catch (Exception e) {  
                                log.warn("Create RabbitMQ Connect & Channel Close Error - {}", e.getMessage());  
                            }  
                        }  
                    });  
  
                    channelMap.remove(1);  
                }  
  
                // TODO 3-2: 1개의 Connection에 QueueNameMap의 숫자만큼 채널 생성  
                List<Channel> channelList = new ArrayList<>();  
  
                for (int i = 1; i <= props.getQueues().size(); i++) {  
                    Channel channel = connection.createChannel();  
                    channelList.add(channel);  
                    log.info("RabbitMQ Channel {} Created", i);  
                }  
  
                channelMap.put(1, channelList);  
  
            } catch (Exception e) {  
                log.error("Rabbit Connection Failed : {}", e.getMessage());  
                e.printStackTrace();  
            }  
        });  
    }  
}
```

<br>

> 📕 **EventDeliveryCallBack**

실질적으로 데이터를 받고 가공하는 로직을 여기에 작성하였습니다.

다른 로직은 볼 필요 없으며, DeliverCallBack 인터페이스를 구현하여 `handle()` 함수에 로직을 작성합니다.

```java
/**  
 * @author 신건우  
 * RabbitMQ Channel에서 받은 Event를 변환 후 21번 Tomcat 서버로 HTTP API 요청  
 * 이벤트 Label을 차량 (V), 사람 (P), 자전거 (B), 사람/자전거 (A)로 분류  
 * <p>  
 * RabbitMQ Queue Name = Instance Name과 동일함 -> Cam01  
 * Table Column Name = "B", "V", "P" 를 이름 뒤에 붙임  
 * Instance Wire Name = ex) Cam01-P01 , Cam01-B01, Cam01-V01  
 */
@Slf4j  
@Service  
@RequiredArgsConstructor  
public class EventDeliveryCallBack implements DeliverCallback {  
    private final RestApiService restApiService;  
    private final JsonParser jsonParser;  
    private final CountService countService;  
    private static final String IN = "IN";  
  
    @Override  
    public void handle(String consumerTag, Delivery message) throws IOException {  
        String routingKey = message.getEnvelope().getRoutingKey(); // RabbitMQ Topic과 동일함, Cvedia Instance 이름과 동일하게 설정  
        String msg = new String(message.getBody(), StandardCharsets.UTF_8);  
        Object dto = this.mapToDto(msg);  
  
        /**  
         * TODO 1: Event Data 변환 & API 전송 & H2 DB 저장  
         *     TODO 1-1: Event의 TimeStamp를 Asia/Seoul이 아닌 UTC로 변환  
         *     TODO 1-2: WireClass의 종류, Wire 이름 구하기  
         *     TODO 1-3: wireName에 맞는 Count 객체를 가져와 Count값을 증가시키기 위함  
         *     TODO 1-4: API를 요청할 때 RoutingKey 뒤에 각각 다른 문자 할당 + Count 수치 증가  
         * TODO 2: 받은 Event를 용도에 맞는 DTO로 매핑  
         * TODO 3: 시간을 iso8601 형식의 UTC로 변환 - 반환값 형식 : yyyy-mm-ddTHH:mm:ssZ  
         * TODO 4: WireClass에 따라 Routing Key에 다른 이니셜 붙임  
         * TODO 5: Cvedia에서 나온 수치들을 Request API를 위한 메세지에 매핑  
         * TODO 6: 이벤트 메시지 변환이 끝나고 마지막 API 요청으로 보낼 Body  
         */  
        if (dto instanceof TripwireDto event) {  
            String inOut = "Counter_01";  
  
            // TODO 1-1: Event의 TimeStamp를 Asia/Seoul이 아닌 UTC로 변환  
            String eventTime = convertEventTime(event.getSystem_timestamp()); // EventTime -> UTC Time  
  
            // TODO 1-2: WireClass의 종류, Wire 이름 구하기  
            String objectClass = event.getEvents().get(0).getExtra().getWireClass(); // Person, Vehicle(Bike, Car)  
            String lineName = event.getEvents().get(0).getExtra().getTripwire().getName(); // LineName = Cam01-A01, Cam01-A02  |  Cam02-V01, Cam02-V02  
            String lineLabel = lineName.substring(6, 7); // P or V or B or A  
            String newCameraNameForSaveH2DB = ""; // H2 DB & 뷰어에 저장될 새로운 카메라 이름  
  
            // TODO 1-3: wireName에 맞는 Count 객체를 가져와 Count값을 증가시키기 위함  
            Count count = null;  
            int i = Integer.parseInt(lineName.substring(7));  
            String num = "";  
  
            // TODO 1-4: API를 요청할 때 RoutingKey 뒤에 각각 다른 문자 할당 + Count 수치 증가  
            //  1번 조건문 : Bike + Person (A) Line에 "Person"이 카운팅 됐을 경우  
            //  2번 조건문 : Bike + Person (A) Line에 "Bike"가 카운팅 됐을 경우  
            //  3번 조건문 : Car Line에 "Car"가 카운팅 됐을 경우  
            //  4번 조건문 : "Person"만 카운팅하는 카메라의 경우  
            // ex) name|Counter_01/count|0/event|2023-11-30T11:11:11Z/CAMERA ID|Cam01-P01  
            if (lineLabel.equals("A") && objectClass.equals("Person")) {  
                if (i < 10) {  
                    num = "0" + i;  
                    newCameraNameForSaveH2DB = "NW01C0" + num;  
                } else {  
                    newCameraNameForSaveH2DB = "NW01C0" + i;  
                }  
                count = countService.getOne(newCameraNameForSaveH2DB);  
                count.setCount(count.getCount() + 1);  
  
            // ex) name|Counter_01/count|0/event|2023-11-30T11:11:11Z/CAMERA ID|Cam01-B01 //  
            } else if (lineLabel.equals("A") && objectClass.equals("Vehicle")) {  
                if (i < 10) {  
                    num = "0" + (i+1);  
                    newCameraNameForSaveH2DB = "NW01C0" + num;  
                } else {  
                    newCameraNameForSaveH2DB = "NW01C0" + (i + 1);  
                }  
                count = countService.getOne(newCameraNameForSaveH2DB);  
                count.setCount(count.getCount() + 1);  
            }  
  
            // ex) name|Counter_01/count|1/event|2023-11-30T11:11:11Z/CAMERA ID|Cam01-V01  
            else if (lineLabel.equals("V") && objectClass.equals("Vehicle")) {  
                if (i < 10) {  
                    num = "0" + i;  
                    newCameraNameForSaveH2DB = "NW01C0" + num;  
                } else {  
                    newCameraNameForSaveH2DB = "NW01C0" + i;  
                }  
                count = countService.getOne(newCameraNameForSaveH2DB);  
                count.setCount(count.getCount() + 1);  
            }  
  
            // ex) name|Counter_01/count|0/event|2023-11-30T11:11:11Z/CAMERA ID|Cam01-P01  
            else if (lineLabel.equals("P") && objectClass.equals("Person")) {  
                if (i < 10) {  
                    num = "0" + i;  
                    newCameraNameForSaveH2DB = "NW01C0" + num;  
                } else {  
                    newCameraNameForSaveH2DB = "NW01C0" + i;  
                }  
                count = countService.getOne(newCameraNameForSaveH2DB);  
                count.setCount(count.getCount() + 1);  
            }  
  
            countService.updateCount(count);  
            requestResultToApi(inOut, count.getCount(), eventTime, newCameraNameForSaveH2DB);  
            log.info("\uD83D\uDE2F\uD83D\uDE2F\uD83D\uDE2F\uD83D\uDE2F\uD83D\uDE2F : {}", newCameraNameForSaveH2DB);  
        }  
    }  
  
    /* -------------------- Util -------------------- */  
    // TODO 2: 받은 Event를 용도에 맞는 DTO로 매핑  
    private Object mapToDto(final String msg) {  
        Object msgObject = null;  
  
        try {  
            msgObject = jsonParser.mapJson(msg);  
        } catch (Exception e) {  
            log.error("[RabbitMQ Delivery] DTO Mapping 실패 - {}", e.getMessage());  
        }  
  
        return msgObject;  
    }  
  
    // TODO 3: 시간을 iso8601 형식의 UTC로 변환 - 반환값 형식 : yyyy-mm-ddTHH:mm:ssZ    
    private String convertEventTime(long time) {  
        return Instant.ofEpochSecond(time).atZone(ZoneId.of("UTC")).format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'"));  
    }  
  
    // TODO 4: WireClass에 따라 Routing Key에 다른 이니셜 붙임  
    private void requestResultToApi(String inOut, int count, String eventTime, String cameraName) {  
        String convertedMessage = convertResult(inOut, count, eventTime, cameraName);  
        String result = getBodyResult(convertedMessage);  
  
        restApiService.request(result);  
        log.info("[{}] 데이터 전송 - 방항: {}, 시간: {}", cameraName, IN, eventTime);  
    }  
  
    // TODO 5: Cvedia에서 나온 수치들을 Request API를 위한 메세지에 매핑  
    //  ex) name|Counter_01/count|0/event|2023-11-30T11:11:11Z/CAMERA ID|Cam01-B  
    private String convertResult(String inOut,  
                                 int count,  
                                 String eventTime,  
                                 String cameraName) {  
        return "name|" + inOut + "/" + "count|" + count + "/event|" + eventTime + "/" + "CAMERA ID|" + cameraName;  
    }  
  
    // TODO 6: 이벤트 메시지 변환이 끝나고 마지막 API 요청으로 보낼 Body    
    private String getBodyResult(String convertedMessage) {  
        return "--------------------------fc94942040fa9be1\n" +  
                "Content-Disposition: form-data; name=\"eventinfo\"\n" +  
                "Content-Type: text/plain\n\n" +  
                convertedMessage + "\n" +  
                "--------------------------fc94942040fa9be1--";  
    }  
}
```

<br>

> 📕 **EventCancelCallBack**

RabbitMQ의 데이터 Consume에 실패했을시 호출되는 콜백입니다.

```java
/**  
 * @author 신건우  
 * RabbitMQ Channel Consume이 취소 됬을때 호출되는 콜백  
 */  
@Slf4j  
@Service  
public class EventCancelCallBack implements CancelCallback {  
    @Override  
    public void handle(String consumerTag) throws IOException {  
        log.warn("RabbitMQ Consumer Canceled - {}", consumerTag);  
    }  
}
```

<br>

> 📕 **EventThread**

RabbitMQ 채널을 별도의 스레드로 실행시키기 위한 EventThread 입니다.

```java
/**  
 * @author 신건우  
 * Consume RabbitMQ Channel  
 */
 @Slf4j  
@AllArgsConstructor  
public class EventThread extends Thread {  
    private RabbitService rabbitService;  
    private Channel channel;  
    private String queueName;  
  
    @Override  
    public void run() {  
        rabbitService.listen(channel, queueName);  
        log.info("RabbitMQ Channel {} Thread Start", channel.getChannelNumber());  
    }  
}
```

---

## 📘 Util

> 📕 **RestApiService**

Spring WebClient를 이용해 Request를 Block 하지 않고 Subscribe하여 Async한 Request를 보내는 Service입니다.

```java
/**  
 * @author 신건우  
 * Spring WebClient를 이용한 Async Rest API Service  
 */
@Slf4j  
@Service  
@RequiredArgsConstructor  
public class RestApiService {  
    private final WebClient webClient;  
    private final Props props;  
  
    // TODO 1: 7번서버 Tomcat - CameraVcasysDataInpController.wd로 요청  
    public void request(String data) {  
//        CountDownLatch latch = new CountDownLatch(1);  
  
        Flux.just(0)  
                .flatMap(i -> {  
                    return webClient.post()  
                            .uri(props.getRequestUrl())  
                            .contentType(MediaType.TEXT_PLAIN)  
                            .body(BodyInserters.fromValue(data))  
                            .retrieve()  
                            .bodyToMono(Void.class)  
                            .onErrorResume(e -> {  
                                log.error("Request API Failed : {}", e.getMessage());  
                                return Mono.error(e);  
                            });  
                }).subscribe(response -> {  
                    log.info("API Request - Success");  
                });  
    }  
  
    // TODO 2: Cvedia Instance Health Check API  
    public Mono<String> getRequest(final String uri) {  
        return webClient.get().uri(uri).retrieve().bodyToMono(String.class);  
    }  
  
    public Mono<String> postRequest(final String uri, final Object data) {  
        return webClient.post().uri(uri).bodyValue(data).retrieve().bodyToMono(String.class);  
    }  
}
```

<br>

> 📕 **JsonParser**

RabbitMQ의 Queue에서 나온Json 규격에 맞는 DTO를 파싱하는 서비스입니다.

JsonNode의 Depth에 있는 필드에 따라 다른 DTO로 변환합니다.

```java
/**  
 * @author 신건우  
 * Json Parsing Service  
 */@Slf4j  
@Service  
@RequiredArgsConstructor  
public class JsonParser {  
    private final ObjectMapper mapper;  
  
    public Object mapJson(String data) throws Exception {  
        if (data == null || data.isEmpty()) {  
            throw new IllegalAccessException("Json is Empty");  
        }  
  
        JsonNode rootNode = mapper.readTree(data);  
        JsonNode classNode = rootNode.path("events");  
  
        // Event 노드가 존재하면 SecuRT Event        
        if (!classNode.isMissingNode()) {  
            JsonNode imgNode = classNode.get(0).path("image");  
            JsonNode subClassNode = classNode.get(0).path("extra").path("class");  
  
            // Event 노드 중 class가 있으면 SecuRT - Tripwire Event            
            if (!subClassNode.isMissingNode()) {  
                return this.parseTripwireEvent(data);  
            }  
            // Event 노드 중 class가 없으면 SecuRT - Area Crowd Event            
            else {  
                // class가 없는 데이터 중 image 필드가 존재하면 SecuRT - Area Crowd (Image) Event      
                if (!imgNode.isMissingNode()) {  
                    return this.parseCrowdImageEvent(data);  
                } else {  
                    return this.parseCrowdEvent(data);  
                }  
            }  
        }  
        // Event 노드가 없으면 Estimation Event        else {  
            return this.parseEstimationEvent(data);  
        }  
    }  
  
    /* ------------------------------ 각 Event별 Parsing ------------------------------ */    private TripwireDto parseTripwireEvent(final String data) {  
        TripwireDto tripwireDto = null;  
  
        try {  
            tripwireDto = mapper.readValue(data, TripwireDto.class);  
        } catch (JsonMappingException e) {  
            log.error("[Json] Tripwire 파싱 실패 with JsonMappingException - {}", e.getMessage());  
        } catch (JsonProcessingException e) {  
            log.error("[Json] Tripwire 파싱 실패 with JsonProcessingException - {}", e.getMessage());  
        }  
  
        return tripwireDto;  
    }  
  
    private AreaCrowdDto parseCrowdEvent(final String data) {  
        AreaCrowdDto areaCrowdDto = null;  
  
        try {  
            areaCrowdDto = mapper.readValue(data, AreaCrowdDto.class);  
        } catch (JsonMappingException e) {  
            log.error("[Json] AreaCrowd 파싱 실패 with JsonMappingException - {}", e.getMessage());  
        } catch (JsonProcessingException e) {  
            log.error("[Json] AreaCrowd 파싱 실패 with JsonProcessingException - {}", e.getMessage());  
        }  
  
        return areaCrowdDto;  
    }  
  
    private AreaCrowdImageDto parseCrowdImageEvent(final String data) {  
        AreaCrowdImageDto areaCrowdImageDto = null;  
  
        try {  
            areaCrowdImageDto = mapper.readValue(data, AreaCrowdImageDto.class);  
        } catch (JsonMappingException e) {  
            log.error("[Json] AreaCrowdImage 파싱 실패 with JsonMappingException - {}", e.getMessage());  
        } catch (JsonProcessingException e) {  
            log.error("[Json] AreaCrowdImage 파싱 실패 with JsonProcessingException - {}", e.getMessage());  
        }  
  
        return areaCrowdImageDto;  
    }  
  
    private EstimationDto parseEstimationEvent(final String data) {  
        EstimationDto estimationDto = null;  
  
        try {  
            estimationDto = mapper.readValue(data, EstimationDto.class);  
        } catch (JsonMappingException e) {  
            log.error("[Json] Estimation 파싱 실패 with JsonMappingException - {}", e.getMessage());  
        } catch (JsonProcessingException e) {  
            log.error("[Json] Estimation 파싱 실패 with JsonProcessingException - {}", e.getMessage());  
        }  
  
        return estimationDto;  
    }  
}
```

---

## 📘 HealthCheck Thread

AI Engine의 분석 Instance가 죽으면 특정 sec마다 자동으로 재실행 시키는 API 요청을 보내는 데몬스레드입니다.

```java
/**  
 * @author 신건우  
 * Cvedia Instance Health Check Thread  
 * Status 4 = 실행중, 나머지는 실행중이 아님  
 */  
@Slf4j  
@Service  
@RequiredArgsConstructor  
public class InstanceHealthCheck extends Thread {  
    private final TaskExecutor healthCheckExecutor;  
    private final ObjectMapper mapper;  
    private final RestApiService restApiService;  
    private final Props props;  
  
    @PostConstruct  
    public void init() {  
        this.monitoringInstanceConnection();  
    }  
  
    @Override  
    public void run() {  
        while (true) {  
            props.getInstances().stream().forEach(name -> {  
                try {  
                    String uri = props.getCvediaUrl() + "/api/instance/get?instance_name=" + name;  
                    String instanceStatement = restApiService.getRequest(uri).block();  
                    InstanceDto[] instances = mapper.readValue(instanceStatement, InstanceDto[].class);  
  
                    if (instances != null && instances.length > 0) {  
                        Arrays.stream(instances).forEach(instance -> {  
  
                            if (instance.getState() == 4) {  
                                log.info("Instance 상태 : 실행 중");  
                            }  
  
                            if (instance.getState() == 0 || instance.getState() == 1 || instance.getState() == 3 || instance.getState() == 5) {  
                                String startUri = props.getCvediaUrl() + "/api/instance/start";  
  
                                InstanceDto requestBody = new InstanceDto();  
                                requestBody.setInstanceName(instance.getInstanceName());  
                                requestBody.setSolution(instance.getSolution());  
  
                                try {  
                                    String requestBodyStr = mapper.writeValueAsString(requestBody);  
                                    restApiService.postRequest(startUri, requestBodyStr).block();  
  
                                    log.info("Instance 시작 - 인스턴스 이름 : {}", requestBody.getInstanceName());  
                                } catch (Exception e) {  
                                    log.error("Instance 시작 실패 with Exception : {}", e.getMessage());  
                                }  
                            }  
                        });  
                    }  
                } catch (Exception e) {  
                    log.warn("Instance Monitoring Failed with an Exception : {}", e.getMessage());  
                }  
            });  
  
            try {  
                Thread.sleep(10000);  
            } catch (InterruptedException e) {  
                log.info("===== Instance Health Check Thread 종료 =====");  
            }  
        }  
    }  
  
    private void monitoringInstanceConnection() {  
        this.setUncaughtExceptionHandler((t, e) -> {  
            log.error("Instance Health Check Thread - 치명적인 오류 발생 : {}", e.getMessage());  
        });  
        this.setDaemon(true);  
        healthCheckExecutor.execute(this);  
    }  
}
```