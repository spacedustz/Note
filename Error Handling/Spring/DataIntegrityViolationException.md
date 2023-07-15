## **💡 DataIntegrityViolation Exception**

<br>

### **Exception 발생 가능성**

1. SQL 쿼리가 잘못되거나 Data가 잘못되었을 경우
2. RuntimeException으로 잘못된 데이터가 바인딩 될 경우
3. 영속성 컨텍스트에 이미 등록된 객체에, 동일ID의 다른 참조값을 가진 객체가 접근할 경우

<br>

### **해결 기록**

1. Entity의 필드명에 오타가 들어간 경우로 인해 잘못된 SQL Insert Query를 던짐
2. MapStruct의 필드 매핑이 잘못된 경우 @Mapping Annotation을 사용하여 올바른 필드매핑
3. 연관관계가 매핑된 객체의 Cascade 전이 범위를 Merge로 변경하면 동일 ID값의 다른 주소값을 참조하는 객체가 들어와도 객체 병합과정을 통해 충돌이 발생하지 않는다