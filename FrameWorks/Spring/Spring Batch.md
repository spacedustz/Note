## Spring Batch
Spring Batch를 사용하게 된 계기는 회사의 csv 파일 내부의 데이터를 DB로 이전하기 위해 알아보게 되었습니다.

배치(Batch)는 일괄처리 란 뜻을 가지고 있습니다.

만약 대용량의 파일을 DB에 저장하는 기능이 필요하다고 가정해보죠. 

<br>

이렇게 큰 데이터를 읽고, 가공하고, 저장한다면 해당 서버는 순식간에 CPU, I/O 등의 자원을 다써버릴 것입니다.

그리고 이 집계 기능은 하루에 1번 수행되고,이를 위해 API를 구성하는 것은 너무 낭비입니다.

바로 이런 단발성으로 대용량의 데이터를 처리하는 애플리케이션을 배치 애플리케이션이라고 합니다.

스프링에서는 Spring Batch를 통해 배치 애플리케이션을 사용할 수 있습니다.

<br>

**Spring Batch 5.0 변경사항**
- StepBuilderFactory, JobBuilderFactory가 Deprecated 되었으며 JobRepository를 명시적으로 사용하도록 권장한다.
- TransactionManager 또한 명시적으로 사용하도록 권장한다.
- @EnableBatchProcessing을 더이상 사용하지 않아도 된다. (혹은 않아야 한다.)

<br>

**Spring Batch 필요한 설정**
1) ItemReader : 데이터 읽기
2) ItemWriter : 데이터 쓰기
3) ItemProcessor : 데이터 가공
4) Step : Job을 실행하기 위한 작업 모음
5) Job : 작업

<br>

**Reader & Writer**
Step은 CsvReader와 CsvWriter를 가지고 있습니다.
csv 파일을 읽어오는 행위를 CsvReader에서 실행할 것이고 읽어온 데이터를 DB에 저장하는 행위를 CsvWriter에서 실행할 것이라고 예상할 수 있다.

---

## Spring Batch 설정 & 기본 사용법

**build.gradle**

```yaml
    implementation("org.springframework.boot:spring-boot-starter-batch")
```

<br>

**application.yml**

- `spring.batch.job.name: WineJob` : BatchConfig에서 Job의 Name 설정
- `spring.batch.jdbc.initialize-schema: always` : Spring Batch 실행 시 DB 내부에 테이블 자동 생성

```yaml
spring:
  # Spring Batch Job
  batch:
    job:
      name: WineJob
    jdbc:
      initialize-schema: always
```

---

## 응용: Wine.csv -> MySQL DB 이동에 대한 Batch Job 설정

### ItemReaderConfig
Reader와 Writer를 이용해 .csv 파일을 파싱하여 DB에 넣습니다.

```kotlin
@Configuration
class ItemReaderConfig(
    private val jobRepository: JobRepository,
    private val transactionManager: PlatformTransactionManager,
    private val csvReader: ItemReader,
    private val csvWriter: ItemWriter,
//    private val dataSource: DataSourceConfig
) {

    /* Wine Reader */
    private val chunkSize = 1000

    @Bean
    fun wineJob(): Job {
        return JobBuilder("WineJob", jobRepository)
            .incrementer(RunIdIncrementer())
            .start(wineStep())
            .build()
    }

    @Bean
    fun wineStep(): Step {
        return StepBuilder("WineStep", jobRepository)
            .chunk<Wine, Wine>(chunkSize)
            .reader(csvReader.csvReader())
            .writer(csvWriter)
            .transactionManager(transactionManager)
            .build()
    }

    companion object {
        private val log: Logger = LogManager.getLogger(this::class.java.name)
    }
}
```

<br>

### ItemReader
데이터를 가져오는 역할입니다.

reader.setResource 부분에서 ClassPathResource, FileSystemResource, UrlResource 3가지의 경로표현을 사용할 수 있습니다.

1) 프로젝트 클래스 경로: src/main/resources(ClasspathResource)

2) 로컬 디렉토리: D://mydata(FileSystemResource)

3) 원격 위치: https://xyz.com/files/… (UrlResource)

저는 FileSystemResource()를 사용했습니다.

```kotlin
@Configuration
@Configuration
class ItemReader {

    @Bean
    fun csvReader(): FlatFileItemReader<Wine> {

        /* Read File */
        val reader: FlatFileItemReader<Wine> = FlatFileItemReader()
        reader.setResource(FileSystemResource("data/wine.csv")) // csv 파일 경로 지정
        reader.setLinesToSkip(1) // Skip Header Line
        reader.setEncoding("UTF-8")

        /* 읽어들이는 데이터를 내부적으로 Line Mapper를 통해 Mapping */
        val mapper: DefaultLineMapper<Wine> = DefaultLineMapper<Wine>()

        /* setNames()를 통해 각각의 데이터 이름 설정 */
        val tokenizer: DelimitedLineTokenizer = DelimitedLineTokenizer(",") // csv 파일의 구분자 지정
        tokenizer.setQuoteCharacter('"')

        /* 엔티티 필드의 이름과 동일하게 설정하고 필드 <-> 컬럼 자동 매핑 */
        val entityClass = Wine::class.java // JPA 엔티티 클래스
        val fieldNames = entityClass.declaredFields.map { it.name }.toTypedArray() // 필드명 배열로 추출
        tokenizer.setNames(*fieldNames) // 배열 요소를 가변 인자로 전달하여 필드명 설정

        /* 엔티티 필드의 이름과 동일하게 설정하고 필드 <-> 컬럼 수동 매핑 */
        tokenizer.setNames(
            "id", "type", "nameKorean", "nameEnglish", "alcohol",
            "acidity", "body", "tannin", "servingTemperature", "score",
            "price", "style", "grade", "importer", "wineryNameKorean",
            "wineryNameEnglish", "regionNameKorean", "regionNameEnglish")
        mapper.setLineTokenizer(tokenizer)

        /* Tokenizer에서 가지고온 데이터들을 VO로 바인딩 */
        val fieldSetMapper: BeanWrapperFieldSetMapper<Wine> = BeanWrapperFieldSetMapper()
        fieldSetMapper.setTargetType(Wine::class.java)
        fieldSetMapper.setStrict(false) // 엄격하지 않은(strict) 모드 설정

        /* 익명 클래스를 상속해서 .csv 컬럼에 Null이 들어올 경우 null로 매핑 */
        mapper.setFieldSetMapper(object : BeanWrapperFieldSetMapper<Wine>() {
            init {
                setTargetType(Wine::class.java)
            }

            override fun mapFieldSet(fieldSet: FieldSet): Wine {
                val wine = super.mapFieldSet(fieldSet)

                // JPA 엔티티의 모든 필드에 대해 자동으로 null 처리 수행
                val targetType = Wine::class.java
                val fieldNames = targetType.declaredFields.map { it.name }

                for (fieldName in fieldNames) {
                    val fieldValue = fieldSet.readRawString(fieldName)
                    if (fieldValue.isNullOrEmpty()) {
                        val field = targetType.getDeclaredField(fieldName)
                        field.isAccessible = true
                        field.set(wine, null)
                    }
                }

                return wine
            }
        })

        /* Line Mapper 지정 */
        reader.setLineMapper(mapper)

        return reader
    }
}
```

<br>

### ItemWriter
데이터를 쓰는 역할입니다.

```kotlin
@Configuration
@Configuration
class ItemWriter(
    private val wineRepository: WineRepository
) : ItemWriter<Wine> {

    override fun write(chunk: Chunk<out Wine>) {
        chunk.forEach { wine -> wineRepository.save(wine) }
    }
}
```
