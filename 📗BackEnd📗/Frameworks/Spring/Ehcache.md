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

<br>

> Listener

이벤트 리스너를 정의하는 요소입니다. 

지정된 이벤트가 발생할 때 호출될 클래스와 실행 모드 등을 설정할 수 있습니다.

캐시가 생성되고 삭제되고 하는 이벤트를 모니터링 하고 싶으면 `org.ehcache.event.CacheEventListener` 를 구현하는 클래스를 만들어서 설정합니다. (태그 순서가 중요)

<br>

> d

```xml
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
  xmlns="http://www.ehcache.org/v3"  
  xsi:schemaLocation="http://www.ehcache.org/v3  
  http://www.ehcache.org/schema/ehcache-core-3.10.xsd">  
  
<!--    <persistence directory="${java.io.tmpdir}"/>-->  
  <!--  <cache-template name="template">-->  
  <!--    캐시가 생성되고 삭제되고 하는 이벤트를 모니터링 하고 싶으면 org.ehcache.event.CacheEventListener 를 구현하는 클래스를 만들어서 설정 (태그 순서가 중요)-->  
  <!--    <listeners>-->  
  <!--        <listener>-->  
  <!--            <class>sample.CacheEventLogger</class>-->  
  <!--            <event-firing-mode>ASYNCHRONOUS</event-firing-mode>--> 
  <!--            <event-ordering-mode>UNORDERED</event-ordering-mode>-->  
  <!--            <events-to-fire-on>CREATED</events-to-fire-on>-->  
  <!--            <events-to-fire-on>EVICTED</events-to-fire-on>-->  
  <!--            <events-to-fire-on>REMOVED</events-to-fire-on>-->  
  <!--            <events-to-fire-on>UPDATED</events-to-fire-on>-->  
  <!--            <events-to-fire-on>EXPIRED</events-to-fire-on>--> 
  <!--        </listener>-->  
  <!--    </listeners>-->  
  <!--  </cache-template>-->
  
  <cache-template name="defaultTemplate">  
    <expiry>  
      <ttl unit="seconds">600</ttl>  
    </expiry>  
    <listeners>  
        <listener>  
            <class>co.kr.dains.crowd.estimation.common.util.EhcacheEventLogging</class>  
            <event-firing-mode>ASYNCHRONOUS</event-firing-mode>  
            <event-ordering-mode>UNORDERED</event-ordering-mode>  
            <events-to-fire-on>CREATED</events-to-fire-on>  
            <events-to-fire-on>EVICTED</events-to-fire-on>  
            <events-to-fire-on>REMOVED</events-to-fire-on>  
            <events-to-fire-on>UPDATED</events-to-fire-on>  
            <events-to-fire-on>EXPIRED</events-to-fire-on>  
        </listener>  
    </listeners>  
  </cache-template>  
  
  <cache alias="msgCache" uses-template="defaultTemplate">  
    <key-type>java.lang.String</key-type>  
    <value-type>java.lang.String</value-type>  
    <expiry>  
      <!-- 캐시 만료 시간 = timeToLiveSeconds -->      <ttl unit="seconds">30</ttl>  
    </expiry>  
    <resources>  
      <!-- JVM heap 메모리 외부의 메모리 -->  
      <offheap unit="MB">10</offheap>  
      <!-- Disk 메모리, LFU strategy-->  
      <!--      persistent="false" Ehcache will wipe the disk data on shutdown.-->      <!--      persistent="true" Ehcache will preserve the disk data on shutdown and try to load it back on restart of the JVM.-->      <!--      <disk unit="MB" persistent="false">10</disk>-->    </resources>  
  </cache>  
</config>
```