## **💡 ElasticCache for Redis**  

**Redis를 캐싱서버로 사용하는 이유**

서버에 Refresh Token을 저장해야하는데 영구적으로 필요한 데이터가 아니기에, 리소스 절약하기 위해 사용

보통 휘발성 데이터들을 따로 빼기 위해 사용한다.

<br>

**구현체**
Lettuce, Jedis 중 Lettuce 사용

<br>

Lecttue - 비동기 처리, 성능up, 추가적인 의존성 필요X, 별도의 설정없이 Redis에 명령 가능
Jedis - Deprecated된 방법, 별도의 추가 의전송필요, None Thread-Safe

------

## **💡 사전 준비**

### **Elasticache Redis Cluster 생성**

AWS ElasticCache Redis Cluster 생성

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cache.png)

<br>

### **EC2 Instance에 gcc설치후 redis-cli 컴파일**

- yum -y install gcc
- wget http://download.redis.io/redis-stable.tar.gz && tar xvzf redis-stable.tar.gz && cd redis-stable && make
- cp src/redis-cli /usr/bin/
- redis-cli -h [Endpoint] -p 6379

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cache2.png)

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cache3.png)

<br>

### **시스템 환경변수에 Redis Primary Node의 Endpoint를 넣고 application.yml에서 가져오기**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cache4.png) 

<br>

### **Spring Boot Project 내에 의존성 추가 & application.yml에 redis 정보 등록**

```yaml
implementation 'org.springframework.boot:spring-boot-starter-data-redis'
```

<br>

### **RedisConfig**

```java
/* Redis Template를 이용한 방식 */

@Configuration
@EnableRedisRepositories
@RequiredArgsConstructor
public class RedisConfig {

    @Value("${spring.redis.host}")
    private String redisHost;

    @Value("${spring.redis.port}")
    private int redisPort;

    private final RedisProperties redisProperties;

    /* RedisConnectionFactory 인터페이스를 통해 LettuceConnectionFactory 반환 */

    @Bean
    public RedisConnectionFactory factory() {
        RedisClusterConfiguration configuration = new RedisClusterConfiguration();
        configuration.clusterNode(redisHost, redisPort);

        LettuceClientConfiguration clientConfiguration = LettuceClientConfiguration.builder()
                .clientOptions(ClientOptions.builder()
                        .socketOptions(SocketOptions.builder()
                                .connectTimeout(Duration.ofMillis(redisProperties.getTimeout())).build())
                        .build())
                .commandTimeout(Duration.ofSeconds(redisProperties.getTimeout())).build();

        return new LettuceConnectionFactory(configuration, clientConfiguration);
    }

    @Bean
    public RedisTemplate<String, String> template() {
        /* RedisTemplate를 받아와 set, get, delete 사용 */
        RedisTemplate<String, String> template = new RedisTemplate<>();

        /* Key & Value Serializer, Factory 설정 */
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new StringRedisSerializer());
        template.setConnectionFactory(factory());

        return template;
    }
}
```

------

## **💡 Redis in Local Server**

<br>

### **Local Server에서의 연동**

- Docker Compose Yml 작성후 Redis Container 생성 & 실행

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cache5.png) 

- 방화벽 포트 & 서비스 오픈

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cache6.png) 

<br>

IntelliJ 내의 Docker 서비스와 로컬 개인서버 연결

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cache8.png) 

<br>

연결 성공

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cache9.png)

<br>

- Spring Boot Project 내에 의존성 추가 & application.yml에 redis 정보 등록

```yaml
implementation 'org.springframework.boot:spring-boot-starter-data-redis'
```

<br>

Redis 서버 IP,Port 등록

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cache10.png) 

<br>

Redis 서버와 정상 통신 가능

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cache11.png) 