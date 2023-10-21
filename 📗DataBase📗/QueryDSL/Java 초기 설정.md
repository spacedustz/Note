## QueryDSL 초기 설정 (Java)

- Spring Boot 3.0 이상
- JDK 17 이상

<br>

```groovy
plugins {  
    id 'java'  
    id 'org.springframework.boot' version '3.1.3'  
    id 'io.spring.dependency-management' version '1.1.3'  
}  
  
group = 'com'  
version = '0.0.1-SNAPSHOT'  
  
test {  
    enabled = false  
}  
  
bootJar {  
    archiveFileName = 'count.jar'  
    archiveClassifier = ''  
}  
  
java {  
    sourceCompatibility = '17'  
}  
  
configurations {  
    compileOnly {  
        extendsFrom annotationProcessor  
    }  
}  
  
repositories {  
    mavenCentral()  
}  
  
dependencies {  
    // Querydsl 추가  
    implementation 'com.querydsl:querydsl-jpa:5.0.0:jakarta'  
    annotationProcessor "com.querydsl:querydsl-apt:${dependencyManagement.importedProperties['querydsl.version']}:jakarta"  
    annotationProcessor "jakarta.annotation:jakarta.annotation-api"  
    annotationProcessor "jakarta.persistence:jakarta.persistence-api"  
}  
  
tasks.named('test') {  
    useJUnitPlatform()  
}
```