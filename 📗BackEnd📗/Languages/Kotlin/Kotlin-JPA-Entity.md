## Kotlin + JPA를 이용하여 Entity를 생성할 때 data class를 피해야 한다.

참고 글 : [Kotlin+JPA+Entity](https://effectivesquid.tistory.com/entry/Kotlin-JPA-%EC%82%AC%EC%9A%A9%EC%8B%9C-Entity-%EC%A0%95%EC%9D%98)

클래스 정의 제약 사항
JPA를 사용하게 되면 대부분 Hibernate를 구현체로 사용하게 된다. Hibernate를 구현체로 사용하게 되면 Entity로 사용할 클래스에 몇 가지 제약사항이 존재한다.

[1](https://docs.oracle.com/javaee/5/tutorial/doc/bnbqa.html)
위의 문서를 보면 다음과 같은 글이 있다.

<br>

Requirements for Entity Classes
An entity class must follow these requirements: The class must not be declared final. No methods or persistent instance variables must be declared final.

<br>

Entity의 해당하는 클래스는 final이면 안된다. 하지만 final이어도 동작이 가능한 것을 확인 할 수 있는데 이는 다음 문서를 통해 확인할 수 있다.
[1](https://docs.jboss.org/hibernate/orm/5.2/userguide/html_single/Hibernate_User_Guide.html#entity-pojo)

<br>


Technically Hibernate can persist final classes or classes with final persistent state accessor (getter/setter) methods. However, it is generally not a good idea as doing so will stop Hibernate from being able to generate proxies for lazy-loading the entity.

<br>

즉, Entity 클래스는 final일 수 있지만 lazy loading을 위한 프록시를 생성할 수 없다고 되어 있다. Java + JPA를 사용하게 된다면 별 문제가 없지만 Kotlin + JPA를 사용하게 된다면 문제가 나오기 시작한다. 첫 번째는 Entity를 data class를 이용하여 정의할 때 발생한다.

kotlin의 data class라는 정의를 알게된다면 Entity를 data class로 정의하고 싶은 욕구가 생긴다. 데이터를 담는 클래스니까?? 하지만 data class는 다음과 같은 특징들이 있다.

<br>

The primary constructor needs to have at least one parameter;
All primary constructor parameters need to be marked as val or var;
Data classes cannot be abstract, open, sealed or inner;
(before 1.1) Data classes may only implement interfaces.
equals()/hashCode() pair;
toString() of the form "User(name=John, age=42)";
componenetN() functions corressponding tothe properties in their order of declaration;
copy() funtion

<br>

위의 특징들을 토대로 필자는 data class는 JPA의 Entity와는 어울리지 않는다고 생각한다. 그 이유들은 다음과 같다.

data classes cannot be abstract, open, sealed or inner
기본적으로 kotlin의 class는 open이라는 예약어를 붙이지 않는 이상 final class이다. 즉, 상속이 불가하다는 이야기이다. 일반 클래스는 open이라는 예약어를 붙여주면 되지만 data class는 이 마저도 불가능하다. 물론 kotlin all open plugin을 통해 해결할 수 있지만 억지스러운 면이 없지 않다.

JPA의 가장 큰 특징 중 하나는 지연 로딩이다. 연관관계가 있는 객체를 FetchType.LAZY로 설정해놓으면 해당 객체를 참조할 때 select 쿼리를 통해 조회 해온다. 지연 로딩으로 설정된 객체를 실제 참조하기 전 까지는 Proxy 객체를 참조하게 되는데 이 Proxy객체는 Entity클래스를 상속하여 만들어진다.
따라서 Entity 클래스가 상속이 가능해야 지연로딩 기능을 이용할 수 있는 것이다.

<br>

equals()/hashCode() & toString() of the form "User(name=John, age=42)";
kotlin의 data class는 컴파일시 여러 메서드를 자동으로 만들어준다. 그 중 JPA를 사용할 때 영향을 주는 메서드가 equals() & hashcode() 와 toString()이다.

먼저, effective java의 3장 규칙9를 보면 hashCode()는 Java에서 제공하는 Map Collection에서 사용되는 메서드인 것을 확인 할 수 있다. 그리고 JPA의 영속성 컨텍스트(Persistence Context)는 Map Collection으로 구현되어있다. JPA의 영속성 컨텍스트에서 어떠한 Entity가 영속성 컨텍스트에 존재하는지 그리고 해당 Entity가 수정되었는지 등을 체크할 때 @Id 애너테이션이 붙은 필드를 이용한다. 즉, 객체를 유일하게 식별할 수 있는 필드는 @Id가 붙은 필드면 충분하다는 뜻이다. 그래서 hashCode()를 만들 때 해당 필드만 가지고 만들면 충분하다.

하지만 data class를 이용하게되면 primary constructor에 명시된 필드를 모두 이용하여 hashCode()를 만들어준다. 이를 피하기 위해 @Id가 붙은 필드(프로퍼티)만 primary constructor에 넣고 나머지 필드(프로퍼티)는 body에 정의하게 되는데 뭔가.. 좀 어색하다..

참고 : 
- [1](https://stackoverflow.com/questions/5031614/the-jpa-hashcode-equals-dilemma) (영문)
- [2](https://big-blog.tistory.com/1451) (한글)

<br>

toString()또한 마찬가지이다. JPA에서 toString()에 의해 무한 루프에 빠지는 경우를 흔히 경험할 수 있다.
- [1](https://yellowh.tistory.com/135)
- [2](https://struberg.wordpress.com/2016/10/15/tostring-equals-and-hashcode-in-jpa-entities/)
- [3](https://blog.baesangwoo.dev/posts/jpa-entity/)

<br>

이러한 문제점들 때문에 필자는 data class 보다는 일반 class로 jpa entity를 정의하고 equals() & hashCode()를 intellij의 도움을 받아 @Id 가 붙은 필드만 선택하여 generate 한다. (command + n 을 누르면 generate code 목록이 나온다.)

위의 내용들을 토대로 필자는 다음과 같이 Entity를 정의하고 사용한다.

<br>

**build.gradle.kts**

```groovy
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "2.4.0"
    id("io.spring.dependency-management") version "1.0.10.RELEASE"
    kotlin("jvm") version "1.4.10"
    kotlin("plugin.spring") version "1.4.10" // wrapped all-open (kotlin("plugin.allopen") version "1.4.10" 을 포함)
    kotlin("plugin.jpa") version "1.4.10" // wrapped no-arg (kotlin("plugin.noarg") version "1.4.10" 을 포함)
}

allOpen {
    annotation("javax.persistence.Entity") // @Entity가 붙은 클래스에 한해서만 all open 플러그인을 적용
}

noArg {
    annotation("javax.persistence.Entity") // @Entity가 붙은 클래스에 한해서만 no arg 플러그인을 적용
}

group = "com.example"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_11

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    runtimeOnly("com.h2database:h2")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
}

tasks.withType<Test> {
    useJUnitPlatform()
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs = listOf("-Xjsr305=strict")
        jvmTarget = "11"
    }
}
```

<br>

**entity**
```kotlin
// User.kt
package com.example.jpa.entity

import javax.persistence.*

@Entity
@Table(name = "user")
class User(name: String, email: String) {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null
    var name: String = name
    var email: String = email

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as User

        if (id != other.id) return false

        return true
    }

    override fun hashCode(): Int {
        return id?.hashCode() ?: 0
    }

    override fun toString(): String {
        return "User(id=$id, name='$name', email='$email')"
    }
}
```

<br>

```kotlin
// Account.kt
package com.example.jpa.entity

import java.math.BigDecimal
import javax.persistence.*

@Entity
@Table(name = "account")
class Account(user: User, number: String, balance: BigDecimal) {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(foreignKey = ForeignKey(ConstraintMode.NO_CONSTRAINT))
    var user: User = user
    var number: String = number
    var balance: BigDecimal = balance

    fun withDraw(money: BigDecimal): BigDecimal {
        this.balance = this.balance.minus(money)
        return this.balance
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as Account

        if (id != other.id) return false

        return true
    }

    override fun hashCode(): Int {
        return id?.hashCode() ?: 0
    }
}
```

<br>

**repository**
```kotlin
// UserRepository.kt
package com.example.jpa.repository

import com.example.jpa.entity.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface UserRepository : JpaRepository<User, Long?> {

    fun findByEmail(email: String): User?
}


// AccountRepository.kt
package com.example.jpa.repository

import com.example.jpa.entity.Account
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface AccountRepository : JpaRepository<Account, Long?> {

    fun findByNumber(number: String): Account?
}
```

<br>

위의 코드들을 간단하게 설명하자면 User와 Account는 연관관계가 있는 구조이며 User : Account = 1 : N 구조이다.
위의 코드를 토대로 두 가지 경우를 테스트 해보면 지연로딩에 대한 문제를 확인할 수 있다. 먼저 테스트 코드는 다음과 같다.

<br>

```kotlin
package com.example.jpa.repository

import com.example.jpa.SpringSupportTest
import com.example.jpa.entity.Account
import com.example.jpa.entity.User
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import java.math.BigDecimal
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@ExtendWith(SpringExtension::class)
@ActiveProfiles("test")
@Transactional
@SpringBootTest
class AccountRepositoryTest {

    @Autowired
    private lateinit var userRepository: UserRepository
    @Autowired
    private lateinit var accountRepository: AccountRepository
    @PersistenceContext
    private lateinit var entityManager: EntityManager

    @BeforeEach
    fun setUp() {
        val user = userRepository.save(User("한태웅", "taewoong.han.squid@navercorp.com"))
        accountRepository.save(Account(user, "111-11111-1111", BigDecimal.ZERO))
    }

    @Test
    fun `계좌번호로 Account 정보 조회`() {
        println("--------- 계좌번호로 Account 정보 조회 ---------")

        //given
        val number = "111-11111-1111"
        entityManager.clear() // 영속성 컨텍스트에 User가 존재한다면 제대로 된 테스트가 진행되지 않기 때문에 영속성 컨텍스트를 clear해준 후에 테스트를 진행하였다.

        //when
        val dut: Account? = accountRepository.findByNumber(number)
//        println(dut?.user)

        //then
        Assertions.assertNotNull(dut)
        Assertions.assertEquals(number, dut!!.number)

        println("--------- 계좌번호로 Account 정보 조회 ---------")
    }
}
```

<br>

위의 테스트 코드를 실행할 때 먼저 build.gradle.kts의 allOpen block을 주석처리한 후 실행하면 다음 결과를 확인할 수 있다.
println(dut?.user)를 주석처리하여 user를 참조하는 코드가 없는데도 user를 조회하는 select query를 db로 질의하게된다.
build.gradle.kts의 allOpen block을 활성화 시킨 후 실행하면 다음과 같은 결과를 확인할 수 있다.
지연 로딩이 제대로 동작하는 것을 확인 할 수 있다.

참고 글: [1](https://woowabros.github.io/experience/2020/05/11/kotlin-hibernate.html)
