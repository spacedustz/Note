## Common 검증 로직

Get은 2번쨰 if 문 전체를 뺴야하고

Patch API는 이 코드를 전체 다써야함 

```kotlin
    /* 유저 & 보드 검증 */
    fun validateUserAndBoard(user: User, board: Board) {

        if (user.grade != "정회원") {
            throw CommonException("${board.kind}-005 - 회원 등급 오류", HttpStatus.FORBIDDEN)
        }

        // Patch API 에서 씀
        if (board.kind != "${board.kind}") {
            log.error("${board.kind}-004 : ${board.kind} 게시글이 아닙니다 - ${board.kind}")
            throw CommonException("${board.kind}-004", HttpStatus.BAD_REQUEST)
        } else if (user.id != board.user.id) {
            log.error("${board.kind}-004 : 작성자가 아닙니다")
            throw CommonException("${board.kind}-011", HttpStatus.BAD_REQUEST)
        }
    }
```

<br>

## CommunityDTO

```kotlin
class CommunityDTO {

    data class User (
        var uid : String?,

        var userName : String?,
        var userAgeRange : String?,
        var userGender : String?,

        var animalName : String?,
        var animal : String?,
        var animalProfile : String?,
        var animalGender : String?,
        var animalNeutralization : Boolean?,
        var animalSize : String?,

        var give : Int?,
        var take : Int?,

        var location : LocationResDTO?,
        var trustPoint : Int?
            ) {

        companion object {
            fun fromEntity(user : com.cosmic.dangnyang.entity.User) : User {
                return User(
                        uid = user.id,
                        userName = user.name,
                        userGender = user.gender,
                        userAgeRange = user.ageRange,

                        animalName = user.animals[0].name,
                        animal = user.animals[0].animal,
                        animalProfile = user.animals[0].profile,
                        animalGender = user.animals[0].gender,
                        animalNeutralization = user.animals[0].neutralization,
                        animalSize = user.animals[0].size,

                        give = user.give,
                        take = user.take,

                        location = user.geometry?.let { LocationResDTO.ModelMapper.entityToDto(it) },
                        trustPoint = user.trustPoint
                )
            }
        }
    }

    data class CommunityDetail (
        var id : String? = null,
        var modified : Boolean? = null,
        var content : String? = null,
        var images : List<String>? = null,
        var liked : Boolean? = null,
        var likes : Int? = null,
        var views : Int? = null,
        var pushNotification : Boolean? = null,
        var comments : List<CommentDTO> = listOf(),
        var createdAt : LocalDateTime? = null,
    ) {
        companion object {
            fun fromEntity(board : Board, uid : String) : CommunityDetail {
                return CommunityDetail.run {
                    CommunityDetail(
                        id = board.id.toString(),
                        modified = (board.modifiedAt != null),
                        content = board.requestContent,
                        images = board.pics,
                        liked = board.boardAlreadyLike(uid),
                        likes = board.likes.size,
                        views = board.view,
                        pushNotification = board.pushUsers.contains(uid),
                        comments = board.comments.filter { it.activateComment() }.map { CommentDTO.ModelMapper.entityToDto(it) }.toList(),
                        createdAt = board.createdAt,
                    )
                }
            }
        }
    }

    /** @desc 투데이펫 Detail */
    class LifeDetail(
            var kind : String,
            var detail : CommunityDetail
    ) {
        companion object {
            fun fromEntity(board : Board, uid : String) : LifeDetail {
                return LifeDetail(
                        kind = "일상",
                        detail = CommunityDetail.fromEntity(board, uid)
                )
            }
        }
    }

    data class Like(
            var liked : Boolean? = false,
            var likes : Int? = 0
    ) {
        companion object {
            fun fromEntity(board : Board, uid : String) : Like {
                return Like(
                        liked = board.boardAlreadyLike(uid),
                        likes = board.likes.size,
                )
            }
        }
    }

    /** @desc 돌봄 SOS DTO */
    data class CareTake(
        var takeStartDate: LocalDateTime? = null,
        var takeEndDate: LocalDateTime? = null,
        var reword: String? = "",
        var neighborAnimal: String? = "",
        var neighborGender: String? = "",
        var preMeeting: Boolean? = null,
        var giveTake : Boolean? = null,
    ) {
        companion object {
            fun fromEntity(form: Board): CareTake {
                return CareTake(
                    takeStartDate = form.requestedAt,
                    takeEndDate = form.requestedAt02,
                    reword = form.reword,
                    neighborAnimal = form.requestAnimalUser,
                    neighborGender = form.requestGender,
                    preMeeting = form.preMeeting,
                    giveTake = form.giveTake
                )
            }
        }
    }

    /** @desc 품앗이 DTO */
    data class CareGive(
        var timeHelp: MutableList<String>? = mutableListOf(),
        var requestHelpTime: String? = "",
        var animalKind: String? = "",
        var animalSize: String?= "",
        var preMeeting: Boolean? = null,
        var neutralization: Boolean?,
    ) {
        companion object {
            fun fromEntity(form: Board): CareGive {
                return CareGive(
                    timeHelp = form.timeHelp,
                    requestHelpTime = form.requestSecondContent,
                    animalKind = form.requestAnimalUser,
                    animalSize = form.animalSize,
                    preMeeting = form.preMeeting,
                    neutralization = form.animalNetralization
                )
            }
        }
    }
}
```

<br>

## NcpS3UploaderRecycleFn

```kotlin
/** @desc 이미지 Recycle Function */

@Component
class NcpS3UploaderRecycleFn(
    @Autowired private val ncpS3Uploader: NcpS3Uploader,
    @Autowired private val apiService: ApiService
) {

    /**
     * @param aBoard : 게시글
     * @param multipartFile : 이미지 파일
     * @param boardKindKor : Web Hook 전송을 위한 게시판의 **한글명**
     * @desc 게시글의 입력받은 이미지 삭제 검증 로직
     */
    fun upload(
        aBoard: Board,
        multipartFile: List<MultipartFile>,
        uid: String,
        boardKindKor: String,
        boardCategoryEng: String
    ) {

        val error: String = boardCategoryEng.uppercase()
        val newImages = try {
            ncpS3Uploader.uploadImages(multipartFile, "$boardCategoryEng/${aBoard.id}")
        } catch (e: CommonException) {
            log.error("$error-IMG-001 : $boardKindKor 게시판 이미지 업로드 실패 - [ 유저명 : $uid, 게시글 번호 : ${aBoard.id} ]", e)
            throw CommonException("$error-IMG-001", HttpStatus.BAD_REQUEST)
        }

        try {
            aBoard.updatePics(newImages)
        } catch (e: Exception) {
            log.error("$error-IMG-002 : $boardKindKor 게시판 이미지 업데이트 실패")
            throw CommonException("$error-IMG-002", HttpStatus.BAD_REQUEST)
        }
    }

    /**
     * @param aBoard : 게시글
     * @param multipartFile : 이미지 파일
     * @param boardKindKor : Web Hook 전송을 위한 게시판의 **한글명**
     * @param boardCategoryEng : 로그 기록을 위함, Error 코드에 쓰일 게시판 카테고리의 **영문명**
     * @desc 이미지 삭제 완료 후, 새로운 이미지 업데이트
     */
    fun update(
        aBoard: Board,
        multipartFile: List<MultipartFile>?,
        uid: String,
    ) : List<String> {

        if (multipartFile?.isNotEmpty() == true) {
            try {
                if (!aBoard.pics.isNullOrEmpty()) {
                    aBoard.pics?.let(ncpS3Uploader::removeImages)
                    aBoard.removePics()
                }
            } catch (e: Exception) {
                log.error("IMG-003 : 게시판 이미지 삭제 실패 - [ 유저명 : $uid, 게시글 번호 : ${aBoard.id} ]", e)
                throw CommonException("IMG-003", HttpStatus.BAD_REQUEST)
            }

            val newImages = try {
                ncpS3Uploader.uploadImages(multipartFile, "board/${aBoard.id}")
            } catch (e: CommonException) {
                log.error("IMG-002 : 게시판 이미지 수정 실패 - [ 유저명 : $uid, 게시글 번호 : ${aBoard.id} ]", e)
                throw CommonException("IMG-002", HttpStatus.BAD_REQUEST)
            }

           return newImages
        }
        else {
            try {
                if (!aBoard.pics.isNullOrEmpty()) {
                    aBoard.pics?.let(ncpS3Uploader::removeImages)
                    aBoard.removePics()
                }
            } catch (e: Exception) {
                log.error("IMG-003 : 게시판 이미지 삭제 실패 - [ 유저명 : $uid, 게시글 번호 : ${aBoard.id} ]", e)
                throw CommonException("IMG-003", HttpStatus.BAD_REQUEST)
            }

            return listOf()
        }
    }

    companion object {
        private val log: Logger = LogManager.getLogger(this.javaClass.name)
    }
}
```

