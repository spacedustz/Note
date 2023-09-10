## 💡 Stored Procedure

쿼리문들의 집합으로, 어떤 동작을 여러쿼리를 거쳐 일괄적으로 처리할 때 사용한다.

만들어놓은 SQL문을 저장하고 필요할 때마다 호출해서 사용하는 방식이다.

<br>

### 사용이유

**성능 향상**

- SP를 처음 실행하면 최적화, 컴파일 단계르 거쳐 결과가 캐시에 저장된다.
- 이후 해당 SP를 실행하면 캐시에 있는 쿼리를 가져와 사용하므로 속도가 빠르다.
- 그렇기 때문에 일반 쿼리를 반복하는 것보다 SP를 사용하는게 성능 측면에서 좋다.

<br>

**유지보수 및 재활용**

- C#, Java 등으로 만들어진 프로그램에서 직접 SQL 쿼리를 호출하지 않고,
   SP 이름을 호출하도록 설정하는 경우가 많다.
- 이 때, 개발자는 수정사항 발생 시 코드 내 SQL문을 건드리는게 아니라 SP 파일만 수정한다.
- 즉 한번 SP를 생성해놓으면, 언제든 실행이 가능하기 때문에 재활용성도 좋다.

<br>

**보안성**

- 사용자별로 테이블에 권한을 주는것이 아닌, SP에만 접근권한을 주는 방식을 사용한다.
- 실제 테이블에 권한을 주는것보다 당연하게도 SP에만 권한을 주는것이 보안측면에서 좋다.

<br>

**네트워크 부하**

- 클라이언트에서 서버로 쿼리의 모든 텍스트가 전송될 경우 큰 부하가 발생한다.
- 하지만 SP는 SP의 이름, 파라미터 등 몇글자만 전송하면 되므로 트래픽을 줄일 수 있다.

<br>

### 기본 구조

```sql
-- 생성
CREATE PROCEDURE procedure_name
AS
	sql_statement
GO;

-- 실행
EXEC procedure_name;
```

---

### 예시

일반적인 생성 & 실행 예시

```sql
-- 생성
CREATE PROCEDURE SelectAllCustomers
AS
	SELECT * FROM Customers
GO;

-- 실행
EXEC SelectAllCustomers;
```



아래 쿼리를 보면 Stored Procedure를 사용하지 않았을떄의 where 조건 값은,

글자 하나라도 틀리면 다른 쿼리로 인식하기 때문에 세 쿼리 모두 다른 것으로 인식한다.

때문에 매번 최적화와 컴파일을 다시 수행해야한다.

<br>

Stored Procedure를 이용하면 이름1을 검색하는 과정에서만 최적화 및 컴파일을 수행한다.

나머지는 메모리(캐시)에 있는것을 사용하므로 수행 시간이 훨씬 빠르다.

```sql
-- Stored Procedure 사용 X
SELECT * FROM user WHERE name = '이름1';
SELECT * FROM user WHERE name = '이름2';
SELECT * FROM user WHERE name = '이름3';

-- Stored Procedure 사용
CREATE PROCEDURE select_name 
	@Name NVARCHAR(3)
AS
	SELECT * FROM user WHERE name =@name;
GO;

EXEC select_name '이름1';
EXEC select_name '이름2';
EXEC select_name '이름3';
```

---

### 문제점

앞서 말한것처럼 SP를 수행할때 최적화를 한다고 했다.

<br>

최적화 단계에서 인덱스를 사용할지 안할지 결정하게 되는데,
인덱스를 사용한다고 항상 수행결과가 빨리지지는 않는다.

<br>

만약 가져올 데이터가 엄청 많다면 인덱스를 사용할때 오히려 느려지게 될 것이다.

<br>

즉, 첫번째 수행 시 최적화가 이루어질때 인덱스 사용여부가 결정되어 버린다.

만약 첫번째 수행때 데이터를 몇건만 가져오도록 파라미터가 설정되어 있다면,
인덱스를 사용하도록 최적화되어 컴파일 되었을 것이다.

<br>

이 때, 두번째 수행에서 많은 건수의 데이터를 가져오도록 파라미터가 세팅되었을때,

일반 쿼리문이라면 파라미터가 달라졌으니 다시 최적화 & 컴파일이 진행되겠지만,

SP는 그냥 인덱스를 사용하는 SP를 실행시켜 버린다.

<br>

이를 방지하기 위해선 SP를 재컴파일 해줘야한다.

재컴파일에는 몇가지 방법이 있는데 자주 사용하는 방식으로 예시를 들어보자.

보통 인덱스 사용여부가 확실하지 않다면 SP를 생성하는 시점에서,
아예 실행 시 마다 다시 컴파일되도록 설정한다.

<br>

#### SP 재컴파일

```sql
DROP PROCEDURE sp_test
GO

CREATE PROCEDURE sp_test
	[파라미터]
WITH RECOMPILE
AS
	[쿼리문]
GO;
```

