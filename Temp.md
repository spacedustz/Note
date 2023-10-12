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

> if ()