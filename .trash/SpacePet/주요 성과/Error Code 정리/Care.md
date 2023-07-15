## 💡CARE  670번줄부터

---

**001** (조회 실패) 404

- getCareBoardIndexList
  - No Usage

- getCareBoardList
  - CareBoardControllerT - getCareBoardList : /care

- getCareBoard
  - CareBoardControllerT - getCareBoard : /care/detail

- getMainCareBoard
  - CareBoardController - getCareMainBoardList : /care/main

- modifyingCareGiveBoard
  - CareBoardController - modifyingCareGiveBoard : /care/modifying/give/{boardID}
- modifyingCareTakeBoard
  - CareBoardControllerT - modifyingCareTakeBoard : /care/modifying/take/{boardID}
- getGiveCheck
  - CareBoardController - getTakeCheck : /care/givecheck

**002** (변환 실패) 404

- getCareBoardIndexList
  - No Usage
- getCareBoardList
  - CareBoardControler - getCareBoardList : /care

- getMainCareBoard
  - CareBoardController - getCareMainBoardList : /care/main
- postCareGiveBoard
  - CareBoardControllerT - postCareGiveBoard : /care/give
- modifyingCareTakeBoard
  - CareBoardControllerT - modifyingCareTakeBoard : /care/modifying/take/{boardID}

**003** (CRUD 실패) 404

- getCareBoard
  - CareBoardControllerT - getCareBoard : /care/detail
- postCareGiveBoard
  - CareBoardControllerT - postCareGiveBoard : /care/give
- modifyingCareGiveBoard
  - CareBoardController - modifyingCareGiveBoard : /care/modifying/give/{boardID}
- postCareTakeBoard
  - CareBoardController - postCareTakeBoard : /care/take
- postCareGive
  - CareBoardControllerT - postCareGive : /care/post/give
- postCareTake
  - No Usage


**004** (유효성 검증 실패) 400

- modifyingCareGiveBoard
  - CareBoardController - modifyingCareGiveBoard : /care/modifying/give/{boardID}

- modifyingCareGiveBoard
  - CareBoardController - modifyingCareGiveBoard : /care/modifying/give/{boardID}
- postCareTakeBoard
  - CareBoardController - postCareTakeBoard : /care/take
- modifyingCareTakeBoard
  - CareBoardControllerT - modifyingCareTakeBoard : /care/modifying/take/{boardID}
- patchCareGive
  - No Usage

- postCareTake
  - No Usage
- patchCareBoardChats
  - CareBoardController - patchCareBoardChats : /care/chats


**005** (권한 인증 실패) 403

- postCareGiveBoard
  - CareBoardControllerT - postCareGiveBoard : /care/give

- modifyingCareGiveBoard
  - CareBoardController - modifyingCareGiveBoard : /care/modifying/give/{boardID}
- postCareTakeBoard
  - CareBoardController - postCareTakeBoard : /care/take

- modifyingCareTakeBoard
  - CareBoardControllerT - modifyingCareTakeBoard : /care/modifying/take/{boardID}
- postCareGive
  - CareBoardControllerT - postCareGive : /care/post/give


---

**IMG-001** (이미지 생성 실패) 400

- postCareGive
  - CareBoardControllerT - postCareGive : /care/post/give
- patchCareGive
  - No Usage
- postCareTake
  - No Usage

**IMG-002** (이미지 수정 실패) 400

- 

**IMG--003** (이미지 삭제 실패) 400

- patchCareGive
  - No Usage
- postCareTake
  - No Usage

---

