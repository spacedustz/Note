## Level 값 변경

```java
zone.setLevel((int) Math.floor(personCount/zone.getArea()));
```

---

## RabbitMqService

> if (msgObject != null) 로직에 추가

```java
else if (msgObject instanceof SecuRTAreaOccupancyEnterEventDto) {  
  List<SecuRTAreaOccupancyEnterEventDto.Event> eventList = ((SecuRTAreaOccupancyEnterEventDto) msgObject).getEvents();  
  
  for (int i = 0; i < eventList.size(); i++) {  
    personCount = eventList.get(i).getExtra().getCurrentEntries();  
  }  
  log.debug("SecuRTAreaOccupancyEnterEventDto");  
} else if (msgObject instanceof SecuRTAreaOccupancyExitEventDto) {  
  List<SecuRTAreaOccupancyExitEventDto.Event> eventList = ((SecuRTAreaOccupancyExitEventDto) msgObject).getEvents();  
  
  for(int i=0;i<eventList.size();i++){  
    personCount = eventList.get(i).getExtra().getCurrentEntries();  
  }  
  log.debug("SecuRTAreaOccupancyExitEventDto");  
  
}
```

---

## JsonParsingService

> if (!classNode.isMissingNode()) 에 추가

```java
JsonNode subClassNode2 = classNode.get(0).path("extra").path("external_id");  
JsonNode subClassNode3 = classNode.get(0).path("extra").path("external_track_id_left");  
  
if (!subClassNode2.isMissingNode()) {  
  SecuRTAreaOccupancyEnterEventDto secuRTAreaOccupancyEnterEventDto = this.parsingSecuRtAreaOccupancyEnterEvent(jsonString);  
  
  return secuRTAreaOccupancyEnterEventDto;  
} else if (!subClassNode3.isMissingNode()) {  
  SecuRTAreaOccupancyExitEventDto secuRTAreaOccupancyExitEventDto =  this.parsingSecuRtAreaOccupancyExitEvent(jsonString);  
  
  return secuRTAreaOccupancyExitEventDto;  
}
```

> 함수 2개 추가

```java
/**  
 * SecuRT Area Occupancy Enter 이벤트 파싱  
 *  
 * @param jsonString  
 * @return  
 */  
private SecuRTAreaOccupancyEnterEventDto parsingSecuRtAreaOccupancyEnterEvent(final String jsonString){  
  SecuRTAreaOccupancyEnterEventDto secuRTAreaOccupancyEnterEventDto = null;  
  
  try {  
    secuRTAreaOccupancyEnterEventDto = objectMapper.readValue(jsonString, SecuRTAreaOccupancyEnterEventDto.class);  
  }catch (JsonProcessingException jsonProcessingException){  
    log.warn("SecuRTAreaOccupancyEnterEventDto jsonProcessingException:{}", jsonProcessingException.getMessage());  
  }catch (Exception exception){  
    log.warn("SecuRTAreaOccupancyEnterEventDto jsonProcessingException:{}", exception.getMessage());  
  }  
  
  return secuRTAreaOccupancyEnterEventDto;  
  
}  
  
/**  
 * SecuRT Area Occupancy Exit 이벤트 파싱  
 *  
 * @param jsonString  
 * @return  
 */  
private SecuRTAreaOccupancyExitEventDto parsingSecuRtAreaOccupancyExitEvent(final String jsonString){  
  SecuRTAreaOccupancyExitEventDto secuRTAreaOccupancyExitEventDto = null;  
  
  try {  
    secuRTAreaOccupancyExitEventDto = objectMapper.readValue(jsonString, SecuRTAreaOccupancyExitEventDto.class);  
  }catch (JsonProcessingException jsonProcessingException){  
    log.warn("SecuRTAreaOccupancyExitEventDto jsonProcessingException:{}", jsonProcessingException.getMessage());  
  }catch (Exception exception){  
    log.warn("SecuRTAreaOccupancyExitEventDto jsonProcessingException:{}", exception.getMessage());  
  }  
  
  return secuRTAreaOccupancyExitEventDto;  
  
}
```

---

## DTO 2개 추가

```java
package co.kr.dains.crowd.estimation.event.receiver.dto;  
  
import com.fasterxml.jackson.annotation.JsonProperty;  
import lombok.Data;  
  
import java.util.List;  
  
/**  
 * CVEDIA 에서 SecuRT Model 로 Instance 를 실행하였을 때 감시 영역에 입장 이벤트가 발생할 시 전달되는 이벤트의 JSON 규격  
 *  
 * @author: spacedustz  
 * @version: 1.0  
 * @since: 2023/10/13  
 */@Data  
public class SecuRTAreaOccupancyEnterEventDto {  
    @JsonProperty("events")  
    private List<Event> events;  
  
    @JsonProperty("frame_id")  
    private int frameId;  
  
    @JsonProperty("frame_time")  
    private double frameTime;  
  
    @JsonProperty("system_date")  
    private String systemDate;  
  
    @JsonProperty("system_timestamp")  
    private long systemTimestamp;  
  
    @Data  
    public static class Event {  
  
        @JsonProperty("extra")  
        private Extra extra;  
  
        @JsonProperty("id")  
        private String id;  
  
        @JsonProperty("label")  
        private String label;  
  
        @JsonProperty("type")  
        private String type;  
    }  
  
    @Data  
    public static class Extra {  
  
        @JsonProperty("bbox")  
        private BBox bbox;  
  
        @JsonProperty("class")  
        private String clazz;  
  
        @JsonProperty("current_entries")  
        private int currentEntries;  
  
        @JsonProperty("external_id")  
        private String externalId;  
  
        @JsonProperty("total_hits")  
        private String totalHits;  
  
        @JsonProperty("track_id")  
        private String trackId;  
    }  
  
    @Data  
    public static class BBox {  
  
        @JsonProperty("height")  
        private double height;  
  
        @JsonProperty("width")  
        private double width;  
  
        @JsonProperty("x")  
        private double x;  
  
        @JsonProperty("y")  
        private double y;  
    }  
}
```

```java
package co.kr.dains.crowd.estimation.event.receiver.dto;  
  
import com.fasterxml.jackson.annotation.JsonProperty;  
import lombok.Data;  
  
import java.util.List;  
  
/**  
 * CVEDIA 에서 SecuRT Model 로 Instance 를 실행하였을 때 감시 영역에 퇴장 이벤트가 발생할 시 전달되는 이벤트의 JSON 규격  
 *  
 * @author: spacedustz  
 * @version: 1.0  
 * @since: 2023/10/13  
 */@Data  
public class SecuRTAreaOccupancyExitEventDto {  
    @JsonProperty("events")  
    private List<Event> events;  
  
    @JsonProperty("frame_id")  
    private int frameId;  
  
    @JsonProperty("frame_time")  
    private double frameTime;  
  
    @JsonProperty("system_date")  
    private String systemDate;  
  
    @JsonProperty("system_timestamp")  
    private long systemTimestamp;  
  
    @Data  
    public static class Event {  
  
        @JsonProperty("extra")  
        private Extra extra;  
  
        @JsonProperty("id")  
        private String id;  
  
        @JsonProperty("label")  
        private String label;  
  
        @JsonProperty("type")  
        private String type;  
    }  
  
    @Data  
    public static class Extra {  
  
        @JsonProperty("bbox")  
        private BBox bbox;  
  
        @JsonProperty("class")  
        private String clazz;  
  
        @JsonProperty("current_entries")  
        private int currentEntries;  
  
        @JsonProperty("external_track_id_left")  
        private String externalTrackIdLeft;  
  
        @JsonProperty("total_hits")  
        private String totalHits;  
  
        @JsonProperty("track_id_left")  
        private String trackIdLeft;  
    }  
  
    @Data  
    public static class BBox {  
  
        @JsonProperty("height")  
        private double height;  
  
        @JsonProperty("width")  
        private double width;  
  
        @JsonProperty("x")  
        private double x;  
  
        @JsonProperty("y")  
        private double y;  
    }  
}
```