## 💡 Together

## DTO

```kotlin
/* 함께해요 게시판 DTO */

/** @desc Post DTO */
class TogetherDTO {

    data class Post(
        var content: String = "",
        var imageRefresh : Boolean? = false
    )

    /** @desc Detail DTO */
    data class Detail(
        var id: Long?,
        var kind: String,
        var user: CommunityDTO.User,
        var detail: CommunityDTO.CommunityDetail
    ) {
        companion object {
            fun fromEntity(board: Board, uid: String): Detail {
                return Detail(
                    id = board.id,
                    kind = "함께해요",
                    detail = CommunityDTO.CommunityDetail.fromEntity(board, uid),
                    user = CommunityDTO.User.fromEntity(board.user),
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

## Controller

```kotlin
/* 함께해요 게시판 컨트롤러 */

@RestController
@RequestMapping("/together")
class TogetherController (
    @Autowired private val togetherService: TogetherService
) {

    /**
     * @param multipartFile : 이미지 파일
     * @param data : 게시글 정보
     * @desc 함께해요 게시글 생성 API
     */
    @Auth(Auth.Role.USER)
    @PostMapping
    fun postTogetherBoard(
        @RequestPart multipartFile: List<MultipartFile>?,
        @RequestPart data: TogetherDTO.Post,
        @RequestAttribute("uid") uid: String,
    ): ResponseEntity<TogetherDTO.Detail> {
        return ResponseEntity(togetherService.postTogetherBoard(multipartFile, data, uid), HttpStatus.CREATED)
    }

    /**
     * @param boardId : 글 번호
     * @param multipartFile : 이미지 파일
     * @param data : 수정할 게시글 정보
     * @param uid : 작성자
     * @desc 함께해요 게시글 수정 API
     */
    @Auth(Auth.Role.USER)
    @PatchMapping("/{boardId}")
    fun patchTogetherBoard(
        @PathVariable boardId: String,
        @RequestPart multipartFile: List<MultipartFile>?,
        @RequestPart data: TogetherDTO.Post,
        @RequestAttribute("uid") uid: String
    ): ResponseEntity<TogetherDTO.Response> {
        return ResponseEntity(togetherService.patchTogetherBoard(boardId, uid, data, multipartFile), HttpStatus.OK)
    }

    /**
     * @param boardId : 글 번호
     * @param uid : 작성자
     * @desc 함께해요 게시글 단건 조회 API
     */
    @Auth(Auth.Role.USER)
    @GetMapping("/{boardId}")
    fun getTogetherBoard(
        @PathVariable boardId: String,
        @RequestAttribute("uid") uid: String
    ): ResponseEntity<TogetherDTO.Detail> {
        return ResponseEntity(togetherService.getTogetherBoard(uid, boardId), HttpStatus.OK)
    }
}
```

<br>

## Service

```kotlin
/* 품앗이 게시판 서비스 */

@Service
class TogetherService (
        @Autowired private val userRecycleFn: UserRecycleFn,
        @Autowired private val boardRecycleFn: BoardRecycleFn,
        @Autowired private val ncpS3UploaderRecycleFn: NcpS3UploaderRecycleFn,
        @Autowired private val ncpS3Uploader: NcpS3Uploader,
        @Autowired private val apiService: ApiService,
        @Autowired private val boardRepository: BoardRepository
) {

    /**
     * @param uid : 작성자
     * @param data : 게시글 정보
     * @param multipartFile : 이미지 파일
     * @desc 함께해요 게시글 업로드
     */
    @Transactional
    fun postTogetherBoard(
            multipartFile: List<MultipartFile>?,
            data: TogetherDTO.Post,
            uid: String,
    ): TogetherDTO.Detail {

        val anUser = userRecycleFn.checkActiveUser(uid)
        userRecycleFn.validateUser(anUser, "together")

        val aBoard: Board = try {
            Board(user = anUser).apply {
                kind = "함께해요"
                requestContent = data.content
                createdAt = LocalDateTime.now()
                pushUsers = mutableListOf(uid)
            }
        } catch (e: Exception) {
            log.error("TOGETHER-004 : 함께해요 게시글 생성 에러 - $e, $uid")
            throw CommonException("TOGETHER-004", HttpStatus.BAD_REQUEST)
        }

        if (aBoard.kind != "함께해요") {
            apiService.serverErrorWebHook(
                    "함께해요 글이 아닙니다.",
                    CommonException("TOGETHER-004", HttpStatus.BAD_REQUEST))
        }

        if (anUser.id != aBoard.user.id) {
            log.error("TOGETHER-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("TOGETHER-005", HttpStatus.FORBIDDEN)
        }

        try {
            boardRepository.save(aBoard)
            boardRepository.flush()
        } catch (e: Exception) {
            log.error("TOGETHER-003 : 함께해요 게시글 SQL 저장 에러 - $e, $uid")
            throw CommonException("TOGETHER-003", HttpStatus.BAD_REQUEST)
        }

        if (!multipartFile.isNullOrEmpty()) {
            var pics = try {
                multipartFile.let { ncpS3Uploader.boardUploadImages(it, "board/${aBoard.id}") }
            } catch (e: Exception) {
                log.error("TOGETHER-IMG-001 : 함께해요 게시글 이미지 업로드 에러 - $e, $uid")
                throw CommonException("TOGETHER-IMG-001", HttpStatus.BAD_REQUEST)
            }

            aBoard.pics = pics
        }

        var result = try {
            TogetherDTO.Detail.fromEntity(aBoard, uid)
        } catch (e: Exception) {
            log.error("TOGETHER-003 : 함께해요 게시글 데이터 매핑 실패 - $e, $uid")
            throw CommonException("TOGETHER-003", HttpStatus.NOT_FOUND)
        }

        log.info("함께해요 게시글 생성 완료 - [ 작성자 : $uid, 글 번호 : $aBoard.id ]")

        return result
    }

    /**
     * @param boardId : 글 번호
     * @param uid : 작성자
     * @param data : 게시글 정보
     * @pram multipartFile : 이미지 파일
     * @desc 함께해요 게시글 수정
     */
    @Transactional
    fun patchTogetherBoard(
            boardId: String,
            uid: String,
            data: TogetherDTO.Post,
            multipartFile: List<MultipartFile>?
    ): TogetherDTO.Response {

        val anUser = userRecycleFn.checkActiveUser(uid)
        val aBoard = boardRecycleFn.checkBoardStatus(boardId.toLong(), uid, false)
        var pics : List<String> = listOf()

        boardRecycleFn.validateUserAndBoard(anUser, aBoard)

        if (aBoard.kind != "함께해요") {
            apiService.serverErrorWebHook(
                    "함께해요 글이 아닙니다.",
                    CommonException("TOGETHER-004", HttpStatus.BAD_REQUEST)
            )
        }
        if (anUser.id != aBoard.user.id) {
            log.error("TOGETHER-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("TOGETHER-005", HttpStatus.FORBIDDEN)
        }

        if (data.imageRefresh == true) {
            pics = ncpS3UploaderRecycleFn.update(aBoard, multipartFile, uid)
        }

        try {
            aBoard.modifyingTogetherBoard(data)
            if (data.imageRefresh == true) aBoard.updatePics(pics)
        } catch (e: Exception) {
            log.error("TOGETHER-003 : 함께해요 게시글 수정 실패 - $uid, $boardId, $e")
            throw CommonException("TOGETHER-003", HttpStatus.NOT_FOUND)
        }

        var result = try {
            TogetherDTO.Response.ModelMapper.entityToDto(aBoard)
        } catch (e: Exception) {
            log.error("TOGETHER-003 : 함께해요 게시글 데이터 매핑 실패 - $e, $uid")
            throw CommonException("TOGETHER-003", HttpStatus.NOT_FOUND)
        }

        log.info("함께해요 게시글 수정 전 게시글 - [ {${aBoard.requestContent}} ]")
        log.info("함께해요 게시글 수정 완료 = [ 작성자 : $uid, 글 번호 : $boardId ]")

        return result
    }

    /**
     * @param boardId : 글 번호
     * @param uid : 작성자
     * @desc 함께해요 게시글 조회
     */
    fun getTogetherBoard(
            uid: String,
            boardId: String,
    ): TogetherDTO.Detail {

        val anUser = userRecycleFn.checkActiveUser(uid)
        val aBoard = boardRecycleFn.checkBoardStatus(boardId.toLong(), uid, false)

        boardRecycleFn.validateUserAndBoard(anUser, aBoard)

        if (aBoard.kind != "함께해요") {
            apiService.serverErrorWebHook(
                    "[ 보안 알림 ] 함께해요 게시글이 아닙니다 - ${aBoard.kind}",
                    CommonException("TOGETHER-004", HttpStatus.BAD_REQUEST)
            )
            throw CommonException("TOGETHER-004", HttpStatus.BAD_REQUEST)
        }
        if (anUser.id != aBoard.user.id) {
            log.error("TOGETHER-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("TOGETHER-005", HttpStatus.FORBIDDEN)
        }

        var result = try {
            TogetherDTO.Detail.fromEntity(aBoard, uid)
        } catch (e: Exception) {
            log.error("TOGETHER-002 : 함께해요 게시글 데이터 매핑 실패 - [ 작성자 : $uid, 글번호 : $boardId ]")
            throw CommonException("TOGETHER-002", HttpStatus.NOT_FOUND)
        }

        log.info("함께해요 게시글 조회 성공 - [ 작성자 : $uid, 글 번호 : $boardId ] ")

        return result
    }

    companion object {
        private val log: Logger = LogManager.getLogger(this.javaClass.name)
    }
}
```
