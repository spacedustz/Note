## 💡 Today Pet

<br>

## Controller

```kotlin
/* Today Pet Controller */

@RestController
@RequestMapping("/today")
class TodayPetController (
    @Autowired private val todayPetService: TodayPetService
) {

    /**
     * @param multipartFile : 이미지 파일
     * @param data : 게시글 정보
     * @param uid : 작성자
     * @desc 투데이펫 게시글 생성 API
     */
    @Auth(Auth.Role.USER)
    @PostMapping
    fun postTodayPetBoard(
        @RequestPart multipartFile: List<MultipartFile>,
        @RequestPart data: TodayPetDTO.Post,
        @RequestAttribute("uid") uid: String,
        @RequestParam(required = false) album : Boolean? // 앨범과 동시 업로드 일 때
    ) : ResponseEntity<TodayPetDTO.Detail> {
        return ResponseEntity(todayPetService.postTodayPetBoard(uid, data, multipartFile, album), HttpStatus.CREATED)
    }

    /**
     * @param boardId : 글 번호
     * @param multipartFile : 이미지 파일
     * @param data : 수정할 게시글 정보
     * @param uid : 작성자
     * @desc 투데이펫 게시글 수정 API
     */
    @Auth(Auth.Role.USER)
    @PatchMapping("/{boardId}")
    fun patchTodayPetBoard(
        @PathVariable boardId: String,
        @RequestPart multipartFile: List<MultipartFile>?,
        @RequestPart data: TodayPetDTO.Post,
        @RequestAttribute("uid") uid: String,
    ) : ResponseEntity<TodayPetDTO.Detail> {
        return ResponseEntity(todayPetService.patchTodayPetBoard(boardId ,uid, data, multipartFile), HttpStatus.OK)
    }

    /**
     * @param boardId : 글 번호
     * @param uid : 작성자
     * @desc 투데이펫 게시글 단건 조회 API
     */
    @Auth(Auth.Role.USER)
    @GetMapping("/{boardId}")
    fun getTodayPetBoard(
        @PathVariable boardId: String,
        @RequestAttribute("uid") uid: String
    ) : ResponseEntity<TodayPetDTO.Detail> {
        return ResponseEntity(todayPetService.getTodayPetBoard(uid, boardId), HttpStatus.OK)
    }

}
```

<br>

## DTO

```kotlin
/* 투데이펫 게시판 DTO */

class TodayPetDTO {

    /** @desc Post DTO */
    data class Post(
        var content: String = "",
        var imageRefresh : Boolean? = false,
    )

    /** @desc Detail DTO */
    data class Detail(
        var kind: String,
        var user: CommunityDTO.User,
        var detail: CommunityDTO.CommunityDetail
    ) {
        companion object {
            fun fromEntity(board: Board, uid: String): Detail {
                return Detail(
                    kind = "일상",
                    user = CommunityDTO.User.fromEntity(board.user),
                    detail = CommunityDTO.CommunityDetail.fromEntity(board, uid)
                )
            }
        }
    }

    /** @desc Response DTO */
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

추후 검증로직을 빼서 RecycleFn 으로 만들 예정

```kotlin
/* 투데이펫 게시판 서비스 */

@Service
class TodayPetService(
    @Autowired private val userRecycleFn: UserRecycleFn,
    @Autowired private val apiService: ApiService,
    @Autowired private val boardRecycleFn: BoardRecycleFn,
    @Autowired private val boardRepository : BoardRepository,
    @Autowired private val ncpS3UploaderRecycleFn: NcpS3UploaderRecycleFn,
    @Autowired private val ncpS3Uploader : NcpS3Uploader,
) {

    /**
     * @param uid : 작성자
     * @param data : 게시글 정보
     * @param multipartFile : 이미지 파일
     * @desc 투데이펫 게시글 생성
     */
    @Transactional
    fun postTodayPetBoard(
        uid: String,
        data: TodayPetDTO.Post,
        multipartFile: List<MultipartFile>,
        album : Boolean?
    ): TodayPetDTO.Detail {

        val anUser = userRecycleFn.checkActiveUser(uid)
        userRecycleFn.validateUser(anUser, "today")

        val aBoard: Board = try {
            Board(user = anUser).apply {
                kind = "일상"
                requestContent = data.content
                createdAt = LocalDateTime.now()
                pushUsers = mutableListOf(uid)
            }
        } catch (e: Exception) {
            log.error("TODAY-004 : 투데이 게시글 생성 에러 - $e, $uid")
            throw CommonException("TODAY-004", HttpStatus.BAD_REQUEST)
        }

        if (aBoard.kind != "투데이펫") {
            apiService.serverErrorWebHook(
                "[ 보안 알림 ] 투데이펫 글이 아닙니다.",
                CommonException("TODAY-004", HttpStatus.BAD_REQUEST))
        }

        if (anUser.id != aBoard.user.id) {
            log.error("TODAY-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("TODAY-005", HttpStatus.FORBIDDEN)
        }

       try {
            boardRepository.save(aBoard)
            boardRepository.flush()
        } catch(e : Exception) {
            log.error("TODAY-006 : 투데이펫 게시글 SQL 저장 에러 - $e, $uid")
            throw CommonException("TODAY-006", HttpStatus.BAD_REQUEST)
        }

        if (multipartFile.isNotEmpty()) {
            var pics = try {
                ncpS3Uploader.boardUploadImages(multipartFile, "board/${aBoard.id}")
            } catch (e : Exception) {
                log.error("TODAY-005 : 투데이 게시글 이미지 업로드 에러 - $e, $uid")
                throw CommonException("TODAY-004", HttpStatus.BAD_REQUEST)
            }

            aBoard.pics = pics
        }

        var result : TodayPetDTO.Detail = try {
            boardRepository.save(aBoard)
            boardRepository.flush()
            TodayPetDTO.Detail.fromEntity(aBoard, anUser.id)
        } catch(e : Exception) {
            log.error("TODAY-006 : 투데이펫 게시글 SQL 저장 에러 - $e, $uid")
            throw CommonException("TODAY-006", HttpStatus.BAD_REQUEST)
        }

        log.info("투데이펫 게시글 생성 완료 - [ 작성자 : $uid, 글 번호 : ${aBoard.id} ]")

        return result
    }

    /**
     * @param uid : 작성자
     * @param data : 게시글 정보
     * @param multipartFile : 이미지 파일
     * @desc 투데이펫 게시글 수정
     */
    @Transactional
    fun patchTodayPetBoard(
        boardId: String,
        uid: String,
        data: TodayPetDTO.Post,
        multipartFile: List<MultipartFile>?
    ): TodayPetDTO.Detail {

        val anUser = userRecycleFn.checkActiveUser(uid)
        val aBoard = boardRecycleFn.checkBoardStatus(boardId.toLong(), uid, false)

        boardRecycleFn.validateUserAndBoard(anUser, aBoard)

        if (aBoard.kind != "일상") {
            apiService.serverErrorWebHook("[ 보안 알림 ] 투데이펫 게시글이 아닙니다 - ${aBoard.kind}", CommonException("TODAY-004", HttpStatus.BAD_REQUEST))
            throw CommonException("TODAY-004", HttpStatus.BAD_REQUEST)
        }

        var pics = ncpS3UploaderRecycleFn.update(aBoard, multipartFile, uid)

        try {
            aBoard.modifyingTodayPetBoard(data)
            aBoard.updatePics(pics)
        } catch (e : Exception) {
            log.error("TODAY-004 : 투데이펫 게시글 수정 실패 - $boardId, $uid, $e")
            throw CommonException("TODAY-004", HttpStatus.BAD_REQUEST)
        }

        var result = try {
            TodayPetDTO.Detail.fromEntity(aBoard, uid)
        } catch (e: Exception) {
            log.error("TODAY-003 : 투데이펫 게시글 데이터 매핑 실패 - $e, $uid")
            throw CommonException("TODAY-003", HttpStatus.NOT_FOUND)
        }

        log.info("투데이펫 게시글 수정 전 게시글 - [ ${aBoard.requestContent} ]")
        log.info("투데이펫 게시글 수정 완료 - [ 작성자 : $uid, 글번호 : $boardId")

        return result
    }

    /**
     * @param boardId : 글번호
     * @param uid : 작성자
     * @desc 투데이펫 게시글 조회
     */
    fun getTodayPetBoard(
        uid: String,
        boardId: String,
    ): TodayPetDTO.Detail {

        val anUser = userRecycleFn.checkActiveUser(uid)
        val aBoard = boardRecycleFn.checkBoardStatus(boardId.toLong(), uid, false)

        boardRecycleFn.validateUserAndBoard(anUser, aBoard)

        if (aBoard.kind != "일상") {
            apiService.serverErrorWebHook(
                " [ 보안 알림 ] 투데이펫 게시글이 아닙니다 - ${aBoard.kind}",
                CommonException("TODAY-004", HttpStatus.BAD_REQUEST)
            )
        }

        if (anUser.id != aBoard.user.id) {
            log.error("TODAY-005 : 작성자가 아닙니다 - [ 유저명 : $uid ]")
            throw CommonException("TODAY-005", HttpStatus.FORBIDDEN)
        }

        val result = try {
            TodayPetDTO.Detail.fromEntity(aBoard, uid)
        } catch (e: Exception) {
            log.error("TODAY-002 : 투데이펫 게시글 데이터 매핑 실패 - [ 작성자 : $uid, 글 번호 : $boardId")
        }

        log.info("투데이펫 게시글 조회 성공 - [ 작성자 : $uid, 글번호 : $boardId ]")

        return result as TodayPetDTO.Detail
    }

    companion object {
        private val log: Logger = LogManager.getLogger(this.javaClass.name)
    }
}
```
