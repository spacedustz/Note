## Coroutine GlobalScope
저번에 Coroutine의 CoroutineScope를 알아봤었는데 이번엔 GlobalScope를 알아보겠습니다.

코루틴은 실행의 일시중단(Suspend)&재개(Resume)를 할수있는 비선점형 멀티태스킹을 위한 서브루틴의 일반화가 가능하게 합니다.

<br>

### 다시 생각해보는 Coroutine 장점
- 스레드와 다른점은 Coroutine은 스레드와 함께 사용됩니다.
- Coroutine은 코드 실행 중 멈출 수 있고(Suspendable) 다시 실행(Resume)할 수 있는 제어능력이 있습니다.
- 또, 작업을 쉽게 전환하며 병렬성이 아닌 동시성을 지원하며 실시간 컨텍스트를 가능하게 하며,
- 세마포어, 뮤텍스같은 기본적인 동기화 작업도 불필요합니다.
- 비동기 코드이지만 동기코드처럼 보입니다.(가독성이 뛰어나며 간단하게 구현이 가능함)
- 효율적이고 빠릅니다. (스레드 2000개 = 메모리1.5GB / 코루틴 100만개 = 메모리 700MB)

---

## Coroutine - Delay 활용
- Coroutine을 실행하는 가장 기본적인 방법은 GlobalScope를 사용하는 것입니다.
- 아래 코드처럼 GlobalScope.launch()를 작성하면 이 함수는 Job이라는 타입을 리턴합니다.
- Job은 백그라운드 작업을 의미합니다.

<br>

```kotlin
class MainActivity : AppCompatActivity() {
  val TAG = "MainActivity"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)

    GlobalScope.launch() {
      delay(3000L) // 3초 후 실행
      Log.d(TAG, "thread1 ${Thread.currentThread().name}")
    }
  }
}
```

<br>

- 위 코드처럼 GlobalScope 안에 작업을 제어할 수 있는 delay를 넣을 수 있습니다.
- Delay를 사용하면 지금 이 GlobalScope는 Suspend 됩니다. (이때 모든 스레드가 멈추는게 아님)
- Sleeping은 모든 스레드를 멈추게 한다면 Coroutine Delay는 특정 Task만 중단하고 다른 Task는 정상적으로 작동합니다.
- 즉, 위 코드를 실행 후 로그를 확인해보면 thread2가 실행되고 3초호 thread1이 실행됩니다.
- 이 말은 thread1이 delay 상태에 들어갔을때 thread2는 백그라운드로 실행 중입니다.
- [Suspend 함수가 뭔지 모른다면 (이전 포스팅 글)](https://iizz.tistory.com/294)

<br>

**Delay의 특징**
- Delay는 2곳에서 사용할 수 있습니다. (GlobalScope와 Suspend Function, 이 외에는 사용 불가능)

<br>

```kotlin
class MainActivity : AppCompatActivity() {
  val TAG = "MainActivity"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)

    GlobalScope.launch(Dispatchers.Main) {
      Log.d(TAG, "1")
      delay(3000L)

      Log.d(TAG, "Coroutine Says Hello From Thread1 ${Thread.currentThread().name}")

      Log.d(TAG, "2")

      doNetworkCall()
      Log.d(TAG, "3")

      doNetworkCall2()
      Log.d(TAG, "4")
    }
    Log.d(TAG, "5")
  }

  // Suspend Function
  suspend fun doNetworkCall(): String {
    delay(3000L)
    return "This is the Answer"
  }

  suspend fun doNetworkCall2(): String {
    delay(3000L)
    return "This is the Answer"
  }
}
```

<br>

- 이렇게 Suspend Function을 사용하여 Delay를 fun 안에 넣어서 사용할 수 있습니다.
- 실행순서는 5,1 이 동시에 실행 - 3초 딜레이 후 2번, 3초 딜레이 후 3번, 3초 딜레이 후 4번 순으로 실행됩니다.

---

## Coroutine - Dispatcher
- GlobalScope에 launch는 파라미터로 Dispatcher를 받을 수 있습니다.
- 만약 파라미터를 넘겨주지 않으면 상위 Coroutine Scope로부터 Context(Dispatchers 포함)를 상속 받습니다.
- Dispatcher는 CoroutineContext를 상속받아 어떤 스레드를 사용할 지 미리 지정해주는 역할을 합니다.
- Dispatcher의 종류는 크게 4가지가 있습니다.

|Dispatcher 종류|활용|
|---|---|
|Dispatchers.Main|메인스레드에서 사용하거나 UI 관련된 작업을 할 때 사용합니다.|
|Dispatchers.IO|네트워크 프로그래밍을 할 때 사용하며 데이터를 읽고 쓰는데 적합합니다.|
|Dispatchers.Default|많은 계산을 할 떄 사용합니다. 만약 10000번의 계산이 필요하면 다른 스레드를 방해하지 않고 계산합니다.|
|Dispatchers.Unconfined|Context를 지정하지 않겠다는 의미입니다. 즉 Coroutine을 호출한 스레드에서 동작되게끔 합니다.|

<br>

**Coroutine Context 생성**

```kotlin
GlobalScope.launch(newSingleThreadContext("MyThread")) {}
```

<br>

**여러 Context를 이동해가며 사용해야 할 때**
- Dispatcher.IO Thread 내부의 네트워크 데이터를 가져왔다고 가정합니다.
- 이 데이터를 메인에서 사용하고 싶다면 Dispatcher.Main을 지정하면 됩니다.
- 이처럼 IO <-> Main 두 스레드를 모두 사용해야 할 떄 Coroutine을 통해 간단히 구현 가능합니다.

<br>

```kotlin
GlobalScope.launch(Dispatchers.IO) {
  Log.d(TAG, "1")
  val answer = doNetworkCall()

  withContext(Dispatchers.Main) {
    Log.d(TAG, "2")
    TextView.text = answer
  }

  suspend fun doNetworkCall(): String {
    delay(3000L)
    return "This is the Answer"
  }
}
```

<br>

- 위 코드를 보면 IO 스레드의 네트워크 데이터를 불러와서 3초 후 doNetworkCall() Suspend Fun을 통해 Main 스레드를 실행하게 됩니다.

---

다음은 저번에 알아봤던 runBlocking과 async 함수 내용을 까먹어서 다시 알아보면서 글을 써보겠습니다.
