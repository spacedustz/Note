## 💡 Coroutine

코틀린에서 코루틴은 비동기 프로그래밍에 유용한 기능입니다. 

코루틴을 사용하면 비동기 처리를 할 때 콜백 함수를 작성하지 않아도 되며, 코드의 가독성과 유지보수성도 높아집니다. 

코루틴을 사용하기 위해서는 다음과 같은 과정이 필요합니다.

<br>

### 코루틴 라이브러리 추가하기

코루틴을 사용하기 위해서는 코루틴 라이브러리를 추가해야 합니다. 

코루틴 라이브러리는 코틀린 표준 라이브러리의 일부이므로 별도의 설치나 설정이 필요하지 않습니다. 

따라서, 프로젝트의 build.gradle 파일에 다음과 같이 의존성을 추가합니다.

```groovy
dependencies {
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-core:1.5.2'
}
```

<br>

### 코루틴 스코프 생성하기

코루틴을 실행하기 위해서는 코루틴 스코프를 생성해야 합니다. 코루틴 스코프는 코루틴 실행의 범위를 결정합니다. 

예를 들어, 코루틴 스코프가 메인 스레드에서 생성된다면, 코루틴 실행도 메인 스레드에서 수행됩니다. 

다음은 코루틴 스코프를 생성하는 예제 코드입니다.

```kotlin
import kotlinx.coroutines.*

fun main() {
    // 메인 스레드에서 코루틴 스코프 생성
    val scope = CoroutineScope(Dispatchers.Main)

    // ...
}
```

<br>

### 코루틴 작성하기

코루틴을 작성하는 방법에는 여러 가지가 있지만, 가장 기본적인 방법은 `launch` 함수를 사용하는 것입니다. 

`launch` 함수는 비동기 코드를 실행하고, 결과를 반환하지 않습니다. 

다음은 `launch` 함수를 사용하여 코루틴을 작성하는 예제 코드입니다.

```kotlin
import kotlinx.coroutines.*

fun main() {
    // 메인 스레드에서 코루틴 스코프 생성
    val scope = CoroutineScope(Dispatchers.Main)

    // 코루틴 실행
    scope.launch {
        // 비동기 작업 수행
    }

    // ...
}
```

<br>

### 코루틴 실행하기

코루틴은 launch, async, runBlocking 등의 함수를 통해 실행됩니다.

<br>

**launch**

`launch` 함수는 코루틴을 비동기적으로 실행하고 반환값이 없습니다. 

코루틴의 결과를 처리하기 위해서는 Job 객체를 사용해야 합니다.

```kotlin
val job = GlobalScope.launch {
    // 비동기 작업 수행
}
```

<br>

**async**

`async` 함수는 `launch`와 유사하지만, 반환값이 있습니다. 

Deferred 객체를 반환하며, `await` 함수를 호출하여 결과값을 얻을 수 있습니다.

```kotlin
val deferred = GlobalScope.async {
    // 비동기 작업 수행
    "Hello, World!"
}

val result = runBlocking {
    deferred.await()
}
println(result) // "Hello, World!"
```

<br>

**runBlocking**

`runBlocking` 함수는 메인 스레드를 블록하고, 전달된 블록 안에서 코루틴을 실행합니다. 

반환값은 코루틴의 결과값입니다.

```kotlin
eval result = runBlocking {
    // 코루틴 작업 수행
    "Hello, World!"
}
println(result) // "Hello, World!"
```

위의 예제에서 `runBlocking`을 사용하여 메인 스레드가 블록되지 않고 결과값을 출력할 수 있습니다. 

하지만 `runBlocking`은 UI 스레드에서 사용하면 안 됩니다.

또한, `runBlocking`은 테스트에서 코루틴을 실행할 때 사용됩니다.

예를 들어, JUnit 테스트에서 코루틴을 실행할 때 `runBlocking`을 사용할 수 있습니다.