## **💡 RedisSystemException**

**발생이유**

RedisConfig 내의 Cluster Connect Timeout 시간의 잘못된 설정으로 인한 에러

<br>

**해결**

ResdisProperties내에 세션 타임아웃필드 지정

connectTimeout()내부 로직에 시간값을 가져오는곳에 올바른 시간값 기입 수정

```java
@Component
@Getter @Setter
@ConfigurationProperties("spring.redis")
public class RedisProperties {
    private String host;
    private int port;
    @Getter
    @Value("${jwt.refresh-token-expiration-minutes}")
    private int refreshTokenExpirationMinutes;
    private long sessionTime = 1000000000; // 추가
}
```

```java
    @Bean
    public RedisConnectionFactory factory() {
        RedisClusterConfiguration configuration = new RedisClusterConfiguration();
        configuration.clusterNode(redisHost, redisPort);

        LettuceClientConfiguration clientConfiguration = LettuceClientConfiguration.builder()
                .clientOptions(ClientOptions.builder()
                        .socketOptions(SocketOptions.builder()
                                .connectTimeout(Duration.ofMillis(redisProperties.getSessionTime())).build())
                        .build())
                .commandTimeout(Duration.ofSeconds(redisProperties.getSessionTime())).build();
        return new LettuceConnectionFactory(configuration, clientConfiguration);
    }
```