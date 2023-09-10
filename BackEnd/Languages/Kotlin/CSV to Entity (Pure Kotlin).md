## CSV -> Entity -> DB

최근에 CSV 파일의 데이터를 MySQL DB에 연관관계를 설계 후 데이터를 ENtity로 변환해서 넣을일이 있어 작업한 내용을 기록합니다.

처음에 Spring Batch를 사용했다가 테이블이 생기는거랑 번거로워서 Pure Kotlin 으로 바꿔서 작성합니다.

CSV의 첫번째 행은 헤더니까 JPA Entity의 필드로 만들어주고 연관관계 설계를 해서 매핑도 해줬습니다.

CSV 파일이 8개인데 귀찮으니까 작성한것중 1개만 적도록 하겠습니다.

```kotlin
@Entity
data class Wine(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long,

    val type: String,
    val nameKorean: String,
    val nameEnglish: String,
    val alcohol: Float,
    val acidity: Long,
    val body: Long,
    val sweetness: Long,
    val tannin: Long,
    val servingTemperature: String,
    val score: Float,
    val price: Long,
    val style: String?,
    val grade: String?,
    val importer: String,
    val wineryNameKorean: String,
    val wineryNameEnglish: String,
    val regionNameKorean: String ,
    val regionNameEnglish: String,

    @OneToMany(mappedBy = "wine", cascade = [CascadeType.ALL])
    val aroma: MutableList<WineAroma> = mutableListOf(),

    @OneToMany(mappedBy = "wine", cascade = [CascadeType.ALL])
    val pairing: MutableList<WinePairing> = mutableListOf(),

    @OneToMany(mappedBy = "wine", cascade = [CascadeType.ALL])
    val grape: MutableList<WineGrape> = mutableListOf(),

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "winery_id")
    val winery: Winery,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "region_id")
    val region: Region
)
```

<br>

다음으로 CSV의 데이터를 담을 DTO와 Response로 내보낼 형식인 DTO를 작성해줍니다.

```kotlin
class WineDTO {

    data class CsvToEntity(
        val type: String,
        val nameKorean: String,
        val nameEnglish: String,
        val alcohol: Float,
        val acidity: Long,
        val body: Long,
        val sweetness: Long,
        val tannin: Long,
        val servingTemperature: String,
        val score: Float,
        val price: Long,
        val style: String?,
        val grade: String?,
        val importer: String,
        val wineryNameKorean: String,
        val wineryNameEnglish: String,
        val regionNameKorean: String ,
        val regionNameEnglish: String,
    )

    data class SingleResponse(
        val id: Long,
        val type: String,
        val nameKorean: String,
        val nameEnglish: String,
        val alcohol: Float,
        val acidity: Long,
        val body: Long,
        val sweetness: Long,
        val tannin: Long,
        val score: Float,
        val price: Long,
        val style: String?,
        val grade: String?,
        val importer: String,
        val wineryName: List<String>,
        val wineryRegion: List<String>,
        val regionName: List<String>,
        val parentRegionName: List<String>,

        val aroma: List<String>,
        val pairing: List<String>,
        val grape: List<String>
    ) {
        object ModelMapper {
            fun entityToDto(form: Wine): SingleResponse {

                return SingleResponse(
                    id = form.id,
                    type = form.type,
                    nameKorean = form.nameKorean,
                    nameEnglish = form.nameEnglish,
                    alcohol = form.alcohol,
                    acidity = form.acidity,
                    body = form.body,
                    sweetness = form.sweetness,
                    tannin = form.tannin,
                    score = form.score,
                    price = form.price,
                    style = form.style,
                    grade = form.grade,
                    importer = form.importer,
                    wineryName = mutableListOf<String>().apply {
                        add(form.winery.nameKorean)
                        add(form.winery.nameEnglish) },
                    wineryRegion = mutableListOf<String>().apply {
                        add(form.winery.region.nameKorean)
                        add(form.winery.region.nameEnglish) },
                    regionName = mutableListOf<String>().apply {
                        add(form.region.nameKorean)
                        add(form.region.nameEnglish) },
                    parentRegionName = mutableListOf<String>().apply {
                        add(form.region.parentNameKorean.toString())
                        add(form.region.parentNameEnglish.toString()) },
                    aroma = form.aroma.map { i -> i.aroma },
                    pairing = form.pairing.map { i -> i.pairing },
                    grape = form.grape.map { i -> i.grape.nameKorean }
                )
            }
        }
    }

    data class MultiResponse(
        val id: Long,
        val type: String,
        val wineName: List<String>,
        val parentRegion: List<String>
    ) {
        object ModelMapper {
            fun entityToDto(form: Wine): MultiResponse {
                return MultiResponse(
                    id = form.id,
                    type = form.type,
                    wineName = mutableListOf<String>().apply {
                        add(form.nameKorean)
                        add(form.nameEnglish) },
                    parentRegion = mutableListOf<String>().apply {
                        add(form.region.parentNameKorean.toString())
                        add(form.region.parentNameEnglish.toString())
                    }
                )
            }
        }
    }
}
```

<br>

그리고 Service에서 readCsv() 함수를 작성합니다. 자세한 코드는 적지 않을 것이고 형식만 대충 만들어둡니다.
.map 부분에 필드가 3개 밖에 

```kotlin
@Component
class CsvParser(
    @Autowired private val wineRepository: WineRepository
) {

    @PostConstruct
    fun initData() {
        val resource = FileSystemResource("data/wine.csv")
        val wineList: List<Wine> = Files.readAllLines(resource.file.toPath(), StandardCharsets.UTF_8)
            .map { line ->
                val split = line.split(",")

                val alcohol = try {
                    val value = split[3].toDoubleOrNull()
                    if (value != null) {
                        String.format("%.1f", value).toDouble()
                    } else {
                        0.0
                    }
                } catch (e: NumberFormatException) {
                    // 유효하지 않은 값일 경우 대체값 설정
                    0.0
                }

                val score = try {
                    val value = split[9].toDoubleOrNull()
                    if (value != null) {
                        String.format("%.1f", value).toDouble()
                    } else {
                        0.0
                    }
                } catch (e: NumberFormatException) {
                    // 유효하지 않은 값일 경우 대체값 설정
                    0.0
                }

                Wine(
                    id = null,
                    type = split[0],
                    nameKorean = split[1],
                    nameEnglish = split[2],
                    alcohol = alcohol,
                    acidity = split[4].toLong(),
                    body = split[5].toLong(),
                    sweetness = split[6].toLong(),
                    tannin = split[7].toLong(),
                    servingTemperature = split[8],
                    score = score,
                    price = split[10].toLong(),
                    style = split.getOrNull(11) ?: "",
                    grade = split.getOrNull(12) ?: "",
                    importer = split[13],
                    wineryNameKorean = split[14],
                    wineryNameEnglish = split[15],
                    regionNameKorean = split[16],
                    regionNameEnglish = split[17],
                    region = null,
                    winery = null,
                )
            }
        wineRepository.saveAll(wineList)
    }
}
```

