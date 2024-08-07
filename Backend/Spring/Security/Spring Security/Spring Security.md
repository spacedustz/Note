
## 📚 Spring Security

**Custom HTTP Servlet Response**

```java
public class CustomHttpServletRequest extends HttpServletRequestWrapper {  
    private final Map<String, String> customHeaders;  
  
    public CustomHttpServletRequest(HttpServletRequest request) {  
        super(request);  
        this.customHeaders = new HashMap<String, String>();  
    }  
  
    public void putHeader(String name, String value) {  
        this.customHeaders.put(name, value);  
    }  
  
    public String getHeader(String name) {  
        String headerValue = this.customHeaders.get(name);  
        if (headerValue != null) return headerValue;  
  
        return ((HttpServletRequest) getRequest()).getHeader(name);  
    }  
}
```

<br>

**Custom Auth**

```java
@Getter @Setter  
public class CustomAuth implements GrantedAuthority {  
    private int viewId;  
    private boolean create = false;  
    private boolean update = false;  
    private boolean delete = false;  
    private boolean read = false;  
    private boolean noCheck = true;  
    private boolean notConfigured = false;  
  
    @Override  
    public String getAuthority() {  
        return null;  
    }  
}
```

<br>

**Pre Auth**

```java
@Retention(RetentionPolicy.RUNTIME)  
@Target(ElementType.METHOD)  
public @interface PreAuth {  
    int viewId();  
    AuthorizationType[] authorization() default AuthorizationType.Read;  
}
```

<br>

**DetailService**

```java
@Slf4j  
@Service  
@RequiredArgsConstructor  
public class DetailsService implements UserDetailsService {  
    private final AdminRepository adminRepository;  
  
    @Override  
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {  
        log.debug("[ UserDetailService ] - Login Email : {}", email);  
  
        Admin admin = adminRepository.findById(email).orElseThrow(() -> new UsernameNotFoundException(email));  
  
        if (ObjectUtils.isEmpty(admin)) {  
            throw new CommonException(ExceptionCode.INCORRECT_ID_OR_PASSWORD);  
        }  
        if (admin.getAdminStatus() == 0 || admin.getAdminStatus() == 9) {  
            throw new CommonException(ExceptionCode.UNAVAILABLE_USER);  
        }  
  
        return new AdminDetails(admin);  
    }  
  
    @Getter  
    @ToString    
    @AllArgsConstructor    
    public static class AdminDetails extends Admin implements UserDetails {  
        private final Admin admin;  
  
        @Override  
        public Collection<? extends GrantedAuthority> getAuthorities() {  
            List<GrantedAuthority> authorities = new ArrayList<>();  
            String role = admin.getAdminGroup().getName();  
            authorities.add(new SimpleGrantedAuthority(role));  
  
            return authorities;  
        }  
  
        @Override  
        public String getUsername() {  
            return admin.getId();  
        }  
  
        @Override  
        public String getPassword() {  
            return admin.getPassword();  
        }  
  
        @Override  
        public boolean isAccountNonExpired() {  
            return UserDetails.super.isAccountNonExpired();  
        }  
  
        @Override  
        public boolean isAccountNonLocked() {  
            return UserDetails.super.isAccountNonLocked();  
        }  
  
        @Override  
        public boolean isCredentialsNonExpired() {  
            return UserDetails.super.isCredentialsNonExpired();  
        }  
  
        @Override  
        public boolean isEnabled() {  
            return UserDetails.super.isEnabled();  
        }  
    }  
}
```

<br>

**User Authentication Provider**

```java
@Service  
@RequiredArgsConstructor  
@Slf4j  
public class UserAuthenticationProvider implements AuthenticationProvider {  
    protected MessageSourceAccessor messages = SpringSecurityMessageSource.getAccessor();  
  
    private final PasswordEncoder passwordEncoder;  
    private final AdminRepository adminRepository;  
  
    @Override  
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {  
        log.debug("[ User Authentication Provider ] In");  
  
        String loginId = authentication.getName();  
        String password = ((String) authentication.getCredentials()).trim();  
  
        Optional<Admin> optUser = adminRepository.findById(loginId);  
        Admin user = null;  
  
        if (optUser.isPresent()) {  
            user = optUser.get();  
            boolean isMatched = passwordEncoder.matches(password, user.getPassword());  
  
            if (!isMatched) {  
                log.info("[ User Authentication Provider ] - Invalid Password");  
                throw new CommonException(ExceptionCode.INCORRECT_ID_OR_PASSWORD);  
            }  
        } else {  
            log.info("[ User Authentication Provider ] - Not exist Account");  
            throw new CommonException(ExceptionCode.INCORRECT_ID_OR_PASSWORD);  
        }  
  
//        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();  
  
        Collection<? extends GrantedAuthority> authorities = null;  
        ArrayList<String> roles = null;  
  
        try {  
            roles = getRoles(user);  
            authorities = this.getAuthorities(user);  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
  
        if (authorities == null ) {  
            throw new BadCredentialsException(messages.getMessage(  
                    "SimpleGrantedAuthority.noAuthority",  
                    new Object[] { authentication.getName() }, "Username {0} not found"));  
        }  
  
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(loginId, authentication.getCredentials(), authorities);  
        authenticationToken.setDetails(optUser.get());  
  
        log.debug("[ User Authentication Provider ] - Provider Token : {}", authenticationToken);  
        return authenticationToken;  
    }  
  
    @Override  
    public boolean supports(Class<?> authentication) {  
        return true;  
    }  
  
    public Collection<? extends GrantedAuthority> getAuthorities(Admin user) throws Exception {  
        List<GrantedAuthority> authList = getGrantedAuthorities(getRoles(user));  
        return authList;  
    }  
  
    public ArrayList<String> getRoles(Admin user) throws Exception {  
        ArrayList<String> roles = new ArrayList<>();  
  
        String roleName = user.getAdminGroup().getName();  
        roles.add(roleName);  
  
        return roles;  
    }  
  
    public static List<GrantedAuthority> getGrantedAuthorities(List<String> roles) {  
        List<GrantedAuthority> authorities = new ArrayList<>();  
  
        for (String role : roles) {  
            authorities.add(new SimpleGrantedAuthority(role));  
        }  
  
        return authorities;  
    }  
}
```

<br>

**JWT Tokenizer**

```java
@Slf4j  
@Getter  
@Component  
public class JwtTokenizer {  
    @Value("${jwt.secret}")  
    private String secret;  
  
    @Value("${jwt.enabled}")  
    private boolean isExistExpirationTime;  
  
    @Value("${jwt.expiration.access-token}")  
    private int accessTokenExpirationMin;  
  
    // Access Token 생성  
    public String createAccessToken(Admin admin) {  
        String email = admin.getId();  
  
        Map<String, Object> claims = new HashMap<>();  
        claims.put(UserConstants.USER_ID, admin.getId());  
        claims.put(UserConstants.USER_ROLE, admin.getAdminGroup().getName());  
        claims.put(UserConstants.USER_NAME, admin.getName());  
  
        return generateAccessJwts(email, claims, accessTokenExpirationMin, secret);  
    }  
  
    /* ---------- Access Token 생성에 필요한 함수들 ---------- */  
    // Access Token Jwts 생성  
    private String generateAccessJwts(String email, Map<String, Object> claims, int expiration, String secret) {  
        // setClaims()를 먼저 하고 setSubject()를 해야 Subject가 들어감  
        JwtBuilder builder = Jwts.builder()  
                .setClaims(claims)  
                .setSubject(email)  
                .setIssuedAt(new Date(System.currentTimeMillis()))  
                .signWith(createSigningKey(secret), SignatureAlgorithm.HS256);  
  
        if (isExistExpirationTime) {  
            builder.setExpiration(new Date(System.currentTimeMillis() + expiration * 60 * 1000L)); // 분 단위에서 밀리초로 변환  
        }  
  
        return builder.compact();  
    }  
  
    // 토큰 Claims & Subject 검증  
    public boolean validateToken(String token) {  
        try {  
            boolean isValid = false;  
            String subject = this.getSubjectFromToken(token);  
            boolean hasSubject = StringUtils.hasText(subject);  
            boolean containsId = this.getAllClaims(token).containsKey(UserConstants.USER_ID);  
  
            if (hasSubject && containsId) {  
                isValid = true;  
            }  
  
            return isValid;  
        } catch (Exception e) {  
            log.error("[ JWT Token Verification Failed ] - {}", e.getMessage());  
            throw new AuthException("토큰 검증에 실패 하였습니다.");  
        }  
    }  
  
    // Token에서 Subject 반환  
    public String getSubjectFromToken(String token) {  
        try {  
            return this.getClaimFromToken(token, Claims::getSubject);  
        } catch (Exception e) {  
            log.error("Error Getting Subject From Token: ", e);  
            return null;  
        }  
    }  
  
    // 토큰에서 모든 Claims 반환  
    public Claims getAllClaims(String token) {  
        return Jwts.parserBuilder()  
                .setSigningKey(createSigningKey(secret))  
                .build()  
                .parseClaimsJws(token)  
                .getBody();  
    }  
  
    // Get Claims  
    public <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {  
        final Claims claims = this.getAllClaims(token);  
        return claimsResolver.apply(claims);  
    }  
  
    // Signing Key 생성  
    private SecretKey createSigningKey(String secretKey) {  
        return Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));  
    }  
  
    // Get Expiration Time  
    public Date getExpirationDateFromToken(String token) {  
        return this.getClaimFromToken(token, Claims::getExpiration);  
    }  
}
```

<br>

**JWT Authentication EntryPoint**

```java
@Component  
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint {  
    @Override  
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException, ServletException {  
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");  
    }  
}
```

<br>

**JWT Access Denied Handler**

```java
@Component  
public class JwtAccessDeniedHandler implements AccessDeniedHandler {  
    @Override  
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) throws IOException, ServletException {  
        response.sendError(HttpServletResponse.SC_FORBIDDEN, accessDeniedException.getMessage());  
    }  
}
```

<br>

**API Filter**

```java
@Slf4j  
@RequiredArgsConstructor  
public class ApiFilter extends OncePerRequestFilter {  
    private final JwtTokenizer jwtTokenizer;  
  
    private final static List<String> NO_NEED_TOKEN_API = Arrays.asList(  
            /* Login */  
            "/login",  
            /* Swagger */  
            "/api-docs",  
            "/swagger-ui/index.html",  
            "/swagger-ui/",  
            "/swagger-docs",  
            "/v3/api-docs",  
            "/swagger-resources",  
            "/webjars",  
            "/configuration",   
    );  
  
    @Override  
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {  
        log.debug("[ API Filter ] - Filter Internal IN");  
        CustomHttpServletRequest customRequest = null;  
  
        try {  
            customRequest = new CustomHttpServletRequest(request);  
  
            // 토큰이 필요 없는 URL 일 경우 필터체인 통과  
            if (this.isNoNeedTokenApi(customRequest)) {  
                log.info("[ API Filter ] No Need Token API Request - Skipping API Filter IN : {}", customRequest.getRequestURI());  
                customRequest.putHeader(UserConstants.TOKEN_STATUS, TokenStatus.NO_NEED_TOKEN.name());  
                filterChain.doFilter(customRequest, response);  
                return;  
            }  
  
            String token = this.extractToken(request);  
  
            if (!StringUtils.hasText(token)) throw new CommonException(ExceptionCode.INVALID_TOKEN);  
  
            if (!jwtTokenizer.validateToken(token)) {  
                log.warn("[ API Filter ] - JWT Token is Expired");  
                customRequest.putHeader(UserConstants.TOKEN_STATUS, TokenStatus.Expired.name());  
            }  
  
            try {  
                // Claims 에서 이메일과 권한 추출  
                Claims claims = jwtTokenizer.getAllClaims(token);  
                String id = String.valueOf(claims.get(UserConstants.USER_ID));  
                String role = String.valueOf(claims.get(UserConstants.USER_ROLE));  
                String name = String.valueOf(claims.get(UserConstants.USER_NAME));  
  
                if (claims.isEmpty()) {  
                    log.info("[ API Filter ] - JWT Claims is Empty");  
                    customRequest.putHeader(UserConstants.TOKEN_STATUS, TokenStatus.Invalid.name());  
                } else {  
                    // 추출한 이메일과 권한을 헤더에 저장  
                    customRequest.putHeader(UserConstants.USER_ID, id);  
                    customRequest.putHeader(UserConstants.USER_ROLE, role);  
                    customRequest.putHeader(UserConstants.USER_NAME, name);  
                    customRequest.putHeader(UserConstants.TOKEN_STATUS, TokenStatus.Valid.name());  
                }  
  
            } catch (io.jsonwebtoken.security.SecurityException | MalformedJwtException e) {  
                log.debug("Invalid JWT signature");  
                customRequest.putHeader(UserConstants.TOKEN_STATUS, TokenStatus.Invalid.name());  
            } catch (ExpiredJwtException e) {  
                log.debug("Expired JWT");  
                customRequest.putHeader(UserConstants.TOKEN_STATUS, TokenStatus.Expired.name());  
            } catch (UnsupportedJwtException e) {  
                log.debug("Unsupported JWT");  
                customRequest.putHeader(UserConstants.TOKEN_STATUS, TokenStatus.Invalid.name());  
            } catch (IllegalArgumentException e) {  
                log.debug("Invalid JWT");  
                customRequest.putHeader(UserConstants.TOKEN_STATUS, TokenStatus.Invalid.name());  
            } catch (Exception e) {  
                log.error("JWT Validate Exception:" + e.getMessage());  
                customRequest.putHeader(UserConstants.TOKEN_STATUS, TokenStatus.Invalid.name());  
            }  
  
            filterChain.doFilter(customRequest, response);  
            log.debug("[ API Filter ] - Filter Internal OUT");  
        } catch (Exception e) {  
            CustomHttpServletRequest logRequest = new CustomHttpServletRequest(request);  
            log.error("\n[ API Filter ] \nURI - {} \nError - {}", logRequest.getRequestURI(), e.getMessage());  
  
            response.setStatus(HttpStatus.BAD_REQUEST.value());  
            response.setContentType("application/json");  
            response.setCharacterEncoding("UTF-8");  
  
            Map<String, Object> errorResponse = new LinkedHashMap<>();  
            errorResponse.put("code", ExceptionCode.INVALID_TOKEN.getCode()); // ExceptionCode의 code            errorResponse.put("msg", ExceptionCode.INVALID_TOKEN.getMsg());   // ExceptionCode의 msg            errorResponse.put("data", e.getMessage());  
  
            response.getWriter().write(new ObjectMapper().writeValueAsString(errorResponse));  
            response.getWriter().flush();  
            response.getWriter().close();  
        }  
    }  
  
    /**  
     * @author 신건우  
     * @desc 토큰 검증이 필요 없는 API 인지 True, False 반환  
     */  
    private boolean isNoNeedTokenApi(CustomHttpServletRequest request) {  
        String requestURI = request.getRequestURI();  
        return NO_NEED_TOKEN_API.stream().anyMatch(requestURI::startsWith);  
    }  
  
    /**  
     * @author 신건우  
     * @desc Bearer 토큰 추출  
     */  
    private String extractToken(HttpServletRequest request) {  
        String bearerToken = request.getHeader(UserConstants.AUTHORIZATION);  
  
        if (StringUtils.hasText(bearerToken) && bearerToken.trim().toLowerCase().startsWith("bearer")) {  
            return bearerToken.substring(7);  
        } else {  
            return null;  
        }  
    }  
}
```

<br>

**Security Config**

```java
@Slf4j  
@Configuration  
@EnableWebSecurity  
@RequiredArgsConstructor  
public class SecurityConfig {  
    private final JwtTokenizer jwtTokenizer;  
    private final JwtAccessDeniedHandler accessDeniedHandler;  
    private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;  
  
    @Bean  
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {  
        log.info("[ Security Filter Chain ] - IN");  
  
        http  
                .addFilterBefore(new ApiFilter(jwtTokenizer), UsernamePasswordAuthenticationFilter.class)  
  
                // CSRF 공격은 보통 세션 기반 인증 방식의 허점을 노린 것임.  
                // CSRF 공격에 대한 설명 : https://junhyunny.github.io/information/security/spring-boot/spring-security/cross-site-reqeust-forgery/                // JWT 토큰 인증 방식을 사용하기 때문에 CSRF 보호를 비활성화함.  
                .csrf(AbstractHttpConfigurer::disable)  
  
                // CORS 설정  
                .cors(Customizer.withDefaults())  
  
                // HTTP Basic 인증은 사용자 이름과 비밀번호를 Base64로 인코딩하여 HTTP 헤더에 포함시켜 서버에 전송하는 방식  
                // JWT 토큰 인증 방식을 사용하기 때문에 HTTP Basic 인증을 비활성화함.  
                .httpBasic(AbstractHttpConfigurer::disable)  
  
                // 스프링 시큐리티가 기본으로 제공하는 폼 로그인 기능을 비활성화함.(기본 로그인 페이지를 통한 인증 수행을 하지 않겠다는 의미)  
                .formLogin(AbstractHttpConfigurer::disable)  
  
                // Builder 패턴을 사용해 HTTP Request URL에 대한 Authentication 규칙 설정  
                .authorizeHttpRequests((request) -> request  
                        .requestMatchers("/static/**", "/css/**", "/js/**", "/images/**").permitAll()  
                        .requestMatchers("/**").permitAll()  
                        .anyRequest().authenticated())  
  
                // Spring Security가 세션을 생성/유지 하지 않도록 설정, JWT 토큰을 사용하기 떄문에 세션 사용 안함  
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))  
  
                // Exception Handling  
                .exceptionHandling((exception) -> exception  
                        .authenticationEntryPoint(jwtAuthenticationEntryPoint)  
                        .accessDeniedHandler(accessDeniedHandler));  
  
                return http.build();  
    }  
  
    @Bean  
    public PasswordEncoder passwordEncoder() {  
        return new BCryptPasswordEncoder();  
    }  
  
    @Bean  
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {  
        return authenticationConfiguration.getAuthenticationManager();  
    }  
  
    @Bean  
    public CorsConfigurationSource corsConfigurationSource() {  
        //  
        CorsConfiguration configuration = new CorsConfiguration();  
        configuration.setAllowedOrigins(List.of("http://localhost", "http://localhost:3000")); // 허용할 도메인 설정  
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));  
        configuration.setAllowedHeaders(List.of("Authorization", "Cache-Control", "Content-Type"));  
        configuration.setAllowCredentials(true);  
  
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();  
        source.registerCorsConfiguration("/**", configuration);  
        return source;  
    }  
}
```