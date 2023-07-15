## **💡 Spring Security**  

**어플리케이션에 Spring Security가 없을때 중요한 요소가 빠져있다.**

- Authentication (인증)
- Authorization (인가)
- 웹 보안 취약점에 대한 방지

**Spring Security를 사용하는 이유**

- 특정 보안 요구사항을 만족하기 위한 Customizing 용이
- 유연한 확장
- 보안기능이 검증된 신뢰할만한 보안 프레임워크

**Spring Security의 로그인 인증 방식**

- Form Login 방식 : SSR 방식의 어플리케이션에서 주로 사용

<br>

### **Security를 적용하여 보안 취약으로 인한 사고 방지 방법**

- SSL 적용
- Role 별 권한 적용
- 많은 유형의 사용자 인증 기능
- 민감 정보 암호화
- resource ACL
- 알려진 웹 공격 차단

<br>

### **Spring Security 용어**

- Principal (주체)
  - 작업수행 사용자, 시스템 등 인증완료된 사용자의 계정 정보를 의미
- Authentication (인증)
  - 인증의 정상적 수행을 위한 Credential(Password 등) 정보가 필요함
- Authorization (인가)
  - 인증을 통과한 사용자에게 특정 리소스에 대한 권한을 Role 형태로 ACL
- Access Controller (접근제어)
  - resource ACL

------

## **💡 동작 과정**



### **Security Configuration - Inmemory User 설정 (테스트 용도)**

- UserDetailsManager
  - UserDetails 인터페이스의 구현체인 User 작성
- User
  - withDefaultPasswordEncoder() <- Deprecated (유저를 고정해서 사용하지 말라는 의미의 Deprecated)
    - password Incoding
  - roels()
    - 유저 레벨 설정
- InMemoryUserDetailsManager객체 리턴

```java
    // Spring Security의 설정 정보 작성

    @Bean
    public UserDetailManager user() {

        /** 이 방식은 데모 & 테스트 시 유용하게 사용할 수 있으며, 실무에서 사용 X 
         *  사용자 인증을 위한 계정정보를 메모리에 고정
         *
         * 1. UserDetails를 관리하는 UserDetailsManager 인터페이스 타입 선언
         * 2. UserDetails 인터페이스의 구현체인 User 클래스를 사용하여 User의 인증 정보 생성
         * 3. withDefaultPasswordEncoder를 사용한 패스워드의 암호화 적용
         * 4. roles() - 유저의 역할 지정
         * 5. 메모리상으로 UserDetails를 관리하므로 InMemoryUserDetailsManager 구현체를 사용하여 객체를 빈으로 등록
         */

        UserDetails user =
                User.withDefaultPasswordEncoder() // 패스워드 암호화
                        .username("abc@abc.com")
                        .password("1234")
                        .roles("USER")
                        .build();

        UserDetails admin =
                User.withDefaultPasswordEncoder() // 패스워드 암호화
                        .username("admin@abc.com")
                        .password("1234")
                        .roles("ADMIN")
                        .build();

        return new InMemoryUserDetailsManager(user, admin);
    }
```

<br>

### **Security Configuration - Filter 설정 (Custom Login Page 지정)**

- SecurityFilterChain 의 파라미터로 HttpSecurity 사용하며 Exception을 던짐
- Http Option
  - frameOptions() - html 태그 중 **frame,iframe,object** 태그 페이지 렌더링 여부 결정
  - sameOrigin() - 동일 출처의 request만 렌더링
  - csrf().disable() - crsf 공격 방지 disable
  - formlogin() - 로그인 방식 지정
  - loginPage() - 로그인 페이지를 렌더링할 view 지정
  - loginProcessingUrl() - 로그인 인증을 수행할 form.action의 URL과 매핑되는 URL 지정
  - failureUrl() - 로그인 실패 시 리다이렉트될 view 지정
  - logout() - 로그아웃 설정을 위한 LogoutConfigurer 리턴
  - logoutUrl() - 로그아웃 페이지를 렌더링할 view 지정
  - logoutSuccessUrl - 로그인 성공 시 리다이렉트 될 경로 지정
  - and() - 보안설정 체인화
  - authorizeHttpRequests() - 요청이 들어올때 ACL 수행
  - anyRequest().permitAll() - 모든 요청에 대한 접근 허용

```java
    // Custom Login Page 지정
    
    @Bean
    public SecurityFilterChain CustomLoginPage(HttpSecurity lendering) throws Exception {

        /** HTTP Security를 통한 HTTP Request 보안 설정
         * 
         * 1. csrf 공격 방어 disable
         * 2. 인증방법 지정 - form login
         * 3. 파라미터 -> AuthController의 AuthForm()에 URL 요청 전송
         * 4. 로그인 인증 요청을 수행할 요청 URL 지정, login.html - form 태그 - action의 URL과 동일
         * 5. 인증 실패 시 리다이렉트 할 URI 지정
         * 6. 보안 설정을 메소드 체인 형태로 구성 가능
         * 7. 접근 권한 체크 정의
         * 8-9. 클라이언트의 모든 요청에 대해 접근 허용
         */

        lendering
                .csrf().disable() // 1
                .formLogin() // 2
                .loginPage("/secure/auth-form") // 3
                .loginProcessingUrl("/process_login") // 4
                .failureUrl("/secure/auth-form?error") // 5
                .and() // 6
                .authorizeHttpRequests() // 7
                .anyRequest() // 8
                .permitAll(); // 9

        return lendering.build();
    }
```

<br>

### **Security Configuration - Request URL 접근 권한 부여**

```java
    // Request URI 접근 권한 부여

    @Bean
    public SecurityFilterChain AuthorizeRequest(HttpSecurity authorize) throws Exception
    {

        /** exceptionHandling() 부터 설명
         * 
         * 1. 권한없는 사용자가 특정 requestURL에 접근시 표시할 에러 페이지 렌더링 & Exception 처리
         * 2. 람다 표현식을 통한 request URI 접근 권한 부여 - antMatchers 순서 주의 (낮은 권한 순으로 작성 필수)
         * 3. '*'이 1개일 경우 하위 URL의 depth가 1인 URL만 허용
         * 4. 단일 페이지 접근 지정
         * 5. 모든 URL 허용
         */

        authorize
                .csrf().disable()
                .formLogin()
                .loginPage("/secure/auth-form")
                .loginProcessingUrl("/process_login")
                .failureUrl("/secure/auth-form?error")
                .and()
                .exceptionHandling().accessDeniedPage("/secure/denied") // 1
                .and()
                .authorizeHttpRequests(authorize -> authorize // 2
                        .antMatchers("/orders/**").hasRole("ADMIN") // 3
                        .antMatchers("/members/my-page").hasRole("USER") // 4
                        .antMatchers("/**").permitAll()); // 5
        return authorize.build();
    }
```

<br>

### **Security Configuration - LogOut 기능 구현**

```java
    // LogOut 기능 구현

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity logout) throws Exception {

        /** logout() 부터 설명
         * 
         * 1. 로그아웃 설정을 위한 LogoutConfigurer 리턴
         * 2. 로그아웃을 진행할 Request URL 지정
         * 3. 로그아웃 후 리다이렉트 할 URL 지정
         */

        logout
                .csrf().disable()
                .formLogin()
                .loginPage("/auths/login-form")
                .loginProcessingUrl("/process_login")
                .failureUrl("/auths/login-form?error")
                .and()
                .logout()                        // 1
                .logoutUrl("/logout")            // 2
                .logoutSuccessUrl("/")  // 3
                .and()
                .exceptionHandling().accessDeniedPage("/auths/access-denied")
                .and()
                .authorizeHttpRequests(authorize -> authorize
                        .antMatchers("/orders/**").hasRole("ADMIN")
                        .antMatchers("/members/my-page").hasRole("USER")
                        .antMatchers("⁄**").permitAll()
                );
        return logout.build();
    }
```

<br>

### **CORS 설정**

```java
    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        // 모든 출처에 대해 스크립트 기반의 HTTP 통신 허용
        configuration.setAllowedOrigins(Arrays.asList("*"));
        // 파라미터로 지정한 HTTP Method에 대한 HTTP 통신 허용
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PATCH", "DELEE", "GET"));

        // CorsConfigurationSource의 구현체인 UrlBasedCorsConfigurationSource 객체 생성
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        // 모든 URL에 앞에서 구성한 CORS 정책 적용
        source.registerCorsConfiguration("/**", configuration);

        return source;
    }
```

<br>

### **Security Configuration - Password Encrypt 설정**

- PasswordEncoder
  - PasswordEncoderFactories.createDelegatingPasswordEncoder() 를 통해
    DelegatingPasswordEncoder가 PasswordEncoder 구현 객체 생성 
  - User 설정에서 미리 선언한 유저의 PW에도 PasswordEncoder를 통한 암호화 적용

```java
    @Bean
    public PasswordEncoder passwordEncoder() {
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }
```

<br>

### **정리**

- UserDetailsManager - Spring Security의 User를 관리, 하위 타입 -> InMemoryUserDetailsManager
  - UserDetails 로 User 생성, User 정보 관리
  - USerDetailService - User 정보를 로드하는 인터페이스
- UserDetailsService - 유저 정보 로드
- PasswordEncoder - 패스워드 암호화
- AuthorityUtils - 권한 목록 생성용 클래스
  - 리턴 List<GrantedAuthority>
- CustomAuthorityUtils
  - List<GrantedAuthority> 를 이용하여 권한 생성
  - 검증에 필요한 필드를 이용해 유저의 권한을 생성, 매핑

```java
// 유형별 권한 생성

@Component
public class CustomAuthorityUtils {

//    @Value("${mail.address.admin}")
//    private String adminMailAddress;

    // 메모리 저장용
    private final List<GrantedAuthority> ADMIN_ROLES = AuthorityUtils.createAuthorityList("ROLE_ADMIN", "ROLE_USER");
    private final List<GrantedAuthority> USER_ROLES = AuthorityUtils.createAuthorityList("ROLE_USER");

    // DB 저장용
    private final List<String> ADMIN_ROLES_STRING = List.of("ADMIN", "USER");
    private final List<String> USER_ROLES_STRING = List.of("USER");



    // 메모리 상의 Role 기반으로 권한 생성
    public List<GrantedAuthority> createAuthorities(String email) {

        if (email.equals(adminMailAddress)) {
            return ADMIN_ROLES;
        }
        return USER_ROLES;
    }

    // DB에 저장된 Role을 기반으로 권한 정보 생성
    public List<GrantedAuthority> createAuthorities(List<String> roles) {

        List<GrantedAuthority> authorities = roles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_"+role))
                .collect(Collectors.toList());
        return authorities;
    }

    // DB 저장용 Role 생성 검증 요소는 알아서 필드 선정
    public List<String> createRoles(String email) {

        if (email.equals(adminMailAddress)) {
            return ADMIN_ROLES_STRING;
        }
        return USER_ROLES_STRING;
    }
}
```

- CustomUserDetails implements UserDetailsService
  - DB에서 User를 조회하고, 조회한 USer의 권한 정보를 생성하기 위해 MemberRepository와
    HelloAuthorityUtils 클래스를 주입

```java
/* DB조회 멤버 -> Spring Security User로의 변환과정 캡슐화 */

@Component
public class CustomUserDetailsService implements UserDetailsService {
    private final MemberRepository memberRepository;
    private final CustomAuthorityUtils authorityUtils;

    // User의 Role 권한을 생성하기 위해 DI 받음
    public CustomUserDetailsService(MemberRepository memberRepository, CustomAuthorityUtils authorityUtils) {
        this.memberRepository = memberRepository;
        this.authorityUtils = authorityUtils;
    }


    // DB의 정보를 기반으로 유저의 인증 처리

    @Override // UserDetailsService의 구현 메서드
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        Optional<Member> optMember = memberRepository.findByEmail(username);

        Member findMember = optMember.orElseThrow(
                () -> new BusinessLogicException(ExceptionCode.MEMBER_NOT_FOUND));

        Collection<? extends GrantedAuthority> authorities = authorityUtils.createAuthorities(findMember.getEmail());

        // 리팩터링 포인트
//        return new User(findMember.getEmail(), findMember.getPassword(), authorities);
        return new CustomUserDetails(findMember);
    }

    // 유저 정보 생성 내부 클래스
    private final class CustomUserDetails extends Member implements UserDetails {

        CustomUserDetails(Member member) {
            setMemberId(member.getMemberId());
            setName(member.getName());
            setEmail(member.getEmail());
            setPassword(member.getPassword());
            setRoles(member.getRoles());
        }


        // CustomAuthorityUtils의 메서드를 이용해 User의 권한 정보 생성
        @Override
        public Collection<? extends GrantedAuthority> getAuthorities() {
            return authorityUtils.createAuthorities(this.getRoles());
        }

        @Override
        public String getUsername() {
            return getEmail();
        }

        @Override
        public boolean isAccountNonExpired() {
            return true;
        }

        @Override
        public boolean isAccountNonLocked() {
            return true;
        }

        @Override
        public boolean isCredentialsNonExpired() {
            return true;
        }

        @Override
        public boolean isEnabled() {
            return true;
        }
    }
}
```

- DBMemberService implements MemberService
  - User의 인증 정보를 DB에 저장

```java
/* DB에 User를 등록하기 위한 클래스 */

public class DBMemberService implements CustomMemberService {

    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;
    private final CustomAuthorityUtils authorityUtils;

    public DBMemberService(MemberRepository memberRepository, PasswordEncoder passwordEncoder, CustomAuthorityUtils authorityUtils) {
        this.memberRepository = memberRepository;
        this.passwordEncoder = passwordEncoder;
        this.authorityUtils = authorityUtils;
    }

    @Override
    public Member createMember(Member member) {
        // 멤버 검증
        verifyExistsEmail(member.getEmail());

        String encryptedPassword = passwordEncoder.encode(member.getPassword());

        member.setPassword(encryptedPassword);

        // 권한 정보를 DB에 저장
        List<String> roles = authorityUtils.createRoles(member.getEmail());
        member.setRoles(roles);

        Member savedMember = memberRepository.save(member);

        System.out.println("# Create Member in DB");
        return savedMember;
    }
}
```

- Spring Security에서 SimpleGrantedAuthority 를 사용해 Role 베이스 형태의 권한을 지정할 때
  ‘Roll_’ + 권한명 형태로 지정해야함

- AuthenticationProvider - 직접 인증 처리

```java
/* 직접 로그인 인증 방식 */

@Component
public class UserAuthenticationProvider implements AuthenticationProvider {

    private final CustomUserDetailsService userDetailsService;
    private final PasswordEncoder passwordEncoder;

    public UserAuthenticationProvider(CustomUserDetailsService userDetailsService, PasswordEncoder passwordEncoder) {
        this.userDetailsService = userDetailsService;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {

        // 파라미터값을 캐스팅해 UsernamePasswordAuthenticationToken 을 얻음
        UsernamePasswordAuthenticationToken authToken = (UsernamePasswordAuthenticationToken) authentication;

        // 위에서 얻은 토큰
        String username = authToken.getName();
        Optional.ofNullable(username).orElseThrow(() -> new UsernameNotFoundException("Invalid Name or Password"));

        try {
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);

            String password = userDetails.getPassword();
            verifyCredentials(authToken.getCredentials(), password);

            Collection<? extends GrantedAuthority> authorities = userDetails.getAuthorities();

            return UsernamePasswordAuthenticationToken.authenticated(username, password, authorities);
        } catch (Exception e) {
            throw new UsernameNotFoundException(e.getMessage());
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return UsernamePasswordAuthenticationToken.class.equals(authentication);
    }

    private void verifyCredentials(Object credentials, String password) {
        if (!passwordEncoder.matches((String)credentials, password)) {
            throw new BadCredentialsException("Invalid User name or User Password");
        }
    }
}
```

<br>

Filter Chain

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Security.png) 