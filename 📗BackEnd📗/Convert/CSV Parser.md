## 📘 Parsing CSV

샘플 CSV 파일을 Spring에서 Parsing 해보겠습니다.

<br>

**Sample CSV File**

```
7,0,0,C:/Users/root/Desktop/Tools/Cvedia-2023.4.0/files/instances/My Instances/OutputTest.json,Thu Aug 17 09:17:39 2023,1692231459,
7,1,0.0333,C:/Users/root/Desktop/Tools/Cvedia-2023.4.0/files/instances/My Instances/OutputTest.json,Thu Aug 17 09:17:39 2023,1692231459,
7,2,0.0667,C:/Users/root/Desktop/Tools/Cvedia-2023.4.0/files/instances/My Instances/OutputTest.json,Thu Aug 17 09:17:39 2023,1692231459,
```

<br>

> 😯 **JPA Entity**

**CSV의 식별자인 frame_id는 JPA에서 Auto Increment로 숫자가 자동으로 들어가기 때문에 생성자에서 빼줍니다.**

```java
@Entity @Getter  
@NoArgsConstructor(access = AccessLevel.PROTECTED)  
public class Frame {  
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)  
    @Column(name = "frame_id")  
    private Long id;  
    private int count;  
    private Float frameTime;  
    private String instanceId;  
  
    @Column(nullable = true)  
    private LocalDateTime systemDate;  
  
    @Column(nullable = true)  
    private Long systemTimestamp;  
  
    private Frame(int count, Float frameTime, String instanceId, LocalDateTime systemDate, Long systemTimestamp) {  
        this.count = count;  
        this.frameTime = frameTime;  
        this.instanceId = instanceId;  
        this.systemDate = systemDate;  
        this.systemTimestamp = systemTimestamp;  
    }  
  
    public static Frame createOf(int count, Float frameTime, String instanceId, LocalDateTime systemDate, Long systemTimestamp) {  
        return new Frame(count, frameTime, instanceId, systemDate, systemTimestamp);  
    }  
}
```

<br>

> 😯 **FrameRepository**

설명은 생략합니다.

```java
public interface FrameRepository extends JpaRepository<Frame, Long> {}
```

<br>

> 😯 **Parser** 

Service 만들어 RestAPI 요청을 보내면, 프로잭트 내부의 `sample/test.csv`를 읽어 각각의 필드에 맞게 매핑하는 방식입니다.

- `@Transactional`을 사용하여 변환이 실패하면 데이터 일관성 유지를 위해 트랜잭션을 롤백 시킵니다.
- CSV의 첫 행은 Header이기 때문에 For 문을 돌때 0번 라인은 스킵하고 1번부터 Loop를 돌아야 합니다.
- Sample CSV는 ","으로 분리되어 있기 때문에 ","로 Split해서 배열에 넣어줍니다.
- Date의 형식이 `Thu Aug 17 09:17:41 2023` 형식으로 CSV에 저장 되어 있어서 DateFormatter를 사용하였습니다.
- String 타입이 아닌건 전부 형변환 후 인덱스와 생성자의 자리에 맞게 변환 후 엔티티화 해줍니다.
- 엔티티들을 리스트에 넣고 데이터베이스에 저장합니다.

```java
@Component  
@RequiredArgsConstructor  
public class Parser {  
    private final FrameRepository frameRepository;  
    private final Logger log = LoggerFactory.getLogger(Parser.class);  
  
    /**  
     * 변환, 리스트 저장 실패 시 트랜잭션 롤백  
     */  
    @PostConstruct  
    @Transactional    
    public void initData() {  
        // 임시로 로컬에서 CSV를 읽어옴  
        Resource resource = new ClassPathResource("sample/test.csv");  
  
        try {  
            List<String> lines = Files.readAllLines(Paths.get(resource.getFile().getPath()), StandardCharsets.UTF_8);  
            List<Frame> list = new ArrayList<>();  
  
            // CSV의 첫 행은 헤더이기 때문에 0번쨰 인덱스 스킵  
            for (int i=1; i<lines.size(); i++) {  
                String[] split = lines.get(i).split(",");  
  
                // CSV 파일의 값중 String이 아닌 값들의 타입 변환 준비  
                int count;  
                float frameTime;  
                long systemTimestamp;  
                LocalDateTime systemDate;  
                DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss yyyy", Locale.ENGLISH);  
                String dateString = split[4];  
  
                try {  
                    // Count 변환  
                    count = Integer.parseInt(split[0]);  
  
                    // Frame Time 변환  
                    Float frameValue = Float.parseFloat(split[2]);  
                    frameTime = Float.parseFloat((String.format("%.4f", frameValue))); // 소수점 4자리 까지만  
  
                    // System TimeStamp 변환  
                    systemTimestamp = Long.parseLong(split[5]);  
  
                    // System Date 날짜 변환  
                    systemDate = LocalDateTime.parse(dateString, dateFormat);  
                } catch (Exception e) {  
                    log.error("CSV 데이터 변환 실패");  
                    throw new CommonException("DATA-003", HttpStatus.BAD_REQUEST);  
                }  
  
                // Entity 생성  
                Frame frame = Frame.createOf(  
                        count,  
                        frameTime,  
                        split[3],  
                        systemDate,  
                        systemTimestamp  
                );  
  
                list.add(frame);  
            }  
  
            // 리스트에 Entity 추가  
            try {  
                frameRepository.saveAll(list);  
            } catch (Exception e) {  
                log.error("Entity List 저장 실패");  
                throw new CommonException("DATA-002", HttpStatus.BAD_REQUEST);  
            }  
  
        } catch (IOException e) {  
            log.error("데이터 파싱 실패");  
            throw new CommonException("DATA-001", HttpStatus.BAD_REQUEST);  
        }  
    }  
}
```

<br>

**결과**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/csv.png)

<br>

**다른 Date Format을 쓰는 방법**

```java
SimpleDateFormat dateFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss yyyy");  
Date date = dateFormat.parse(dateString);  
systemDate = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
```

<br>

파싱 테스트로 아주 간단하게만 구현해보았지만 나중에 Spring Batch를 이용해 주기적으로 특정 디렉토리의 파일들을 읽어서. 

자동으로 파싱 후 DB저장 데이터 추가 시 Reactive하게 프론트엔드의 Time Graph를 변환시키는 내용을 추가해보겠습니다.
