## 💡 (Buffered) InputStream & OutputStream

InputStream과 OutputStream 클래스는 바이트 단위로 데이터를 읽고 쓰는 기본적인 입출력 클래스입니다. 

이 클래스를 활용하여 파일 입출력 뿐만 아니라 네트워크 상에서도 데이터를 주고받을 수 있습니다. 

InputStream과 OutputStream 클래스의 주요 메서드와 사용법을 예시와 함께 알아보겠습니다.

---

## InputStream 클래스

- `read()`: 1바이트씩 데이터를 읽어옵니다. 반환값은 읽은 데이터의 바이트 값입니다. 더 이상 읽을 데이터가 없을 경우 -1을 반환합니다.
- `read(b: ByteArray)`: 지정한 바이트 배열에 데이터를 읽어옵니다. 읽은 바이트 수를 반환합니다.
- `read(b: ByteArray, off: Int, len: Int)`: 지정한 바이트 배열의 off 위치부터 len 바이트 수만큼 데이터를 읽어옵니다. 읽은 바이트 수를 반환합니다.
- `available()`: 현재 읽을 수 있는 바이트 수를 반환합니다.
- `skip(n: Long)`: n 바이트 수 만큼 건너뛰어 데이터를 읽어옵니다.
- `mark(readlimit: Int)`: 현재 위치를 마크합니다. 읽을 수 있는 바이트 수는 readlimit으로 지정합니다.
- `reset()`: 마크한 위치로 되돌아갑니다.
- `close()`: 입력 스트림을 닫습니다.

```kotlin
val inputStream: InputStream = File("file.txt").inputStream()

// 1바이트씩 읽기
var byteRead = inputStream.read()
while (byteRead != -1) {
    println(byteRead.toChar())
    byteRead = inputStream.read()
}

// 바이트 배열에 읽기
val bytes = ByteArray(1024)
val bytesRead = inputStream.read(bytes)
if (bytesRead != -1) {
    println("Byte 배열에 읽기" + bytes.decodeToString(0, bytesRead))
}

// 바이트 배열의 일부분만 읽기
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

inputStream.close()
```

---

## OutputStream 클래스

- `write(b: Int)`: 1바이트씩 데이터를 출력합니다.
- `write(b: ByteArray)`: 지정한 바이트 배열의 데이터를 출력합니다.
- `write(b: ByteArray, off: Int, len: Int)`: 지정한 바이트 배열의 off 위치부터 len 바이트 수만큼 데이터를 출력합니다.
- `flush()`: 버퍼에 남아있는 데이터를 모두 출력합니다.
- `close()`: 출력 스트림을 닫습니다.

```kotlin
val outputStream: OutputStream = File("file.txt").outputStream()

// 1바이트씩 출력
outputStream.write('h'.toInt())
outputStream.write('e'.toInt())
outputStream.write('l'.toInt())
outputStream.write('l'.toInt())
outputStream.write('o'.toInt())

// 바이트 배열 출력
val bytes = "world".toByteArray()
outputStream.write(bytes)

// 바이트 배열 일부분만 출력
val bytes2 = "Hello, world".toByteArray()
outputStream.write(bytes2, 7, 5)

// 출력 스트림 버퍼 비우기
outputStream.flush()

outputStream.close()
```

InputStream과 OutputStream 클래스는 입출력 스트림을 다루는 기본적인 클래스이므로 자주 사용됩니다. 

파일 입출력은 물론이고, 네트워크 통신에서도 많이 사용됩니다. 

또한, 이들 클래스를 활용하여 기능적으로 더 복잡한 BufferedInputStream, BufferedOutputStream 등을 사용할 수도 있습니다.

<br>

코틀린의 `OutputStream`의 `write()` 메서드는 **파일의 모든 내용을 덮어씌우기 때문에**, 기존 파일의 내용이 삭제됩니다. 이는 파일을 새로 쓰는 것과 동일한 효과를 냅니다.

이는 `OutputStream`의 생성자에 `append` 파라미터를 사용하여, 파일의 끝에 쓰거나, 기존 내용에 추가할 수 있습니다. `append` 파라미터가 `true`로 설정되면, 기존 파일 내용에 새로운 데이터를 추가하게 됩니다.

예를 들어, 아래 코드는 `OutputStream`을 생성할 때 `append` 파라미터를 `true`로 설정하여, 기존 파일에 데이터를 추가합니다.

```kotlin
val file = File("example.txt")
val outputStream = FileOutputStream(file, true)
outputStream.write("New Data".toByteArray())
outputStream.close()
```

이 코드는 "example.txt" 파일의 끝에 "New Data"라는 새로운 내용을 추가합니다.

---

## BufferedInputStream & BufferedOutputStream

Kotlin에서 `BufferedInputStream`과 `BufferedOutputStream`은 I/O 작업의 성능을 향상시키기 위해 사용되는 클래스입니다. 기본적으로 입출력 작업은 하드디스크나 네트워크와 같은 외부 자원과의 작업이기 때문에 작업 속도가 느릴 수 있습니다. 이러한 작업에서 버퍼링은 중요한 역할을 합니다.

<br>

`BufferedInputStream`과 `BufferedOutputStream` 클래스는 기본적으로 메모리 상에 버퍼를 두고 데이터를 일정 크기만큼 불러와서 버퍼링을 수행합니다. 이를 통해 입출력 작업을 수행할 때마다 디스크나 네트워크에 액세스하는 것보다 메모리에서 데이터를 읽거나 쓰는 것이 더욱 빠르기 때문에 성능 향상을 기대할 수 있습니다.

<br>

`BufferedInputStream`과 `BufferedOutputStream`은 각각 `InputStream`과 `OutputStream`을 상속받아 구현됩니다. 이들은 `InputStream`과 `OutputStream`이 제공하는 모든 기능을 제공하면서, 추가로 버퍼링을 수행합니다. 예를 들어, `BufferedInputStream`의 `read()` 메서드를 호출하면 내부적으로 버퍼에서 일정 크기만큼 데이터를 읽고, 만약 버퍼가 비어있다면 다시 디스크에서 데이터를 읽어와서 버퍼에 저장합니다. 마찬가지로 `BufferedOutputStream`의 `write()` 메서드를 호출하면 버퍼에 일정 크기만큼 데이터를 저장하고, 버퍼가 가득 차면 디스크에 데이터를 씁니다.

<br>

따라서, `BufferedInputStream`과 `BufferedOutputStream`은 I/O 작업에서 성능을 향상시키기 위해 사용됩니다. 그러나 작은 데이터의 경우에는 버퍼링이 성능을 떨어뜨릴 수 있으므로 적절한 크기의 버퍼를 사용하는 것이 중요합니다.
