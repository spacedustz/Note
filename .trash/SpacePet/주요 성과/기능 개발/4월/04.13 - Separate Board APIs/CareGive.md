## 💡 CareGive

---

## DTO

```kotlin
/* 품앗이 게시판 DTO */
class CareGiveDTO {

    /** @desc 품앗이 Post DTO */
    data class Post(
        var content: String = "",
        var give: CommunityDTO.CareGive,
        var imageRefresh: Boolean? = false
        )

    /** @desc 품앗이 Detail DTO */
    data class Detail(
        var kind: String,
        var user: CommunityDTO.User,
        var detail: CommunityDTO.CommunityDetail,
        var give: CommunityDTO.CareGive
    ) {
        companion object {
            fun fromEntity(form: Board, uid: String): Detail {
                return Detail(
                    kind = "돌봄제공",
                    user = CommunityDTO.User.fromEntity(form.user),
                    detail = CommunityDTO.CommunityDetail.fromEntity(form, uid),
                    give = CommunityDTO.CareGive.fromEntity(form)
                )
            }
        }
    }

    data class Response(
        var id: String? = null
    ) {
        companion object {
            fun fromEntity(form: Board): Response {
                return Response(
                    id = form.id.toString()
                )
            }
        }
    }
}
```

---

## Service

```kotlin
/* 품앗이 게시판 서비스 */

@Service
class CareGiveService(
    @Autowired private val userRecycleFn: UserRecycleFn,
    @Autowired private val boardRecycleFn: BoardRecycleFn,
    @Autowired private val ncpS3UploaderRecycleFn: NcpS3UploaderRecycleFn,
    @Autowired private val ncpS3Uploader: NcpS3Uploader,
    @Autowired private val apiService: ApiService,
    @Autowired private val boardRepository: BoardRepository
) {

    /**
     * @param data : 게시글 정보
     * @param multipartFile : 이미지 파일
     * @param uid : 유저 아이디
     * @desc 품앗이 게시글 업로드
     */
    @Transactional
    fun postCareGiveBoard(
        data: CareGiveDTO.Post,
        multipartFile: List<MultipartFile>?,
        uid: String
    ): CareGiveDTO.Response {

        val anUser = userRecycleFn.checkActiveUser(uid)
        userRecycleFn.validateUser(anUser, "give")

        val aBoard: Board = try {
            Board(user = anUser).apply {
                kind = "돌봄제공"
                requestContent = data.content
                requestSecondContent = ""
                preMeeting = data.give.preMeeting ?: false
                requestAnimalUser = data.give.animalKind ?: ""
                animalSize = data.give.animalSize
                animalNetralization = data.give.neutralization
                timeHelp = data.give.timeHelp?.toMutableList()
                timeReword = data.give.requestHelpTime
                pushUsers = mutableListOf(uid)
                createdAt = LocalDateTime.now()
            }
        } catch (e: Exception) {
            log.error("GIVE-004 : 돌봄제공 게시글 생성 에러 - $e, $uid")
            throw CommonException("GIVE-004", HttpStatus.BAD_REQUEST)
        }

        if (aBoard.kind != "돌봄제공") {
            apiService.serverErrorWebHook(
                "[ 보안 알림 ] 돌봄제공 글이 아닙니다.",
                CommonException("GIVE-004", HttpStatus.BAD_REQUEST))
        }

        if (anUser.id != aBoard.user.id) {
            log.error("GIVE-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("GIVE-005", HttpStatus.FORBIDDEN)
        }

        try {
            boardRepository.save(aBoard)
            boardRepository.flush()
        } catch (e: Exception) {
            log.error("GIVE-003 : 품앗이 게시글 SQL 저장 에라 - $e, $uid")
            throw CommonException("GIVE-003", HttpStatus.BAD_REQUEST)
        }

        if (!multipartFile.isNullOrEmpty()) {
            var pics = try {
                multipartFile.let { ncpS3Uploader.boardUploadImages(it, "board/${aBoard.id}") }
            } catch (e: Exception) {
                log.error("GIVE-IMG-001 : 품앗이 게시글 이미지 업로드 에러 - $e, $uid")
                throw CommonException("GIVE-IMG-001", HttpStatus.BAD_REQUEST)
            }
            aBoard.pics = pics
        }

        var result = try {
            CareGiveDTO.Response.fromEntity(aBoard)
        } catch (e: Exception) {
            log.error("GIVE-003 : 품앗이 게시글 데이터 매핑 실패 - $e, $uid")
            throw CommonException("GIVE-003", HttpStatus.NOT_FOUND)
        }

        log.info("돌봄제공 게시글 생성 완료 - [ 작성자 : $uid, 글 번호 : $aBoard.id ]")

        return result
    }

    /**
     * @param data : 돌봄요청 게시글 정보
     * @param multipartFile : 이미지 파일
     * @param uid : 유저 아이디
     * @param boardId : 글번호
     * @desc 품앗이 게시글 수정
     */
    @Transactional
    fun patchCareGiveBoard(
        data: CareGiveDTO.Post,
        multipartFile: List<MultipartFile>?,
        uid: String,
        boardId: String
    ): CareGiveDTO.Response {

        val anUser = userRecycleFn.checkActiveUser(uid)
        val aBoard = boardRecycleFn.checkBoardStatus(boardId.toLong(), uid, false)
        var pics: List<String> = listOf()

        boardRecycleFn.validateUserAndBoard(anUser, aBoard)

        if (aBoard.kind != "돌봄제공") {
            apiService.serverErrorWebHook(
                "[ 보안 알림 ] 돌봄제공 글이 아닙니다.",
                CommonException("GIVE-004", HttpStatus.BAD_REQUEST)
            )
        }
        else if (anUser.id != aBoard.user.id) {
            log.error("GIVE-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("GIVE-005", HttpStatus.FORBIDDEN)
        }

        if (data.imageRefresh == true) {
            pics = ncpS3UploaderRecycleFn.update(aBoard, multipartFile, uid)
        }

        try {
            aBoard.modifyingCareGiveBoard(data)
            if (data.imageRefresh == true) aBoard.updatePics(pics)
        } catch (e: Exception) {
            log.error("GIVE-003 : 품앗이 게시글 수정 실패 - $uid, $boardId, $e")
            throw CommonException("GIVE-003", HttpStatus.NOT_FOUND)
        }

        val result = try {
            CareGiveDTO.Response.fromEntity(aBoard)
        } catch (e: Exception) {
            log.error("GIVE-003 : 품앗이 게시글 데이터 매핑 실패 - $e, $uid")
            throw CommonException("GIVE-003", HttpStatus.NOT_FOUND)
        }

        log.info("돌봄제공 게시글 수정 전 게시글 - [ ${aBoard.requestContent} ]")
        log.info("돌봄제공 게시글 수정 완료 - [ 작성자 : $uid, 글번호 : $boardId ]")

        return result
    }

    /**
     * @param uid: 작성자
     * @param boardId : 글번호
     * @desc 품앗이 게시글 조회
     */
    fun getCareGiveBoard(
        uid: String,
        boardId: String
    ): CareGiveDTO.Detail {

        val anUser = userRecycleFn.checkActiveUser(uid)
        val aBoard = boardRecycleFn.checkBoardStatus(boardId.toLong(), uid, false)

        boardRecycleFn.validateUserAndBoard(anUser, aBoard)

        if (aBoard.kind != "돌봄제공") {
            apiService.serverErrorWebHook(
                "[ 보안 알림 ] 돌봄제공 게시글이 아닙니다 - ${aBoard.kind}",
                CommonException("GIVE-004", HttpStatus.BAD_REQUEST)
            )
        }
        if (anUser.id != aBoard.user.id) {
            log.error("GIVE-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("GIVE-005", HttpStatus.FORBIDDEN)
        }

        val result = try {
            CareGiveDTO.Detail.fromEntity(aBoard, uid)
        } catch (e: Exception) {
            log.error("GIVE-002 : 돌봄제공 게시글 조회 실패 - [ 작성자 : $uid, 글번호 : $boardId ]")
            throw CommonException("GIVE-002", HttpStatus.BAD_REQUEST)
        }

        log.info("돌봄제공 게시글 조회 성공 - [ 작성자 : $uid, 글번호 : $boardId ]")

        return result
    }

    companion object {
        private val log: Logger = LogManager.getLogger(this.javaClass.name)
    }
}
```

---

## Controller

```kotlin
/* 품앗이 게시판 컨트롤러 */

@RestController
@RequestMapping("/give")
class CareGiveController(
    @Autowired private val careGiveService: CareGiveService
) {

    @Auth(Auth.Role.USER)
    @PostMapping
    fun postCareGiveBoard(
        @RequestPart data: CareGiveDTO.Post,
        @RequestPart multipartFile: List<MultipartFile>?,
        @RequestAttribute("uid") uid: String
    ): ResponseEntity<CareGiveDTO.Response> {
        return ResponseEntity(careGiveService.postCareGiveBoard(data, multipartFile, uid), HttpStatus.CREATED)
    }

    @Auth(Auth.Role.USER)
    @PatchMapping("/{boardId}")
    fun patchCareGiveBoard(
        @RequestPart data: CareGiveDTO.Post,
        @RequestPart multipartFile: List<MultipartFile>?,
        @RequestAttribute("uid") uid: String,
        @PathVariable boardId: String
    ): ResponseEntity<CareGiveDTO.Response> {
        return ResponseEntity(careGiveService.patchCareGiveBoard(data, multipartFile, uid, boardId), HttpStatus.OK)
    }

    @Auth(Auth.Role.USER)
    @GetMapping("/{boardId}")
    fun getCareGiveBoard(
        @RequestAttribute("uid") uid: String,
        @PathVariable boardId: String
    ): ResponseEntity<CareGiveDTO.Detail> {
        return ResponseEntity(careGiveService.getCareGiveBoard(uid, boardId), HttpStatus.OK)
    }
}
```

