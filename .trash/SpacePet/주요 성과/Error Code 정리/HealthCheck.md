## 💡 SERVER

---

**001** (조회 실패) 404

- getInspectionTime
  - HealthCheckController - getInspectionTime : /health-check/inspection-time

- getVersionAndOs
  - HealthCheckController - getVersionAndOs : /health-check/version

- getVersionDesc
  - HealthCheckController - getVersionDesc : /health-check/versions

- patchStatus
  - HealthCheckController - patchStatus : /health-check/patch-stat


**002** (변환 실패) 404

- getInspectionTime
  - HealthCheckController - getInspectionTime : /health-check/inspection-time
- chengeVersion
  - HealthCheckService - getVersionAndOs

**003** (CRUD 실패) 404

- getVersionAndOs
  - HealthCheckController - getVersionAndOs : /health-check/version


**004** (유효성 검증 실패) 400

- patchStatus
  - HealthCheckController - patchStatus : /health-check/patch-stat

- chengeVersion
  - HealthCheckService - getVersionAndOs


**005** (권한 인증 실패) 403

- 

---

