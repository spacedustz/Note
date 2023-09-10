## 💡 File Class

코틀린에서 File 클래스는 파일과 디렉토리를 다루는 데 사용됩니다. 

클래스를 사용하려면 `java.io` 패키지를 임포트해야 합니다. 

아래는 File 클래스에서 사용 가능한 주요 메서드와 예시 코드입니다.

<br>

### 생성자

- `File(path: String)`: 지정된 경로를 가진 파일이나 디렉토리를 나타내는 File 객체를 생성합니다.
- `File(parent: String, child: String)`: 지정된 부모 경로와 자식 경로를 가진 파일이나 디렉토리를 나타내는 File 객체를 생성합니다.

```kotlin
// 파일 경로를 가지고 File 객체 생성
val file1 = File("file.txt")

// 부모 경로와 자식 경로를 가지고 File 객체 생성
val parentDir = "C:/parent"
val childFile = "child.txt"
val file2 = File(parentDir, childFile)
```

<br>

### 파일/디렉토리 생성

- `createNewFile()`: 새로운 파일을 생성합니다. 이미 존재하는 파일이면 false를 반환합니다.
- `mkdir()`: 새로운 디렉토리를 생성합니다. 이미 존재하는 디렉토리이거나 부모 디렉토리가 없으면 false를 반환합니다.
- `mkdirs()`: 지정된 경로에 있는 모든 디렉토리를 생성합니다.

```kotlin
// 새로운 파일 생성
val file = File("file.txt")
file.createNewFile()

// 새로운 디렉토리 생성
val dir = File("newdir")
dir.mkdir()

// 중첩된 디렉토리 생성
val nestedDir = File("newdir/subdir")
nestedDir.mkdirs()
```

<br>

### 파일/디렉토리 삭제

- `delete()`: 파일 또는 디렉토리를 삭제합니다. 디렉토리가 비어있지 않으면 삭제되지 않습니다.

```kotlin
// 파일 삭제
val file = File("file.txt")
file.delete()

// 디렉토리 삭제
val dir = File("newdir")
dir.delete()
```

<br>

### 파일/디렉토리 존재 확인

- `exists()`: 파일 또는 디렉토리의 존재 여부를 확인합니다.

```kotlin
// 파일 존재 확인
val file = File("file.txt")
if (file.exists()) {
    println("file exists")
} else {
    println("file does not exist")
}

// 디렉토리 존재 확인
val dir = File("newdir")
if (dir.exists()) {   
    println("directory exists")
    } else {
    println("directory does not exist")
}
   
```

<br>

### 파일/디렉토리 정보 확인

- `isFile()`: 파일 여부를 확인합니다.
- `isDirectory()`: 디렉토리 여부를 확인합니다.
- `length()`: 파일 크기를 반환합니다.
- `list()`: 디렉토리 내 파일 및 디렉토리 목록을 문자열 배열로 반환합니다.
- `listFiles()`: 디렉토리 내 파일 및 디렉토리 목록을 File 객체 배열로 반환합니다.

```kotlin
// 파일 여부 확인
val file = File("file.txt")
if (file.isFile()) {
    println("file is a file")
} else {
    println("file is not a file")
}

// 디렉토리 여부 확인
val dir = File("newdir")
if (dir.isDirectory()) {
    println("dir is a directory")
} else {
    println("dir is not a directory")
}

// 파일 크기 확인
val fileSize = file.length()
println("file size is $fileSize bytes")

// 디렉토리 내 파일 및 디렉토리 목록 출력
val files = dir.list()
for (f in files) {
    println(f)
}

// 디렉토리 내 파일 및 디렉토리 객체 배열 출력
val fileObjs = dir.listFiles()
for (f in fileObjs) {
    println(f.absolutePath)
}
```

<br>

### 파일/디렉토리 경로 확인

- `getPath()`: 파일 또는 디렉토리의 경로를 반환합니다.
- `getAbsolutePath()`: 파일 또는 디렉토리의 절대 경로를 반환합니다.

```kotlin
// 경로 확인
val file = File("file.txt")
println("file path: ${file.path}")
println("file absolute path: ${file.absolutePath}")

val dir = File("newdir")
println("dir path: ${dir.path}")
println("dir absolute path: ${dir.absolutePath}")
```

위와 같이 File 클래스를 활용하여 파일 입출력을 다룰 수 있습니다. 