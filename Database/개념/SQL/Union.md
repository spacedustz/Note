## 💡 Union

둘 이상의 SQL 명령문을 결합하는데 사용한다.

<br>

**Union 표현식**

- Union은 기본적으로 고유한 값만 선택한다.
- SELECT문과 UNION을 사용할 때는 무조건 같은 수의 컬럼이 있어야 한다.
- 컬럼은 비슷한 유형의 데이터 타입을 가져야 한다.
- 중복 값을 허용하려면 Union All을 사용한다.

```sql
SELECT column_name(s) FROM table1
UNION
SELECT column_name(s) FROM table2;
```

<br>

**Union All 표현식**

- 중복된 값까지 허용

```sql
SELECT column_name(s) FROM table1
UNION ALL
SELECT column_name(s) FROM table2;
```

<br>

### 예시

Customers, Suppliers 테이블의 도시(고유 값)를 반환한다.

참고 : 도시가 동일한 경우 고유값만 선택하기 때문에 중복값은 배제된다.

```sql
SELECT City FROM Customers
UNION
SELECT City FROM Suppliers
ORDER BY City;
```

<br>

중복 값을 포함한 도시 반환

```sql
SELECT City FROM Customers
UNION ALL
SELECT City FROM Suppliers
ORDER BY City;
```

<br>

Where를 사용한 Union

Customers, Suppliers 테이블에서 도시가 Germany인 컬럼만 반환

```sql
SELECT City, Country FROM Customers
WHERE Country='Germany'
UNION
SELECT City, Country FROM Suppliers
WHERE Country='Germany'
ORDER BY City;
```

<br>

중복 값을 포함한 도시 반환

```sql
SELECT City, Country FROM Customers
WHERE Country='Germany'
UNION ALL
SELECT City, Country FROM Suppliers
WHERE Country='Germany'
ORDER BY City;
```

