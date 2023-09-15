## ELK

유저가 클릭 -> MessageAnalyze 엔티티 생성 -> 

Elastic Search

- LogStash로부터 전달받은 데이터 저장, 검색 및 집계

LogStash

- 로그 및 트랜잭션 데이터를 수집과 집계 및 파싱 -> ElasticSearch러 전달
- 정제 및 전처리 담당

Kibana

- 저장된 로그를 ElasticSearch의 빠른 검색을 통해 가져오며, 이를 시각화 및 모니터링

FileBeat

- 로그를 생성하는 서버에 설치해 로그 수집, LogStash 서버로 로그 전송

<br>

---

## Spring Boot 설정

**Spring Boot Dependency**

```groovy
implementation("org.springframework.boot:spring-boot-starter-data-elasticsearch")
```

<br>

**Project Main Class에 Annotation 추가 **

```@ConfigurationPropertiesScan
@ConfigurationProperties
```

<br>

**Application.yml**

```yaml
elasticsearch:
  host: localhost
  port: 9200

logging:
  level:
    org.springframework: INFO
    org.devkuma: DEBUG
```

