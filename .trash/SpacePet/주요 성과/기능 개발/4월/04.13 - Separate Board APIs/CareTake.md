## 💡 CareTake

---

## DTO

```kotlin
/* 돌봄 SOS 게시판 DTO */
class CareTakeDTO {

    /** @desc 돌봄 SOS Post DTO */
    data class Post(
        var content: String = "",
        var take: CommunityDTO.CareTake,
        val imageRefresh: Boolean? = false
    )

    /** @desc 돌봄 SOS Detail DTO */
    data class Detail(
        var kind: String,
        var user: CommunityDTO.User,
        var detail: CommunityDTO.CommunityDetail,
        var take: CommunityDTO.CareTake
    ) {
        companion object {
            fun fromEntity(form: Board, uid: String): Detail {

                return Detail(
                    kind = "돌봄요청",
                    user = CommunityDTO.User.fromEntity(form.user),
                    detail = CommunityDTO.CommunityDetail.fromEntity(form, uid),
                    take = CommunityDTO.CareTake.fromEntity(form)
                )
            }
        }
    }

    /** @desc 돌봄 SOS Response DTO */
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
/* 돌봄 SOS 서비스 */

@Service
class CareTakeService(
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
     * @desc 돌봄 SOS 게시글 업로드
     */
    @Transactional
    fun postCareTakeBoard(
        data: CareTakeDTO.Post,
        multipartFile: List<MultipartFile>?,
        uid: String
    ): CareTakeDTO.Response {

        val anUser = userRecycleFn.checkActiveUser(uid)

        userRecycleFn.validateUser(anUser, "take")

        val aBoard: Board = try {
            Board(user = anUser).apply {
                kind = "돌봄요청"
                requestContent = data.content
                preMeeting = data.take.preMeeting ?: false
                requestGender = data.take.neighborGender ?: ""
                requestAnimalUser = data.take.neighborAnimal ?: ""
                requestedAt = data.take.takeStartDate
                requestedAt02 = data.take.takeEndDate
                reword = data.take.reword
                giveTake = data.take.giveTake
                pushUsers = mutableListOf(uid)
                createdAt = LocalDateTime.now()
            }
        } catch (e: Exception) {
            log.error("TAKE-004 : 돌봄 SOS 게시글 생성 에러 - $e, $uid", HttpStatus.BAD_REQUEST)
            throw CommonException("TAKE-004", HttpStatus.BAD_REQUEST)
        }

        if (aBoard.kind != "돌봄요청") {
            apiService.serverErrorWebHook(
                "[ 보안 알림 ] 돌봄요청 글이 아닙니다.",
                CommonException("TAKE-004", HttpStatus.BAD_REQUEST)
            )
        }

        if (anUser.id != aBoard.user.id) {
            log.error("TAKE-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("TAKE-005", HttpStatus.FORBIDDEN)
        }

        try {
            boardRepository.save(aBoard)
            boardRepository.flush()
        } catch (e: Exception) {
            log.error("TAKE-003 : 돌봄요청 게시글 SQL 저장 에러 - $e, $uid")
            throw CommonException("TAKE-003", HttpStatus.BAD_REQUEST)
        }

        if (!multipartFile.isNullOrEmpty()) {
            var pics = try {
                multipartFile.let { ncpS3Uploader.boardUploadImages(it, "board/${aBoard.id}") }
            } catch (e: Exception) {
                log.error("TAKE-IMG-001 : 돌봄요청 게시글 이미지 업로드 에러 - $e, $uid")
                throw CommonException("TAKE-IMG-001", HttpStatus.BAD_REQUEST)
            }
            aBoard.pics = pics
        }

        var result = try {
            CareTakeDTO.Response.fromEntity(aBoard)
        } catch (e: Exception) {
            log.error("TAKE-003 : 돌봄요청 게시글 데이터 매핑 실패 - $e, $uid")
            throw CommonException("TAKE-003", HttpStatus.NOT_FOUND)
        }

        log.info("돌봄요청 게시글 생성 완료 - [ 작성자 : $uid, 글번호 : ${aBoard.id} ]")

        return result
    }

    /**
     * @param data : 돌봄요청 게시글 정보
     * @param multipartFile : 이미지 파일
     * @param uid : 유저 아이디
     * @param boardId : 글번호
     * @desc 돌봄 SOS 게시글 수정
     */
    @Transactional
    fun patchCareTakeBoard(
        data: CareTakeDTO.Post,
        multipartFile: List<MultipartFile>?,
        uid: String,
        boardId: String
    ): CareTakeDTO.Response {

        val anUser = userRecycleFn.checkActiveUser(uid)
        val aBoard = boardRecycleFn.checkBoardStatus(boardId.toLong(), uid, false)
        var pics: List<String> = listOf()

        boardRecycleFn.validateUserAndBoard(anUser, aBoard)

        if (aBoard.kind != "돌봄요청") {
            apiService.serverErrorWebHook(
                "[ 보안 알림 ] 돌봄요청 글이 아닙니다.",
                CommonException("TAKE-004", HttpStatus.BAD_REQUEST)
            )
        }
        if (anUser.id != aBoard.user.id) {
            log.error("TAKE-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("TAKE-005", HttpStatus.FORBIDDEN)
        }

        if (data.imageRefresh == true) {
            pics = ncpS3UploaderRecycleFn.update(aBoard, multipartFile, uid)
        }

        try {
            aBoard.modifyingCareTakeBoard(data)
            if (data.imageRefresh == true) aBoard.updatePics(pics)
        } catch (e: Exception) {
            log.error("GIVE-003 : 돌봄요청 게시글 수정 실패 - $uid, $boardId, $e")
            throw CommonException("GIVE-003", HttpStatus.NOT_FOUND)
        }

        val result = CareTakeDTO.Response.fromEntity(aBoard)

        log.info("돌봄요청 게시글 수정 전 게시글 - [ ${aBoard.requestContent} ]")
        log.info("돌봄요청 게시글 수정 완료 - [ 작성자 : $uid, 글번호 : $boardId ]")

        return result
    }

    /**
     * @param uid: 작성자
     * @param boardId : 글번호
     * @desc 돌봄 SOS 게시글 조회
     */
    fun getCareTakeBoard(
        uid: String,
        boardId: String
    ): CareTakeDTO.Detail {

        val anUser = userRecycleFn.checkActiveUser(uid)
        val aBoard = boardRecycleFn.checkBoardStatus(boardId.toLong(), uid, false)

        boardRecycleFn.validateUserAndBoard(anUser, aBoard)

        if (aBoard.kind != "돌봄요청") {
            apiService.serverErrorWebHook(
                "[ 보안 알림 ] 돌봄요청 게시글이 아닙니다 - ${aBoard.kind}",
                CommonException("TAKE-004", HttpStatus.BAD_REQUEST)
            )
        }
        if (anUser.id != aBoard.user.id) {
            log.error("TAKE-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("TAKE-005", HttpStatus.FORBIDDEN)
        }

        val result = try {
            CareTakeDTO.Detail.fromEntity(aBoard, uid)
        } catch (e: Exception) {
            log.error("TAKE-002 : 돌봄요청 게시글 조회 실패 - [ 작성자 : $uid, 글번호 : $boardId ]")
            throw CommonException("TAKE-002", HttpStatus.BAD_REQUEST)
        }

        log.info("돌봄요청 게시글 조회 성공 - [ 작성자 : $uid, 글번호 : $boardId ]")

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
/* 돌봄 SOS 컨트롤러 */

@RestController
@RequestMapping("/take")
class CareTakeController(
    @Autowired private val careTakeService: CareTakeService
) {

    @Auth(Auth.Role.USER)
    @PostMapping
    fun postCareGiveBoard(
        @RequestPart data: CareTakeDTO.Post,
        @RequestPart multipartFile: List<MultipartFile>?,
        @RequestAttribute("uid") uid: String
    ): ResponseEntity<CareTakeDTO.Response> {
        return ResponseEntity(careTakeService.postCareTakeBoard(data, multipartFile, uid), HttpStatus.CREATED)
    }

    @Auth(Auth.Role.USER)
    @PatchMapping("/{boardId}")
    fun patchCareGiveBoard(
        @RequestPart data: CareTakeDTO.Post,
        @RequestPart multipartFile: List<MultipartFile>?,
        @RequestAttribute("uid") uid: String,
        @PathVariable boardId: String
    ): ResponseEntity<CareTakeDTO.Response> {
        return ResponseEntity(careTakeService.patchCareTakeBoard(data, multipartFile, uid, boardId), HttpStatus.OK)
    }

    @Auth(Auth.Role.USER)
    @GetMapping("/{boardId}")
    fun deleteCareTake(
        @RequestAttribute("uid") uid: String,
        @PathVariable boardId: String
    ): ResponseEntity<CareTakeDTO.Detail> {
        return ResponseEntity(careTakeService.getCareTakeBoard(uid, boardId), HttpStatus.OK)
    }
}
```

