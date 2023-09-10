## **💡 SQL을 사용해 ERD 설계하기**

[ERD 설계](https://dbdiagram.io/)
그림의 표를 보고 명령어를 작성하여 ERD를 설계 해보자.

<br>

Step 1

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Schema5.png) 

<br>

user , content 테이블 생성, id의 pk를 content의 fk로 연결

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Schema6.png)

<br>

Step 2

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Schema7.png) 

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Schema8.png)

<br>

최종 완료

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Schema9.png)

------

## **💡 데이터베이스 정규화**  

- **Data redundancy (데이터 중복)**
  - 실제 데이터의 복사본 or 부분적 복사본
  - 일관된 자료 처리의 어려움
  - 저장공간 낭비
  - 효율성 감소
- **Data integrity (데이터 무결성)**
  - 정확성,일관성 유지
- **Anomaly(이상현상)**
  - 갱신이상 (update anomaly)
    - 동일 데이터가 여러 행(레코드)에 있을때 어떤걸 갱신해야 하는지에 대한 논리적 일관성 없음 으로 인해 발생
    - ex) Employee ID가 동일한 레코드의 경우 어떤 데이터를 갱신해야 하는지 모를때
  - 삽입이상 (insertion anomaly)
    - 데이터 삽입을 못하는 경우를 가르킴
    - ex) 새 직원이 왔을때, 아직 가르칠 수업이 정해지지 않은 경우 데이터 추가 X
  - 삭제이상 (deletion anomaly)
    - 데이터의 특정 부분을 삭제 시 의도치 않게 다른 부분도 함께 지워지는 현상
    - ex) 한 직원이 담당하는 수업이 사라지는것을 적용할때 발생
    - ex) 한 직원 데이터의 수업관련 데이터를 지우기 위해 레코드 전체가 사라져 다른 데이터도 같이 삭제됨

------

## **💡 SQL Advanced**

### **Case 사용하기**

- SQL 에서 프로그래밍의 if문과 비슷한 기능을 사용할 수 있다.
- 이 쿼리는 CustomerId 필드값에 따라 3개의 그룹(GROUP 1,2,3)으로 나뉨

```sql
SELECT CASE
			WHEN CustomerId <= 25 THEN 'GROUP 1'
			WHEN CustomerId <= 50 THEN 'GROUP 2'
			ELSE 'GROUP 3'
		END
	FROM customers
```

<br>

### **SUBQUERY 사용하기**

- 쿼리 작성 시, 다른 쿼리문 포함 가능하며, 소괄호로 감싸고 결과는 개별 값 or 레코드 리스트이다
- 서브쿼리의 결과를 하나의 칼럼으로 사용 가능

```sql
SELECT CustomerId, CustomerId = (SELECT CustomerId FROM customers WHERE CustomerId = 2)
FROM customers
WHERE CustomerId < 6
```

<br>

### **IN, NOT IN 사용하기**

- IN = 특정 값이 서브쿼리에 존재하는지 확인
- 이 쿼리는 customers 테이블에서 'CustomerId'의 값이 서브쿼리에서 돌려받는 값에 속한 결과만 조회
- \* NOT IN을 사용하면, 서브쿼리에서 조회된 10 미만을 제외한(10을 초과하는) 레코드 조회

```sql
SELECT *
FROM customers
WHERE CustomerId IN (SELECT CustomerId FROM customers WHERE CustomerId < 10)
```

<br>

### **EXISTS** or **NOT EXISTS 사용하기**

- 돌려받은 서브쿼리에 존재하는 레코드 확인
- 조회하려는 레코드가 존재한다면 참, 아니면 거짓 리턴
- 이 쿼리는 employees 테이블에서 'EmployeeId' 필드를 조회함
- 이때, 서브쿼리로 customers 테이블의 'SupportRepId' 필드값과 employees 테이블의 필드값을 비교해,
  일치하는 레코드를 가져옴

```sql
SELECT EmployeeId
FROM employees e
WHERE EXISTS (
	SELECT 1
	FROM customers c
	WHERE c.SupportRepId = e.EmployeeId
	)
ORDER BY EmployeeId
```

<br>

## **FROM 사용하기**

- FROM 에도 서브쿼리 사용 가능
- 쿼리와 서브쿼리를 사용해 조회된 결과를 하나의 테이블이나 조회할 대상으로 지정해 사용 가능

```sql
SELECT *
FROM (
	SELECT CustomerId
	FROM customers
	WHERE CustomerId < 10
	)
```