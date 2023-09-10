## **💡 Application Deployment & Build**

<br>

### **IDE Tool이 없는 환경**

- Windows
  - PS C:/{direction}> .\gradlew bootjar
- Git
  - Project Directory 이동
  - ./gradlew build
  - java -jar {project-name}.jar server-properties.active=""

<br>

프로젝트 빌드

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Build.png) 

<br>

어플리케이션 실행

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Build2.png) 

------

### **Profile을 이용한 DB 설정 정보 포함**

- application-{name}.yml 형식의 환경 별 파일 생성 후 DB별로 설정 정보 분리

<br>

### **서버 배포**

- PaaS
  - CF CLI 사용 - cf push acloudyspringtime -p target/{file-name}.jar
- IaaS
  - AWS Beanstalk, Container Registry, Code Deploy 등

<br>

### **IntelliJ <-> DB 연동**

- build.gradle

```yaml
implementation 'mysql:mysql-connector-java'
implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
```

- application.yml

```yaml
# MySQL 설정
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# DB Source URL
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/Schema?useSSL=false&useUnicode=true&serverTimezone=Asia/Seoul

#DB Username
spring.datasource.username=<username>

#DB Password
spring.datasource.password=<password>

#true 설정시 JPA 쿼리문 확인 가능
spring.jpa.show-sql=true

#DDL(Create, Alter, Drop) 정의시 DB의 고유 기능을 사용할 수 있다.
spring.jpa.hibernate.ddl-auto=update

# JPA의 구현체인 Hibernate가 동작하면서 발생한 SQL의 가독성을 높여준다.
spring.jpa.properties.hibernate.format_sql=true
```

<br>

Test Connecttion Succeeded

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Build3.png) 

<br>

Test DB,User 생성

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Build4.png) 

<br>

연동된 MySql testuser

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Build5.png) 

<br>

테이블 생성

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Build6.png)

<br>

Post 요청

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Build7.png) 

<br>

Member Table에 데이터 저장

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Build8.png)