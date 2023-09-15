## **💡 JPA Memo**

<br>

###  **Class**

| **EntityManager**                           | 영속성 컨텍스트 관리                                         |
| ------------------------------------------- | ------------------------------------------------------------ |
| **EntityManagerFactory**                    | Spring으로 EntityManager 객체에 DI 주입                      |
| **CommandLineRunner**                       | Application 런타임 시 초기화 작업 추가                       |
| **LocalDateTime**                           | 컬럼의 TIMESTAMP 타입과 매핑, @Temporal 생략                 |
| **TransactionManager**                      | 어플리케이션에 트랜잭션 적용, DI주입식 사용 (AOP 방식)       |
| **TransactionInterceptor**                  | 트랜잭션 어드바이스용 트랜잭션 경계 설정 클래스              |
| **RuleBasedTransaction Attribute**          | 트랜잭션 Attribute 설정 클래스                               |
| **Advisor**                                 | Advisor 객체 생성 후, DefaultPointcutAdvisor의 생성자 파라미터로 포인트컷, 어드바이스 전달 |
| **AspectJExpression PointCut**              | TransactionInterceptor를 타겟 클래스에 적용하기 위한 포인트컷 지정 클래스 객체 생성 후, 포인트컷 표현식으로 타겟 클래스 지정 |
| **DataSource**                              | 데이터 소스 생성 클래스                                      |
| **MysqlXADataSource**                       | DB 접속 정보 설정 클래스, setURL(""), setUser("DB_user"), setPassword("DB_PW") [setURL] "jdbc:mysql://localhost:port/DB_name" "?allowPublicKeyRetrieval=true" "&characterEncoding=UTF-8" |
| **AtomikosDataSourceBean**                  | setXaDataSoutce(), setUniqueResourceName("")                 |
| **LocalContainerEntity ManagerFactoryBean** | JPA의 EntityManager를 얻기 위한 클래스  setDataSource(data_source_method) setPackagesToScan(new String[] {"", ""}) setJpaVendorAdapter() setPersistenceUnitName("") setJpaPropertyMap() |
| **HibernateJpaVendor Adapter**              | LocalContainerEntityManagerFactoryBean에서 사용하는 어댑터 중 내가 사용할 HibernateJpaVendorAdapter를 설정  setDatabases(Database.MYSQL)  Hibernate에서 필요한 설정정보를 Map으로 설정 MapName.properties.put() |
| **UserTranscationManager**                  | 어플리케이션이 트랜잭션 경계에서 관리되는것을 명시적으로 정의 AtomikosJtpPlatform의 트랜잭션 매니저로 설정 |
| **JtaTransactionManager**                   | 생성자로 userTransaction 빈, atomikosTransactionManager 빈을 넘겨주면 atomikos의 분산 트랜잭션 사용 가능 |
| **AtomikosJtaPlatform**                     | AbstractJtaPlatform을 상속받은 후 트랜잭션 매니저의 위치와 UserTransaction의 위치를 지정 해주면 됨 |
| **ApplicationEventPublisher**               | ApplicationContext가 상속하는 인터페이스중 하나 옵저버 패턴의 구현체로 이벤트 프로그래밍에 필요한 기능 제공 |

------

### **Method**

| **createEntityManager()**  | EntityManager 클래스의 객체를 얻는다                         |
| -------------------------- | ------------------------------------------------------------ |
| **getTransaction()**       | 트랜잭션 객체 얻음, 이 객체를 기준으로 DB의 테이블에 데이터 저장 |
| **begin()**                | 트랜잭션 시작 메소드, 보통 시작메소드 이후 객체 생성 후 persist() 진행 |
| ***\*persist(Entity)\****  | 영속성 컨텍스트에 객체 정보 저장, 1차 캐시 등록 & SQL 저장소에 INSERT 쿼리 형태로 등록 |
| **commit()**               | 영속성 컨텍스트에 있는 객체를 DB의 테이블에 저장, SQL 저장소에 저장된 쿼리 삭제됨 |
| ***\*find(.class, 값)\**** | 영속성 컨텍스트 내 객체 조회 (DB에서 조회가 아님)            |