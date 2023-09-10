## **💡 Aggregate**  

- 비슷한 업무 도메인들의 집합
- Aggregate Root = 각각의 도메인 대표, root의 key를 다른 도메인이 foreign키로 가지고 있음
- Aggregate Root 선정 기준 = 다른 도메인과 연관성이 있는 도메인 (1:N)
- 설계중 Aggregate Root역할을 할 엔티티 클래스를 잘 선정해야함

<br>

### **엔티티 설계**

- 1:N의 관계에서 1은 N의 객체를 참조할 수 있도록 List를 멤버변수로 가진다
- N:N의 관계에서, 1:N - N:1로 변환하도록 N쪽의 객체를 참조하도록 1쪽에서 List를 멤버 변수로 가짐
  ex) private **AggregateReference**<User, long> userId;
- 객체 참조 = 테이블에서의 외래키 참조

<br>

### **테이블 설계**

- 각 테이블의 컬럼은 엔티티의 멤버변수와 1:1 매핑됨
- 테이블의 이름을 SQL의 예약어와 겹치지 않게 설정
- 1:N의 관계에서 N은 1의 Key를 외래키로 조인한다
- N:N의 관계에서, 1:N - N:1 관계로 변환하도록 조인테이블을 생성

<br>

### **Aggregate 객체 매핑**

- Spring Data JDBC를 사용하려면 설계한 도메인 엔티티 클래스들의 관계를
  DDD의 Aggregate 매핑 규칙에 맞게 변경해야함
- *** Aggregate 객체 매핑 규칙 \***
  - 1. 모든 엔티티 객체의 status는 Aggregate Root를 통해서만 변경허용
  - 2. 동일한 Aggregate 내에서의 객체 참조는 엔티티간 객체로 참조
  - 3. Root **-** Root 간 참조는 **ID**로 참조

<br>

### **Query Method**

- find + By + SQL Query
  내부적으로는 **테이블의 컬럼명**으로 매핑되지만 Spring에선 **엔티티의 멤버변수명**으로 입력해줘야함
- 조건 컬럼을 여러개를 지정하고 싶으면 'And' 사용
- @Query("")를 이용한 동적 쿼리 파라미터를 이용해도 좋지만 일반적으로 쿼리 메소드를 이용하는것을 권장