## 💡 Join

두 개 이상의 테이블 사이의 컬럼을 기반으로 행을 결합하는데 사용한다.

<br>

### 다양한 유형의 SQL Join

- (INNER) JOIN : 두 테이블 간 일치하는 값이 있는 레코드 반환
- LEFT (OUTER) JOIN : 왼쪽 테이블의 모든 레코드를 반환하고 오른쪽 테이블의 일치하는 레코드 반환
- RIGHT (OUTER) JOIN : 오른쪽 테이블의 모든 레코드를 반환하고 왼쪽 테이블의 일치하는 레코드 반환
- FULL (OUTER) JOIN : 왼쪽 또는 오른쪽 테이블에 일치 항목이 있는 경우 모든 레코드 반환

![image-20230408103512817](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Join.png) 

<br>

### Sample Table

<br>

**Orders 테이블**

| OrderID | CustomerID | OrderDate  |
| :------ | :--------- | :--------- |
| 10308   | 2          | 1996-09-18 |
| 10309   | 37         | 1996-09-19 |
| 10310   | 77         | 1996-09-20 |

<br>

**Customers 테이블**

| CustomerID | CustomerName                       | ContactName    | Country |
| :--------- | :--------------------------------- | :------------- | :------ |
| 1          | Alfreds Futterkiste                | Maria Anders   | Germany |
| 2          | Ana Trujillo Emparedados y helados | Ana Trujillo   | Mexico  |
| 3          | Antonio Moreno Taquería            | Antonio Moreno | Mexico  |

<br>

### 예시

Order 테이블의 CustomerID 컬럼은 Customers 테이블의 PK를 참조하는 FK이다.

INNER JOIN을 사용해서 두 테이블 간 일치하는 값이 있는 레코드를 선택하는 SQL문이다.

```sql
SELECT Orders.OrderId, Customers.CustomerName, Orders.OrderDate
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;
```

---

## 💡 Inner Join

두 테이블에서 일치하는 값이 있는 레코드를 반환한다.

```sql
SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name;
```

<br>

### 예시

Orders와 Customers 테이블 간 고객정보가 있는 모든 주문을 선택한다.

```sql
SELECT Orders.OrderID, Customers.CustomerName
FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID;
```

<br>

3개의 테이블 조인, Orders는 Customers와 Shippers의 PK를 FK로 가지고 있다.

```sql
SELECT Orders.OrderID, Customers.CustomerName, Shippers.ShipperName
FROM ((Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID)
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID);
```

---

## 💡 Left Join

왼쪽 테이블의 모든 레코드와 오른쪽 테이블의 일치하는 레코드를 반환한다.

```sql
SELECT column_name(s)
FROM table1
LEFT JOIN table2
ON table1.colomn_name = table2.column_name;
```

<br>

### 예시

Customers 테이블 (왼쪽)의 모든 레코드와 Orders 테이블의 일치 항목을 반환한다.

참고 : 만약 오른쪽 테이블에 일치 항목이 없더라도 왼쪽 테이블의 모든 레코드를 반환한다.

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
ORDER BY Customers.CustomerName;
```

---

## 💡 Right Join

오른쪽 테이블의 모든 레코드와 왼쪽 테이블의 일치하는 레코드를 반환한다.

```sql
SELECT column_name(s)
FROM table1
RIGHT JOIN table2
ON table1.column_name = table2.column_name;
```

<br>

### 예시

Orders 테이블 (왼쪽) 의 일치하는 레코드와 Employees 테이블(오른쪽)의 모든 레코드를 반환한다.

참고 : 만약 왼쪽 테이블에 일치 항목이 없더라도 오른쪽 테이블의 모든 레코드를 반환한다.

```sql
SELECT Orders.OrderID, Employees.LastName, Employees.FirstName
FROM Orders
RIGHT JOIN Employees ON Orders.EmployyeID = Employees.EmployeeID
ORDER BY Orders.OrderID;
```

---

## 💡 Full (Outer) Join

왼쪽과 오른쪽 테이블 레코드에 일치 항목이 있는 경우 모든 레코드를 반환한다.

참고 : Full Join은 잠재적으로 매우 큰 결과 집합을 반환할 수 있다.

```sql
 SELECT column_name(s)
 FROM table1
 FULL OUTER JOIN table2
 ON table1.column_name = table2.column_name
 WHERE condition;
```

<br>

### 예시

CustomerName을 기준으로 Customers와 Orders의 일치하는 레코드를 전부 반환한다.

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
ORDER BY Customers.CustomerName;
```

---

## 💡 Self Join

1개의 테이블에 가상으로 n개의 별칭을 부여하여 n개의 테이블로 간주한 뒤 Self Join한다.

1개의 컬럼 내에 섞여있는 여러 레코드들을 다른 컬럼을 통해서 관계를 알 수 있는 모습으로 조회 가능.

```sql
SELECT Alias1.컬럼명, Alias2.컬럼명
FROM table1 Alias1, table table2 Alias2
WHERE Alias1.컬럼명 = Alias2.컬럼명;
```

<br>

### 예시

Customers 테이블의 City를 기준으로 CustomerName을 A와 B로 나눠서 조인한다.

```sql
SELECT A.CustomerName AS CustomerName1, B.CustomerName AS CustomerName2, A.City
FROM Customers A, Customers B
WHERE A.CustomerID <> B.CustomerID
AND A.City = B.City
ORDER BY A.City;
```

