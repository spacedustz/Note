## 💡에러코드 정리

https://www.notion.so/spacepet/e77e3908b2bb48079e654d687769ae6d?v=707311c93016402ca296c8aaea1b4d93

<br>

### 에러코드 정리 기준

- 1-  조회 실패 (단건, 리스트 등) - 404 Not Found
- 2 - 변환 실패 (DTO 등 ResponseEntity) - 404 Not Found
- 3 - Save 실패(CRUD 등) - 404 Not Found
- 4 - 유효성 검증 실패 (Property 불일치 등) - 400 Bad Request
- 5 - 권한 인증 실패 - 403 Forbidden

---

### 이미지, 좋아요 등 부가 기능 에러 

XX-IMG-000

- 1 - 이미지 업로드 실패 - 400 Bad Request
- 2 - 이미지 수정 실패 - 400 Bad Request
- 3 - 이미지 삭제 실패 - 400 Bad Request



XX-LIKE-001

- 1 - 좋아요 포스트 실패 - 400 Bad Request

---

### 어드민 기능

- log.info 를 찍거나 할 때 [Admin] 을 붙인다.

---

### Boards

BOARD-001	[Get]
/v3/boards
/boards	BOARDS	404	uid등 조회 조건에 안맞는 값이 들어 왔을때 [조회] 실패
BOARD-002	[Get]
/v3/boards
/boards	BOARDS	404	타입이 안맞거나 휴먼에러로 인한 DTO 등의 [변환] 실패
BOARD-003	[Post]
/v3/album
/album	BOARDS	404	엔티티나 파라미터에 잘못된 값이 들어올 경우 [Save] 실패 (변경 등 포함)
BOARD-004	[Get]
/v3/boards
/boards

[Get]
/v3/boards/{id}
/boards/{id}	BOARDS	400	Property의 [유효성 검증] 실패