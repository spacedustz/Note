## Entity 설계

와인, 와인향, 와인과 어룰리는 음식, 포도주, 양조장, 포도, 포도_share, 지역

---

## 요구사항

* [data](data) 폴더의 파일을 참고하여 entity 설계
* 해당 데이터들을 삽입, 수정, 삭제, 조회할 수 있는 API 구현
* 조회 기능은 다음을 포함

    * 와인 조회 (완료)
        * 필터링: 와인 종류, 알코올 도수 범위, 와인의 가격 범위, 와인의 스타일, 와인의 등급, 지역
        * 정렬: 와인 이름, 알코올 도수, 산도, 바디감, 단맛, 타닌, 와인의 점수, 와인의 가격
        * 검색: 와인 이름

    * 와이너리 조회 (완료)
        * 필터링: 지역
        * 정렬: 와이너리 이름
        * 검색: 와이너리 이름

    * 포도 품종 조회 (완료)
        * 필터링: 지역
        * 정렬: 포도 품종 이름, 산도, 바디감, 단맛, 타닌
        * 검색: 포도 품종 이름

    * 지역 조회 (완료)
        * 필터링: 상위 지역
        * 정렬: 지역 이름
        * 검색: 지역 이름

    * 수입사 조회 (완료)
        * 정렬: 수입사 이름
        * 검색: 수입사 이름

* 조회 기능은 다음 정보를 제공

    * 와인 조회 (단일, 다수 완료)
        * 다수 조회 시: 와인의 종류, 와인 이름, 최상위 지역 이름
        * 단일 조회 시: 와인의 종류, 와인 이름, 알코올 도수, 산도, 바디감, 단맛, 타닌, 와인의 점수, 와인의 가격, 와인의 스타일, 와인의 등급, 수입사 이름, 와이너리 이름, 와이너리
          지역, 지역 이름 및 모든 상위 지역 이름, 와인의 향, 와인과 어울리는 음식, 포도 품종

    * 와이너리 조회 (단일, 다수 완료)
        * 다수 조회 시: 와이너리 이름, 지역 이름
        * 단일 조회 시: 와이너리 이름, 지역 이름, 와이너리의 와인

    * 포도 품종 조회 (단일, 다수 완료)
        * 다수 조회 시: 포도 품종 이름, 지역 이름
        * 단일 조회 시: 포도 품종 이름, 산도, 바디감, 단맛, 타닌, 지역 이름, 포도 품종의 와인

    * 지역 조회 (단일, 다수 완료)
        * 다수 조회 시: 지역 이름
        * 단일 조회 시: 지역 이름, 모든 상위 지역 이름, 포도 품종, 와이너리 이름, 와인 이름

    * 수입사 조회 (단일, 다수 완료)
        * 다수 조회 시: 수입사 이름
        * 단일 조회 시: 수입사 이름, 수입사의 와인

## Data description

### Wine

#### wine.csv

* `type`: 와인의 종류
* `name_korean`: 와인 이름(한글)
* `name_english`: 와인 이름(영어)
* `alcohol`: 알코올 도수
* `acidity`: 산도
* `body`: 바디감
* `sweetness`: 단맛
* `tannin`: 타닌
* `serving_temperature`: 권장섭취온도
* `score`: 와인의 점수
* `price`: 와인의 가격
* `style`: 와인의 스타일
* `grade`: 와인의 등급
* `importer`: 수입사
* `winery_name_korean`: 와이너리 이름(한글)
* `winery_name_english`: 와이너리 이름(영어)
* `region_name_korean`: 지역 이름(한글)
* `region_name_english`: 지역 이름(영어)

#### wine_aroma.csv

* `name_korean`: 와인 이름(한글)
* `name_english`: 와인 이름(영어)
* `aroma`: 와인의 향

#### wine_pairing.csv

* `name_korean`: 와인 이름(한글)
* `name_english`: 와인 이름(영어)
* `pairing`: 와인과 어울리는 음식

#### wine_grape.csv

* `name_korean`: 와인 이름(한글)
* `name_english`: 와인 이름(영어)
* `grape_name_korean`: 포도 품종(한글)
* `grape_name_english`: 포도 품종(영어)

### Winery

#### winery.csv

* `name_korean`: 와이너리 이름(한글)
* `name_english`: 와이너리 이름(영어)
* `region_name_korean`: 지역 이름(한글)
* `region_name_english`: 지역 이름(영어)

### Grape

#### grape.csv

* `name_korean`: 포도 품종(한글)
* `name_english`: 포도 품종(영어)
* `acidity`: 산도
* `body`: 바디감
* `sweetness`: 단맛
* `tannin`: 타닌

#### grape_share.csv

* `name_korean`: 포도 품종(한글)
* `name_english`: 포도 품종(영어)
* `share`: 포도 품종의 비율
* `region_name_korean`: 지역 이름(한글)
* `region_name_english`: 지역 이름(영어)

### Region

#### region.csv

* `name_korean`: 지역 이름(한글)
* `name_english`: 지역 이름(영어)
* `parent_name_korean`: 상위 지역 이름(한글)
* `parent_name_english`: 상위 지역 이름(영어)

---

### 엔티티 작성

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
    val servingTemperature: String?,
    val score: Float,
    val price: Long,
    val style: String?,
    val grade: String?,
    val importer: String?,
    val wineryNameKorean: String,
    val wineryNameEnglish: String,
    val regionNameKorean: String,
    val regionNameEnglish: String,
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "winery_id")
    val winery: Winery,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "region_id")
    val region: Region
)

@Entity
data class WineAroma(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long,

    @Column(name = "name_korean")
    val nameKorean: String,

    @Column(name = "name_english")
    val nameEnglish: String,

    val aroma: String,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "wine_id")
    val wine: Wine
)

@Entity
data class WinePairing(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long,

    val nameKorean: String,
    val nameEnglish: String,
    val pairing: String,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "wine_id")
    val wine: Wine
)

@Entity
data class WineGrape(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long,

    val nameKorean: String,
    val nameEnglish: String,
    val grapeNameKorean: String,
    val grapeNameEnglish: String,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "wine_id")
    val wine: Wine,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "grape_id")
    val grape: Grape
)

@Entity
data class Winery(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long,

    val nameKorean: String,
    val nameEnglish: String,
    val regionNameKorean: String,
    val regionNameEnglish: String,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "region_id")
    val region: Region
)

@Entity
data class Grape(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long,

    val nameKorean: String,
    val nameEnglish: String,
    val acidity: Long,
    val body: Long,
    val sweetness: Long,
    val tannin: Long
)

@Entity
data class GrapeShare(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long,

    val nameKorean: String,
    val nameEnglish: String,
    val share: Float,
    val regionNameKorean: String,
    val regionNameEnglish: String,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "grape_id")
    val grape: Grape,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "region_id")
    val region: Region
)

@Entity
data class Region(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long,

    @Column(name = "name_korean", unique = true)
    val nameKorean: String,

    @Column(name = "name_english", unique = true)
    val nameEnglish: String,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_name_korean", referencedColumnName = "name_korean", foreignKey = ForeignKey(name = "fk_parent_korean"))
    val parentNameKorean: Region? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_name_english", referencedColumnName = "name_english", foreignKey = ForeignKey(name = "fk_parent_english"))
    val parentNameEnglish: Region? = null
)
```

---

## 연관관계

Wine
- N:1 to Winery
- N:1 to Region

WineAroma
- N:1 to Wine

WineGrape
- N:1 to Wine
- N:1 to Grape

WinePairing
- N:1 to Wine

Winery
- N:1 to Region

Grape
- None

GrapeShare
- N:1 to Grape
- N:1 to Region

Region
- N:1 to Self

