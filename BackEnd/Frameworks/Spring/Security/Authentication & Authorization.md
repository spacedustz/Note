## **💡 Authentication Processing Flow**

인증 처리 과정

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Authentication.png)

<br>

- 1. User의 로그인 시도, Request를 제일 먼저 만나는 컴포넌트 - UsernamePasswordAuthenticationFilter

  Login Form 방식의 로그인 시 사용

<br>

- 2. ID, PW를 전달받은 UsernamePasswordAuthenticationFilter는 UsernamePasswordAuthenticationToken을 생성

  \* UsernamePasswordAuthenticationFilter는 AbstractAuthenticationProcessingFilter를 상속한다.
   UsernamePasswordAuthenticationToken은 Authentication 인터페이스의 구현체이다

<br>

- 3. 인증이 되지않은 Authentication을 AuthenticationManager 인터페이스를 구현한 ProviderManager에게 전달

<br>

- 4. ProviderManager -> AuthenticationProvider로 인증이 되지않은 Authentication 전달

<br>

- 5. UserDetailsService를 이용해 UserDetails를 구현한 User의 Credential 조회

  UserDetails는 DB에 저장된 사용자의 Credential인 PW, 권한 정보를 포함하는 컴포넌트이고,
  그 UserDetails를 제공하는 컴포넌트가 UserDetailService이다

<br>

- 6. DB에서 조회한 사용자의 Credential을 기반으로 UserDetails를 생성 후, AuthenticationProvider에게 전달

<br>

- 7. UserDetails를 전달받고 PasswordEncoder를 이용해

  UserDetails의 PW와 Authentication의 PW가 일치하는지 검증

<br>

- 8. 인증에 성공하면 UserDetails를 이용해 인증된 Authentication 생성 후 ProviderManager에게 전달

  인증에 실패하면 Exception을 발생시키고 인중 중단

<br>

- 9. 인증된 Authentication을 AuthenticatinFilter로 전달

<br>

- 10. SecurityCOntextHolder를 이용해 SecurityContext에 인증된 Authentication을 저장함

   그리고 SecurityContext는 Spring Security의 정책에 따라 HttpSession에 저장된,
  사용자의 인증 유지 or Stateless 유지

<br>

```java
// 로그인 폼 방식을 사용할 때 사용하는 필터
// Filter의 doFilter()는 상속받은 AbstractAuthenticationProcessingFilter에 존재함
public class UsernamePasswordAuthenticationFilter extends AbstractAuthenticationProcessingFilter {

    // 클라이언트의 로그인 폼을 통해 전송되는 Request Parameter의 Default Username & Password이다
    private static final String SPRING_SECURITY_FORM_USERNAME_KEY = "username;";
    private static final String SPRING_SECURITY_FORM_PASSWORD_KEY = "password";

    // 클라이언트의 URL에 매치되는 Matcher
    // AbstractAuthenticationProcessingFilter에 전달되어 Filter가 구체적 작업을 수행할지 다른 Filter를 호출할지 결정
    private static final AntPathRequestMatcher DEFAULT_ANT_PATH_REQUEST_MATCHER = new AntPathRequestMatcher("/login", "POST");

    // Matcher와 AuthenticationManager를 AbstractAuthenticationProcessingFilter에게 전달
    public UsernamePasswordAuthenticationFilter(AuthenticationManager authenticationManager) {
        super(DEFAULT_ANT_PATH_REQUEST_MATCHER, authenticationManager);
    }

    // 클라이언트에서 전달한 Username & Password를 이용해 인증을 시도하는 메서드
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {

        // HTTP 메서드가 Post가 아니면 throw Exception
        if (this.postOnly && !request.getMethod().equals("POST")) {
            throw new AuthenticationServiceException("Authentication Method Not Supported: " + request.getMethod());
        }

        String username = obtainUsername(request);
        String password = obtainPassword(request);

        // 클라이언트에서 전달한 Username & Password를 이용해 토큰 생성
        UsernamePasswordAuthenticationToken authRequest = UsernamePasswordAuthenticationToken.unauthenticated(username, password);

        // AuthenticationManager의 authenticate() 메서드를 이용해 인증 처리 위임
        return this.getAuthenticationManager().authenticate(authRequest);
    }
}
```

------

### **복습**

```markdown
> ## 📌 인증 구조

1. 로그인 요청 -> UsernamePasswordAuthenticationFilter가 받음

2. UsernamePasswordAuthenticationFilter가 UsernamePasswordAuthenticationToken 생성
   (이 토큰은 Authentication을 구현한 클래스이며 인증이 되지않은 Authentication임)

3. 필터가 Authentication을 AuthenticationManager(인증처리 총괄)에게 전달
   (ProviderManager = AuthenticationManager의 구현클래스, 인증 위임 총괄)

4. ProviderManager가 AuthenticationProvider에게 인증이 되지않은 Authentication 전달

5. AuthenticationProvider가 UserDetailsService를 이용해 UserDetails 조회
   (UserDetails는 DB등의 저장소에 저장된 유저의 정보를 담고있는 컴포넌트)

6. DB에서 조회한 유저의 정보,크리덴셜 등으로 UserDetails를 생성 후 AuthenticationProvider에게 다시 전달

7. UserDetails를 받은 AuthenticationProvider는 PasswordEncoder를 이용해 (UserDetails의 PW == Authentication의 PW)를 검증, 인증에 실패 시 Exception throw

8. AuthenticationProvider는 인증된 Authentication을 ProviderManager에게 전달
   (principal, credential, grantedAuthorities를 가지고 있는 Authentication)

9. 인증된 Authentication을 UsernamePasswordAuthenticationFilter에게 전달

10. SecurityContextHolder를 이용해 SecurityContext에 인증된 Authentication 저장
```

---

## **💡 Processing Flow**  

Spring Security 5.5 이전 버전까지는 FilterSecurityInterceptor를 통한 권한 부여 처리 과정이
상당히 복잡해서 이해가 쉽지 않았지만 5.5 부터는 AuthorizationFilter의
손쉬운 AuthorizationManager API를 이용한 권한 부여 작업을 할 수 있게 되었다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Authorization.png)

<br>

- 1. AuthorizationFilter는 SecurityContextHolder로부터 Authentication 획득

<br>

- 2. AuthorizationFilter는 SecurityContextHolder로부터 얻은

  HttpServletRequest & Response , FilterChain을 기반으로 FilterInvocation 생성

<br>

- 3. AuthorizationManager의 구현체인 RequestMatcherDelegationgAuthorizationManager 에게 전달

  RequestMatcher 평가식을 기반으로 평가식에 매치되는 AuthorizationManager 구현클래스 에게 권한부여처리 위임

<br>

- 4. 적절한 권한이 아닌 사용자임이 밝혀지면 AccessDeniedException을 발생시키고 프로세스가 종료된다.

<br>

- 5. 적절한 권한일 경우 다음 요청 프로세스로 넘어간다.

------

### **복습**

```markdown
> ## 📌 인가 구조

1. URL을 통해 사용자의 액세스를 제한하는 AuthorizationFilter는 SecurityContextHolder로부터 Authenticaton을 획득
   (권한 부여 필터)

2. 얻은 Authentication과 HttpServletRequest를 AuthorizationManager 에게 전달

3. Authorization의 구현체인 RequestMatcherDelegatingAuthorizationManager는 RequestMatcher 평가식을 기반으로 해당 평가식에 매치되는 AuthorizationManger에게 권한부여 처리를 위임

4. RequestMatcherDelegatingAuthorizationManager의 직접 처리가 아닌 AuthorizationManager의 다른 구현체에게 권한처리 위임

5. 내부에서 매치되는 AuthorizationManager의 구현 클래스가 있다면 해당 구현 클래스가 사용자의 권한을 체크

6. 적절한 권한이 아닐 시 AccessDeniedException throw 되고 ExceptionTranslationFilter가 Exception 처리

7. 적절한 권한일 시 다음 요청 프로세스 계속 이어나감
```