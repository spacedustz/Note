## 가상 시나리오

새로운 회사에 입사했는데, 수 년간 운영중인 거대한 프로젝트에 투입되었다. 
전체 소스 코드는 수 십만 라인이고, 클래스 수도 수 백개 이상이다.  

<br>

처음 맡겨진 요구사항은 로그 추적기를 만드는 것이다.  
애플리케이션이 커지면서 점점 모니터링과 운영이 중요해지는 단계이며,
특히 최근 자주 병목이 발생하고 있다. 

<br>

어떤 부분에서 병목이 발생하는지, 그리고 어떤 부분에서 예외가 발생하는지를 로그를 통해 확인하는 것이 점점 중요해지고 있다.
기존에는 개발자가 문제가 발생한 다음에 관련 부분을 어렵게 찾아서 로그를 하나하나 직접 만들어서 남겼다. 
로그를 미리 남겨둔다면 이런 부분을 손쉽게 찾을 수 있을 것이다. 이 부분을 개선하고 자동화 하는 것이 미션이다.

---

## 요구사항

- 모든 PUBLIC 메서드의 호출과 응답 정보를 로그로 출력 애플리케이션의 흐름을 변경하면 안됨
	- 로그를 남긴다고 해서 비즈니스 로직의 동작에 영향을 주면 안됨 
- 메서드 호출에 걸린 시간  
- 정상 흐름과 예외 흐름 구분
	- 예외 발생시 예외 정보가 남아야 함
- 메서드 호출의 깊이 표현  
- HTTP 요청을 구분
	- HTTP 요청 단위로 특정 ID를 남겨서 어떤 HTTP 요청에서 시작된 것인지 명확하게 구분이 가능해야 함
	- 트랜잭션 ID (DB 트랜잭션X), 여기서는 하나의 HTTP 요청이 시작해서 끝날 때 까지를 하나의 트랜잭션이라 함

<br>

### 예시

모니터링 툴을 사용하면 많은 부분이 해결되지만, 학습이 목적이니 직접 구현한다.

```markdown
정상 요청

  [796bccd9] OrderController.request()
  [796bccd9] |-->OrderService.orderItem()
  [796bccd9] |   |-->OrderRepository.save()
  [796bccd9] |   |<--OrderRepository.save() time=1004ms
  [796bccd9] |<--OrderService.orderItem() time=1014ms
  [796bccd9] OrderController.request() time=1016ms

예외 발생

  [b7119f27] OrderController.request()
  [b7119f27] |-->OrderService.orderItem()
  [b7119f27] | |-->OrderRepository.save() 
  [b7119f27] | |<X-OrderRepository.save() time=0ms ex=java.lang.IllegalStateException: 예외 발생! 
  [b7119f27] |<X-OrderService.orderItem() time=10ms ex=java.lang.IllegalStateException: 예외 발생! 
  [b7119f27] OrderController.request() time=11ms ex=java.lang.IllegalStateException: 예외 발생!
```

---

## 로그추적기 V1 - 프로토타입

어플리케이션의 모든 로직에 직접 로그를 남기는 방법도 있지만, 더 효율적인 개발 방법이 필요하다.

특히 트랜잭션 ID와 깊이를 표현하는 방법은 기존 정보를 이어 받아야 하기 때문에,

단순히 로그만 남긴다고 해결할 수 있는 것은 아니다.

요구사항에 맟추어 어플리케이션에 효과적으로 로그를 남기기 위한 로그 추적기를 개발해보자.

<br>

요구사항에 맟춰 어플리케이션에 효과적으로 로그를 남기기 위한 로그추적기를 개발해보자.

먼저 프로토타입 버전을 개발해보자.

아마 코드를 모두 작성하고 테스트 코드까지 실행해봐야 감이 올것이다.

먼저 로그 추적기를 위한 기반 데이터를 가지고 있는 TraceId, TraceStatus 클래스를 만들어보자.

<br>

### TraceID

로그 추적기는 트랜잭션ID와 깊이를 표현하는 방법이 필요하다.  
여기서는 트랜잭션ID와 깊이를 표현하는 level을 묶어서 TraceId 라는 개념을 만들었다.

<br>

**UUID**

TraceId 를 처음 생성하면 createId() 를 사용해서 UUID를 만들어낸다. UUID가 너무 길어서 여기서는 앞 8자리만 사용한다. 이 정도면 로그를 충분히 구분할 수 있다. 여기서는 이렇게 만들어진 값을 트랜잭션ID 로 사용한다.

```markdown
ab99e16f-3cde-4d24-8241-256108c203a2 //생성된 UUID 
ab99e16f //앞 8자리만 사용
```

<br>

**createNextId()**

다음 TraceId 를 만든다. 예제 로그를 잘 보면 깊이가 증가해도 트랜잭션ID는 같다. 대신에 깊이가 하나 증가한다.

실행 코드: new TraceId(id, level + 1)

```markdown
[796bccd9] OrderController.request()

[796bccd9] |-->OrderService.orderItem() //트랜잭션ID가 같다. 깊이는 하나 증가한다.
```

따라서 createNextId() 를 사용해서 현재 TraceId 를 기반으로 다음 TraceId 를 만들면 id 는 기존과 같고, level 은 하나 증가한다.

<br>

**createPreviousId()**

createNextId() 의 반대 역할을 한다.  
id 는 기존과 같고, level 은 하나 감소한다.

<br>

**isFirstLevel()**

첫 번째 레벨 여부를 편리하게 확인할 수 있는 메서드


```kotlin
/**  
 * @author 신건우  
 * @param id : 트랜잭션 ID * @param level : 트랜잭션 깊이  
 * @desc 단순히 트랜잭션의 id, level을 표현하는 클래스  
 */  
data class TraceId(  
    var id: String,  
    var level: Long  
) {  
      
    constructor() : this(UUID.randomUUID().toString().substring(0, 8), 0)  
  
    fun createId(): String {  
        return UUID.randomUUID().toString().substring(0, 8)  
    }  
  
    fun createNextId(): TraceId {  
        return TraceId(id, level.plus(1))  
    }  
  
    fun createPrevId(): TraceId {  
        return TraceId(id, level.minus(1))  
    }  
  
    fun isFirstLevel(): Boolean {  
        return level == 0L  
    }  
}
```

<br>

### TraceStatus

 * @param traceId : 트랜잭션의 ID와 Level 보유  
 * @param startTimeMs : 로그의 시작시간, 로그 종료 시 이걸 기준으로 시작~종료 전체 수행 시간을 구한다  
 * @param message : 시작 시 사용한 메시지, 이후 로그 종료시에도 이 메시지를 사용해서 출력한다  
 * @desc 로그의 상태 정보 클래스 

TraceId , TraceStatus 를 사용해서 실제 로그를 생성하고, 처리하는 기능을 개발해보자.

```kotlin
/**  
 * @author 신건우  
 * @param traceId : 트랜잭션의 ID와 Level 보유  
 * @param startTimeMs : 로그의 시작시간, 로그 종료 시 이걸 기준으로 시작~종료 전체 수행 시간을 구한다  
 * @param message : 시작 시 사용한 메시지, 이후 로그 종료시에도 이 메시지를 사용해서 출력한다  
 * @desc 로그의 상태 정보 클래스  
 */  
data class TraceStatus (  
    val traceId: TraceId,  
    val startTimeMs: Long,  
    val message: String  
)
```

<br>

### TracerV1

TracerV1을 사용해서 실제 로그를 시작하고 종료할 수 있다.
그리고, 로그를 출력하고 실행시간도 측정이 가능하다.

**로그추적기에 사용되는 Method**
`begin()` : public
`end()` : public
`exception()` : public
`complete()` : private
`addSpace()` : private
<br>

```kotlin
@Component  
class TracerV1(  
    val START_PREFIX: String = "-->",  
    val COMPLETE_PREFIX: String = "<--",  
    val EX_PREFIX: String = "<X-"  
) {  
  
    fun begin(message: String): TraceStatus {  
        val traceId = TraceId()  
        val startTimeMs = System.currentTimeMillis()  
  
        log.info("${traceId.id} ${addSpace(START_PREFIX, traceId.level)}, $message")  
  
        return TraceStatus(traceId, startTimeMs, message)  
    }  
  
    fun end(status: TraceStatus) {  
        complete(status, null)  
    }  
  
    fun exception(status: TraceStatus, e: Exception) {  
        complete(status, e)  
    }  
  
    private fun complete(status: TraceStatus, e: Exception?) {  
        val stopTimeMs = System.currentTimeMillis()  
        val resultTimeMs = stopTimeMs - status.startTimeMs  
        val traceId = status.traceId  
  
        if (e == null) {  
            log.info("${traceId.id} ${addSpace(COMPLETE_PREFIX, traceId.level)}, ${status.message}, $resultTimeMs")  
        } else {  
            log.info("${traceId.id} ${addSpace(EX_PREFIX, traceId.level)}, ${status.message}, $resultTimeMs")  
        }  
    }  
  
    private fun addSpace(prefix: String, level: Long): String {  
        val sb: StringBuilder = StringBuilder()  
  
        for (i in 0 .. level) {  
            sb.append(if (i==level) "|$prefix" else "|   ")  
        }  
        return sb.toString()  
    }  
  
    companion object {  
        private val log: Logger = LogManager.getLogger(this::class.java)  
    }  
}
```

---

## 하나씩 자세히 알아보자.

**begin()**

- 로깅을 시작한다.
- 로그 메시지를 파라미터로 받아 시작 로그 출력
- 응답 결과로 현재 로그의 상태인 TraceStatus 반환

<br>

**end()**

- 로그를 종료한다.
- 파라미터로 시작 로그의 상태(TraceStatus)를 전달 받는다.
- 이 값을 활용해 실행 시간을 계산하고, 종료 시에도 시작할 때와 동일한 로그 출력 가능
- 정상 흐름에서 호출한다.

<br>

**exception()**

- 로그를 예외 상황으로 종료한다.
- TraceStatus, Exception 정보를 함께 전달 받아서 실행시간, 예외 정보를 포함한 결과 출력
- 예외가 발생했을 때 호출한다.

<br>

**complete()**

- end(), exception()의 요청 흐름을 한곳에서 편리하게 처리한다.
- 실행시간을 측정하고 로그를 남긴다.

<br>

**addSpace()**

- 다음과 같은 결과를 출력한다.
- prefix : `-->`
	- level 0 :
	- level 1 : |-->
	- level2 : |   |-->
- prefix : `<--`
	- level 0 :
	- level 1 : |<--
	- level 2 : |   |<--
- prefix : `<X-`


로그추적기 V1은 아직 모든 요구사항을 만들지 못하므로 이후 기능을 하나씩 추가할 예정이다.

---

## 테스트

```kotlin
class TracerV1Test {  
  
    @Test  
    fun begin_end() {  
        val trace: TracerV1 = TracerV1()  
        val status = trace.begin("Hello")  
        trace.end(status)  
    }  
  
    @Test  
    fun begin_exception() {  
        val trace: TracerV1 = TracerV1()  
        val status = trace.begin("Hello")  
        trace.exception(status, IllegalStateException())  
    }  
}
```

**begin_end 실행 로그**

```markdown
[41bbb3b7] hello
[41bbb3b7] hello time=5ms
```

**begin_exception 실행 로그**

```markdown
[898a3def] hello
[898a3def] hello time=13ms ex=java.lang.IllegalStateException
```

<br>

<img src="https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/tracer.png" weight="500" height="500"/>

<br>

**실행해서 정상 동작하는지 확인하자.**  
실행: http://localhost:8080/request?itemId=hello 
결과: ok