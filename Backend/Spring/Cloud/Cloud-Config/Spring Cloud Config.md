## 📘 Spring Cloud Config

분산된 환경의 어플리케이션에서 환경설정 정보를 중앙의 Config Server에 모아 관리하게 해주는 라이브러리이다.

<br>

구축을 하게 된 배경은 디스코드 봇을 만드는중인데 봇의 토큰 값을 로컬에서 관리하는 방법 말고
다른방법이 또 있을까 해서 검색하다 AWS Parameter Store를 할까 하다가 이걸로 하게 됐다.

<br>

### **구현 순서**

- Spring Cloud Config Server
- Spring Cloud Config Client
- SSH Key 등록

------
## 📘 Spring Cloud Config Server

여러 서버들의 설정정보를 모아놓을 HQ Config Server

<br>

사전 준비 사항

- Spring Cloud Config 서버로 쓸 Private Git Repository 생성
- Spring Initializer -> Spring Cloud Config -> Config Server 프로젝트 생성

<br>

### **Gradle 의존성 추가**

```yaml
implementation("org.springframework.boot:spring-boot-starter-actuator")
```

<br>

### **application.yml 설정**

```yaml
server:
  port: 8081

spring:
  cloud:
    config:
      server:
        git:
          # config server가 참조할 yml 파일들을 모아둔 repository의 주소
          uri: https://github.com/iizzzz/Config-Server.git
          # config server가 참조할 repository의 branch 이름은 main이다.
          default-label: main
          username: username
          password: password
          # 모든 설정 정보를 암호화 시키겠다는 의미
        encrypt:
          enabled: false

# actuator 설정
# management 아래의 설정들 -> actuator의 설정 정보들.
# 설정 파일의 정보가 변경된 경우에 refresh를 통해서 새로운 설정 정보를 가져올 수 있다.
management:
  endpoints:
    web:
      exposure:
        include: "*"
  endpoint:
    shutdown:
      enabled: true

# 암호화를 시키는데 사용되는 Key 값
encrypt:
  key: key-brian
```

단, 여기서 주의할 점은 두 가지다.

- yml 파일을 모아둔 github repository가 존재 해야한다.
- yml 파일을 모아둔 github repository는 public 상태에 있어야 한다.

<br>

필요한 서버의 설정 정보를 따로 yml을 만든다 (discord-token.yml)

```yaml
discord:
  token: abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc
```

application.yml 설정을 끝냈으면 프로젝트의 main 함수에 **@EnableConfigServer 달아주자.**

<br>

### **Plain Text(평문) 암호화**

application.yml에 작성했던 encrypt 설정으로 평문을 암호화해, 적용하고 싶은 yml의 값을 암호화해서 넣도록 하자.

http://localhost:8081/encrypt

<br>

암호화된 값을 yml에 넣을때 꼭 "{cipher}암호화된값" 의 형식으로 넣어야 동작함.

![](./1.png)

------
## 📘 Spring Cloud Config Client

Config Server의 민감정보나 파라미터를 불러와서 사용할 서버

<br>

### **Build.gradle 의존성 추가**

```yaml
ext {
    set('springCloudVersion', "2022.0.1")
}

dependencyManagement {
    imports {
        mavenBom "org.springframework.cloud:spring-cloud-dependencies:${springCloudVersion}"
    }
}

dependencies {
    implementation 'org.springframework.cloud:spring-cloud-starter-bootstrap'
    implementation 'org.springframework.cloud:spring-cloud-starter-config'
}
```

<br>

### **application.yml 설정**

```yaml
server:
  port: 8080

spring:
  application:
    name: discord
  profiles:
    active: token
  config:
    import: "optional:configserver:http://localhost:8081"
  cloud:
    config:
      name: discord
      profile: token

management:
  endpoints:
    web:
      exposure:
        include: "*"

encrypt:
  key: key-brian
```

<br>

### **Controller 생성해서 테스트**

```java
@RefreshScope
@Component
@Getter @Setter
@ToString
public class Token {
    @Value("${discord.token}")
    private String token;
}
@RequestMapping
@RefreshScope
@RestController
public class ConfigController {

    private final Token token;

    public ConfigController(Token token) {
        this.token = token;
    }


    @GetMapping("/test")
    public String config() {
        System.out.println(token);
        return token.toString();
    }
}
```

------
## 📘 SSH Key 등록

- SSH키 생성
  - ssh-keygen -m PEM -t ecdsa -b 256 -C "Github 계정" -f 키파일명
- 생성된 공개키를 Github 계정에 추가
  - cat key.pub
- 개인키 복사
- host-key와 host-key-algorithm 확인
  - ssh-keyscan -t ecdsa github.com

<br>

### **Config Server의 application.yml 수정**

```yaml
server:
  port: 8081

spring:
  cloud:
    config:
      server:
        git:
          # config server가 참조할 yml 파일들을 모아둔 repository의 주소
          uri: Git SSH 주소로 변경
          # config server가 참조할 repository의 branch 이름은 main이다.
          default-label: main
          ignore-local-ssh-settings: true
          private-key: |
            -----BEGIN EC PRIVATE KEY-----
            비밀키는 소중해요
            비밀키는 소중해요
            비밀키는 소중해요
            -----END EC PRIVATE KEY-----
          host-key: AAAA~~~
          host-key-algorithm: ecdsa~~
          search-paths: src/**
        # 모든 설정 정보를 암호화 시키겠다는 의미
        encrypt:
          enabled: false

# actuator 설정
# management 아래의 설정들 -> actuator의 설정 정보들.
# 설정 파일의 정보가 변경된 경우에 refresh를 통해서 새로운 설정 정보를 가져올 수 있다.
management:
  endpoints:
    web:
      exposure:
        include: "*"
  endpoint:
    shutdown:
      enabled: true

# 암호화를 시키는데 사용되는 Key 값
encrypt:
  key: key-brian
```

<br>

**localhost:8081/config/local (Config 서버)와,
localhost:8080/test (Config 클라이언트)를 들어가보면 암호화와 토큰 값이 잘 나오는 걸 볼 수 있다.**

![](./2.png)

<br>

![](./3.png)