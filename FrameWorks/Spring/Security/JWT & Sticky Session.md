## **💡 JWT 인증 (CSR 방식)**

**기존 SSR 세션 기반 방식**
HTTP는 Request 전송 후 & Response 수신 후 Connection을 끊는 **비연결성**,
Request, Response에 대한 상태를 버리는 **비상태성**의 특성이 있는데,
서버에서는 매번 인증된 사용자가 보낸 Request인지 어떻게 구분할까?

<br>

 답은 세션 기반의 자격증명 방식을 사용해 유저의 정보를 세션의 형태로 저장한다

<br>

### **JWT 유래**

- SSR 방식에서의 세션 기반 FilterChain 인증을 사용했을때 인증에 필요한 리소스는 모두 서버가 부담해야했다.
- 이 리소스 부담을 덜어줄 방법을 고안해낸게 CSR방식의 JWT인증으로, 인증부담을 클라이언트에게 전가한다.
- 민감정보를 클라이언트 측에서 보관하는 보안관점에서의 취약점 -> 인증정보 암호화로 해결

<br

### **JWT 특징**

- Access Token & Refresh Token 사용
- 서버측에서 인증된 사용자 정보를 관리 X
- 토큰을 헤더에 포함시켜 사용자 인증, 토큰 만료 전까지 토큰의 무효화 불가능
- 인증 사용자의 Request 상태를 유지 할 필요가 없기 때문에 확장성 ↑, 세션 불일치 문제 없음
- redis 등 인메모리 DB에 무효화시킬 토큰의 만료시간을 짧게 주어 토큰 무효화 문제 보완 가능

<br

### **세션 기반 자격 증명의 특성**

- 서버는 인증된 유저를 세션 저장소에서 관리
- 고유 정보인 세션ID로 유저의 Authentication을 증명
- 세션 ID만을 이용한 클라이언트 측 전송으로 인한 네트워크 트래픽 ↓
- 세션 불일치 등의 문제 발생 가능성이 있다.
- SSR 방식의 Application에 적합한 방식

------

### **💡 JWT Token의 구조**

- Header
  - 어떤 종류의 토큰인지 & 어떤 Hash 암호화 알고리즘을 사용할지 JSON Format 형태로 정의
  - 이 객체를 base64 Encoding하면 JWT의 Header 부분 완성
  - **ex:** { "alg: "HS256", "typ": "JWT" }
- Payload
  - User 민감하지 않은 정보(**ex:** name, age 등)가 담겨있는 메인 필드
  - 할당할 수 있는 권한 정의 
  - 이 객체를 base64 Encoding하면 JWT의 Payload 부분 완성
- Signature
  - Base64로 인코딩된 Header, Payload를 원하는 Private Key + Header에서 지정한 알고리즘을 이용해,
    Header & Payload에 대한 단방향 암호화 수행
  - 위처럼, 암호회된 메시지는 토큰의 위변조 검증에 사용됨

```java
HMACSHA256(base64UrlEncode(header) + '.' + base64UrlEncode(payload), secret);
```

------

#### **인증 과정**

- 인증 정보가 담긴 Post 요청 전송
- 인증정보가 일치하면 DB가 암호화 토큰을 생성해 클라이언트로 전송
- 클라이언트가 다시 HTTP Header에 암호화된 토큰 & 리소스 요청을 포함한 정보 전송
- 서버에서 암호화된 토큰을 디코딩하여 인증 정보가 일치하면 요청한 리소스를 응답해준다

<br

### **JWT의 장점**

- Statelessness
  - 클라이언트의 정보를 저장할 필요가 없다
  - 토큰을 헤더에 추가해서 인증을 한다
- Stability
  - 키 노출 필요성 X
  - 암호화 한 토큰 사용
- Scalability
  - 서버의 무조건적인 토큰 생성 불필요
  - 토큰 생성작업의 역할 분리가 가능하다
- Easy Authroization
  - 토큰의 Payload에 권한 정보를 담을 수 있다

<br

### **JWT의 단점**

- Payload 디코딩의 용이함 -> 보안 취약
- length가 긴 토큰 -> 네트워크 부하 증가
- 토큰 만료기간이 없는경우 자동 삭제가 안됨 -> 서버 부하 증가

<br

### **구조 복습**

```markdown
> ## 📌 JWT 구조 (2,3,5,7 구현), (4,6은 Spring Security의 AuthenticationManager가 처리)

1. 클라이언트가 서버에 로그인 인증 요청(Username & Password를 서버에 전송)

2. 로그인 인증을 담당하는 Security Filter(JwtAuthenticationFilter)가 로그인 인증 정보 수신

3. Security Filter가 수신한 로그인 정보를 AuthenticationManager에게 전달해 인증 처리를 위임

4. AuthenticationManager가 CustomUserDetailsService에게 사용자의 UserDetails 조회 위임

5. CustomUserDetailsService가 사용자의 크리덴셜을 DB에서 조회 후, AuthenticationManager에게 UserDetails 전달

6. AuthenticationManager가 로그인 인증 정보와 UserDetails의 정보를 비교해 인증 처리

7. JWT 생성 후, 클라이언트에게 전달
```

------

## **💡 구현**

<br

### **JwtTokenizer**

```java
public class JwtTokenizer {

    // Encoding Plain Text
    public String encodeBase64SecretKey(String secretKey) {
        return Encoders.BASE64.encode(secretKey.getBytes(StandardCharsets.UTF_8));
    }

    // Access Token 생성
    public String generateAccessToken(Map<String, Object> claims,
                                      String subject,
                                      Date expiration,
                                      String base64EncodedSecretKey) {

        // Key 객체 생성
        Key key = getKeyFromBase64EncodedKey(base64EncodedSecretKey);

        return Jwts.builder()
                .setClaims(claims)  // Custom Claims 추가(인증된 사용자 정보)
                .setSubject(subject) // JWT title
                .setIssuedAt(Calendar.getInstance().getTime()) // 발행일자
                .setExpiration(expiration) // 만료일자
                .signWith(key) // 서명을위한 Key 객체 설정
                .compact(); // 직렬화
    }

    // RefreshToken 생성, Custom Claims가 필요 없음
    public String generateRefreshToken(String subject,
                                       Date expiration,
                                       String base64EncodedSecretKey) {

        Key key = getKeyFromBase64EncodedKey(base64EncodedSecretKey);

        return Jwts.builder()
                .setSubject(subject)
                .setIssuedAt(Calendar.getInstance().getTime())
                .setExpiration(expiration)
                .signWith(key)
                .compact();
    }

    // Decoding
    private Key getKeyFromBase64EncodedKey(String base64EncodedSecretKey) {

        byte[] keyBytes = Decoders.BASE64.decode(base64EncodedSecretKey);
        Key key = Keys.hmacShaKeyFor(keyBytes);

        return key;
    }
}
```

<br

### **JwtAuthenticationFilter**

```java
// Username & Password 기반의 인증을 처리하기위한 상속
public class JwtAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenizer jwtTokenizer;

    public JwtAuthenticationFilter(AuthenticationManager authenticationManager, JwtTokenizer jwtTokenizer) {
        this.authenticationManager = authenticationManager;
        this.jwtTokenizer = jwtTokenizer;
    }


    // 메서드 내부에서 인증 시도 로직 구현
    @Override
    @SneakyThrows // 메서드 선언부에 throws를 정의 안해도 검사된 예외를 throw할수 있게 해주는 어노테이션
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {

        // 역직렬화를 위한 객체
        ObjectMapper objectMapper = new ObjectMapper();

        // Object Mapper를 이용한 역직렬화, JSON -> Java 객체
        LoginDto loginDto = objectMapper.readValue(request.getInputStream(), LoginDto.class);

        // Username과 Password를 포함한 UsernameAuthenticationToken 생성
        UsernamePasswordAuthenticationToken authenticationToken =
                new UsernamePasswordAuthenticationToken(loginDto.getEmail(), loginDto.getPassword());

        // DI 받은 AuthenticationManager 에게 인증 처리 위임
        return authenticationManager.authenticate(authenticationToken);
    }

    // 인증 성공 시 호출될 메서드
    @Override
    protected void successfulAuthentication(HttpServletRequest request,
                                            HttpServletResponse response,
                                            FilterChain chain,
                                            Authentication authResult) {

        // 엔티티 객체를 얻음
        Member member = (Member) authResult.getPrincipal();
        // Access Token 생성
        String accessToken = delegateAccessToken(member);
        // Refresh Token 생성
        String refreshToken = delegateRefreshToken(member);

        // Response Header에 Access Token 추가
        response.setHeader("Authorization", "Bearer " + accessToken);
        // Response Header에 Refresh Token 추가
        response.setHeader("Refresh", refreshToken);
    }

    // Private Access Token 생성 로직
    private String delegateAccessToken(Member member) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("username", member.getEmail());
        claims.put("roles", member.getRoles());

        String subject = member.getEmail();
        Date expiration = jwtTokenizer.getTokenExpiration(jwtTokenizer.getAccessTokenExpirationMinutes());

        String base64EncodedSecretKey = jwtTokenizer.encodeBase64SecretKey(jwtTokenizer.getSecretKey());

        String accessToken = jwtTokenizer.generateAccessToken(claims, subject, expiration, base64EncodedSecretKey);

        return accessToken;
    }

    // Private Refresh Token 생성 로직
    private String delegateRefreshToken(Member member) {
        String subject = member.getEmail();
        Date expiration = jwtTokenizer.getTokenExpiration(jwtTokenizer.getRefreshTokenExpirationMinutes());
        String base64EncodedSecretKey = jwtTokenizer.encodeBase64SecretKey(jwtTokenizer.getSecretKey());

        String refreshToken = jwtTokenizer.generateRefreshToken(subject, expiration, base64EncodedSecretKey);

        return refreshToken;
    }
}
```

<br

### **SecurityConfiguration - JWT 로그인 인증 설정 추가**

```java
// JWT AuthenticationFilter 등록
public class CustomFilterConfigurer extends AbstractHttpConfigurer<CustomFilterConfigurer, HttpSecurity> {

    @Override // Configure Method를 Override 함으로써 SecurityConfig를 Customizing 할 수 있다
    public void configure(HttpSecurity builder) throws Exception {

        // getSharedObject()로 인해 SecurityConfigurer간에 공유되는 객체를 얻을 수 있음
        AuthenticationManager authenticationManager = builder.getSharedObject(AuthenticationManager.class);

        // 객체 생성과 동시에 AuthenticationManager & JwtTokenizer를 DI 해줌
        JwtAuthenticationFilter jwtAuthenticationFilter = new JwtAuthenticationFilter(authenticationManager, jwtTokenizer);

        // setFilterProccessUrl() 를 통해 로그인 URL Customize 가능 (default url은 /login 이다)
        jwtAuthenticationFilter.setFilterProcessesUrl("/auth/login");

        // addFilter()를 통해 JWT 검증필터를 Filter Chain에 추가
        builder.addFilter(jwtAuthenticationFilter);
    }
}
```

<br>

회원가입 후, 로그인 요청을 보냈을때 Access Token, Refresh Token이 잘 생성됨

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/JWT.png) 

------

## **💡 Sticky Session**

- 로드밸런서가 세션 만료 기간동안 클라이언트 & 서버 간 선호도를 생성하는 프로세스
- 세션을 고정하므로 네트워크 리소스 사용의 최적화
- 로드밸런서는 유저의 세부정보를 조회하여 식별자를 할당한다
- Sticky Session이 유지 되는동안 로드밸런서는 이 특정 사용자의 모든 요청을 특정 서버로의 요청을 라우팅
- 이처럼, 세션 지속성이 없을 경우, 웹 앱은 다수의 서버에 특정 유저의 정보를 유지해야 하므로,
  대규모 네트워크 트래픽을 가진 환경에서는 비효율적일 수 밖에 없다

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sticky_Session.png) 