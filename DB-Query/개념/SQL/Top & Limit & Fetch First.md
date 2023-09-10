## 💡 Top & Limit & Fetch First

Top은 반환할 레코드 수를 지정하는 데 사용하며, 수천개의 레드코드 있는 대형 테이블에 유용하다.

참고: 모든 DB에서 Select Top을 지원하는 것은 아니다.

<br>

**SQL Server**

```sql
SELECT TOP number|percent column_name(s)
FROM table_name
WHERE condition;
```

<br>

**MySQL**

```sql
SELECT column_name(s)
FROM table_name
WHERE condition
LIMIT number;
```

<br>

**Oracle12**

```sql
SELECT column_name(s)
FROM table_name
ORDER BY column_name(s)
FETCH FIRST number ROWS ONLY;
```

---

### Sample Table

| CustomerID | CustomerName                       | ContactName        | Address                       | City        | PostalCode | Country |
| :--------- | :--------------------------------- | :----------------- | :---------------------------- | :---------- | :--------- | :------ |
| 1          | Alfreds Futterkiste                | Maria Anders       | Obere Str. 57                 | Berlin      | 12209      | Germany |
| 2          | Ana Trujillo Emparedados y helados | Ana Trujillo       | Avda. de la Constitución 2222 | México D.F. | 05021      | Mexico  |
| 3          | Antonio Moreno Taquería            | Antonio Moreno     | Mataderos 2312                | México D.F. | 05023      | Mexico  |
| 4          | Around the Horn                    | Thomas Hardy       | 120 Hanover Sq.               | London      | WA1 1DP    | UK      |
| 5          | Berglunds snabbköp                 | Christina Berglund | Berguvsvägen 8                | Luleå       | S-958 22   | Sweden  |

---

### 예시

**처음 3개의 레코드 선택**

SQL Server

```sql
SELECT TOP 3 *
FROM Customers;
```

<br>

MySQL

```sql
SELECT *
FROM Customers
LIMIT 3;
```

<br>

Oracle

```sql
SELECT *
FROM Customers
FETCH FIRST 3 ROWS ONLY;
```

---

**테이블의 레코드 중 처음 50% 선택**

SQL Server

```sql
SELECT TOP 50 PERCENT * 
FROM Customers;
```

<br>

Oracle

```sql
SELECT *
FROM Customers
FETCH FIRST 50
PERCENT ROWS ONLY;
```

---

**국가가 Germany인 처음 3개의 레코드 선택**

SQL Server

```sql
SELECT TOP 3 *
FROM Customers
WHERE Country = 'Germany';
```

<br>

MySQL

```sql
SELECT *
FROM Customers
WHERE Country = 'Germany'
LIMIT 3;
```

<br>

Oracle

```sql
SELECT *
FROM Customers
WHERE Country = 'Germany'
FETCH FIRST 3 ROWS ONLY;
```

