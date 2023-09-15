## **💡 Schema Design**

Teachers : Classes = 1:N의관계 / Classes : Students = N:N의 관계

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Schema.png) 

- Schema = 데이터베이스에서 데이터가 구성되는 방식과 서로 다른 엔티티간의 관계에 대한 설명
- Entity = 테이블(객체와 같은 개념)
- Record = 테이블에 저장된 요소, 행렬로 치면 행(row)으로 볼수있다
- Column = 열
- tuple = 행

<br>

### **1:1 관계의 데이터 정렬 방식**

각 전화번호가 단 1명의 유저와 1:1로 매칭됨, 그 반대도 동일하다면 1:1관계라고 할 수 있음

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Schema2.png)

<br>

### **1:N 관계의 데이터 정렬 방식**

Teacher테이블의 Classes 컬럼을 Classes의 **primary key**(ID)를 참조하면 ClassID는 **foreign key**라고 불린다.

- 만약 Teacher의 Classes에 여러 값을 저장하면, 상수 시간(constant-time)에 대한 검색 손실이 발생함
- 그럼 여러 값이 아닌 1개씩 저장한다고해도, 교사가 이름을 바꾼다면 모든 데이터를 업데이트해야함
- Classes테이블에 TeacherID 컬럼을 추가하여 1개씩 저장하는게 최선의 방법

<br>

### **N:N의 관계의 데이터 정렬 방식**

위와 같은 예시로 Classes에 여러 Student의 primary key를 넣는건 좋지 않은 방법

- 그럼 이번에도 위 처럼 Student에 Classes를 넣는 방식은? 불가능 N:N의 관계이기 때문
- 수업과 학생이 교차하는 점을 좌표계와 비슷한 형태로 나타냄, 예를들면 (4, 3) 처럼 아래 그림과 같이 설계함
  그럼 맨처음 그림에서 Classes와 Student 사이에는 Join테이블을 생성해야 한다

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Schema3.png)

<br>

### **자기참조 관계 (Self Referencing Relationship)**

예를 들어 추천인 입력을 생각해보자

recommend_id가 user_id와 연결된 상태

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Schema4.png) 

------

## **💡 SQL 내장함수**

### **그룹화**

```sql
SELECT * FROM customers;  ↓ 
SELECT * FROM customers GROUP BY State;
```

<br>

### **HAVING - 그룹화된 결과 필터링**

```sql
# 이 쿼리는 모든 고객의 주문서에서 가격의 평균을 구한 뒤에, 그 평균이 6.00을 넘는 결과만 조회
# WHERE과 적용방식이 달라서 필터링을 해야한다면 그룹화 전에 WHERE로 미리 해주는게 좋다
SELECT CustomerId, AVG(Total) FROM Invoices GROUP BY CustomerId HAVING AVG(Total) > 6.00
```

이 쿼리는 모든 고객의 주문서에서 가격의 평균을 구한 뒤에, 그 평균이 6.00을 넘는 결과만 조회

WHERE과 적용방식이 달라서 필터링을 해야한다면 **그룹화 전에** WHERE로 미리 해주는게 좋다

<br>

### **COUNT() - 레코드 개수 세기**

모든 레코드에 대한 COUNT 함수 사용 예시

결과값 = 각 그룹의 첫번째 레코드, 각 그룹의 레코드 갯수 집혜 후 리턴

```sql
# 모든 레코드에 대한 COUNT 함수 사용 예시
# 결과값 = 각 그룹의 첫번째 레코드, 각 그룹의 레코드 갯수 집혜 후 리턴
SELECT *, COUNT(*) FROM customers GROUP BY State;
```



```sql
# 그룹으로 묶인 결과의 레코드 개수 확인
SELECT State, COUNT(*) FROM customers GROUP BY State;
```

<br>

### **SUM() - 레코드의 합 리턴**

```sql
# invoice_items 테이블에서 InvoiceId 필드를 기준으로 그룹하고, UnitPrice 필드 값의 합을 구함
SELECT InvoiceId, SUM(UnitPrice) FROM invoice_items GROUP BY InvoiceId;
```

<br>

### **AVG() - 레코드의 평균값 계산**

```sql
SELECT TrackId, AVG(UnitPrice) FROM invoice_items GROUP BY TrackId;
```

<br>

### **MAX(), MIN()**

```sql
# 각 고객의 지불 최소 금액
SELECT CustomerID, MIN(Total) FROM invoices GROUP BY CustomerId;
```

<br>

### **SELECT의 실행 순서**

- **FROM invoices -** invoices 테이블에 접근
- **WHERE CustomerId >= 10** **-** CustomerId 필드가 10 이상인 레코드 조회
- **GROUP BY CustomerId -** CustomerId를 기준으로 그룹화
- **HAVING SUM(Total) >= 30 -** Total 필드의 총합이 3- 이상인 결과들만 필터링
- **SELECT CustomerId, AVG(Total) -** 조회된 결과에서 CustomerId필드와 Total필드의 평균값을 구함
- **ORDER BY 2 -** AVG(Total) 필드를 기준으로 오름차순 정렬한 결과 리턴

```sql
SELECT CustomerId, AVG(Total)
FROM invoices
WHERE CustomerId >= 10
GROUP BY CustomerId
HAVING SUM(Total) >= 30
ORDER BY 2;
```