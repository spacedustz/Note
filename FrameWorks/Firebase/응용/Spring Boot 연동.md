## 💡 Firebase Spring Boot 연동

### 사전 준비사항

[Firebase 프로젝트 생성](https://console.firebase.google.com/)

- Firebase 프로젝트 & Cloud Firestore 생성
- Firebase 프로젝트 설정 - 서비스 계정 - 새 비공개 키 생성 - json 파일 Spring resources 디렉터리로 이동

---

### Dependency 등록

```yaml
implementation group: 'com.google.firebase', name: 'firebase-admin', version: '8.1.0'
```

---

### Spring Boot 설정

```kotlin
// FirebaseConfig.kt

@Service
@Configuration
class FirebaseConfig {
    @Value("\${firebasePath}")
    private val firebaseFilePath: String? = null
    
    @PostConstructor
    fun init() {
        try {
            val stream = Thread.currentThread().contextClassLoader.getResourceAsStream(firebaseFilePath)
            
            val options = FirebaseOptions.builder()
            .setCredentials(GoogleGredentials.fromStream(stream))
            .setDatabaseUrl("https://~~.com/")
            .build()
            
            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options)
            }
        } catch (e: Exception) {
            log.error("FIREBASE-001 : Firebase Initialize Failed")
            throw Exception("", HttpStatus.EXPECTED_FAILED)
        }
    }
}
```

