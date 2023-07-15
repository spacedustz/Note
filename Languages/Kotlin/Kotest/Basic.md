## Kotest Basic

---

## Settings

build.gradle

```groovy
testImplementation("io.kotest:kotest-runner-junit5:5.3.2")  
testImplementation("io.kotest.extensions:kotest-extensions-spring:1.1.1")
```

<br>

plugins
- Kotest

---

## Spec

코틀린에는 테스트 레이아웃이 10개정도 있는데 이 중 하나를 상속받아 진행한다.

여러 테스트 프레임워크에서 영향을 받아 만들어진 것도 있고, 코틀린만을 위해 만들어진 것도 있다.

[Spec](https://kotest.io/docs/framework/testing-styles.html#free-spec)

어떤 스타일을 고르던 기능적 차이는 없다.

취향에 따라, 혹은 팀의 스타일에 따라 고르면 될 듯 하다.

ex) FreeSpec

```kotlin
internal class HumanTest: FreeSpec() {}
```

<br>

### AnnotationSpec

**JUnit과 가장 유사한 테스트 스타일이다. JUnit -> kotest로 마이그레이션할 때 가장 변경이 적은 테스트 스타일**이긴 하다.

그렇지만 **NON-ASCII 경고가 발생하기도 하고, StringSpec이라는 대체제**도 있으므로 개인적으론 StringSpec을 쓰는 게 더 나아보인다.

```kotlin
import io.kotest.core.spec.style.AnnotationSpec  
  
class AnnotationSpec : AnnotationSpec() {  
    @Test  
    fun `회원의 비밀번호와 일치하는지 확인한다()`{  
        val user = createUser()  
        shouldNotThrowAny { user.authenticate(PASSWORD) }  
    }  
  
    @Test  
    fun `회원의 비밀번호와 다를 경우 예외가 발생한다`() {  
        val user = createUser()  
        shouldThrow<UnidentifiedUserException> { user.authenticate(WRONG_PASSWORD) }  
    }  
}
```

<br>

### StringSpec

**@Test라는 어노테이션을 붙이지 않아도 되고, fun 키워드 없이 바로 테스트명을 String으로 지을 수 있다는 점에서 매력적**이라 느껴진다. 한글로 작성해도 인텔리제이에서 노란줄을 띄워주지 않아 편안하다.

StringSpec은 AnnotationSpec과 같이 괄호 위치가 ({ ... })인 점에 유의하자.

```kotlin
import io.kotest.core.spec.style.StringSpec  
  
class UserTest : StringSpec({  
    "회원의 비밀번호와 일치하는지 확인한다" {  
        val user = createUser()  
        shouldNotThrowAny { user.authenticate(PASSWORD) }  
    }  
    "회원의 비밀번호와 다를 경우 예외가 발생한다" {  
        val user = createUser()  
        shouldThrow<UnidentifiedUserException> { user.authenticate(WRONG_PASSWORD) }  
    }})
```

<br>

### BehaviorSpec

**Given-When-Then 테스트 패턴**을 쓰고 싶을 때 사용한다.

**Given When Then을 소문자로 작성하지 않도록 주의하자.**

소문자로 작성할 경우 given, then은 상관없지만 when은 백틱을 쳐주도록 하자. (given `when` then)

참고로 slot은 mockK 관련 키워드이다. mockito 대신 mockK를 이용하면 더 코틀린스러운 테스트를 작성 가능하다.

```kotlin
import io.kotest.core.spec.style.BehaviorSpec  
  
internal class UserServiceTest : BehaviorSpec({  
    val userRepository: UserRepository = mockk()  
    val passwordGenerator: PasswordGenerator = mockk()  
  
    Given("유저의 비밀번호가 주어질 때") {  
        When("비밀번호를 변경하려 하면") {  
            var request: EditPasswordRequest = mockk()  
  
            slot<Long>().also { slot ->  
                every { userRepository.getById(capture(slot)) } answers { createUser(id = slot.captured) }  
            }  
            Then("확인용 비밀번호가 일치한다면 변경한다") {  
                // ...  
            }  
  
            Then("확인용 비밀번호가 일치하지 않으면 예외가 발생한다") {  
                // ...  
            }  
        }    }})
```

<br>

### DescribeSpec

**DCI 패턴**을 쓰고 싶을 때 사용한다.

Given When Then 패턴이 아닌 DCI 패턴을 사용하고 싶을 경우 DescribeSpec을 사용하면 된다.

**BehaviorSpec의 Given-When-Then 패턴과 DescribeSpec의 DCI 패턴은 테스트 중첩 (Given 안에 When 여러 개, When 안에 Then 여러 개처럼)이 가능하다는 장점**이 있다. 
이는 중복을 제거하기에 좋다.

```kotlin
import io.kotest.core.spec.style.DescribeSpec  
  
internal class UserServiceTest : DescribeSpec({  
    val userRepository: UserRepository = mockk()  
  
    describe("UserService") {  
        var user: User = createUser()  
        var request: ResetPasswordRequest = mockk()  
  
        context("비밀번호를 비교할 때") {  
            var request: EditPasswordRequest = mockk()  
            slot<Long>().also { slot ->  
                every { userRepository.getById(capture(slot)) } answers { createUser(id = slot.captured) }  
            }            // ...  
  
            it("확인용 비밀번호가 일치한다면 변경한다") {  
                // ...  
            }  
  
            it("확인용 비밀번호가 일치하지 않으면 예외가 발생한다") {  
                // ...  
            }  
        }    }})
```

---

## 테스트 코드 작성

아래 테스트 코드는 FreeSpec 기준으로 작성한다.

<br>

### 전후 처리

기존 @BeforeEach, @BeforeAll, @AfterEach 등과 같은 전후처리를 위한 기본 어노테이션을 사용하지 않는다.
각 Spec의 SpecFunctionCallbacks 인터페이스에 의해 override하여 구현한다.

<br>

```kotlin
interface SpecFunctionCallbacks {
   fun beforeSpec(spec: Spec) {}
   fun afterSpec(spec: Spec) {}
   fun beforeTest(testCase: TestCase) {}
   fun afterTest(testCase: TestCase, result: TestResult) {}
   fun beforeContainer(testCase: TestCase) {}
   fun afterContainer(testCase: TestCase, result: TestResult) {}
   fun beforeEach(testCase: TestCase) {}
   fun afterEach(testCase: TestCase, result: TestResult) {}
   fun beforeAny(testCase: TestCase) {}
   fun afterAny(testCase: TestCase, result: TestResult) {}
}
```

<br>

위 인터페이스를 참고하여 작성하면 아래와 같이 사용할 수 있다.

```kotlin
internal class HumanTest : FreeSpec() {

    override fun beforeSpec(spec: Spec) {
        println("beforeSpec")
    }

    override fun beforeTest(testCase: TestCase) {
        println("beforeTest")
    }

    override fun beforeContainer(testCase: TestCase) {
        println("beforeContainer")
    }

    override fun beforeEach(testCase: TestCase) {
        println("beforeEach")
    }

    override fun beforeAny(testCase: TestCase) {
        println("beforeAny")
    }

    init {
        "그냥 컨테이너" - {
            "그냥 테스트1" {
                println("그냥 테스트1")
                "".length shouldBe 0
            }
            "그냥 테스트2" {
                println("그냥 테스트2")
                "12345".length shouldBe 5
            }
        }
    }
}
```

<br>

실행 결과, 결과를 보면 각 Function들이 어느 시점에 실행되는지 확인 가능하다.

```markdown
## 실행결과

beforeSpec

beforeContainer
beforeAny
beforeTest

beforeEach
beforeAny
beforeTest
그냥 테스트1

beforeEach
beforeAny
beforeTest
그냥 테스트2
```

---

## Assertion 알아보기

kotest는 아주 풍부한 assertion을 제공하는데, 몇가지 assertion 사용법에 대해 알아보자.

[Assertions](https://kotest.io/docs/assertions/assertions.html)

전부 다 알아보기는 너무 많으니 간단한 예제로 대체한다.

### 예시

```kotlin
init {
    "Matchers" - {
        val testStr = "I am iron man"
        val testNum = 5
        val testList = listOf<String>("iron", "bronze", "silver")

        "일치 하는지" {
            testStr shouldBe "I am iron man"
        }
        "일치 안 하는지" {
            testStr shouldNotBe "I am silver man"
        }
        "해당 문자열로 시작하는지" {
            testStr shouldStartWith "I am"
        }
        "해당 문자열을 포함하는지" {
            testStr shouldContain "iron"
        }
        "리스트에서 해당 리스트의 값들이 모두 포함되는지" {
            testList shouldContainAll listOf("iron", "silver")
        }
        "대소문자 무시하고 일치하는지" {
            testStr shouldBeEqualIgnoringCase "I AM IRON MAN"
        }
        "보다 큰거나 같은지" {
            testNum shouldBeGreaterThanOrEqualTo 3
        }
        "해당 문자열과 길이가 같은지" {
            testStr shouldHaveSameLengthAs "I AM SUPERMAN"
        }
        "문자열 길이" {
            testStr shouldHaveLength 13
        }
        "여러개 체이닝" {
            testStr.shouldStartWith("I").shouldHaveLength(13).shouldContainIgnoringCase("IRON")
        }
    }
}
```

<br>

### Exception 발생 체크

```kotlin
"Exception" - {
    "ArithmeticException Exception 발생하는지" {
        val exception = shouldThrow<ArithmeticException> {
            1 / 0
        }
        exception.message shouldStartWith("/ by zero")
    }
    "어떤 Exception이든 발생하는지" {
        val exception = shouldThrowAny {
            1 / 0
        }
        exception.message shouldStartWith("/ by zero")
    }
}
```

<br>

### Clues를 이용한 에러 추적

테스트 중이나 테스트가 실패했을때 더 자세한 단서를 남길 수 있다.

```kotlin
"Clues" - {
    data class HttpResponse(val status: Int, val body: String)
    val response = HttpResponse(404, "the content")
    
    "Not Use Clues" {
        response.status shouldBe 200
        response.body shouldBe "the content"
        // 결과: expected:<200> but was:<404>
    }
    "With Clues" {
        withClue("status는 200이여야 되고 body는 'the content'여야 한다") {
            response.status shouldBe 200
            response.body shouldBe "the content"
        }
        // 결과: status는 200이여야 되고 body는 'the content'여야 한다
    }
    "As Clues" {
        response.asClue {
            it.status shouldBe 200
            it.body shouldBe "the content"
        }
        // 결과: HttpResponse(status=404, body=the content)
    }
}
```

<br>

### Soft Assertion

Sort Assertion을 사용하면 중간에 asert가 실패해도 assertAll 처럼 끝까지 체크가 가능하다.

```kotlin
"Soft Assertions" - {
    val testStr = "I am iron man"
    val testNum = 5

    "Not Soft" {
        testStr shouldBe "IronMan"
        testNum shouldBe 1
        // 결과: expected:<"IronMan"> but was:<"I am iron man">
    }
    "Use Soft" {
        assertSoftly {
            testStr shouldBe "IronMan"
            testNum shouldBe 1
        }
        // 결과: expected:<"IronMan"> but was:<"I am iron man">
        //      expected:<1> but was:<5>
    }
}
```

<br>

### Data Driven Testing

아래 기능을 이용해서 다른 매개변수를 정의하여 각각 테스트가 가능하다.

이렇게 데이터를 세팅하고, 각 행별로 테스트가 가능하다.

```kotlin
data test" - {
    "forAll" {
        forAll(
            row("haha", 13),
            row("hoho", 22),
        ) { name, age ->
            name.length shouldBe 4
            age shouldBeGreaterThanOrEqualTo 10
        }
    }
    "table forAll" {
        table(
            headers("name", "age"),
            row("haha", 13),
            row("hoho", 22)
        ).forAll { name, age ->
            name.length shouldBe 4
            age shouldBeGreaterThanOrEqualTo 10
        }
    }
    "collection" {
        listOf(
            row("haha", 13),
            row("hoho", 22)
        ).map { (name: String, age: Int) ->
            name.length shouldBe 4
            age shouldBeGreaterThanOrEqualTo 10
        }
    }
}
```