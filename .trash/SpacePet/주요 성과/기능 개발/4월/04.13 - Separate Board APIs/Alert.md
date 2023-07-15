## 💡 Alert

---

## DTO

```kotlin
/* 실종신고 게시글 DTO */

/** @desc Post DTO */
class AlertDTO {
    data class Post(

        var user: CommunityDTO.User,
        var detail: CommunityDTO.CommunityDetail,
        var imageRefresh: Boolean? = false,
        var userPhone: String? = "",

        /** @desc 실종 정보 */
        var missingDate: LocalDateTime? = null,
        var missingTime: LocalDateTime? = null,
        var missingLocation: String = "",

        /** @desc 반려동물 정보 */
        var missingAnimalKind: String = "",
        var missingAnimalBreed: String = "",
        var missingAnimalBirth: String = "",
    )

    /** Detail DTO */
    data class Detail(
        var user: CommunityDTO.User,
        var kind: String,
        var detail: CommunityDTO.CommunityDetail,

        /** @desc 실종 정보 */
        var missingDate: LocalDateTime? = null,
        var missingTime: LocalDateTime? = null,
        var missingLocation: String = "",
        var userPhone: String? = "",

        /** @desc 반려동물 정보 */
        var missingAnimalName: String?,
        var missingAnimalGender: String?,
        var missingAnimalKind: String?,
        var missingAnimalBreed: String?,
        var missingAnimalBirth: String?,
        var missingAnimalNetralization: Boolean? = false,

        var found: Boolean = false
    ) {
        companion object {
            fun fromEntity(board: Board, uid: String): Detail {
                return Detail(
                    kind = "실종신고",
                    user = CommunityDTO.User.fromEntity(board.user),
                    detail = CommunityDTO.CommunityDetail.fromEntity(board, uid),

                    missingDate = board.requestedAt,
                    missingTime = board.requestedAt02,
                    missingLocation = board.requestedLocation ?: "",
                    userPhone = board.phoneNumber,

                    missingAnimalName = board.animalName,
                    missingAnimalGender = board.requestGender,
                    missingAnimalKind = board.requestAnimalUser,
                    missingAnimalBreed = board.breed,
                    missingAnimalBirth = board.animalBirth,
                    missingAnimalNetralization = board.animalNetralization,
                    found = board.connected
                )
            }
        }
    }

    /** Response DTO */
    data class Response(
        var id: Long? = null
    ) {
        object ModelMapper {
            fun entityToDto(form: Board): Response {
                return Response(
                    id = form.id
                )
            }
        }
    }
}
```

<br>

## Service

```kotlin
/* 실종신고 게시판 서비스 */

@Service
class AlertService (
    @Autowired private val userRecycleFn: UserRecycleFn,
    @Autowired private val boardRecycleFn: BoardRecycleFn,
    @Autowired private val ncpS3UploaderRecycleFn: NcpS3UploaderRecycleFn,
    @Autowired private val apiService: ApiService,
    @Autowired private val boardRepository: BoardRepository,
    @Autowired private val ncpS3Uploader: NcpS3Uploader
        ) {

    /**
     * @param uid : 작성자
     * @param data : 게시글 정보
     * @param multipartFile : 이미지 파일
     * @desc 실종신고 게시글 업로드
     */
    @Transactional
    fun postAlertBoard(
        uid: String,
        data: AlertDTO.Post,
        multipartFile: List<MultipartFile>
    ): AlertDTO.Detail {

        val anUser = userRecycleFn.checkActiveUser(uid)
        userRecycleFn.validateUser(anUser, "alert")

        val aBoard: Board = try {
            Board(user = anUser).apply {
                kind = "실종신고"
                requestContent = data.detail.content ?: ""
                requestedAt = data.missingDate
                requestedAt02 = data.missingTime
                requestedLocation = data.missingLocation
                phoneNumber = data.userPhone ?: ""
                animalName = data.user.animalName
                requestAnimalUser = data.missingAnimalKind
                breed = data.missingAnimalBreed
                requestGender = data.user.animalGender ?: ""
                animalNetralization = data.user.animalNeutralization
                animalSize = data.user.animalSize
                animalBirth = data.missingAnimalBirth
                createdAt = LocalDateTime.now()
            }
        } catch (e: Exception) {
            log.error("ALERT-004 : 실종신고 게시글 생성 에러 - $e, $uid")
            throw CommonException("ALERT-004", HttpStatus.BAD_REQUEST)
        }

        if (aBoard.kind != "실종신고") {
            apiService.serverErrorWebHook(
                "실종신고 글이 아닙니다.",
            CommonException("ALERT-004", HttpStatus.BAD_REQUEST))
        }
        if (anUser.id != aBoard.user.id) {
            log.error("ALERT-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("ALERT-005", HttpStatus.FORBIDDEN)
        }

        try {
            boardRepository.save(aBoard)
            boardRepository.flush()
        } catch(e : Exception) {
            log.error("ALERT-006 : 실종신고 게시글 SQL 저장 에러 - $e, $uid")
            throw CommonException("ALERT-006", HttpStatus.BAD_REQUEST)
        }

        if (!multipartFile.isNullOrEmpty()) {
            var pics = try {
                ncpS3Uploader.boardUploadImages(multipartFile, "board/${aBoard.id}")
            } catch (e : Exception) {
                log.error("ALERT-IMG-001 : 실종신고 게시글 이미지 업로드 에러 - $e, $uid")
                throw CommonException("ALERT-IMG-001", HttpStatus.BAD_REQUEST)
            }

            aBoard.pics = pics
        }

        var result : AlertDTO.Detail = try {
            AlertDTO.Detail.fromEntity(aBoard, uid)
        } catch (e : Exception) {
            log.error("ALERT-005 : 실종신고 게시글 이미지 업로드 에러 - $e, $uid")
            throw CommonException("ALERT-004", HttpStatus.BAD_REQUEST)
        }

        log.info("실종신고 게시글 생성 완료 - [ 작성자 : $uid, 글 번호 : ${aBoard.id} ]")

        return result
    }

    /**
     * @param boardId : 글 번호
     * @param uid : 작성자
     * @param data : 게시글 정보
     * @param multipartFile : 이미지 파일
     * @desc 실종신고 게시글 수정
     */
    @Transactional
    fun patchAlertBoard (
        boardId: String,
        uid: String,
        data: AlertDTO.Post,
        multipartFile: List<MultipartFile>?
    ): AlertDTO.Detail {

        val anUser = userRecycleFn.checkActiveUser(uid)
        val aBoard = boardRecycleFn.checkBoardStatus(boardId.toLong(), uid, false)
        var pics: List<String> = listOf()

        boardRecycleFn.validateUserAndBoard(anUser, aBoard)

        if (aBoard.kind != "실종신고") {
            apiService.serverErrorWebHook(
                "실종신고 글이 아닙니다.",
                CommonException("ALERT-004", HttpStatus.BAD_REQUEST))
        }

        if (data.imageRefresh == true) {
            pics = ncpS3UploaderRecycleFn.update(aBoard, multipartFile, uid)
        }

        try {
            aBoard.modifyingAlertBoard(data)
            if (data.imageRefresh == true) aBoard.updatePics(pics)
        } catch (e: Exception) {
            log.error("ALERT-003 : 실종신고 게시글 수정 실패 - $uid, $boardId, $e")
            throw CommonException("ALERT-003", HttpStatus.NOT_FOUND)
        }

        val result = try {
            AlertDTO.Detail.fromEntity(aBoard, uid)
        } catch (e: Exception) {
            log.error("ALERT-003 : 실종신고 게시글 데이터 매핑 실패 - $e, $uid")
            throw CommonException("ALERT-003", HttpStatus.NOT_FOUND)
        }

        log.info("실종신고 게시글 수정 전 게시글 - [ {${aBoard.requestContent} ]")
        log.info("실종신고 게시글 수정 완료 - [ 작성자 : $uid, 글 번호 : $boardId ]")

        return result
    }

    /**
     * @param boardId : 글 번호
     * @param uid : 작성자
     * @desc 실종신고 게시글 조회
     */
    fun getAlertBoard (
        uid: String,
        boardId: String,
    ): AlertDTO.Detail {

        val anUser = userRecycleFn.checkActiveUser(uid)
        val aBoard = boardRecycleFn.checkBoardStatus(boardId.toLong(), uid, false)

        boardRecycleFn.validateUserAndBoard(anUser, aBoard)

        if (aBoard.kind != "실종신고") {
            apiService.serverErrorWebHook(
                "[ 보안 알림 ] 실종신고 게시글이 아닙니다 - ${aBoard.kind}",
                CommonException("ALERT-004", HttpStatus.BAD_REQUEST))
        }

        val result = try {
            boardRepository.findByIdAndCheckStatus(boardId.toLong(), false)
        } catch (e: Exception) {
            log.error("ALERT-002 : 실종신고 게시글 조회 실패 - [ 작성자 : $uid, 글 번호 : $boardId ]")
            throw CommonException("ALERT-002", HttpStatus.BAD_REQUEST)
        }

        log.info("실종신고 게시글 조회 성공 - [ 작성자 : $uid, 글 번호 : $boardId ]")

        return AlertDTO.Detail.fromEntity(aBoard, uid)
    }

    companion object {
        private val log: Logger = LogManager.getLogger(this.javaClass.name)
    }
}
```

<br>

## Controller

```kotlin
/* 실종신고 게시판 컨트롤러 */

@RestController
@RequestMapping("/alert")
class AlertController (
    @Autowired private val alertService: AlertService
        ) {

    /**
     * @param multipartFile : 이미지 파일
     * @param data : 게시글 정보
     * @param uid : 작성자
     * @desc 실종신고 게시글 생성 API
     */
    @Auth(Auth.Role.USER)
    @PostMapping
    fun postAlertBoard(
        @RequestPart multipartFile: List<MultipartFile>,
        @RequestPart data: AlertDTO.Post,
        @RequestAttribute("uid") uid: String
    ): ResponseEntity<AlertDTO.Detail> {
        return ResponseEntity(alertService.postAlertBoard(uid, data, multipartFile), HttpStatus.CREATED)
    }

    /**
     * @param boardId : 글 번호
     * @param multipartFile : 이미지 파일
     * @param data : 수정할 게시글 정보
     * @param uid : 작성자
     * @desc 실종신고 게시글 수정 API
     */
    @Auth(Auth.Role.USER)
    @PatchMapping("/{boardId}")
    fun patchAlertBoard(
        @PathVariable boardId: String,
        @RequestAttribute("uid") uid: String,
        @RequestPart data: AlertDTO.Post,
        @RequestPart multipartFile: List<MultipartFile>?,
    ): ResponseEntity<AlertDTO.Detail> {
        return ResponseEntity(alertService.patchAlertBoard(boardId, uid, data, multipartFile), HttpStatus.OK)
    }

    /**
     * @param boardId : 글 번호
     * @param uid: 작성자
     * @desc 실종신고 게시글 단건 조회 API
     */
    @Auth(Auth.Role.USER)
    @GetMapping("/{boardId}")
    fun getAlertBoard(
        @PathVariable boardId: String,
        @RequestAttribute("uid") uid: String
    ): ResponseEntity<AlertDTO.Detail> {
        return ResponseEntity(alertService.getAlertBoard(uid, boardId), HttpStatus.OK)
    }
}
```

