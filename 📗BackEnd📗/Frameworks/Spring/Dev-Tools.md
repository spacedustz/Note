
## 📘 Spring Dev-Tools

코드 수정 시 브라우저에 반영 하려면 재 시작을 해야 하는데 이런 불편한 점을 해결할 수 있습니다.

크게 아래 5가지 기능을 제공합니다.

- Property Defaults (속성 기본값)
- Automatic Restart (자동 재시작)
- Live Reload (실시간 리로드)
- Global Settings (전역 설정)
- Remote Applications (원격 어플리케이션)

<br>

## 📘 Automatic Restart

**IDE Settings**

- IntelliJ - Settings - Advanced Settings - Compiler 부분에 Allow auto-make to start even ... 부분 체크
- IntelliJ - Settings - Build, Execution - Compiler - Builld Project automatically 체크

<br>

**Yaml 파일**

- spring.devtools.restart.enabled  # Automatic Restart 사용 여부  
- spring.devtools.restart.additional-exclude # Automatic Restart 내에서 제외할 파일 경로

```yaml
spring:
	devtools:
		restart:
			enabled: true
			additional-exclude: static/**, public/**
```

---

## 📘 Live Reload

**IDE Settings**

IntellJ - Edit Configuration - Modify Options - On Update Option - Resource Update 체크

<br>

**Yaml 파일**

```yaml
spring:
	devtools:
		livereload:
			enabled: true
```