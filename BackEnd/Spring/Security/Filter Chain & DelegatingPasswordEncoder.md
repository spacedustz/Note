## **💡 Filter Chain**  

- Request URI Path를 기반으로 HttpServletRequest 를 **URI <-> Filter & Servlet 매핑**
- 필터체인 안에서 순서를 지정할 수 있으며, **순서는 매우 중요**
- 순서를 지정하기 위한 @Order & Ordered 인터페이스를 구현해서 순서 지정
- FilterRegistrationBean을 이용해 순서 지정 가능
- Spring Security의 Filter Chain은 **URL별로 여러개 등록** 가능
- 어떤 Filter Chain을 사용할지는 **FilterChainProxy가 결정**하며, 가장 먼저 매칭된 Filter Chain을 실행

<br>

### **Servlet Filter Chain의 2가지 종류**

- DelegatingFilterProxy(Servlet Filter Chain)
  - **Bean으로 등록된** Spring Security의 필터를 사용하는 시작점
  - Servlet Container 영역의 Filter와 ApplicationContext에 Bean으로 등록된 필터들을 연결해주는 브릿지 역할
- FilterChainProxy
  - Servlet Filter Chain에서 **Spring Security Filter Chain의 시작점**

<br>

### **Servlet FilterChain**

- Servlet FilterChain
  - Request URI Path를 기반으로 HttpServletRequest 처리
    - ex) /api/**
  - Request URI Path에 따라 어떤 Filter & Servlet을 매핑할 지 결정
-  Filter
  - Filter Chain 내부에서 순서 지정, 순서에 따라 동작
-  Filter Chain 순서 지정 방법
  - setOrder(int)
  - Bean으로 등록되는 Filter에 @Order 어노테이션 사용 or Orderd 인터페이스 구현으로 인한 순서 지정
  - FilterRegistrationBean을 이용한 Filter 순서 지정

------

### **💡 Filter 구현**

- Client Request가 Endpoint에 도달하기 전 가로채서 필터 처림
- Spring Security의 Filter를 작성 & 등록시 기존 필터들 사이에서 우선순위를 잘 적용해야한다

<br>

### **Filter 생성**

- init()
  - 생성한 Filter에 대한 초기화
  - FilterConfig를 파라미터로 가지고, ServletException을 던짐
- doFilter()
  - Filter가 처리하는 로직 구현
  - ServletRequest, ServletResponse, FilterChain를 파라미터로 가짐
  -  IOException, ServletException을 던짐
  - ServletRequest - Filter 호출 전처리 작업
  - ServletResponse - Filter 호출 후처리 작업
- destroy()
  - Filter가 ApplicationContext에서 종료 시 호출, Filter가 사용한 Resource 반납 로직 구현

```java
public class FilterOne implements Filter {

    // 초기화
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
        System.out.println("# First Filter 생성");
    }

    // ServletRequest를 이용해 다음 Filter로 넘어가기 위한 전처리 작업 수행
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        System.out.println("--- First Filter Start ---");
        chain.doFilter(request, response);
        System.out.println("--- First Filter End ---");
    }

    // Filter가 사용한 리소스 반납
    @Override
    public void destroy() {
        System.out.println("# First Filter Destroy");
        Filter.super.destroy();
    }
}
```

<br>

```java
public class FilterTwo implements Filter {

    // 초기화
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
        System.out.println("# Second Filter 생성");
    }

    // ServletRequest를 이용해 다음 Filter로 넘어가기 위한 전처리 작업 수행
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        System.out.println("--- First Filter Start ---");
        chain.doFilter(request, response);
        System.out.println("--- First Filter End ---");
    }

    // Filter가 사용한 리소스 반납
    @Override
    public void destroy() {
        System.out.println("# Second Filter Destroy");
        Filter.super.destroy();
    }
}
```

<br>

### **Filter 적용을 위한 FilterConfiguration Class**

- Spring Bean 등록
  - FilterRegistrationBean<T>의 생성자로 Filter의 구현객체인 CustomFilter를 파라미터로 넘겨서 Filter 등록

```java
@Configuration
public class FilterConfiguration {

    // 필터의 순서 지정
    @Bean
    public FilterRegistrationBean<FilterOne> filterOne() {

        FilterRegistrationBean<FilterOne> registrationBean = new FilterRegistrationBean<>(new FilterOne());
        registrationBean.setOrder(1);

        return registrationBean;
    }

    @Bean
    public FilterRegistrationBean<FilterTwo> filterTwo() {
        FilterRegistrationBean<FilterTwo> registrationBean = new FilterRegistrationBean<>(new FilterTwo());
        registrationBean.setOrder(2);

        return registrationBean;
    }
}
```

------

## **💡 DelegatingPasswordEncoder**  

Spring Security에서 지원하는 PasswordEncoder의 구현 객체를 생성해주는 Component
App에서 사용될 PasswordEncoder를 지정, 사용자의 Password를 단방향 암호화를 해줌

<br>

### **DelegatingPasswordEncoder 도입 시 주의점**

- Password Encoding 방식을 Migration하기 어려운 방식을 사용중인 경우
  - 버전이 올라간 hash 암호화 알고리즘을 채용해야함
- **Deprecated** 되는 암호화 알고리즘은 Spring Security의 관리에서 벗어남

<br>

### **DelegatingPasswordEncoder의 장점**

- 암호화 알고리즘을 지정 하지 않으면 Spring Security가 권장 암호화 알고리즘 지정 (ex: bcrpt)
- Regacy 방식을 사용하는 이미 암호화된 패스워드도 검증 지원
- 암호화 알고리즘의 유연한 변경, 단, 이미 암호화된 패스워드의 Migration이 선행되어야함

------

## **💡 PasswordEncoder 구현**

<br>

### **DelegatingPasswordEncoder를 이용한 PasswordEncoder 생성**

Spring Security Recomended

<br>

PasswordEncoderFactories의 createDelegatingPasswordEncoder 메서드를 이용해
DelegatingPasswordEncoder 객체 생성, 내부적으로 DelegatingPasswordEncoder가 PasswordEncoder 객체 생성

```java
PasswordEncoder pw = PasswordEncoderFactories.createDelegatingPasswordEncoder();
```

<br>

### **Custom DelegatingPasswordEncoder 생성**

- Default 암호화 알고리즘 지정 후, Map에 암호화 알고리즘을 담아서 원할때 DelegatingPasswordEncoder 객체 생성

```java
public class CustomDelegatingPasswordEncoder {

    public void customEncoder() {

        // Default 암호화 알고리즘 지정
        String defaultEncoder = "bcrypt";

        // 추후 변경에 사용할 암호화 알고리즘 지정
        Map<String, PasswordEncoder> encoders = new HashMap<>();
        encoders.put(defaultEncoder, new BCryptPasswordEncoder());
        encoders.put("sha256", new StandardPasswordEncoder());
        encoders.put("scrypt", new SCryptPasswordEncoder());
        encoders.put("noop", NoOpPasswordEncoder.getInstance());
        encoders.put("pbkdf2", new Pbkdf2PasswordEncoder());

        // DelegatingPasswordEncoder 객체 리턴
        PasswordEncoder passwordEncoder = new DelegatingPasswordEncoder(defaultEncoder, encoders);
    }
}
```

<br>

### **Password Format의 암호화**

- Spring Security5에서는 패스워드 암호화 알고리즘 유형을 prefix로 추가함
  - {passwordencoder-id}encodedPassword
- Example
  -  BCryptPasswordEncoder
    - {bcrypt}$2a$10$dXJ3SW6G7P50lGSDJfdkosjfwe.20cQQubK3.HZAzG3YB1tlRy.fqvM/BG
  - ScryptPasswordEncoder
    - {scrypt}$e0801$8bS2fFs1Su2IKSn9Z9kM+TPXfOc/9bdYSasdqN1oD9qfVThWEwdRTnO7re7Ei+fUZRJ68k9lTyuTeUp4of4g24hHnazw==$OAOec05+bXxvuu/1qZ6NUR+xQYvYv7BeL1QxwRpY5Pc=