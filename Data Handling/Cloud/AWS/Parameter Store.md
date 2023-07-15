## 💡 AWS Parameter Store

디스코드 봇 토큰을 AWS Parameter Store를 이용해서 Spring Boot로 값을 가져온다.

<br>

### Dependency 설정

```yaml
ext {
    set('springCloudVersion', "Hoxton.SR6")
}

implementation 'org.springframework.cloud:spring-cloud-starter-aws-parameter-store
```

<br>

### src/main/resources 아래에 bootstrap.yml 파일 생성

**prefix**

- 파라미터의 접두사를 지정할 수 있다. 주의해야할 점은 해당값은 /로 시작해야한다.
- default : /config

**name**

- 파라미터의 식별자 애플리케이션이름이다. 해당 파라미터를 어떤 애플리케이션에 적용할건지를 지정할 수 있다.
- 만일 해당값을 지정하지 않으면 spring.application.name 속성에 정의된 값을 참조하게 된다.
- 해당 속성마저도 없으면 'application' 이라는 이름이 부여된다.
- default : application

**profile-separator**

- 하나의 애플리케이션을 여러환경에 배포할 수 있게끔 구분자를 지정해두는데 이 속성은 위 name과 같이 쓰인다.
- 데이터베이스 엔드포인트 값을 예로들면 /config/kimjonghyun_local/jdbc.url, /config/kimjonghyun_production/jdbc.url 이렇게 구성된다.
- default : _

**profile**

- spring.config.activate.on-profile에 정의된 값이다.

**enabled**

- AwsParamStoreBootstrapConfiguration를 활성화 한다.
- default : true

```yaml
# enabled - 파라미터 스토어 설정 ON
# prifix - 파라미터 스토어의 Key 값 가장 첫번째 구분용
# name - Key의 두분째 구분용, 바로 하단의 profileSeparator와 함께 사용가능
# profileSeparator - name과 할께 사용될 prifile 식별자
# failFast - 기본값 True, 스토어에서 값을 못 읽었을때 할 행동 지정, true면 어플 실행을 못하게함

aws:
 paramstore:
   enabled: true
   prefix: /discord 
   name: token
   profileSeparator: _
```

<br>

### IAM User

- IAM User를 만든다.
- SSM FullAccess, SSM ReadOnly Access 권한을 추가한다.
- IAM User의 AccessKey를 받는다.