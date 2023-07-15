Spring Boot에 Thumbnail 이미지 만들기

- Graphics2D 이용
- Thumbnailator 라이브러리 이용

<br>

Gradle Library 추가

```yaml
/* thumbnailator */
implementation group: 'net.coobird', name: 'thumbnailator', version: '0.4.1'
```

<br>

### Grapic2D Controller

업로드 파일을 DatePath에 맞는 디렉터리에 저장 할것이고,

그 파일의 이름은 Thumbnail이라는 의미인 "s_" + uuid + originalFileName 으로 만들것이다.

```java
@RequestMapping(value = "uploadTest", method = RequestMethod.POST)
public void uploadTestPost(MultipartFile[] uploadFile) {
    log.info("uploadTestPost.............");
    
    // 업로드 디렉터리 지정
    String uploadDirectory = "C:\\upload";
    
    // Simple Date Format을 이용하여 Date 타입 단순화
    SimpleDateFormat sdt = new SimpleDateFormat("yyyy-MM-dd");
    Date date = new Date();
    String formatDate = sdt.format(date);
    
    // Data의 '-' 부분을 File.separator로 분리
    String datePath = formatDate.replace("-", File.separator);
    
    // 파일 생성(디렉터리, DatePath)
    File uploadPath = new File(uploadDirectory, datePath);
    
    // uploadPath가 존재 하지 않으면 파일 업로드
    if (uploadPath.exists() == false) {
        uploadPath.mkdirs();
    }
    
    // 입력으로 들어온 데이터를 돌면서
    for (MultipartFile multipartFile : uploadFile) {
        // File Original Name을 가져옴
        String uploadFileName = multipartFile.getOriginalFileName();
        
        // 랜덤 UUID 생성
        String uuid = UUID.randomUUID().toString();
        // UUID + _ + 파일네임
        uploadFileName = uuid + "_" + uploadFileName;
        
        // 파일 생성
        File saveFile = new File(uploadPath, uploadFileName);
        
        // 멀티파트파일 전송
        try {
            multipartFile.transterTo(saveFile);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

```kotlin
@RequestMapping(value = "uploadTest, method = RequestMethod.POST")
fun uploadTestPost(
    uploadFile: List<MultipartFile>
) {
    log.info("uploadTestPost............")
    
    val uploadDirectory = "C:\\upload"
    
    val sdt: SimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd")
    val date: Date = Date()
    val formatDate = sdt.format(date)
    
    val datePath = formatDate.replace("-", File.separator);
    
    val uploadPath = File(uploadDirectory, datePath)
    
    if (uploadPath.exists() == false) uploadPath.mkdirs()
    
    for (multipartFile in uploadFile) {
        val uploadFileName = multipartFile.getOriginalFileName()
        
        val uuid: UUID = UUID.randomUUID().toString()
        
        val uploadFileName = uuid + "_" + uploadFileName;
        
        val saveFile: File = File(uploadPath, uploadFileName)
        
        try {
            multipartFile.transferTo(saveFile)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
```



---

### IIOReadProgressListener Interface

```java
public interface IIOReadProgressListener extends EventListener {
    
    void sequenceStarted(ImageReader source, int minIndex);
    
    void sequenceComplete(ImageReader source);
    
    void imageStarted(ImageReader source, int imageIndex);
    
    void imageProgress(ImageReader source, float percentageDone);
    
    void imageComplete(ImageReader source);
    
    void thumbnailStarted(ImageReader source, int imageIndex, int thumbnameIndex);
    
    void thumbnailProgress(ImageReader source, float percentageDone);
    
    void thumbnailComplete(ImageReader source);
    
    void readAborted(ImageReader source);
}
```

---

### ThumbnailReadListener Class

```java
private class ThumbnailReadListener implements IIOReadProgressListener {
    JPEGImageReader reader = null;
    
    ThumbnailReadListener (JPEGImageReader reader) {
        this.reader = reader;
    }
    
    public void sequenceStarted(ImageReader source, int minIndex) {}
    public void sequenceComplete(ImageReader source) {}
    
    public void imageStarted(ImageReader source, int imageIndex) {}
    public void imageProgress(ImageReader source, float percentageDone) {
        reader.thumbnailProgress(percentageDone);
    }
    
    public void imageComplete(ImageReader source) {}
    
    public void thumbnailStarted(ImageReader source, int imageIndex, int thumbnailIndex) {}
    public void thumbnailProgress(ImageReader source, float percentageDone) {}
    public void thumbnailComplete(ImageReader source);
    
    public void readAborted(ImageReader source) {}
}
```

---

### getThumbnail Function

```java
BufferedImage getThumbnail(ImageInputStream iis, JPEGImageReader reader) throw IOException {
    iis.mark();
    iis.seek(streamPos);
    
    JPEGImageReader thumbReader = new JPEGImageReader(0, null);
    thumbReader.setInput(iis);
    thumbReader.addIIOReadProgressListener(new ThumbnailReadListener(reader));
    
    BufferedImage ret = thumbReader.read(0, null);
    thumbReader.dispose();
    iis.reset();
    
    return ret;
}
```



