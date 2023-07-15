## 💡 Thumbnail Function

<br>

---

### File Entity

```kotlin
@Entity
@DynamicUpdate
class File (
    
    @Id @GeneratedValue
    var id: String,
    var originFileName: String,
    var fullPath: String
) {
    
    
    constructor (
        id: Long,
        originFileName: String,
        fullPath: String
    ) {
        this.id = id
        this.originFilename = originFileName
        this.fullPath = fullPath
    }
}
```

---

### FileDTO

```kotlin
data class FileDTO(
    var id: Long,
    var originFileName: String,
    var fullPath: String
) {
    companion object {
        fun fromEntity(form: File) {
            return FileDTO(
                id = form.id
                originFileName = form.originFileName
                fullPath - form.fullPath
            )
        }
    }
}
```

