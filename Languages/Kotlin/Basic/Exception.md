## 💡 코틀린에서 예외를 다루는법

목차

- Try Catch Finally
- Checked & Unchecked Exception
- Try With Resource

---

## 💡 Try Catch Finally

Try-Catch-Finally 문법은 자바,코틀린이 둘 다 동일하며, 코틀린에선 Expression이다.

코틀린에서 try-catch는 Expression이기 떄문에 return이나 변수의 값에 바로 할당이 가능하다

<br>

주어진 문자열을 정수로 변경하는 예시

```java
// Java
private int parseIntOrThrow(@NotNull String str) {
    try {
        return Integer.parseInt(str);
    } catch (NumberFormatException e) {
        throw new IllegalArgumentException(String.format("주어진 %s는 숫자가 아닙니다.", str));
    }
}
```

```kotlin
// Kotlin
fun parseIntOrThrow(str : String) : Int {
    return try {
        str.toInt()
    } catch (e : NumberFormatException) {
        throw IllegalArgumentException("주어진 ${str}는 숫자가 아납니다.")
    }
}
```

<br>

주어진 문자열을 정수로 변경하는 예시, 실패하면 Null 반환

```java
// Java
private Integer parseIntOrThrowV2(String str) {
    try {
        return Integer.parseInt(str);
    } catch (NumberFormatException e) {
        return null;
    }
}
```

```kotlin
// Kotlin
fun parseIntOrThrowV2(str : String?) : Int? {
    return try {
        return str?.toInt()
    } catch (e : NumberFormatException e) {
        null
    }
}
```

---

## 💡 Checked Exception & unchecked Exception

코틀린에선 Checked와 Unchecked의 구분이 없고 모두 Unchecked Exception으로 간주한다.

그래서 코틀린에선 throws를 볼 일이 없다.

<br>

프로젝트 내 파일의 내용을 읽어오는 예시

```java
// Java
public void readFile() throws IOException {
    File currentFile = new File(".");
    File file = new File(currentFile.getAbsolutePath() + "/a.txt");
    BufferedReader br = new BufferedReader(new FileReader(file));
    System.out.println(br.readLine());
    br.close();
}
```

```kotlin
// Kotlin
class FilePrint {
    fun readFile() {
        val currentFile = File(".")
        val file = File(currentFile.absolutePath + "/a.txt")
        val br = BufferedReader(FileReader(file))
        println(br.readLine())
        br.close()
    }
}
```

---

## 💡 Try With Resource

코틀린은 Try With Resource 구문이 없기 때문에 use라는 inline 확장함수를 통해 구현한다.

<br>

프로젝트 내 파일의 내용을 읽어오는 동일한 예시

```java
// Java
// 외부 리소르를 try() 안에 넣고 try()가 종료되면 자동으로 자원 반환이 이루어진다.
public void readFile(String path) throws IOException {
    try (BufferedReader br = new BufferedReader(new FileReader(path))) {
        System.out.println(br.readLine());
    }
}
```

```kotlin
// Kotlin
fun readFile(path: String) {
    BufferedReader(FileReader(path)).use {
        br -> println(br.readLine())
    }
}
```

