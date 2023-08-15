## Vue 로컬 테스트 시 Cors Proxy 우회

Vue를 사용한 프론트엔드 서버에서 백엔드 서버의 데이터를 받아오는 연습을 하던 도중 CORS 에러를 만났습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/cors.png)

<ㅠ

<br>

백엔드만 할땐 몰랐었는데 프론트엔드를 하다가 만나니 또 새로운 기분입니다.

이 CORS 에러를 해결하는 방법은 2가지가 있습니다.

<br>

### Backend에서 CORS 설정하기

```java
@Configuration  
@EnableWebMvc  
public class CorsConfig implements WebMvcConfigurer {  
  
    @Override  
    public void addCorsMappings(CorsRegistry registry) {  
        registry.addMapping("/api/**")  
                .allowedOrigins("http://localhost:8080") // 허용할 origin (프론트엔드 주소)  
                .allowedMethods("GET", "POST", "PUT", "DELETE") // 허용할 HTTP 메서드  
                .allowedHeaders("*") // 허용할 헤더  
                .allowCredentials(true); // Credentials (쿠키 등) 허용 여부  
    }  
}
```