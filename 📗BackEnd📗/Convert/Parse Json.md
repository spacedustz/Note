## 📘 Parse Json

복잡한 구조의 Json 데이터를 Parsing 해서 JVM 기반의 객체로 변환하는 방법을 작성합니다.

<br>

> 😯 **Sample Json Data**

이 샘플 데이터의 필드 중, **system_data**, **crossing_direction** 2개의 필드만 필요하다고 가정하고,

2개의 필드만 뽑아 JPA Entity로 파싱해 보겠습니다.

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

<br>

> **Message DTO**

```java
@Service  
@Transactional  
@RequiredArgsConstructor  
public class EventService {  
  
    private final EventRepository eventRepository;  
    private final ExtraRepository extraRepository;  
    private final BboxRepository bboxRepository;  
    private final VerticeRepository verticeRepository;  
  
    public List<EventDTO.Response> parseJson() throws Exception {  
        List<Event> eventList = new ArrayList<>();  
        List<JsonNode> rootNode = new ArrayList<>();  
        ObjectMapper objectMapper = new ObjectMapper();  
  
        // Json 파일 받아서 객체 배열로 분리  
//        String jsonContent = new String(Files.readAllBytes(Paths.get("C:\\Users\\root\\Desktop\\Tools\\Cvedia\\files\\output\\eventsExport.json")));  
        ClassPathResource resource = new ClassPathResource("test.json");  
  
        String jsonContent = Files.readString(Paths.get(resource.getURI()));  
        String[] splitJson = jsonContent.split("\n");  
  
        for (String json : splitJson) {  
            JsonNode jsonObject = objectMapper.readTree(json);  
            rootNode.add(jsonObject);  
        }  
  
        // 분리된 Json 객체마다 반복  
        for (JsonNode node : rootNode) {  
  
            // Event의 FrameId 삽입  
            Event event = new Event();  
            event.setFrameId(node.get("frame_id").asDouble());  
  
            JsonNode eventsArray = node.get("events");  
  
            if (eventsArray != null && eventsArray.isArray()) {  
                for (JsonNode eventNode : eventsArray) {  
                    Extra extra = new Extra();  
                    JsonNode extraNode = eventNode.get("extra");  
  
                    // Bbox 매핑  
                    JsonNode bbox = extraNode.get("bbox");  
                    if (bbox != null) {  
                        Bbox bboxEntity = Bbox.createOf(  
                                bbox.get("height").asDouble(),  
                                bbox.get("width").asDouble(),  
                                bbox.get("x").asDouble(),  
                                bbox.get("y").asDouble()  
                        );  
                        bboxRepository.save(bboxEntity);  
                        extra.setBbox(bboxEntity);  
                    }  
  
                    // Vertices 매핑  
                    JsonNode vertices = extraNode.get("tripwire").get("vertices");  
                    List<Vertice> verticeList = new ArrayList<>();  
  
                    if (vertices != null && vertices.isArray() && vertices.size() > 0) {  
  
                        for (JsonNode vertice : vertices) {  
                            if (vertice != null) {  
                                Vertice verticeEntity = Vertice.createOf(  
                                        vertice.get("x").asDouble(),  
                                        vertice.get("y").asDouble()  
                                );  
                                verticeRepository.save(verticeEntity);  
                                verticeList.add(verticeEntity);  
                            }  
                        }  
                        extra.setVertices(verticeList);  
                    }  
                    extraRepository.save(extra);  
                    event.setExtra(extra);  
                }  
            }  
            eventRepository.save(event);  
            eventList.add(event);  
        }  
        System.out.println("Event List : " + eventList);  
  
        return eventList.stream().map(EventDTO.Response::fromEntity).collect(Collectors.toList());  
    }  
}
```