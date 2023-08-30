## 💡 File I/O

코틀린에서 파일 입출력을 다루는 데에 필요한 기본적인 클래스들입니다. 

<br>

### File 클래스

파일을 다루는 데 필요한 메서드를 제공합니다. 

생성, 삭제, 이름 변경, 크기 확인 등의 작업을 할 수 있습니다. 

File 클래스는 java.io.File 클래스를 코틀린에서 사용하기 위한 래퍼 클래스입니다.

```kotlin
val file = File("파일 경로")
```

### FileInputStream 클래스

파일을 바이트 단위로 읽기 위한 클래스입니다. read() 메서드를 사용하여 파일 내용을 읽어들일 수 있습니다.

```kotlin
val inputStream = FileInputStream("파일 경로")
val data = inputStream.read()
```

### FileOutputStream 클래스

파일을 바이트 단위로 쓰기 위한 클래스입니다. write() 메서드를 사용하여 파일 내용을 쓸 수 있습니다.

```kotlin
val outputStream = FileOutputStream("파일 경로")
outputStream.write(byteArrayOf(1, 2, 3))
```

### BufferedReader 클래스

문자 단위로 파일을 읽기 위한 클래스입니다. readLine() 메서드를 사용하여 파일 내용을 읽어들일 수 있습니다.

```kotlin
val bufferedReader = BufferedReader(FileReader("파일 경로"))
val line = bufferedReader.readLine()
```

### BufferedWriter 클래스

문자 단위로 파일을 쓰기 위한 클래스입니다. write() 메서드를 사용하여 파일 내용을 쓸 수 있습니다.

```kotlin
val bufferedWriter = BufferedWriter(FileWriter("파일 경로"))
bufferedWriter.write("Hello, world!")
```

### ObjectInputStream 클래스

객체를 읽어들이기 위한 클래스입니다. readObject() 메서드를 사용하여 객체를 읽어들일 수 있습니다.

```kotlin
val objectInputStream = ObjectInputStream(FileInputStream("파일 경로"))
val obj = objectInputStream.readObject()
```

### ObjectOutputStream 클래스

객체를 쓰기 위한 클래스입니다. writeObject() 메서드를 사용하여 객체를 쓸 수 있습니다.

```kotlin
val objectOutputStream = ObjectOutputStream(FileOutputStream("파일 경로"))
objectOutputStream.writeObject(obj)
```

