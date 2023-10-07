## 📘 Parse Json

복잡한 구조의 Json 데이터를 Parsing 해서 JVM 기반의 객체로 변환하는 방법을 작성합니다.

---

## 📘 Sample Json Data

아래 샘플 데이터는 3개의 Json 객체가 들어있는 샘플 파일의 내용입니다.

<br>

**이 Json 객체들이 들어있는 샘플 파일은 2가지의 문제점이 있습니다.**

- 객체들이 배열로 감싸져 있지 않다는 점
- 1개의 객체가 끝나고 `,`로 구분이 되어 있지 않고 개행으로만 구분이 되어 있다는 점

<br>

일단 이 데이터는 직접 보기 번거로우니 아래 객체 1개만 분리해서 정리 해놓은 Json 데이터를 보겠습니다.

```json
{"events":[{"extra":{"bbox":{"height":0.09538894146680832,"width":0.020211786031723022,"x":0.8141869902610779,"y":0.43013182282447815},"class":"Person","count":1,"track_id":"PersonTracker_33","tripwire":{"check_anchor_point":"bottom_center","color":[0,0,1,1],"crowding_min_count":4,"detect_animals":true,"detect_people":true,"detect_unknowns":false,"detect_vehicles":true,"direction":"Both","groupby":"tripwire_crossing","id":"b9c8af94-f8b0-4c20-8b64-a2eea8a30e2e","ignore_stationary_objects":true,"inference_strategy":"full_frame","name":"Wire 1","restrict_vehicle_type":false,"timestamp":1691566866432.0,"trigger_crossing":true,"trigger_crowding":false,"trigger_loitering":false,"trigger_on_enter":false,"trigger_on_exit":false,"vertices":[{"x":0.8115726709365845,"y":0.5092348456382751},{"x":0.9272996783256531,"y":0.5620052814483643},{"x":0.43175074458122253,"y":0.8390501141548157},{"x":0.7270029783248901,"y":0.9525066018104553}]}},"id":"881671fa-83dd-4027-a3ad-9c53576cab54","label":"Tripwire crossed","type":"tripwire_crossing"}],"frame_id":429,"frame_time":14.3,"system_date":"Wed Aug  9 17:20:00 2023","system_timestamp":1691569200}  
{"events":[{"extra":{"bbox":{"height":0.11692357808351517,"width":0.028519250452518463,"x":0.8249245285987854,"y":0.4926007390022278},"class":"Person","count":2,"track_id":"PersonTracker_45","tripwire":{"check_anchor_point":"bottom_center","color":[0,0,1,1],"crowding_min_count":4,"detect_animals":true,"detect_people":true,"detect_unknowns":false,"detect_vehicles":true,"direction":"Both","groupby":"tripwire_crossing","id":"b9c8af94-f8b0-4c20-8b64-a2eea8a30e2e","ignore_stationary_objects":true,"inference_strategy":"full_frame","name":"Wire 1","restrict_vehicle_type":false,"timestamp":1691566866432.0,"trigger_crossing":true,"trigger_crowding":false,"trigger_loitering":false,"trigger_on_enter":false,"trigger_on_exit":false,"vertices":[{"x":0.8115726709365845,"y":0.5092348456382751},{"x":0.9272996783256531,"y":0.5620052814483643},{"x":0.43175074458122253,"y":0.8390501141548157},{"x":0.7270029783248901,"y":0.9525066018104553}]}},"id":"123af068-b774-48c9-92cc-523fba2ce1e9","label":"Tripwire crossed","type":"tripwire_crossing"}],"frame_id":590,"frame_time":19.666666666666668,"system_date":"Wed Aug  9 17:20:07 2023","system_timestamp":1691569207}  
{"events":[{"extra":{"bbox":{"height":0.2726112902164459,"width":0.057636808604002,"x":0.669583797454834,"y":0.6824167966842651},"class":"Person","count":3,"track_id":"PersonTracker_43","tripwire":{"check_anchor_point":"bottom_center","color":[0,0,1,1],"crowding_min_count":4,"detect_animals":true,"detect_people":true,"detect_unknowns":false,"detect_vehicles":true,"direction":"Both","groupby":"tripwire_crossing","id":"b9c8af94-f8b0-4c20-8b64-a2eea8a30e2e","ignore_stationary_objects":true,"inference_strategy":"full_frame","name":"Wire 1","restrict_vehicle_type":false,"timestamp":1691566866432.0,"trigger_crossing":true,"trigger_crowding":false,"trigger_loitering":false,"trigger_on_enter":false,"trigger_on_exit":false,"vertices":[{"x":0.8115726709365845,"y":0.5092348456382751},{"x":0.9272996783256531,"y":0.5620052814483643},{"x":0.43175074458122253,"y":0.8390501141548157},{"x":0.7270029783248901,"y":0.9525066018104553}]}},"id":"03fcdac4-3b3e-41af-a265-8689eadfe29d","label":"Tripwire crossed","type":"tripwire_crossing"}],"frame_id":614,"frame_time":20.466666666666665,"system_date":"Wed Aug  9 17:20:08 2023","system_timestamp":1691569208}
```

아래 코드는 위 3개의 객체 중 1개의 Json 객체만 따로 빼온 것입니다.

이 샘플 데이터의 필드 중, 임의로 필요한 필드를 고른 후 

Json 객체들을 돌면서, 필요한 필드들을 뽑아 JPA Entity로 파싱해 보겠습니다.

<br>

_필요한 필드_

- 데이터 최상단의 `frame_id`
- events 배열 하위의 extra 하위의 bbox의 `height`, `width`, `x`, `y` 4개 필드
- event 배열 하위의 exra 하위의 tripwire 하위의 vertices 배열 내부에 있는 `x`, `y`의 리스트들

총 6개의 필드를 뽑아 JPA Entity로 파싱해 보겠습니다.

샘플 Json 데이터의 Json 객체는 3개이니 JPA Entity도 3개를 만들고, 각 Entity당 6개의 필드 데이터를 가질겁니다.

```json
{  
  "events": [  
    {  
      "extra": {  
        "bbox": {  
          "height": 0.1276407390832901,  
          "width": 0.02904696948826313,  
          "x": 0.6992628574371338,  
          "y": 0.43387532234191895  
        },  
        "class": "Person",  
        "count": 2,  
        "crossing_direction": "down",  
        "external_id": "4e9ea30a-86a1-4c5d-a485-17a598f83c3b",  
        "track_id": "PersonTracker_42",  
        "tripwire": {  
          "check_anchor_point": "bottom_center",  
          "color": [  
            0,  
            0,  
            1,  
            1  
          ],  
          "cooldown_bandwidth": 0.07000000029802322,  
          "cross_bandwidth": 0.029999999329447746,  
          "crowding_min_count": 4,  
          "detect_animals": true,  
          "detect_people": true,  
          "detect_unknowns": false,  
          "detect_vehicles": true,  
          "direction": "Both",  
          "groupby": "tripwire_counting",  
          "id": "91c21599-1d71-4455-a1d4-0fd2e9d70cf6",  
          "ignore_stationary_objects": true,  
          "inference_strategy": "full_frame",  
          "name": "Wire-Test",  
          "restrict_object_max_size": false,  
          "restrict_object_min_size": false,  
          "restrict_person_attributes": false,  
          "restrict_vehicle_type": false,  
          "timestamp": 1694047141888.0,  
          "trigger_crossing": true,  
          "trigger_crowding": false,  
          "trigger_loitering": false,  
          "trigger_on_enter": false,  
          "trigger_on_exit": false,  
          "vertices": [  
            {  
              "x": 0.7106109261512756,  
              "y": 0.5444126129150391  
            },  
            {  
              "x": 0.9437298774719238,  
              "y": 0.6217765212059021  
            }  
          ]  
        }  
      },  
      "id": "057baaa0-94c4-432f-8051-a5615f34b980",  
      "label": "Tripwire crossed",  
      "type": "tripwire_crossing"  
    }  
  ],  
  "frame_id": 739,  
  "frame_time": 24.633333333333333,  
  "system_date": "Thu Sep 7 09:42:26 2023",  
  "system_timestamp": 1694047346  
}
```

---

## 📘 Entity & Repository

> 😯 **Message Entity**

필요한 필드가 전부 소수점을 가진 숫자여서 Double로 주고 필드들과 생성자를 만들었습

```java
@Entity  
@Getter @Setter  
@NoArgsConstructor(access = AccessLevel.PROTECTED)  
public class Message {  
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)  
    @Column(name = "message_id")  
    private Long id;  
    private Double frameId;  
    private Double bboxHeight;  
    private Double bboxWidth;  
    private Double bboxX;  
    private Double bboxY;  
  
    @OneToMany(mappedBy = "message", cascade = CascadeType.ALL, orphanRemoval = true)  
    private List<Vertice> vertices = new ArrayList<>();  
  
    private Message(Double frameId, Double bboxHeight, Double bboxWidth, Double bboxX, Double bboxY, List<Vertice> vertices) {  
        this.frameId = frameId;  
        this.bboxHeight = bboxHeight;  
        this.bboxWidth = bboxWidth;  
        this.bboxX = bboxX;  
        this.bboxY = bboxY;  
        this.vertices = vertices;  
    }  
  
    public static Message createOf(Double frameId, Double bboxHeight, Double bboxWidth, Double bboxX, Double bboxY, List<Vertice> vertices) {  
        return new Message(frameId, bboxHeight, bboxWidth, bboxX, bboxY, vertices);  
    }  
}
```

---

데이터를 파싱해

```java
@Slf4j  
@Service  
@Transactional  
@RequiredArgsConstructor  
public class MessageService {  
    private final MessageRepository messageRepository;  
    private final VerticeRepository verticeRepository;  
  
    public List<MessageDto.Response> parseJson() throws Exception {  
        List<JsonNode> jsonList = new ArrayList<>();  
        ObjectMapper objectMapper = new ObjectMapper();  
  
//        String jsonContent = new String(Files.readAllBytes(Paths.get("C:\\Users\\root\\Desktop\\Tools\\Cvedia\\files\\output\\eventsExport.json")));  
  
        // 프로젝트 내부 Sample 디렉터리의 샘플 Json 파일을 가져옵니다.  
        ClassPathResource resource = new ClassPathResource("sample/test.json");  
  
        // 파일에서 Json 데이터를 읽어 들여 String 값으로 변환합니다.  
        String jsonContent = Files.readString(Paths.get(resource.getURI()));  
  
        // 샘플 파일의 Json 객체들은 개행으로 구분되어 있어서 개행을 기준으로 객체들을 String 배열에 담습니다.  
        String[] splitJson = jsonContent.split("\n");  
  
        // 객체 분리가 되어 String 배열에 담긴 데이터들을 JsonNode 타입의 리스트에 담습니다.  
        for (String json : splitJson) {  
            JsonNode jsonObject = objectMapper.readTree(json);  
            jsonList.add(jsonObject);  
        }  
  
        /* Json 배열을 돌기 전, 필요한 변수들을 선언해 줍니다. */  
        Double frameId = null, bboxHeight = null, bboxWidth = null, bboxX = null, bboxY = null;  
        List<Message> messageList = new ArrayList<>();  
  
        // JsonNode List를 돌며 Json 객체들 1개씩 돌며, 필요한 필드를 추출해 Entity의 필드에 넣고 저장합니다.  
        for (JsonNode node : jsonList) {  
  
            // Json의 구조 중 최상단에 위치한 frame_id를 변수에 넣어줍니다.  
            frameId = node.get("frame_id").asDouble();  
  
            // 최상단의 바로 밑은 event 배열이 있습니다. event 배열을 순회합니다.  
            JsonNode eventArray = node.get("events");  
  
            if (eventArray != null && eventArray.isArray()) {  
                for (JsonNode event : eventArray) {  
  
                    // event -> extra -> bbox의 4개 값들을 변수에 넣어줍니다.  
                    JsonNode bbox = event.get("extra").get("bbox");  
                    if (bbox != null) {  
                        bboxHeight = bbox.get("height").asDouble();  
                        bboxWidth = bbox.get("width").asDouble();  
                        bboxX = bbox.get("x").asDouble();  
                        bboxY = bbox.get("y").asDouble();  
                    }  
                }  
            }  
  
            // 위에서 얻은 값들로 엔티티 생성  
            Message message = Message.createOf(  
                    frameId,  
                    bboxHeight,  
                    bboxWidth,  
                    bboxX,  
                    bboxY,  
                    null  
            );  
  
            // Vertice리스트를 verticeList 변수에 넣습니다.  
            List<Vertice> vertices = getVertices(eventArray, message);  
  
            message.setVertices(vertices);  
            messageList.add(message);  
              
            // 메시지 저장  
            try {  
                messageRepository.save(message);  
            } catch (Exception e) {  
                log.error("Message 객체 저장 실패 - {}", e.getMessage());  
                throw new CommonException("Message-001", HttpStatus.INTERNAL_SERVER_ERROR);  
            }  
  
            // Vertice 저장  
            try {  
                verticeRepository.saveAll(vertices);  
            } catch (Exception e) {  
                log.error("Message 객체 저장 실패 - {}", e.getMessage());  
                throw new CommonException("Message-001", HttpStatus.INTERNAL_SERVER_ERROR);  
            }  
  
            // 변수 초기화  
            frameId = null;  
            bboxHeight = null;  
            bboxWidth = null;  
            bboxX = null;  
            bboxY = null;  
        }  
  
        log.info("Json 객체 데이터 파싱 완료");  
        return messageList.stream().map(MessageDto.Response::fromEntity).collect(Collectors.toList());  
    }  
  
    // Json 데이터 값 중 events 배열을 받아 event를 돌면서 Vertice 객체들을 빼냅니다.  
    public List<Vertice> getVertices(JsonNode eventArray, Message message) {  
        List<Vertice> verticeList = new ArrayList<>();  
  
        if (eventArray != null && eventArray.isArray()) {  
            for (JsonNode event : eventArray) {  
                // Vertices 를 구합니다.  
                JsonNode vertices = event.get("extra").get("tripwire").get("vertices");  
  
                if (vertices != null && vertices.isArray() && vertices.size() > 0) {  
                    for (JsonNode vertice : vertices) {  
                        // Vertice 엔티티를 생성해 x,y 값을 넣어줍니다.  
                        Vertice verticeEntity = Vertice.createOf(  
                                vertice.get("x").asDouble(),  
                                vertice.get("y").asDouble()  
                        );  
                        verticeEntity.setMessage(message);  
  
                        // Vertice 리스트에 객체를 추가합니다.  
                        verticeList.add(verticeEntity);  
                    }  
                }  
            }  
        }  
  
        return verticeList;  
    }  
}
```