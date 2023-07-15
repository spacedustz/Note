## 💡 Thumbnail Function

<br>

### Library 추가

Thumbnailator 라이브러리는 적은양의 코드만을 이용해 썸네일을 제작할 수 있다.

가로 세로 사이즈를 결정하면 비율에 맞게 조정해주는 기능을 제공한다.

```yaml
implementation group: 'net.coobird', name: 'thumbnailator', version: '0.4.11'
```

---

### yaml  설정

```yaml
# 파일 업로드

# 파일 업로드 기능여부 선택
spring.servlet.multipart.enabled=true

# 업로드된 파일의 임시 저장경로
spring.servlet.multipart.location=volumes/ming/git/learnfromcode:\\upload

# 한번에 최대 업로드 가능 용량
spring.servlet.multipart.max-request-size=30MB

# 파일 하나의 최대 크기
spring.servlet.multipart.max-file-size=10MB

#  업로드된 파일 저장
com.example.upload.path =/Volumes/ming/git/LearnFromCode\upload
```

---

### Controller

```kotlin
@RestController
class UploadController(
    @Value("${upload.path}")
    private val uploadPath: String?
) {
    
    @PostMapping("/upload")
    fun uploaFile(images: List<MultipartFile>): ResponseEntity<UploadResultDTO> {
        
        val resultDTOList = ArrayList<>()
        
        for (img in images) {
            
            try {
                if (img.getContentType().startsWith("image") == false) {
                    return ResponseEntity(HttpStatus.FORBIDDEN)
                }
                
                // 실제 파일 이름은 전체 경로가 들어오므로 잘라줌
                val originalName = img.getOriginalFileName()
                val fileName = originalName.subString(originalName.lastIndexOf("\\") +1)
                
                // 날짜 폴더 생성
                val folderPath = makeFolder()
                
                // UUID 생성
                val uuid = UUID.randomUUID().toString()
                
                // 저장할 파일 이름 중간에 '_'를 이용해 구분
                val saveName = uploadPath 
                + File.separator 
                + floderPath 
                + File.separator 
                + uuid
                + fileName
                
                val savePath: Path = Paths.get(saveName)
                
                img.transferTo(savePath)
                resultDTOList.add(UploadResultDTO(fileName, uuid, folderPath))
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        return ResponseEntity(resultDTOList, HttpStatus.CREATED);
    }
    
        private fun makeFolder(): String {
        val str = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"))
            
        val folderPath = str.replace("/", File.separator)
            
        // 폴더 생성
        val uploadPathFolder: File = File(uploadPath, folderPath)
            
        if (uploadPathFolder.exists() == false) {
            uploadPathFolder.mkdirs()
        }
        return folderPath
    }
}
```

---

### UploadResultDTO

```kotlin
data class UploadResultDTO(
    val fileName: String?,
    val uuid: String?,
    val folderPath: String?,
) {
    fun getImageURL() {
        try {
            return URLEncoder.encode(folderPath + "/" + uuid + fileName, "UTF=8")
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return ""
    }
}
```

