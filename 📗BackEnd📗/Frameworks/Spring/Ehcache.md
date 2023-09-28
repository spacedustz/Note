## 📘 Spring Ehcache

 Spring에서 간단하게 사용할 수 있는 Java기반 오픈소스 캐시 라이브러리 입니다.

redis나 memcached같은 캐시 엔진들도 있지만, 

저 2개의 캐시 엔진과는 달리 ehcache는 Daemon을 가지지 않고 Spring 내부적으로 동작하여 캐싱 처리를 합니다.

<br>

따라서 redis같이 별도의 서버를 사용하여 생길 수 있는 네트워크 지연 혹은 단절같은 이슈에서 자유롭고,

같은 로컬 환경 일지라도 별도로 구동하는 memcached와는 다르게 ehcache는 서버 어플리케이션과 라이프사이클을 같이 하므로 사용하기 더욱 간편합니다.

<br>

Ehcache의 2.x 버전과 3 버전의 차이는 큽니다.

3 버전 부터는 javax.cache API(JSR-107)와의 호환성을 제공합니다. 따라서 표준을 기반으로 만들어 졌습니다.

또, 3 버전에서는 **offheap**이라는 저장 공간을 제공합니다.

**offheap**이란 말 그대로 힙 메모리를 벗어난 메모리로 Java GC에 의해 데이터가 정리되지 않는 공간입니다.

<br>

3 버전을 기준으로 글을 작성하겠습니다.

---

## 📘 사용법 - 설정

Ehcache를 사용하는 방법엔 여러가지가 있습니다.

- Github에서 직접 jar를 받아 import 하기
- Maven Central 에서 Dependency 가져오기

Maven Dependency로 가져오는 방법을 선택하겠습니다.

<br>

**build.gradle**

```groovy
implementation 'org.springframework.boot:spring-boot-starter-cache'  
implementation 'org.ehcache:ehcache:3.10.8'  
implementation 'javax.cache:cache-api:1.1.1' // expiry 기능을 위해 필요 (JSR-107 API)
```

<br>

**ehcache.xml**

이제 캐시에 대해 어떻게 처리할 것인지 정의하기 위해 `ehcache.xml`파일을 작성합니다.

파일의 위치는 프로젝트 내 `resources` 디렉터리 하위에 위치해야 합니다.

```xml

```