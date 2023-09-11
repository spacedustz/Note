## 📕 RabbitMQ 설치 (Linux)

> **서버 환경** :  AWS EC2 t2.micro / Red Hat Enterprise Linux 9.2.0 버전 기반으로 진행합니다.

Shell Script를 작성해서 간단하게 환경 세팅을 할 건데 그 전에  AWS 보안 그룹에서 사용할 포트/IP 허용 해줍니다.

실제 상용 서버에서는 `IP-Port`로 필요한 포트만 할당 하는 게 좋지만 저는 귀찮으므로

보안 그룹에서 제 Local External IP 대역을 /32로 설정해서 Local Network에 모든 TCP 포트를 할당하였습니다.

<br>

📕 **서버 환경 요구사항**

- Docker 사용 X

<br>

📕 **인스턴스 생성 후 접속**

Xshell, Putty, Gitbash, Cmd 등 터미널을 열고 인스턴스를 생성할 때 만든 Pem키가 위치한 곳으로 이동합니다.

Pem키가 위치한 곳에서

```bash
chmod 600 {Pem-Key-Name}.pem
ssh -i ./{Pem-Key-Name}.pem {인스턴스 IP or Public DNS}
```

를 입력해서 AWS 인스턴스에 접속 해줍니다.

<br>

인스턴스에 접속 후, AWS 보안 그룹에서 허용한 내 Local 대역과 통신이 되는지 Ping 테스트를 해봅니다.

```bash
ping {My-Local_External_IP}
```

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/rabbit-aws.png)

핑 던지고 위 사진처럼 `icmp_seq, ttl, time`값이 잘 찍히면 허용이 된겁니다.

<br>

📕 **(Optional) 루트 계정 비밀번호 설정**

저는 sudo를 쓰기 귀찮으므로 root 계정에서 하는게 편해서 루트로 로그인해서 비밀번호를 바꿔 주었습니다.

```bash
sudo su # root로 switch
passwd # root Password 변경
```

<br>

VM에 따라 다르게 작동하긴 한데 sshd에서 PasswordAuthentication을 yes로 바꿔줍시다.

제 경우(Red Hat Enterprise 9.x.x 버전)에 이 옵션을 안 바꿔주니 접속 Denied가 떴습니다.

```bash
# vi /etc/ssh/sshd_config 로 편집
# 주석 해제 or No로 된걸 Yes로 바꾸기
PasswordAuthentication yes
:wq

# SSHD 서비스 재시작
systemctl restart sshd
```

---

## 📕 **Shell Script 작성**

이제 기본 서버 환경 세팅 스크립트를 작성 하겠습니다.

설치할 RabbitMQ의 버전에 맞는 Erlang-OTP를 설치해야 하니 버전이 호환되는지 부터 확인합니다.

저는 3.12.4를 설치할 것이기 때문에 Erlang 버전은 25 or 26을 설치해야 합니다.

[RabbitMQ에서 필요로 하는 Erlang-OTP 호환성 매트릭스](https://www.rabbitmq.com/which-erlang.html)

<br>

RabbitMQ의 설치 방법을 모르니까 공식 문서로 가서 RPM 기반에서 RabbitMQ를 설치하는 방법을 알아보고 스크립트에 넣었습니다.

[RabbitMQ 설치 공식 문서](https://www.rabbitmq.com/install-rpm.html)

<br>

스크립트의 처음은 Yum을 업데이트하고 서버 관리 보조 툴, firewalld 방화벽을 설치해서 필요한 포트를 열어주었습니다.

**RabbitMQ 기본 사용 포트**

- eqmd: 4369
- Erlang Distribution: 25672
- AMQP TLS : 5671, 5672
- 관리자 웹 콘솔 : 15672
- MQTT : 1883, 8883
- RabbitMQ Socket Port : 15674

포트가 열린지 확인하려면 `firewall-cmd --list-all`을 입력하여 보면 됩니다.

<br>

그리고 `========== RabbitMQ 설치 & 시작 ==========` 부분에서, 

`/etc/yum/repos.d` 디렉터리에 touch로 repo 파일을 만들어줘야 Signing Key, Repo의 정보가 들어가기 떄문에 만들어줘야 합니다.

<br>

Erlang, RabbitMQ의 rpm을 직접 떙겨와서 설치해주었습니다.

[Erlang rpm](https://github.com/rabbitmq/erlang-rpm/releases/download/v26.0.2/erlang-26.0.2-1.el9.x86_64.rpm)

[RabbitMQ rpm](https://github.com/rabbitmq/rabbitmq-server/releases)

```bash
#!/bin/bash

# Red Hat Subscription Plugin 비활성화
sed -i 's/enabled=0/enabled=1/' /etc/yum/pluginconf.d/subscription-manager.conf
dnf -y remove subscription-manager

# ========== Yum 업데이트 & 업그레이드 ==========
dnf -y update && dnf -y upgrade

# ========== 기본 서버 관리 도구, 방화벽 설치 ==========
dnf -y install net-tools firewalld yum-utils wget

# ========== 방화벽 Start / Enable ==========
systemctl start firewalld && systemctl enable firewalld

# ========== 방화벽 포트 오픈 ==========
firewall-cmd --permanent --add-port=22/tcp && firewall-cmd --permanent --add-port=5672/tcp && firewall-cmd --permanent --add-port=15674/tcp && firewall-cmd --permanent --add-port=15672/tcp && firewall-cmd --permanent --add-port=80/tcp && firewall-cmd --permanent --add-port=8080/tcp && --permanent --add-port=6379/tcp && firewall-cmd --permanent --add-port=4369/tcp && firewall-cmd --permanent --add-port=1883/tcp && firewall-cmd --permanent --add-port=25672/tcp && --permanent --add-service=rabbitmq && --permanent --add-service=redis && firewall-cmd --reload

# ========== RabbitMQ 설치 & 시작 ==========

## 기본 RabbitMQ 서명 키 
rpm --import https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc

## 최신 Erlang 저장소 
rpm --import https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key

## RabbitMQ 서버 저장소 
rpm --import https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key

# 패키지 종속성 설치
dnf -y update
dnf -y install socat logrotate

# Erlang & RabbitMQ RPM 다운 & 설치
wget https://github.com/rabbitmq/erlang-rpm/releases/download/v26.0.2/erlang-26.0.2-1.el9.x86_64.rpm
wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.12.4/rabbitmq-server-3.12.4-1.el9.noarch.rpm

dnf -y install erlang-26.0.2-1.el9.x86_64.rpm
dnf -y install rabbitmq-server-3.12.4-1.el8.noarch.rpm

# RabbitMQ Start & Enable
systemctl start rabbitmq-server && systemctl enable rabbitmq-server

# ========== Docker 설치 & 시작 ==========
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker && systemctl enable docker
```

---

## 📕 Spring RabbitMQ

😊 **Spring Boot에 RabbitMQ Dependency 추가**

```groovy
org.springframework.boot:spring-boot-starter-amqp
```

<br>

😊 **RabbitMQ 설정**

**application.yml**

```yaml
spring:
	rabbitmq:  
	  host: {AWS-Instance-Public-IP}
	  port: 5672  
	  username: guest  
	  password: guest  
	  template:  
	    exchange: xx.frame  
	    default-receive-queue: qq.frame  
	    routing-key: message
```

<br>

😊 **RabbitConfig**

[Queue 생성할 때 참고할 좋은 글 발견](https://medium.com/@aleksanderkolata/rabbitmq-spring-boot-04-queue-configuration-a2edeab7a3e6)

[RabbitMQ 공식문서 : Pub/Sub 구조 자바로 구현 ](https://www.rabbitmq.com/tutorials/tutorial-three-java.html)

위의 링크와 Spring RabbitMQ 공식 문서에 Queue, Excange 생성에 대한 문서가 친절하게 나와있어서 보고 작성 했습니다.


```java
@Configuration  
public class RabbitConfig {  
  
    @Value("${spring.rabbitmq.host}")  
    private String host;  
  
    @Value("${spring.rabbitmq.port}")  
    private int port;  
  
    @Value("${spring.rabbitmq.username}")  
    private String id;  
  
    @Value("${spring.rabbitmq.password}")  
    private String pw;  
  
    @Value("${spring.rabbitmq.template.exchange}")  
    private String exchange;  
  
    @Value("${spring.rabbitmq.template.default-receive-queue}")  
    private String queue;  
  
    @Value("${spring.rabbitmq.template.routing-key}")  
    private String key;  
  
    // Topic 타입의 Exchange 생성  
    @Bean  
    public Exchange exchange() { return new TopicExchange(exchange); }  
  
    // Quorum Queue 생성  
    @Bean  
    public Queue queue() {  
        // Queue 타입, Arguments 설정  
        Map<String, Object> args = new HashMap<>();  
        args.put("x-queue-type", "quorum");  
        args.put("x-message-ttl", 200000);  
  
  
        return QueueBuilder.durable(queue).withArguments(args).build();  
    }  
  
    // Exchange <-> Queue Binding  
    @Bean  
    public Binding binding(Queue queue, Exchange exchange) {  
        Map<String, Object> args = new HashMap<>();  
        args.put("x-message-ttl", 200000);  
  
        return BindingBuilder.bind(queue).to(exchange).with(key).and(args);  
    }  
  
    // Message Converter Bean 주입  
    @Bean  
    MessageConverter converter() { return new Jackson2JsonMessageConverter(); }  
  
    // RabbitMQ와의 연결을 위한 Connection Factory Bean 생성  
    @Bean  
    public ConnectionFactory factory() {  
        CachingConnectionFactory factory = new CachingConnectionFactory();  
        factory.setHost(host);  
        factory.setPort(port);  
        factory.setUsername(id);  
        factory.setPassword(pw);  
  
        return factory.getRabbitConnectionFactory();  
    }  
  
    // Rabbit Template 생성  
    @Bean  
    RabbitTemplate template(org.springframework.amqp.rabbit.connection.ConnectionFactory factory, MessageConverter converter) {  
        RabbitTemplate template = new RabbitTemplate(factory);  
        template.setMessageConverter(converter);  
  
        return template;  
    }  
  
    // Subscribe Listener  
    @Bean  
    SimpleRabbitListenerContainerFactory listener(org.springframework.amqp.rabbit.connection.ConnectionFactory connectionFactory) {  
        final SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();  
        factory.setConnectionFactory(connectionFactory);  
        factory.setMessageConverter(converter());  
        factory.setAcknowledgeMode(AcknowledgeMode.AUTO);  
  
        return factory;  
    }  
}
```

<br>

😊 **RabbitService**

서비스에는 Producer 역할인 send 함수와 Subscriber 역할을 하는 consume 함수를 작성합니다.

```java
@Service  
@Transactional  
@RequiredArgsConstructor  
public class RabbitService {  
    private static final Logger log = LoggerFactory.getLogger(RabbitService.class);  
    private final RabbitTemplate template;  
    private final SimpMessagingTemplate messagingTemplate;  
    private final String topic = "message";  
  
    // 메시지 전송 테스트  
    public void send(RabbitDTO message) {  
        try {  
            template.convertAndSend("xx.frame", "qq.frame", message);  
        } catch (Exception e) {  
            log.error("RabbitMQ 메시지 전송 테스트 실패", e);  
        }  
    }  
  
    // Subscribe  
    @RabbitListener(queues = "qq.frame")  
    public void consume(String message) {  
        messagingTemplate.convertAndSend("message", message);  
        log.info("Received Message {}", message);  
        System.out.println("Received Message {}" + message);  
    }  
}
```

<br>

😊 **RabbitController**

테스트로 큐에 메시지를 쌓을 RestAPI를 하나 만들어주었습니다.

```java
@RestController  
@RequestMapping("/rabbit")  
@RequiredArgsConstructor  
public class RabbitController {  
    private final RabbitService rabbitService;  
  
    @PostMapping("send")  
    public ResponseEntity<String> send(RabbitDTO message) {  
        rabbitService.send(message);  
  
        return ResponseEntity.ok().body("RabbitMQ - 메시지 전송 성공"); 
    }  
}
```

<br>

😊 **RabbitDTO**

데이터의 형식은 간단하게 title, message로 보내보겠습니다.

```java
@Getter @Setter  
@AllArgsConstructor(access = AccessLevel.PRIVATE)  
public class RabbitDTO {  
    private String title;  
    private String message;  
}
```

---

## 테스트

Postman을 이용해서 만든 Rest API에 Message를 보내면 Exchange(`xx.frame`)와 Queue(`qq.frame`)가 생기고 서로 바인딩 됩니다.

`q.frame`은 FrontEnd React와 소켓 연결된 Queue이고 `qq.frame`은 Spring과 연결된 Queue입니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/spring-rabbit.png)

<br>

그리고 Queue로 직접 들어가 보면, 

Spring에서 설정한 바인딩 옵션에 설정한 Argument, Durable, Message TTL 전부 잘 들어간 것을 볼 수 있습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/spring-rabbit2.png)