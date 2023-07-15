## 💡 CERT

---

**001** (조회 실패) 404

- postUserCertPhoneInit
  - UserCertControllerT - postUserCertPhoneInit
- postUserCertPhoneEnd
  - UserCertControllerT - ostUserCertPhoneEnd


**002** (변환 실패) 404

- 

**003** (CRUD 실패) 404

- postUserCertPhoneInit
  - UserCertControllerT - postUserCertPhoneInit

**004** (유효성 검증 실패) 400

- postUserCertPhoneInit
  - UserCertControllerT - postUserCertPhoneInit

- postUserCertPhoneEnd
  - UserCertControllerT - ostUserCertPhoneEnd

**005** (권한 인증 실패) 403

- postUserCertPhoneInit
  - UserCertControllerT - postUserCertPhoneInit
- postUserCertPhoneEnd
  - UserCertControllerT - ostUserCertPhoneEnd

**006** (이미 인증한 회원) 417 - 417 - EXPECTATION_FAILED

- postUserCertPhoneInit
  - UserCertControllerT - postUserCertPhoneInit

**007** (폰 인증 횟수 & 시간 초과) 307 - TEMPORARY_REDIRECT

- postUserCertPhoneInit
  - UserCertControllerT - postUserCertPhoneInit
- postUserCertPhoneEnd
  - UserCertControllerT - ostUserCertPhoneEnd

---

