개인 LogBack 세팅

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<configuration>  
    <include resource="org/springframework/boot/logging/logback/defaults.xml" />  
    <include resource="org/springframework/boot/logging/logback/console-appender.xml" />  
  
    <conversionRule conversionWord="clr" converterClass="org.springframework.boot.logging.logback.ColorConverter" />  
    <conversionRule conversionWord="wex" converterClass="org.springframework.boot.logging.logback.WhitespaceThrowableProxyConverter" />  
  
    <!-- 변수 지정 -->  
    <property name="CONSOLE_LOG_PATTERN" value="%clr(%d{yyyy-MM-dd HH:mm:ss}){faint} %clr(%5p){TRACE=white,DEBUG=cyan,INFO=green,WARN=orange,ERROR=red} %clr(${PID:- }){magenta} %clr(---){faint} %clr([%15.15t]){faint} %clr(%-40.40logger{39}){blue} %clr(:){faint} %m%n%wex"/>  
    <property name="LOG_DIR" value="E:\Data\Log\Access-Control" />  
    <property name="LOG_PATH_NAME" value="${LOG_DIR}/hls.log" />  
  
    <!-- FILE Appender -->  
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">  
        <file>${LOG_PATH_NAME}</file>  
        <!-- 일자별로 로그파일 적용하기 -->  
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">  
            <fileNamePattern>${LOG_PATH_NAME}.%d{yyyyMMdd}.zip</fileNamePattern>  
            <maxHistory>5</maxHistory> <!-- 일자별 백업파일의 보관기간 -->  
        </rollingPolicy>  
        <encoder>  
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%-5p] [%F]%M\(%L\) : %m%n</pattern>  
        </encoder>  
    </appender>  
  
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">  
        <encoder>  
            <pattern>${CONSOLE_LOG_PATTERN}</pattern>  
        </encoder>  
    </appender>  
  
    <root level="DEBUG">  
        <appender-ref ref="FILE" />  
        <appender-ref ref="STDOUT" />  
    </root>  
</configuration>
```