## 💡 Alias

테이블의 열에 별칭을 지정하는데 사용하며, 쿼리가 살아있는 동안에만 적용된다.

```sql
/* 컬럼 alias */
SELECT colemn_name AS alias_name
FROM table_name;
```

```sql
/* 테이블 alias */
SELECT column_name(s)
FROM table_name AS alias_name;
```

<br>

### Sample Table

Customers

| CustomerID | CustomerName                       | ContactName    | Address                       | City        | PostalCode | Country |
| :--------- | :--------------------------------- | :------------- | :---------------------------- | :---------- | :--------- | :------ |
| 2          | Ana Trujillo Emparedados y helados | Ana Trujillo   | Avda. de la Constitución 2222 | México D.F. | 05021      | Mexico  |
| 3          | Antonio Moreno Taquería            | Antonio Moreno | Mataderos 2312                | México D.F. | 05023      | Mexico  |
| 4          | Around the Horn                    | Thomas Hardy   | 120 Hanover Sq.               | London      | WA1 1DP    | UK      |

<br>

Orders

| OrderID | CustomerID | EmployeeID | OrderDate  | ShipperID |
| :------ | :--------- | :--------- | :--------- | :-------- |
| 10354   | 58         | 8          | 1996-11-14 | 3         |
| 10355   | 4          | 6          | 1996-11-15 | 1         |
| 10356   | 86         | 6          | 1996-11-18 | 2         |

<br>

### 예시

**CustomerId와 CustomerName 컬럼에 각각 하나씩 별칭 생성**

```sql
SELECT CustomerID AS ID, CUstomerName AS Customer
FROM Customers;
```

<br>

**별칭에 공백이 포함된 경우 " " 또는 [ ] 필요**

```sql
SELECT CustomerID AS ID, CUstomerName AS [Customer Person]
FROM Customers;
```

<br>

**4개의 컬럼을 묶어서 하나의 Address 별칭으로 생성**

```sql
SELECT CustomerName, Address + ', ' + PostalCode + ' ' + City + ', ' Country AS Address
FROM customers;
```

위의 예시의 Mysql 사용법

```sql
SELECT CustomerName, CONCAT(Address,', ',PostalCode,', ',City,',',Country) AS Address
FROM Customers
```

<br>

**CustomerID가 4 (Around the Horn)인 고객의 모든 주문을 선택.**

Order = o , Customers = c 별칭을 사용

<br>

별칭 미사용 예시

```sql
SELECT Orders.OrderID, Orders.OrderDate, Customers,CustomerName
FROM Customers, Orders
WHERE Customers.CustomerName = 'Around the Horn' AND
Customers.CustomerID = Orders.CustomerID;
```

<br>

별칭 사용 예시

```sql
SELECT o.OrderID, o.OrderDate, c.CustomerName
FROM Customers AS c, Orders AS o
WHERE c.CustomerName = 'Around the Horn' AND
c.CustomerID = o.CustomerID;
```

