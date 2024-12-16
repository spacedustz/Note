## Unit-Test

회사에서 항상 급한 일정으로 개발하느라 직접 서버에 환경구성해서 하는 방식으로 일하고 있었는데,

환경 구성부터 서버 배포까지 시간도 걸리고 너무 번거로워 테스트 코드로 빠르게 테스트 하고 싶어서 알아보게 되었습니다.

<br>

### Dependencies

build.gradle 파일에 로깅과 테스트를 위해 의존성을 설정해줬고 추가로, static 함수를 mocking 할거라면 `mockito-inline`을 추가 해주면 됩니다.

```groovy
dependencies {
    // Lombok
    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'
    testCompileOnly 'org.projectlombok:lombok'
    testAnnotationProcessor 'org.projectlombok:lombok'

    // Test
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'org.springframework.security:spring-security-test'
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
    testImplementation 'org.mockito:mockito-inline:5.2.0'
    test {
        useJUnitPlatform()
    }
}
```

<br>

### Test Class 작성

- `@WebMvcTest` : 어프리케이션 전체가 아닌 Web Layer만 테스트 할때 사용하며, controllers 옵션을 사용해 특정 Controller 클래스만 지정해 인스턴스화 한다, `@SpringBootTest`를 사용해도 똑같지만, 전체 어플리케이션의 컨텍스트를 인스턴스화 할 필요가 없을때는 단위테스트용으로 `@WebMvcTest`를 사용하자.
- `excludeFilters` : 