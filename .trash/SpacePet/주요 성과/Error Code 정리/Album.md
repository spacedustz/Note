## 💡 Album

---

**001** (조회 실패) 404

- postAlbum
  - AlbumControllerT - postAlbum : /album

- patchAlbum
  - AlbumControllerT - patchAlbum : /album/{id}


**002** (변환 실패)  404

- patchAlbum
  - AlbumControllerT - patchAlbum : /album/{id}


**003** (CRUD 실패)  404

- postAlbum
  - AlbumControllerT - postAlbum : /album

- deleteAlbum@pa
  - AlbumControllerT - deleteAlbum : /album


**004** (유효성 검증 실패) 400

- getAlbumList
  - AlbumControllerT - getAlbumList : /album

- getAlbumMainList
  - AlbumControllerT - getAlbumList : /album


**005** (권한 인증 실패) 403

- patchAlbum
  - AlbumControllerT - patchAlbum : /album/{id}

- deleteAlbum
  - AlbumControllerT - deleteAlbum : /album

- deleteAlbumComment
  - AlbumControllerT - deleteAlbumComment : /album/{albumId}/comments/{commentId}


---

**IMG-001** (이미지 생성 실패) 400

- postAlbum
  - AlbumControllerT - postAlbum : /album

- patchAlbum
  - AlbumControllerT - patchAlbum : /album/{id}


**IMG-002** (이미지 수정 실패) 400

- postAlbum
  - AlbumControllerT - postAlbum : /album

- patchAlbum
  - AlbumControllerT - patchAlbum : /album/{id}


**IMG-003** (이미지 삭제 실패) 400

- deleteAlbum

---

**LIKE-001** (좋아요 생성 실패) 400

- likeAlbum
  - AlbumControllerT - patchAlbumLike : /album/like/{id}


**LIKE-002** (좋아요 수정 실패) 400

- 

**LIKE-003** (좋아요 삭제 실패) 400

- deleteAlbum
  - AlbumControllerT - deleteAlbum : /album


---

**COMM-001** (댓글 생성 실패) 400

- postAlbumComment
  - AlbumControllerT - postAlbumComment : /album/{id}/comments


**COMM-002** (댓글 수정 실패) 400

- 

**COMM-003** (댓글 삭제 실패) 400

- deleteAlbumComment
- postAlbumComment
  - AlbumControllerT - postAlbumComment : /album/{id}/comments