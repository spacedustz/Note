## 📘 RabbitMQ with MultiThreading

단일 서버의 RabbitMQ  Connection을 맺을때 RabbitConfig를 작성해서 했었는데,

이번은 여러서버에 분산된 RabbitMQ를 클러스터링 하지않고 Spring Boot 서버에서 멀티스레딩으로,

각각의 RabbitMQ Connection Factory에 연결하여 데이터를 받아 보겠습니다.

<br>

이번에는 Queue에서 바로 데이터를 Receive 하지 않습니다.

- 각 서버당 RabbitMQ Connection을 ConcurrentHashMap에 넣어 연결
- 연결된 RabbitMQ의 Queue 개수에 맞는 RabbitMQ Channel을 생성해 별개의 스레드로 실행하여 데이터 Consume

---

## 📘 Channel Consume

RabbitMQ의 Chann

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