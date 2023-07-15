## Coroutine Suspend

코루틴은 기본적으로 일시중단이 가능하다.

launch로 실행하든 async로 실행하든 내부에 해당 코루틴을 일시중단 해야하는 동작이 있으면, 코루틴은 일시 중단된다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/suspend.png)

위 그림을 코드로 표현하면 다음과 같다.

```kotlin
fun suspendEx() {
		val job3 = CoroutineScope(Dispatchers.IO).async {
				// 2. IO Thread에서 작업 3을 수행한다.
				(1..10000).sortedByDescending { it }
				// 5. 작업 3 완료
		}

		val job1 = CoroutineScope(Dispatchers.Main).launch {
				// 1. Main Thread에서 작업 1을 수행한다.
				println(1)

				// 3. 작업 1의 남은 작업을 위해 작업3으로부터 결과값이 필요하기 때문에 Main Thread는 작업1을 일시중단한다.
				val job3Result = job.await()
				// 6. 작업3로부터 결과를 전달받는다.

				// 7. 작업 1 재개
				job3Result.forEach { println(it) }
		}

		// 4. Main Thread에서 작업2가 수행되고 완료된다.
		val job2 = CoroutineScope(Dispatchers.Main).launch {
				prntln("Job2 수행 완료")
		}
}
```

1. Main Thread의 Coroutine1에서 작업 1이 수행되며 Main Thread의 자원을 점유한다.
2. IO Threadn의 Coroutine3에서 작업3이 수행되며 IO Thread의 자원을 점유한다.
3. Coroutine1에서 Coroutine3의 작업3 결과가 필요한 작업이 나온다. 이때, Coroutine1은 중단된다.
4. Coroutine2가 Main Thread를 점유하여 작업2를 수행하고 완료한다.
5. Coroutine3의 작업3이 완료된다.
6. Coroutine1은 작업3의 결과를 전달받는다.
7. Coroutine1이 재개된다.

<br>

위 코드의 결과값은 다음과 같다.

```bash
I/System.out: 1  // Coroutine1 작업
I/System.out: Job2 수행 완료  // Coroutine2 작업
I/System.out: 10000. // Coroutine1 작업 재개
		9999
		9998
		9997
		9996
		9995
		9994
		9993
		9992
		9991
		9990
		9989
		..
```

<br>

Job3는 IO Thread 위에서 수행되는 async 작업이며 결과값을 반환받는 작업이다.

1부터 10000까지를 내림차순으로 정렬해서 반환받는 작업이다보니 Job1의 println(1)보다 시간 소요가 많다.

<br>

이 때문에 Job1 코루틴은 Job3의 결과를 기다려야 한다. 그래서 중간에 일시 중단하는 단계가 필요한 것임.

비동기 작업을 하다보면 이러한 상황이 많은데, 이때 코루틴에서 해당 코루틴 작업을 일시 중단 가능하도록 한다.

그래서 일시 중단 가능한 함수는 코루틴 내부에서 수행되어야 한다.

---

## 코루틴 일시 중단은 코루틴 내부에서

### 만약 일시 중단을 코루틴 블럭 내부에서 수행하지 않으면 어떻게 될까?

바로 일시 중단 함수로 바꾸라는 오류가 생긴다.

이를 해결하려면 일시 중단 작업을 코루틴 내부로 옮기고 fun을 suspend fun으로 바꿔줘야 함.

<br>

또한 위 예시에서는 일시 중단 동작을 간단하게 설명하기 위해 Coroutine Scope를 재정의 하고 있다.

suspend fun은 부모의 Scope를 coroutineScore {...} 블럭을 통해 접근할 수 있기 때문에,

다음과 같이 쓸수 있다. 아래와 같이 쓰면 부모 CoroutineScope가 취소될 시 Job3도 취소된다.

```kotlin
suspend fun suspendEx2 {
		suspendEx1()
}

suspend fun suspendEx1 {
		coroutineScope {
				val job3 = async(Dispatchers.IO) {
						(1..10000).sortedByDescending {it }
				}
		}
}
```