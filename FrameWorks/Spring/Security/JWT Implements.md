## **💡 Processing Flow**

JWT 생성 흐름

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/JWT2.png) 

<br>

JWT 검증 처리 흐름

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/JWT3.png) 

------

## **💡 구현** 

**사전 작업**
UserDto의 Post 내부클래스에 password 필드 추가
Entity 클래스에 password 필드, 권한테이블 생성 로직 추가

------

### **SecurityConfiguration :** Spring Security를 이용한 보안 강화를 위한 보안 구성

- **Annotation**
  - @Configuration
- **implementation, extends**
  - None
- **Dependency Injection**
  - JwtTokenizer
- **Method**
  - @Bean public SecurityFilterChain -> 보안 설정
    - param = HttpSecurity
    - throws = Exception
    - 로그인 방식, csrf공격 방지 등 보안 옵션 설정
    - return http.build()
  - @Bean public PasswordEncoder -> PasswordEncoder 빈 생성
    - param = None
    - throws = None
    - return PasswordEncoderFactories.createDelegatingPasswordEncoder()
  - @Bean CorsConfigurationSource -> 디테일한 CORS 정책 설정
    - param = None
    - throws = None
    - 1. Origin 통신 허용
    - 2. 지정한 HTTP Method 허용
    - UrlBasedCorsConfigurationSource 객체를 이용한 URL 접근제어
    - return UrlBasedCorsConfigurationSource 객체
  - public Class CustomFilterConfigurer -> CustomFilter 적용 
    - param = None
    - throws = None
    - extends = AbstractHttpConfigurer<customfilterconfigurer, httpsecurity>
      - Overrided Method public void name
        - param = HttpSecurity
        - throws = Exception
        - CustomHandlerFilter 적용 기능 구현

------

### **UserService**

유저 등록 시 id, pw, authority 저장

<br>

- **Annotation**
  - @Transactional, @Service
- **implementation, extends**
  - None
- **Dependency Injection**
  - Repo, ApplicationEventPublisher, PasswordEncoder, CustomAuthorityUtils
- **Method**
  - createUser
    - param = User
    - throws = None
    - verify Mail
    - PasswordEncoder를 이용한 User PW 암호화
    - CustomAuthorityUtils를 이용한 User Role 생성
    - DB에 User 저장
    - return ApplicationEventPublisher의 구현체인 MemberRegistrationApplicationEvent 객체로
      저장된 User 정보를 감싸고 저장된 User 리턴

------

### **PrivateDetailsService**

DB에서 조회한 User의 Credential을 AuthenticationManager에게 전달하는 클래스 

<br>

- **Annotation**
  - @Component
- **implementation, extends**
  - implements UserDetailsService
- **Dependency Injection**
  - Repo, CustomAuthorityUtils
- **Method**
  - Overrided public UserDetails loadUserByUsername
    - param = String username
    - throws = UsernameNotFoundException
    - fingByEmail -> Optional User(username) + exception 반환
    - return 위에서 얻은 optionalUser를 내부 클래스의 생성자로 반환
  - 내부 클래스 private final class privateDetails
    - param = None
    - throws = None
    - extends(entity), imp(UserDetails)
    - Contructor(Entity entity) -> set User Info
    - Overrided methods -> grant Athority, imp UserDetails's Methods

------

### **JwtTokens**

User의 로그인 성공 시, JWT 생성 & 발급 & 검증

<br>

- **Annotation**
  - @Component, (field) @Getter, @Value (mapping with .yml field)
- **Member**
  - key, (set expirer time for access & refresh tokens)
- **implementation, extends**
  - None
- **Dependency Injection**
  - None
- **Method**
  - public String [평문 -> encoding 로직] 
    - param = String keyname
    - throws = None
    - return Encoders.BASE64.Encode(keyname.getBytes(StandardCharsets.UTF-8)
  - public String [인증이 완료된 사용자에게 Access Token 발급 로직]
    - param = Map<String, Object> , String sub, Date ex, String encodedKey
    - 위의 Encoding 로직을 이용한 암호화된 암호 -> 키 변환 생성
    - return Jwts.builder + param 값 설정
  - public String [Access Token 만료시 발급 할 Refresh Token 생성 로직]
    - param = String sub, Date ex, String encodedKey
    - 위의 Encoding 로직을 이용한 암호화된 암호 -> 키 변환 생성
    - return Jwts.builder + param 값 설정
  - private Key [JWT 서명에 사용할 비밀 키 생성 로직]
    - param = String encodedKey
    - Decoders를 이용한 encodedKey 디코딩 - 반환타입 : byte Array
    - Key = Keys.hmacShaKeyFor(위에서 반환된 byte Array]
    - return 키
  - public void [JWT 검증 로직]
    - param = String jws, String encodedKey
    - 위의 Encoding 로직을 이용한 암호화된 암호 -> 키 변환 생성
    - return Jwts.parseBuilder() + 키를 이용한 sign + jws 리턴

------

### **PrivateJwtAuthenticationFilter**

유저의 로그인 정보를 직접 수신 + 인증 처리의 Entrypoint 역할을 하는 필터

<br>

- **Annotation**
  - (Method) @SneakyTrows, @Override
- **implementation, extends**
  - extends = UsernamePasswordAuthenticationFilter
- **Dependency Injection**
  - AuthenticationManager, JwtTokenizer
- **Method**
  - public Authentication [인증 시도 로직]
    - param = HttpServletRequest, HttpServletResponse
    - throws = None
    - 받은 User의 로그인 정보를 DTO로 역직렬화 하기 위한 ObjectMapper 객체 생성
    - Dto = objectMapper.readValue(request.getInputStream(), Dto.class) 로 DTO 역직렬화
    - Dto의 정보로 UsernamePasswordAuthenticationToken를 이용한 객체 생성
    - return AuthenticationManager의 메소드인 authenticate를 이용하여 인증 처리 위임
  - Overrided protected void [인증 성공 시 반환할 토큰 생성 로직]
    - param = HttpServletRequest & Response, FilterChain, Authentication
    - throws = None
    - Authentication의 기능인 getPrincipal()로 Entity 객체를 얻음
    - 위에서 얻은 Entity를 파라미터로, 밑에 작성할 [토큰 생성 로직]을 이용한 토큰 생성
    - response Header에 토큰 정보를 set
  - private String [Access Token 생성 로직]
    - param = Entity
    - throws = None
    - filed = Map,sub,ex,encodedKey -> 파라미터로 받은 Entity의 필드를 이용해 값을 채움
    - 토큰 생성 = 위에서 주입받은 Jwt생성 클래스의 토큰 생성 로직을 이용해 토큰 생성
    - return AccessToken
  - private String [Refresh Token 생성 로직]
    - param = Entity
    - throws = None
    - filed = sub,ex,encodedKey -> 파라미터로 받은 Entity의 필드를 이용해 값을 채움
    - 토큰 생성 = 위에서 주입받은 Jwt생성 클래스의 토큰 생성 로직을 이용해 토큰 생성
    - return Refresh Token

------

### **인증 성공 & 실패 시 Exception을 던지는 등, 추가 작업을 수행할 AuthenticationHandler 2개 생성**

- **Annotation**
  - @Slf4j
- **implementation, extends**
  - AuthenticationSuccessHandler, AuthenticationFailureHandler
- **Dependency Injection**
  - None
- **Method**
  - Overrided public void onAuthenticationSuccess & Failure
    - param = HttpServletRequest & Response,(success) Authentication / (fail) AuthenticationException
    - throws = IOException
    - (성공 시) log.info(" Message ")
    - (실패 시) log.error(" Message ", AuthenticationException의 기능인 getMessage())
    - (fail) return sendErrorResponse(response) 
  - (실패 시) private void [실패 시 던질 ErrorResponse]
    - param = HttpServletResponse
    - throws = IOExeption
    - Gson 객체 생성
    - ErrorResponse의 상태 호출
    - response에 적절한 에러 응답 set (error, Error.class)