
## 💡 QueryDSL - Auto Entity Serialization

코틀린 기반 Spring Boot에서 QueryDSL을 이용해 자동으로 엔티티 직렬화를 하려면 다음과 같은 설정이 필요합니다.

---

## Gradle 설정

QueryDSL을 사용하기 위해서는 Gradle에 QueryDSL 관련 의존성을 추가해야 합니다. build.gradle 파일에 다음과 같이 의존성을 추가합니다.

```groovy
plugins {
		kotlin("kapt") version "1.4.10" // QueryDSL
		idea // QueryDSL
}

val querydslVersion ="5.0.0" // QueryDSL

dependencies {
		implementation("com.querydsl:querydsl-jpa:$querydslVersion") // QueryDSL
		kapt("com.querydsl:querydsl-apt:$querydslVersion:jpa") // QueryDSL
}
```

QClass가 IntelliJ를 사용할 수 있도록 경로 추가 (추가 안해도 알아서 QEntity가 생기므로 난 추가 안함)

엔티티를 만들고 어플리케이션을 실행시키면 Entity에 맞는 QType 클래스가 생긴다.

```groovy
idea {  
    module {  
        val kaptMain = file("build/generated/source/kapt/main")  
        sourceDirs.add(kaptMain)  
        generatedSourceDirs.add(kaptMain)  
    }  
}
```

---

## QueryDsl Config 작성

```kotlin
@Configuration  
class QueryDslConfig(  
    @PersistenceContext  
    private val entityManager: EntityManager  
  
){  
    @Bean  
    fun jpaQueryFactory(): JPAQueryFactory {  
        return JPAQueryFactory(this.entityManager)  
    }  
}
```

---

## Application.yml 작성

```yaml
spring:  
  
#H2  
  h2:  
    console:  
      enabled: true  
  
  datasource:  
    url: jdbc:h2:mem:test  
    username: sa  
    password:  
    driver-class-name: org.h2.Driver  
  
# JPA  
  jpa:  
    hibernate:  
      ddl-auto: create  
    properties:  
      hibernate:  
        format_sql: true  
  
# Logging  
logging:  
  level:  
    org:  
      hibernate.sql: debug
```

---

## 예제 도메인 모델

Member N : Team 1


![image](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/querydsldomain.png)

<br>

### Member Class

```kotlin
@Entity  
data class Member(  
  
    @Column(name = "member_id")  
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)  
    var id: Long,  
    var name: String,  
    var age: Long,  
  
    @ManyToOne(fetch = FetchType.LAZY)  
    @JoinColumn(name = "team_id")  
    var team: Team  
) {  
    constructor(name: String, age: Long, team: Team): this(id = 0L, name = name, age = age, team = team)  
  
    fun changeTeam(team: Team) {  
        this.team = team  
        team.members.plus(this)  
    }  
  
    fun generateId(): String {  
        return UUID.randomUUID().toString().substring(0, 8)  
    }  
}
```

<br>

### Team Class

```kotlin
@Entity  
class Team (  
  
    @Column(name = "team_id")  
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)  
    var id: Long,  
    var name: String = "",  
  
    @OneToMany(mappedBy = "team")  
    var members: List<Member> = mutableListOf()  
) {  
    constructor(name: String): this(id = 0L, name = name)  
}
```