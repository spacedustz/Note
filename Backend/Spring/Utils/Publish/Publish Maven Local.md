백엔드 서버를 여러개로 나눌때, 서버마다 공통적으로 사용하는 클래스들을 하나의 프로젝트에 몰아넣고,

이 프로젝트를 라이브러리화 해서 사용하기 위한 설정 방법을 작성합니다.

<br>

**build.gradle**

- 라이브러리로 사용할 프로젝트의 `build.gradle` 파일에 퍼블리싱 플러그인와 설정을 해줍니다.
- 기본 세팅은 생략하고 퍼블리싱에 필요한 라인만 넣었습니다.
- Version Mapping을 안해주면 dependency에 모두 버전을 명시해야 한다고 퍼블리싱 에러가 뜨므로, 버전 매핑을 통해 런타임 시 버전을 가져와 매핑합니다.

```groovy
plugins {  
    id 'maven-publish'  
}

group = 'com.ys'  
version = '1.0.0'

publishing {  
    publications {  
       maven(MavenPublication) {  
          from components.java  
  
          versionMapping {  
             usage('java-api') {  
                fromResolutionOf('runtimeClasspath')  
             }  
             usage('java-runtime') {  
                fromResolutionResult()  
             }  
          }       
	   }    
	}
}

dependencies {  
    // Publishing을 위한 Web 추가
    implementation 'org.springframework.boot:spring-boot-starter-web'
}
```

<br>

**BeanConfig**

- 그리고 저는 이 라이브러리로 사용할 프로젝트에 `application.yml`파일 없이 사용하고 싶어서, DataSource 설정이나 Property 설정을 자바코드로 Bean을 주입해 주었습니다.

```java
/**  
 * @author 신건우  
 * @desc 공통 Bean Config  
 * 1. Property(application.yml) 파일 관련 Bean 생성  
 * 2. DB Datasource 관련 Bean 생성  
 */  
@Configuration  
@EnableJpaAuditing  
@EnableAspectJAutoProxy  
@EnableTransactionManagement  
public class BeanConfig {  
    @Bean  
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {  
        return new PropertySourcesPlaceholderConfigurer();  
    }  
  
    @Bean(name = "dataSource")  
    @ConfigurationProperties(prefix = "spring.datasource.hikari")  
    public DataSource dataSource() {  
        return DataSourceBuilder.create().build();  
    }  
}
```

<br>

**퍼블리싱**

`./gradlew publishToMavenLocal`을 입력해 Maven Local에 등록합니다.

그리고, 라이브러리화 된 이 프로젝트를 사용할 프로젝트의 `build.gradle`에 아래 내용을 입력해줍니다.

- 기존 MavenCentral()만 있던 repositoriies에 `mavenLocal()` 추가
- `dependencies`에는 해당 프로젝트의 group, version을 입력해주고 name은 해당 프로젝트의 `settings.gradle` 파일에 입력된 프로젝트 명을 적어줍니다.

```groovy
repositories {  
    mavenCentral()  
    mavenLocal()  
}

dependencies {
	implementation group: 'com.ys', name: 'YS-Common', version: '1.0.0'
}
```

<br>

위 내용을 적어주고 빌드하면 해당 라이브러리에 포함된 모든 클래스를 Import 할 수 있게 됩니다.