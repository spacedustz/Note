## Jar Start Option

### 메모리 설정

- **-Xms2048m**: JVM이 시작할 때 할당하는 초기 메모리 크기를 2048MB로 설정합니다.
- **-Xmx2048m**: JVM이 사용할 수 있는 최대 메모리 크기를 2048MB로 제한합니다.
- **-XX:NewSize=800m**: Young Generation(신세대 영역)의 초기 크기를 800MB로 설정합니다.
- **-XX:MaxNewSize=800m**: Young Generation의 최대 크기를 800MB로 제한합니다.
- **-XX:SurvivorRatio=4**: Eden 영역과 Survivor 영역의 비율을 4:1로 설정합니다.

<br>

### 시스템 속성 설정

- **-Dspring.config.location=file:{PATH.yml}:** Spring Boot 애플리케이션의 구성 설정 위치를 지정합니다.
- **-Dlogging.config=file:{PATH.xml}:** logback-spring 파일의 위치를 정의합니다.
- **-DLOG_PATH=$LOG_DIR**: 로그 파일의 경로를 환경 변수 `LOG_DIR`에서 지정된 값으로 설정합니다.
- **-Duser.timezone=GMT+09:00**: 애플리케이션의 시간대를 GMT+09:00으로 설정합니다.
- **-Dcom.datastax.driver.FORCE_NIO=true**: DataStax Java 드라이버가 NIO(Non-blocking I/O) 모드를 강제로 사용하도록 설정합니다.

<br>

```
-Dspring.config.location=file:{PATH.yml}
-Dlogging.config=file:{PATH.xml}
-Xms2048m
-Xmx2048m
-XX:NewSize=800m Young Generation(신세대 영역)의 초기 크기를 800MB로 설정합니다.
-XX:MaxNewSize=800m Young Generation의 최대 크기를 800MB로 제한합니다.
-XX:SurvivorRatio=4 Eden 영역과 Survivor 영역의 비율을 4:1로 설정합니다.
```
