## 💡 Order By

결과 집합을 오름차순 & 내림차순으로 정렬하는데 사용한다.

Default는 오름차순 정렬이며, 내림차순 정렬은 DESC를 사용한다.

<br>

```sql
SELECT column1, column2
FROM table_name
ORDER BY column1, column2, ...
ASC|DESC;
```

<br>

### Sample Table

| CustomerID | CustomerName                       | ContactName        | Address                       | City        | PostalCode | Country |
| :--------- | :--------------------------------- | :----------------- | :---------------------------- | :---------- | :--------- | :------ |
| 1          | Alfreds Futterkiste                | Maria Anders       | Obere Str. 57                 | Berlin      | 12209      | Germany |
| 2          | Ana Trujillo Emparedados y helados | Ana Trujillo       | Avda. de la Constitución 2222 | México D.F. | 05021      | Mexico  |
| 3          | Antonio Moreno Taquería            | Antonio Moreno     | Mataderos 2312                | México D.F. | 05023      | Mexico  |
| 4          | Around the Horn                    | Thomas Hardy       | 120 Hanover Sq.               | London      | WA1 1DP    | UK      |
| 5          | Berglunds snabbköp                 | Christina Berglund | Berguvsvägen 8                | Luleå       | S-958 22   | Sweden  |

<br>

### 예시

Country 컬럼을 기준으로 Customers 테이블의 모든 레코드를 정렬한다.

```sql
SELECT *
FROM Customers
ORDER BY Country;
```

DESC를 이용한 내림차순 정렬

```sql
SELECT *
FROM Customers
ORDER BY Country DESC;
```

Country, CustomerName 컬럼을 기준으로 Customers테이블을 정렬하며,
국가가 동일한 경우 CustomerName으로 정렬한다.

```sql
SELECT *
FROM Customers
ORDER BY Country, CustomerName;
```

Country 컬럼을 오름차순 정렬, CustomerName 컬럼을 내림차순 정렬한다.

```sql
SELECT *
FROM Customers
ORDER BY Country ASC, CustomerName DESC;
```

