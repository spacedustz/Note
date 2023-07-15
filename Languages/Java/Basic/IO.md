## 💡 I/O

<br>

| **Java.io 패키지의 주요 클래스**           | **설명**                                                     |
| ------------------------------------------ | ------------------------------------------------------------ |
| File                                       | 파일 시스템의 **파일 정보**를 얻기 위한 클래스               |
| Console                                    | 콘솔로부터 문자를 입출력하기 위한 클래스                     |
| **InputStream / OutputStream**             | **바이트 단위** 입출력을 위한 **최상위** 입출력 스트림 클래스 |
| FileInputStream / FileOutputStream         | 바이트 단위 입출력을 위한 **하위** 스트림 클래스             |
| DataInputStream / DataOutputStream         |                                                              |
| ObjectInputStream / ObjectOutputStream     |                                                              |
| PrintStream                                |                                                              |
| BufferedInputStream / BufferedOutputStream |                                                              |
| **Reader / Writer**                        | **문자 단위** 입출력을 위한 **최상위** 입출력 스트림 클래스  |
| FileReader / FileWriter                    | 문자 단위 입출력을 위한 **하위** 스트림 클래스               |
| InputStreamReader / OutputStreamWriter     |                                                              |
| PrinterWriter                              |                                                              |
| BufferedReader / BufferedWriter            |                                                              |

<br>

바이트 단위 입출력 스트림 

- 그림, 멀티미디어, 문자등 모든 종류의 데이터들을 주고 받을 수 있다.

 문자 단위 입출력 스트림

- 오로지 문자만 주고받을 수 있게 특화되어 있다.

---

### **InputStream**

- 바이트 기반 입력 스트림의 최상위 클래스로 추상 클래스이다.
- 모든 바이트 기반 입력 스트림은 이 클래스를 상속받아서 만들어짐.

  InputStream 클래스에는 바이트 기반 입력 스트림이 기본적으로 가져야 할 메소드들이 정의 되어 있음.

| **메소드**                           | **설명**                                                     |
| ------------------------------------ | ------------------------------------------------------------ |
| int available()                      | 현재 읽을 수 있는 바이트 수를 반환한다                       |
| void close()                         | 현재 열려있는 InputStream을 닫는다                           |
| void mark(int readlimit)             | InputStream에서 현재의 위치를 표시해준다                     |
| boolean markSupported()              | 해당 InputStream에서 mark()로 지정된 지점이 있는지에 대한 여부를 확인한다 |
| abstract int read()                  | InputStream에서 한 바이트를 읽어서 int값으로 반환한다        |
| int read(byte[] b)                   | byte[] b 만큼의 데이터를 읽어서 b에 저장하고 읽은 바이트 수를 반환한다 |
| int read(byte[] b, int off, int len) | len만큼 읽어서 byte[] b의 off위치에 저장하고 읽은 바이트 수를 반환한다 |
| void reset()                         | mark()를 마지막으로 호출한 위치로 이동                       |
| long skip(long n)                    | InputStream에서 n바이트만큼 데이터를 스킵하고 바이트 수를 반환한다 |

---

### **OutputStream**

- 바이트 기반 출력 스트림의 최상위 클래스로 추상클래스이다.
- 모든 바이트 기반 출력 스트림 클래스는 이 클래스를 상속받아서 만들어짐.

  OutputStream 클래스에는 모든 바이트 기반 출력 스트림이 기본적으로 가져야할 메소드가 정의되어 있음.

| 메소드                                 | 설명                                          |
| -------------------------------------- | --------------------------------------------- |
| void close()                           | OutputStream을 닫는다                         |
| void flush()                           | 버퍼에 남아있는 출력 스트림을 출력한다        |
| void write(byte[] b)                   | 버퍼의 내용을 출력한다                        |
| void write(byte[] b, int off, int len) | b배열 안에 있는 시작 off부터 len만큼 출력한다 |
| abstract void write(int b)             | 정수 b의 하위 1바이트를 출력한다              |

