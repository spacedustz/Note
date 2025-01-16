## ❌ Kotlin - mark, reset not supported

> **문제의 코드**

```kotlin
inputStream.mark(2)
val bytes2 = ByteArray(2)
inputStream.read(bytes2, 0, 2)
println("바이트 배열 일부만 읽기 1 : " + bytes2.decodeToString())

inputStream.reset()
inputStream.read(bytes2, 0, 2)
println("바이트 배열 일부만 읽기 2 : " + bytes2.decodeToString())
```

<br>

> **원인**

InputStream 객체가 mark()와 reset() 함수를 지원하지 않아서 예외가 발생합니다.

InputStream의 mark()와 reset() 함수는,

InputStream의 내부 포인터 위치를 저장하고, 나중에 해당 위치로 이동할 수 있도록 해줍니다.

그러나 일부 InputStream 구현체는 이러한 기능을 지원하지 않을 수 있습니다.

<br>

> **해결 방법**

`markSupported()` 함수를 사용하여 mark()와 reset() 메소드를 지원하는지 확인한 후,

지원되는 경우에만 해당 함수를 호출하는 것입니다.

```kotlin
if (inputStream.markSupported()) {
    inputStream.mark(2)
    val bytes2 = ByteArray(2)
    inputStream.read(bytes2, 0, 2)
    println("바이트 배열 일부만 읽기 1 : " + bytes2.decodeToString())

    inputStream.reset()
    inputStream.read(bytes2, 0, 2)
    println("바이트 배열 일부만 읽기 2 : " + bytes2.decodeToString())
} else {
    println("mark/reset not supported")
}
```

이렇게 하면 `mark()`와 `reset()` 함수가 지원되는 경우에만 해당 코드 블록이 실행되므로 예외가 발생하지 않습니다.