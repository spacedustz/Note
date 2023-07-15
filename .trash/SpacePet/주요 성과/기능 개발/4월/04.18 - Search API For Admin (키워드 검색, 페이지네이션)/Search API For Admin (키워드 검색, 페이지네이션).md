## 🧑🏻‍💻 Search API For Admin (키워드 검색, 페이지네이션)
---

## 💡 요구사항
<br>
### **조건**
- 유저 서비스안에 구현 할 것
- 유저 컨트롤러 안에 구현 할 것 (어드민만 접근 가능)
- 성능이슈를 생각해 볼 것 (검색 기능 - 검색 알고리즘 뿐만 아니라 SQL 성능 고려) - 심화
<br>
### **현재 어드민 컨트롤러의 유저 리스트 검색 기능은 전체 유저를 검색한다.**

- 이를 해결하기 위해 Paging 기능을 도입해 한 번에 30명의 유저를 검색가능하게 한다
  (단 파라미터를 이용해 1페이지, 2페이지등 검색이 가능해야 한다)
  정회원 / 부회원 / 준회원 순으로 검색 가능한 API를 구현한다
- 전체 유저를 불러오지 못해 생기는 검색 기능의 미비를 위해 새로운 검색 API를 구현한다 (GET)
  한 API에서 구현해야 하는 검색 조건은 다음과 같다 (AND 조건 및 OR 조건으로 구분할 것)
  **유저 이메일**
  **유저 동물 이름**
  **유저 이름**
  (위 조건은 추가 될 수 있다)
- 추가 필터링을 위해 파라미터가 아닌 body로 받는 것을 고려하는 API를 구축한다 (POST API)
  페이징을 구현하여 검색할 것

---

### AdminController

```kotlin
/**   
 * @author 신건우  
 * @param data : 검색 조건으로 받을 데이터  
 * @desc 회원 리스트 조회 (페이지네이션 적용)   
 */  
@GetMapping("/search")  
fun getAllUserByKeyword(  
    @RequestBody data: SearchDTO  
): ResponseEntity<List<UserSearchDTO>> {  
    return ResponseEntity(userService.getAllUserByKeyword(data), HttpStatus.OK)  
}
```

---

### UserSearchDTO

```kotlin
/**  
 * @author 신건우  
 */  
@JsonInclude(JsonInclude.Include.NON_NULL)  
data class UserSearchDTO(  
  
    /** @desc 키워드 검색 조건 */    var keyword: String = "",  
    var and: Boolean? = null,  
  
    /** @desc 반려동물 정보 */    var animalName: String? = "",  
    var animal: String? = "",  
    var breed: String? = "",  
  
    /** @desc 유저 정보 */    var userName: String? = "",  
    var userAgeRange: String? = "",  
    var userGender: String? = "",  
    var userLocation: String? = "",  
  
    var userCreatedAt: LocalDateTime? = null,  
    var userProfileAt: LocalDateTime? = null,  
    var userRefreshedAt: LocalDateTime? = null,  
    var email: String? = "",  
) {  
    object ModelMapper {  
        fun entityToDto(form: User): UserSearchDTO {  
  
            var animalName = ""  
            var animal = ""  
            var breed = ""  
  
            var location = form.geometry.toString()  
  
            if (form.animals.size != 0) {  
                animalName = form.animals[0].name  
                animal = form.animals[0].animal  
                breed = form.animals[0].breed  
            }  
            return UserSearchDTO(  
                animalName = animalName,  
                animal = animal,  
                breed = breed,  
  
                userName = form.name,  
                userAgeRange = form.ageRange,  
                userGender = form.gender,  
                userLocation = location,  
                userCreatedAt = form.userDate?.createdAt,  
                userProfileAt = form.userDate?.profileAt,  
                userRefreshedAt = form.userToken?.tokenCreatedAt,  
                email = form.email,  
            )  
        }  
    }  
}  

/** @desc No Usage */
@JsonInclude(JsonInclude.Include.NON_NULL)  
data class UserSearchDetailDTO(  
  
    /** 키워드 검색 조건 */    var keyword: String? = "",  
    var and: Boolean? = null,  
  
    /** @desc 반려동물 정보 */    var animalName: String? = "",  
    var breed: String? = "",  
    var animalAge: String? = "",  
    var animal: String? = "",  
    var animalNeutralization: Boolean? = null,  
  
    var animalImages: List<String>? = listOf(),  
  
    /** 유저 정보 */    var userName: String? = "",  
    var userAgeRange: String? = "",  
    var trustPoint: Int? = 0,  
    var give: Int? = 0,  
    var take: Int? = 0,  
    var userCreatedAt: LocalDateTime? = null,  
    var userProfileAt: LocalDateTime? = null,  
    var userRefreshedAt: LocalDateTime? = null,  
    var userProfile: String? = "",  
    var grade: String? = "",  
    var sido: String? = "",  
    var sigungu: String? = "",  
    var dong: String? = "",  
    var userLocation: String? = ""  
) {  
    companion object {  
        fun fromEntity(form: User): UserSearchDetailDTO {  
  
            var animalName = ""  
            var breed = ""  
            var animalAge = ""  
            var animal = ""  
            var animalNeutralization: Boolean? = null  
  
            val location = form.geometry.toString()  
  
            if (form.animals.size != 0) {  
                animalName = form.animals[0].name  
                breed = form.animals[0].breed  
                animalAge = form.animals[0].getAge()  
                animal = form.animals[0].animal  
                animalNeutralization = form.animals[0].neutralization  
            }  
  
            return UserSearchDetailDTO(  
                animalName = animalName,  
                breed = breed,  
                animalAge = animalAge,  
                animal = animal,  
                animalNeutralization = animalNeutralization,  
                animalImages = form.userDetail?.animalImages,  
  
                userName = form.name,  
                userAgeRange = form.ageRange,  
                trustPoint = form.trustPoint,  
                give = form.give,  
                take = form.take,  
                userCreatedAt = form.userDate?.createdAt,  
                userProfileAt = form.userDate?.profileAt,  
                userRefreshedAt = form.userToken?.tokenCreatedAt,  
                userProfile = form.userProfile,  
                grade = form.grade,  
                sido = form.geometry?.sido,  
                sigungu = form.geometry?.sigungu,  
                dong = form.geometry?.dong,  
                userLocation = location  
            )  
        }  
    }  
}  
  
data class SearchDTO(  
    var userName: String? = "",  
    var email: String? = "",  
    var animalName: String? = "",  
    var and: Boolean? = null  
)
```

---

### UserService

```kotlin
/**   
* @author 신건우  
 * @param data : 조건 검색 데이터  
 * @desc 유저 키워드 검색   
*/  
fun getAllUserByKeyword(data: SearchDTO): List<UserSearchDTO> {  
  
    val users = try {  
        userRepository.findUserByKeyword(data.email, data.userName, data.animalName, data.and)  
    } catch (e: Exception) {  
        log.error("유저 정보 검색 실패 - [ ${data.email}, ${data.userName}, ${data.animalName}, ${data.and} - $e ]")  
        throw CommonException("유저 정보 검색 실패", HttpStatus.BAD_REQUEST)  
    }  
  
    log.info("유저 검색 완료 - [ 결과 유저 수 : ${users!!.size} ]")  
  
    return users.stream().map { UserSearchDTO.ModelMapper.entityToDto(it) }.toList()  
}
```

---

### CustomUserRepository

```kotlin
fun findUserByKeyword(email: String?, userName: String?, animalName: String?, and: Boolean?): MutableList<User>?
```

---

### CustomUserRepositoryImpl

```kotlin
/**  
 * @author 신건우  
 * @desc 유저 전체 조회(필터링) 키워드 검색  
 * @fun findUserByKeyword & searchCondition  
 */override fun findUserByKeyword(  
    email: String?,  
    userName: String?,  
    animalName: String?,  
    and: Boolean?  
): MutableList<User>? {  
  
    val paging = PageRequest.of(0, 30)  
  
    val builder = searchCondition(email, userName, animalName, and)  
  
    return queryFactory  
        .selectFrom(user)  
        .where(builder)  
        .orderBy(user.userToken.tokenCreatedAt.desc())  
        .offset(paging.offset).limit(30.toLong())  
        .fetch()  
}  
  
/**  
 * @author 신건우  
 * @desc 조건 검색 내부 함수  
 */  
fun searchCondition(  
    email: String?,  
    userName: String?,  
    animalName: String?,  
    and: Boolean?,  
): BooleanBuilder {  
  
    val builder = BooleanBuilder()  
  
    fun eqUserName(userName: String?): BooleanExpression? {  
        return if (userName.isNullOrEmpty()) null else user.name.contains(userName)  
    }  
  
    fun eqAnimalName(animalName: String?): BooleanExpression? {  
        return if (animalName.isNullOrEmpty()) null else user.animals.any().name.contains(animalName)  
    }  
  
    fun eqEmail(email: String?): BooleanExpression? {  
        return if (email.isNullOrEmpty()) null else user.email.contains(email)  
    }  
  
    if (and!!) builder.and(eqEmail(email)) else builder.or(eqEmail(email))  
  
    if (and!!) builder.and(eqUserName(userName)) else builder.or(eqUserName(userName))  
  
    if (and!!) builder.and(eqAnimalName(animalName)) else builder.or(eqAnimalName(animalName))  
  
    return builder  
}
```

---

### 완료

![image-20230420110603892](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/searchAPI_done.png)
