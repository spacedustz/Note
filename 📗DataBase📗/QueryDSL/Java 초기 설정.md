## QueryDSL 초기 설정 (Java)

- Spring Boot 3.0 이상
- JDK 17 이상

<br>

```groovy
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

<br>

그 후, build -> clean 한번 해주고, other -> compileJava를 실행하고 compileQuerydsl 실행