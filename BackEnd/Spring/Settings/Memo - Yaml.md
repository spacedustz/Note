## **💡 Application.yml**

---

### ⭐ 인텔리제이 로그 한글 깨질때

```yaml
server:
  servlet:
    encoding:
      force-response: true
      charset: UTF-8
```

---

### ⭐ HTTP Encoding CharSet 설정

```yaml
server:
  servlet:
    encoding:
      charset: UTF-8
      force-response: true
```

---

### ⭐ Mail 설정

```yaml
mail:
  address:
    admin: admin@gmail.com
```

---

### ⭐ H2 Database

```yaml
h2:
  console:
    enabled: true
    path: /h2
datasource:
  url: jdbc:h2:mem:test
```

---

### ⭐ JPA

```yaml
datasource:
  url:jdbc:mysql://{url}:3306/{db_name}?allowPublicKeyRetrieval=true&useSSL=false&characterEncoding=UTF-8&serverTimezone=Asia/Seoul
  username: abc
  password: abc
  driver-class-name: com.mysql.cj.jdbc.Driver

jpa:
  database: mysql
  database-platform: org.hibernate.spatial.dialect.mysql.MySQL56InnoDBSpatialDialect
  hibernate:
    ddl-auto: create  # (1) 스키마 자동 생성
  show-sql: true      # (2) SQL 쿼리 출력
  properties:
    hibernate:
      format_sql: true  # (3) SQL pretty print
//  sql:
//    init:
//      data-locations: classpath*:db/h2/data.sql
```

---

### ⭐ Logging Level 설정

```yaml
# JPA
logging:
  level:
    org:
      springframework:
        orm:
          jpa: DEBUG

# Logging
logging:
  level:
    org:
      hibernate: info
```

---

### ⭐ JWT 설정

```yaml
jwt:
  key:
    secret: ${JWT_SECRET_KEY}               # 민감한 정보는 시스템 환경 변수에서 로드한다.
  access-token-expiration-minutes: 30
  refresh-token-expiration-minutes: 420
```

---

### ⭐ OAuth2 Client 설정

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            clientId: xxxxx
            client-secret: xxxxx
            scope: // 스코프값을 지정하면 해당 범위만큼의 Resourse를 Client(백엔드 어플리케이션)에게 제공
            - email
            - profile
```

---

### ⭐ Firebase

```yaml
firebasePath: xxx.json
```

---

### ⭐ Ncp S3 Uploader

```yaml
ncp:
  endpoint:
  regionName:
  bucketName:
  accessKey:
  secretKey:
```

---

### ⭐ MultiPart

```yaml
  servlet:
    multipart:
      max-file-size: 30MB
      max-request-size: 30MB
```

