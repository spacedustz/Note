## 💡 Email 인증 구현

Google SMTP Server를 이용해 이메일 인증을 통한 랜덤 인증번호 구현

<br>

### 개발 환경

- Java 11
- Spring 2.x
- Gradle
- MySQL, Redis
- IntelliJ

<br>

### 흐름

1. 사용자는 회원가입 화면에서 가입하려는 이메일을 입력 후 이메일 인증 버튼 클릭
2. 클라이언트 서버에게 사용자의 이메일로 인증 번호 전송 요청
3. 서버는 랜덤 인증 번호 생성. 인증 번호를 Redis에 저장 후 사용자의 이메일로 인증 번호 전송
4. 사용자는 인증 번호 확인 후 인증 번호 입력 후 확인 버튼 클릭
5. 클라이언트는 서버에게 인증 번호 검증 요청
6. 서버는 전달받은 인증 번호가 Redis에 저장된 인증 번호와 동일한지 확인 후 동일하면 true 반환

---

### SMTP 계정 설정

우선 SMTP을 사용할 구글 계정 설정을 해줘야 한다.

**구글 로그인 → 구글 계정 관리 → 검색창에 “앱 비밀번호” 검색.**

만약 앱 비밀번호를 검색해도 나오지 않는다면 2단계 인증을 하지 않았을 확률이 높다. 

2단계 인증을 먼저 진행하자 . 2단계 인증 과정은 생략한다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/email.png) 

<br>

**앱: 메일 / 기기: Windows 컴퓨터로 생성**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/email2.png) 

<br>

**생성된 앱 비밀번호를 따로 저장해두자 (외부로 노출시키지 말자) → 확인 클릭**

![img](../img/email3.png) 

<br>

**구글 Gmail → 설정 → 전달 및 POP/IMAP → 아래 이미지처럼 설정 → 변경사항 저장 클릭**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/email4.png) 

---

## 구현

구글 SMTP 설정이 모두 끝났다면 구현해보자

<br>

### build.gradle

```groovy
implementation group: 'org.springframework.boot', name: 'spring-boot-starter-mail', version: '3.0.5'
```

 <br>

### application.yml

```yaml
spring:
	mail:
    host: host
    port: 587
    username: username
    password: password
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
          connectiontimeout: 5000
          timeout: 5000
          writetimeout: 5000
    auth-code-expiration-millis: 1800000  # 30 * 60 * 1000 == 30분
```

- **host**: Gmail의 SMTP 서버 호스트
- **port**: SMTP 서버의 포트 번호. Gmail SMTP 서버는 587번 포트를 사용
- **username**: 이메일을 보내는 용으로 사용되는 계정의 이메일 주소 입력
- **password**: 위에서 생성했던 앱 비밀번호 입력
- **properties**: 이메일 구성에 대한 추가 속성
- **auth**: SMTP 서버에 인증 필요한 경우 true로 지정한다. Gmail SMTP 서버는 인증을 요구하기 때문에 true로 설정해야 한다.
- **starttls**: SMTP 서버가 TLS를 사용하여 안전한 연결을 요구하는 경우 true로 설정한다. TLS는 데이터를 암호화하여 안전한 전송을 보장하는 프로토콜이다.
- **connectiontimeout**: 클라이언트가 SMTP 서버와의 연결을 설정하는 데 대기해야 하는 시간(Millisecond). 연결이 불안정한 경우 대기 시간이 길어질 수 있기 때문에 너무 크게 설정하면 전송 속도가 느려질 수 있다.
- **timeout**: 클라이언트가 SMTP 서버로부터 응답을 대기해야 하는 시간(Millisecond). 서버에서 응답이 오지 않는 경우 대기 시간을 제한하기 위해 사용된다.
- **writetimeout**: 클라이언트가 작업을 완료하는데 대기해야 하는 시간(Millisecond). 이메일을 SMTP 서버로 전송하는 데 걸리는 시간을 제한하는데 사용된다.
- **auth-code-expiration-millis:** 이메일 인증 코드의 만료 시간(Millisecond)

---

### EmailConfig

JavaMailSender 인터페이스를 구현하는 클래스. JavaMailSender 인터페이스는 JavaMail API를 사용하여 이메일을 전송하는 데 사용된다.

```java
@Configuration
public class EmailConfig {

    @Value("${spring.mail.host}")
    private String host;

    @Value("${spring.mail.port}")
    private int port;

    @Value("${spring.mail.username}")
    private String username;

    @Value("${spring.mail.password}")
    private String password;

    @Value("${spring.mail.properties.mail.smtp.auth}")
    private boolean auth;

    @Value("${spring.mail.properties.mail.smtp.starttls.enable}")
    private boolean starttlsEnable;

    @Value("${spring.mail.properties.mail.smtp.starttls.required}")
    private boolean starttlsRequired;

    @Value("${spring.mail.properties.mail.smtp.connectiontimeout}")
    private int connectionTimeout;

    @Value("${spring.mail.properties.mail.smtp.timeout}")
    private int timeout;

    @Value("${spring.mail.properties.mail.smtp.writetimeout}")
    private int writeTimeout;

    @Bean
    public JavaMailSender javaMailSender() {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost(host);
        mailSender.setPort(port);
        mailSender.setUsername(username);
        mailSender.setPassword(password);
        mailSender.setDefaultEncoding("UTF-8");
        mailSender.setJavaMailProperties(getMailProperties());

        return mailSender;
    }

    private Properties getMailProperties() {
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", auth);
        properties.put("mail.smtp.starttls.enable", starttlsEnable);
        properties.put("mail.smtp.starttls.required", starttlsRequired);
        properties.put("mail.smtp.connectiontimeout", connectionTimeout);
        properties.put("mail.smtp.timeout", timeout);
        properties.put("mail.smtp.writetimeout", writeTimeout);

        return properties;
    }
}
```

application.yml에 설정한 환경 변수들을 사용하여 JavaMailSenderImpl 객체를 생성한다. 이 객체를 사용해서 이메일을 보낼 수 있다.

---

### MailService

이메일 발송을 담당하는 클래스

```java
@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class MailService {

    private final JavaMailSender emailSender;

    public void sendEmail(String toEmail,
                          String title,
                          String text) {
        SimpleMailMessage emailForm = createEmailForm(toEmail, title, text);
        try {
            emailSender.send(emailForm);
        } catch (RuntimeException e) {
            log.debug("MailService.sendEmail exception occur toEmail: {}, " +
                    "title: {}, text: {}", toEmail, title, text);
            throw new BusinessLogicException(ExceptionCode.UNABLE_TO_SEND_EMAIL);
        }
    }

    // 발신할 이메일 데이터 세팅
    private SimpleMailMessage createEmailForm(String toEmail,
                                             String title,
                                             String text) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject(title);
        message.setText(text);

        return message;
    }
}
```

- createEmailForm(): 발송할 이메일 데이터를 설정하는 메서드이다. 수신자 이메일 주소, 이메일 제목, 이메일 내용을 입력 받아 SimpleMailMessage 객체를 생성하여 반환한다.
- sendEmail( ): 이메일을 발송하는 메서드 파라미터로 이메일 주소, 이메일 제목, 이메일 내용을 입력 받아 이메일 creataEmailForm() 메서드로 넘겨준다. createForm() 메서드가 SimpleMailMessage 객체를 생성하여 반환하면 주입 받은 emailSender.send() 메서드에 담아 메일을 발송한다.

---

### MemberController

이메일 인증 번호 요청과 인증 번호 검증을 요청 API를 생성한다. DTO 클래스는 생략한다.

```java
@Slf4j
@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
public class MemberController {
    private final MemberService memberService;

    ...

    @PostMapping("/emails/verification-requests")
    public ResponseEntity sendMessage(@RequestParam("email") @Valid @CustomEmail String email) {
        memberService.sendCodeToEmail(email);

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/emails/verifications")
    public ResponseEntity verificationEmail(@RequestParam("email") @Valid @CustomEmail String email,
                                            @RequestParam("code") String authCode) {
        EmailVerificationResult response = memberService.verifiedCode(email, authCode);

        return new ResponseEntity<>(new SingleResponseDto<>(response), HttpStatus.OK);
    }
}
```

- sendMessage(): 이메일 전송 API. 이메일을 파라미터로 받아 해당 MemberService.sendCodeToEmail() 메서드로 넘겨준다.
- verificationEmail(): 이메일 인증을 진행하는 API. 이메일과 사용자가 작성한 인증 코드를 파라미터로 받아 MemberService.verifiedCode() 메서드로 넘긴다. 인증에 성공하면 ture를 실패하면 false를 반환한다.

---

### MemberService

인증 번호 생성, 검증을 담당할 클래스.

```java
@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class MemberService {

    private static final String AUTH_CODE_PREFIX = "AuthCode ";

    private final MemberRepository memberRepository;

    private final MailService mailService;

    private final RedisService redisService;

		@Value("${spring.mail.auth-code-expiration-millis}")
    private long authCodeExpirationMillis;

		...

    public void sendCodeToEmail(String toEmail) {
        this.checkDuplicatedEmail(toEmail);
        String title = "Travel with me 이메일 인증 번호";
        String authCode = this.createCode();
        mailService.sendEmail(toEmail, title, authCode);
        // 이메일 인증 요청 시 인증 번호 Redis에 저장 ( key = "AuthCode " + Email / value = AuthCode )
        redisService.setValues(AUTH_CODE_PREFIX + toEmail,
                authCode, Duration.ofMillis(this.authCodeExpirationMillis));
    }

    private void checkDuplicatedEmail(String email) {
        Optional<Member> member = memberRepository.findByEmail(email);
        if (member.isPresent()) {
            log.debug("MemberServiceImpl.checkDuplicatedEmail exception occur email: {}", email);
            throw new BusinessLogicException(ExceptionCode.MEMBER_EXISTS);
        }
    }

    private String createCode() {
        int lenth = 6;
        try {
            Random random = SecureRandom.getInstanceStrong();
            StringBuilder builder = new StringBuilder();
            for (int i = 0; i < lenth; i++) {
                builder.append(random.nextInt(10));
            }
            return builder.toString();
        } catch (NoSuchAlgorithmException e) {
            log.debug("MemberService.createCode() exception occur");
            throw new BusinessLogicException(ExceptionCode.NO_SUCH_ALGORITHM);
        }
    }

    public EmailVerificationResult verifiedCode(String email, String authCode) {
        this.checkDuplicatedEmail(email);
        String redisAuthCode = redisService.getValues(AUTH_CODE_PREFIX + email);
        boolean authResult = redisService.checkExistsValue(redisAuthCode) && redisAuthCode.equals(authCode);

        return EmailVerificationResult.of(authResult);
    }
}
```

- creatCode(): 6자리의 랜덤한 인증 코드를 생성하여 반환하는 메서드
- checkDuplicatedEmail(): 회원가입하려는 이메일로 이미 가입한 회원이 있는지 확인하는 메서드. 만약 해당 이메일을 가진 회원이 존재하면 예외를 발생한다.
- sendCodeToEmail(): 인증 코드를 생성 후 수신자 이메일로 발송하는 메서드. 이후 인증 코드를 검증하기 위해 생성한 인증 코드를 Redis에 저장한다.
- verifiedCode(): 인증 코드를 검증하는 메서드. 파라미터로 전달받은 이메일을 통해 Redis에 저장되어 있는 인증 코드를 조회한 후 파라미터로 전달 받은 인증 코드와 비교한다. 만약 두 코드가 동일하다면 true를, Redis에서 Code가 없거나 일치하지 않는다면 false를 반화한다. 반환된 boolean 값은 DTO로 변환하여 반환한다.

<br>

🔥 **잠깐! 왜 MailService에서 인증 번호 로직을 작성하지 않았을까?**

이유는 각 클래스의 역할과 관련 있다. MailService 클래스는 이름 그대로 이메일 전송과 관련된 역할만을 수행한다. MemberService 클래스는 회원과 관련된 여러 가지 기능을 담당하고 있다.

sendCodeToEmail 메서드와 verifiedCode 메서드는 이메일 전송뿐만 아니라 회원 가입 과정에서 이메일 인증이 필요한 기능을 수행한다. 그렇기 때문에 MemberService 클래스에서 해당 메서드를 작성했다.

---

## 에러 발생1

```
class file for javax.mail.internet.MimeMessage not found
```

이메일 인증 구현 후 테스트를 위해 실행을 하자 만난 첫 번째 에러 에러메세지 그대로 MimeMessage 클래스를 찾을 수 없다고 한다.

<br>

### 해결

MimeMessage 클래스는 JavaMail API에서 제공하는 메일을 나타내는 클래스이다. MimeMessage 객체를 사용하여 메일을 작성하고 전송할 수 있다.

JavaMailSender는 JavaMail API를 감싸고 있으며, MimeMessage 객체를 생성하여 메일을 전송한다. JavaMailSender 클래스로 가보면 MimeMessage 클래스를 찾을 수 없다는걸 알 수 있다.

Java11은 JavaMail API를 기본 제공하지 않는다고 한다. 따라서 MimeMessage 클래스를 사용하려면 JavaMail API 라이브러리를 수동으로 추가해야 한다.

```groovy
implementation 'javax.mail:javax.mail-api:1.6.2'
```

---

## 에러 발생2

MimeMessage 라이브러리를 추가한 후 실행해보니 발생한 에러다.

```
java.lang.ClassNotFoundException: com.sun.mail.util.FolderClosedIOException
	at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:581) ~[na:na]
	at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:178) ~[na:na]
	at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:522) ~[na:na]
	at org.springframework.mail.javamail.JavaMailSenderImpl.createMimeMessage(JavaMailSenderImpl.java:341) ~[spring-context-support-5.3.25.jar:5.3.25]
	at org.springframework.mail.javamail.JavaMailSenderImpl.send(JavaMailSenderImpl.java:319) ~[spring-context-support-5.3.25.jar:5.3.25]
	at org.springframework.mail.javamail.JavaMailSenderImpl.send(JavaMailSenderImpl.java:312) ~[spring-context-support-5.3.25.jar:5.3.25]
	at com.frog.travelwithme.global.security.auth.service.MailService.sendEmail(MailService.java:50) ~[classes/:na]
	at com.frog.travelwithme.global.security.auth.service.MailService$$FastClassBySpringCGLIB$$a6cb3bbb.invoke(<generated>) ~[classes/:na]
```

com.sun.mail.util.FolderClosedIOException 클래스는 JavaMail 라이브러리의 일부분이다.

결국, JavaMail 라이브러리에 필요한 라이브러리가 classpath에 없어서 발생한 에러이다.

<br>

### 해결

찾아보니 javax.mail:javax.mail-api 라이브러리는 구현체가 포함되어 있지 않아서 구현체인 com.sun.mail:javax.mail 라이브러리를 추가해주어야 한다.

```groovy
implementation group: 'com.sun.mail', name: 'javax.mail', version: '1.6.2' 
```

---

## 테스트

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/email5.png)

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/email6.png)

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/email7.png)

<br>

성공!!!