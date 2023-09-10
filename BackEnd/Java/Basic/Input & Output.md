I/O란 Input과 Output의 약자로 입력과 출력, 간단히 줄여서 입출력이라고 한다. 

입출력 은 컴퓨터 내부 또는 외부의 장치와 프로그램간의 데이터를 주고받는 것을 말한다. 

예를 들면 키보드로부터 데이터를 입력받는다든가 System.out.printing을 이용해서 화면에 출력한다던가 하는 것이 가장 기본적인 입출력의 예이다.

---

## Stream

자바에서 입출력을 수행하려면, 즉 어느 한쪽에서 다른 쪽으로 데이터를 전달하려면,

두 대상을 연결하고 데이터를 전송할 수 있는 무언가가 필요한데 이것을 스트림(stream)이 라고 정의했다. 

> 스트림이란 데이터를 운반하는데 사용되는 연결통로이다.

<br>

물이 한쪽 방향으로만 흐르는것과 같이 스트림은 단방향통신만 가능하기 떄문에 하나의 스트림으로 입/출력을 동시처리가 안된다.

그래서 입출력을 동시에 수행하려면 입력스트림/출력스트림 2개의 스트림이 필요하다.

<br>

스트림은 먼저 보낸 데이터를 먼저 받게 되어 있으며 중간에 건너뜀 없이 연속적으로 데 이터를 주고받는다. 

큐(queue)와 같은 FIFO(First In First Out)구조로 되어 있다고 생각 하면 이해하기 쉬울 것이다.

---

## 바이트기반 스트림 - InputStream & OutputStream

스트림은 바이트단위로 데이터를 전송하며 입출력 대상에 따라 다음과 같은 입출력스트림이 있다.

<br>

> 입력 / 출력 스트림의 종류

|입력스트림|출력스트림|입출력 대상의 종류|
|---|---|---|
|File(InputStream)|File(OutputStream)|파일|
|ByteArray(InputStream)|ByteArray(OutputStream)|메모리(byte 배열)|
|Piped(InputStream)|Piped(OutputStream)|프로세스 (프로세스 간 통신)|
|Audio(InputStream)|Audio(OutputStream)|오디오 장치|

<br>

위와 같이 여러 종류의 입출력 스트림이 있으며, 어떤 대상에 작업을 할 것인지에 따라 맞는 스트림을 사용하면 된다.

예를 들어 어떤 파일의 내용을 읽고자 하는 경우 `FileInputStream`을 사용하면 된다.

<br>

> read()의 반환타입이 byte가 아니라 int인 이유는 read()의 반환값의 범위가 0~255와 -1 이기 때문이다.

|InputStream|OutputStream|
|---|---|
|abstract int read()|abstract void write(int b)|
|int read(byte[] b)|void write(byte[] b)|
|int read(byte[], int off, int len)|void write(byte[] b, int off, int len)|

<br>

```java
public abstract class InputStream {
	// 입력스트림으로부터 1 byte를 읽어서 반환한다. 읽을 수 없으면 -1을 반환한다.
	abstract int read();

	// 입력 스트림으로부터 len개의 byte를 읽어서 byte 배열 b의 off 위치부터 저장한다.
	int read(byte[] b, int off, int len) {
		for (int i = off;, i < off + len; i++) {
			b[i] = (byte) read();
		}
	}

	// 입력 스트림으로부터 byte 배열 b의 크기만큼 데이터를 읽어서 배열 b에 저장한다.
	int read(byte[] b) {
		return read(b, 0, b.length);
	}
}
```

---

## 보조 스트림

위에서 설명한 스트림 외에도 스트림의 기능을 보완하기 위한 보조스트림이 제공된다.

보조스트림은 `실제 데이터를 주고받는 스트림이 아니기 때문에` 데이터 입출력 기능은 없지만, 스트림의 기능향상이나 새로운 기능을 추가할 수 있다.

<br>

그래서 보조 스트림만으로는 입출력을 처리할 수 없고 스트림을 먼저 생성한 후 이를 이용해 보조스트림을 생성해야 한다.

예를 들어, test.txt라는 파일을 읽기위해 FileInputStream을 사용할 때, 입력 성능을 향상시키기 위해 버퍼를 사용하는 보조스트림인

BufferedInputStream을 사용한 코드는 다음과 같다.

```java
// 먼저 기반 스트림 생성
FileInputStream fis = new FileInptuStream("test.txt");

// 기반 스트림을 이용해서 보조 스트림 생성
BufferedIntputStream bis = new BufferedInputStream(fis);

// 보조스트림인 BufferedInputStream으로부터 데이터를 읽는다.
bis.read();
```

<br>

코드 상으로는 보조스트림인 BufferedInputStream이 입력기능을 수행하는 것처럼 보이지만,

실제로는 BufferedInputStream과 연결된 FileInputStream이 입력기능을 수행하고,

보조스트림인 BufferedStream은 버퍼만을 제공한다.

<br>

버퍼를 사용한 입출력과 사용하지 않은 입출력간의 성능차이는 상당하기 때문에 대부분의 경우 버퍼를 이용한 보조스트림을 사용한다.

<br>

> 보조 스트림의 종류

- BufferedInputStream
- DataInputStream
- DigestInputStream
- LineNumberInputStream
- PushbackInputStream

<br>

위 보조스트림들은 모두 FilterInputStream의 자손들이고, FilterInputStream은 InputStream의 자손이므로,

결국 모든 보조스트림 역시 InputStream과 OutputStream의 자손들이므로 입출력 방법이 같다.

<br>

|입력|출력|설명|
|---|---|---|
|FilterInputStream|FilterOutputStream|필터를 이용한 입출력 처리|
|BufferedInputStream|BufferedOutputStream|버퍼를 이용한 입출력 성능 향상|
|DataInputStream|DataOutputStream|int, float과 같은 기본타입으로 데이터를 처리하는 기능|
|SequenceInputStream|없음|두 개의 스트림을 하나로 연결|
|LineNumberInputStream|없음|읽어 온 데이터읠 ㅏ인 번호를 카운트(JDK1.1부터 LineNumberReader로 대체)|
|ObjectInputStream|ObjectOutputStream|데이터를 객체단위로 읽고 쓰는데 사용, 주로 파일을 이용하여 객체 직렬화와 관련이 있음|
|없음|PrintStream|버퍼를 이용하며, 추가적인 print 관련 기능(print,printf,println)|
|PushbackInputStream|없음|버퍼를 이용해서 읽어 온 데이터를 다시 되돌리는 기능(unread, push back to buffer)|

---

## 문자기반 스트림 - Reader, Writer

위에서 알아본 스트림은 모두 바이트기반 스트림이다. `(바이트기반 = 입출력의 단위가 1 byte라는 의미)`

C언어와 달리 Java는 한 문자를 의미하는 char형이 2byte기 때문에 바이트기반의 스트림으로 2byte인 문자를 처리하는데 어려움이 있다.

이 점을 보완하기 위해서 문자기반의 스트림이 제공된다.

문자데이터를 입출력할 때는 바이트기반 스트림 대신 문자기반 스트림을 사용하자.

- InputStreamReader
- OutputStraemReader

<br>

|바이트기반 스트림 (Input/Output Stream)|문자기반 스트림 (Reader/Writer)|
|---|---|
|File|File|
|ByteArray|CharArray|
|Piped|Piped|
|StringBuffer|String|

<br>

문자 기반 스트림의 이름은 바이트기반 스트림의 이름에서 InputStream -> Reader, OutputStream -> Writer로 바꿔주면 된다.

단 ByteArrayInputStream에 대응하는 문자기반 스트림은 char 배열을 사용하는 CharArrayReader이다.

<br>

> 바이트기반 스트림과 문자기반 스트림의 읽기/쓰기에 사용되는 함수 비교

byte 배열 대신 char 배열을 사용한다는 것과 추상메서드가 달라졌다.

**InputStream**

- abstract int read()
- int read(byte[], b)
- int read(byte[] b, int off, int len)

**OutputStream**

- abstract void wirte(int b)
- void write(byte[] b)
- void write(byte[] b, int off, int len)

<br>

**Reader**

- int read()
- int read(char[] cbuf)
- abstract int read(char[] cbuf, int off, int len)|

**Writer**

- void write(int c)
- void write(char[] cbuf)
- abstract void write(char[] cbuf, int off, int len)
- void write(String str)
- void write(String str, int off, int len)

<br>

보조스트림 역시 다음과 같은 문자기반 보조스트림이 존재하며 사용목적과 방식은 둘다 같다.

|바이트기반 보조스트림(Input/Output Stream)|문자기반 보조스트림(Reader/Writer)|
|---|---|
|Buffered|Buffered|
|Filter|Filter|
|LineNumber|LineNumber|
|Print|Print|
|Pushback|Pushback|

---

## 바이트기반 스트림의 함수

바이트기반 스트림의 함수들을 알아보자.

<br>

> InputStream의 함수

|함수명|설명|
|---|---|
|int available()|스트림으로부터 읽어 올 수 있는 데이터의 크기를 반환한다.|
|void close()|스트림을 닫고 자원 반환|
|void mark(int readlimit)|현재 위치를 표시한다. 후에 reset()에 의해 표시한 위치로 돌아갈 수 있다. readlimit은 되돌아갈 수 있는 byte의 수이다.|
|boolean markSupported()|mark()와 reset()을 지원하는지 알려준다. 두 기능의 지원은 선택적이므로, 두 기능을 사용하기 전에 markSupported()를 호출해 지원여부를 확인해야한다.|
|abstract int read()|1 byte를 읽어온다.(0~255 사이의 값) 더이상 읽을 데이터가 없으면 -1 반환. abstract 이라서 InputStream의 자손들은 각각 알맞게 구현해야한다.|
|int read(byte[] b)|배열 b의 크기만큼 읽어서 배열을 채우고 읽은 데이터의 수를 반환한다. 반환하는 값은 항상 배열의 크기보다 작거나 같다.|
|int read(byte[] b, int off, int len)|최대 len개의 byte를 읽어서 배열 b의 지정된 위치인 off부터 저장한다. 실제로 읽어올 데이터가 len개보다 적을 수 있다.|
|void reset()|스트림에서의 위치를 마지막으로 mark()가 호출된 위치로 되돌린다.|
|long skip(long n)|스트림에서 주어진 길이(n)만큼 건너뛴다.|

<br>

> OutputStream의 함수

|함수명|설명|
|---|---|
|void close()|입력소스를 닫고 자원 반환|
|void flush()|스트림의 버퍼에 있는 모든 내용을 출력소스에 쓴다.|
|abstract void write(int b)|주어진 값을 출력소스에 쓴다.|
|void write(byte[] b)|주어진 배열 b에 저장된 모든 내용을 출력소스에 쓴다.|
|void write(byte[] b, int off, int len)|주어진 배열 b에 저장된 내용중 off번째부터 len개의 데이터를 읽어서 출력소스에 쓴다.|

<br>

- 스트림의 종류에 따라 mark()와 reset()을 사용해 이미 읽은 데이터를 되돌려 다시 읽을 수 있다.
- 이 기능을 지원하는 스트림인지 확인하는 markSupported()를 통해 알 수 있다.
- flush()는 버퍼가 있는 출력스트림의 경우에만 의미가 있으며, OutputStream에 정의된 flush()는 아무런 일도 하지 않는다.
- 프로그램이 종료될 때 닫지 않은 스트림을 JVM이 자동으로 닫아주지만, 반드시 close()를 호출해 닫아주자.
- 하지만 ByteArrayInputStream과 같이 메모리를 사용하는 스트림과 `System.in/out`과 같은 표준 입출력 스트림은 닫지 않아도 된다.

---

## ByteArrauInputStream & ByteArrayOutputStream

ByteArrayInputStream/ByteArrayOutputStream은 메모리, 즉 바이트배열에 데이터 를 입출력 하는데 사용되는 스트림이다. 

주로 다른 곳에 입출력하기 전에 데이터를 임시 로 바이트배열에 담아서 변환 등의 작업을 하는데 사용된다. 

자주 사용되지 않지만 스트림을 이용한 입출력방법을 보여 주는 예제를 작성하기에는 적합해서, 

이 스트림을 이용해서 읽고 쓰는 여러 방법을 보여 주는 예제들을 작성해 보았다.

```java
public static void main(String[] args) {
	byte[] inSrc = {0,1,2,3,4,5,6,7,8,9};
	byte[] outSrc = null;
	
	ByteArrayInputStream input = null;
	ByteArrayOutputStream output = null;

	input = new ByteArrayInputStream(inSrc);
	output = new ByteArrayOutputStream();

	int data = 0;

	while ((data = input.read()) != -1) {
		output.write(data); // void write(int b)
	}

	outSrc = output.toByteArray(); // 스트림의 내용을 Byte 배열로 반환

	System.out.println("Input Source : " + Arrays.toString(inSrc));
	System.out.println("Output Source : " + Arrays.toString(outSrc));
}

/* 출력 결과 */
// Input Source : [0,1,2,3,4,5,6,7,8,9]
// Output Source : [0,1,2,3,4,5,6,7,8,9]
```

<br>

바이트 배열은 사용하는 자원이 메모리 밖에 없으므로 가비지컬렉터에 의해 자동 자원 반환이 되기 때문에 close()를 안써도 된다.

