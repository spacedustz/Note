## 💡 Select Into

한 테이블의 데이터를 새 테이블로 복사할 때 사용한다.

<br>

### 기본 형식

```sql
SELECT *
INTO newtable [IN externaldb]
FROM oldtable
WHERE condition;
```

<br>

일부 열만 새 테이블에 복사

```sql
SELECT column1, column2, column3 ...
INTO newtable [IN externaldb]
FROM oldtable
WHERE condition;
```

<br>

### 예시

Customer의 백업본 생성

```sql
SELECT *
INTO CustomersBK
FROM Customers;
```

<br>

IN을 사용하여 데이블을 다른 데이터베이스의 새 테이블로 복사

```sql
SELECT *
INTO CustomerBK IN 'Backup.mdb'
FROM customers;
```

<br>

몇 개의 열만 새 테이블에 복사

```sql
SELECT CustomerName, ContactName INTO CustomerBK
FROM Customers;
```

<br>

국가가 독일인 고객만 새 테이블에 복사

```sql
SELECT *
INTO CustomerBK
FROM Customers
WHERE Country = 'Germany';
```

<br>

둘 이상의 테이블에서 새 테이블로 데이터를 복사

```sql
SELECT Customers.CustomerName, Orders.OrderID
INTO CustomerOrderBK
FROM Customerss
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;
```

---

## 💡 Insert Into Select

한 테이블에서 데이터를 복사하여 다른 테이블에 삽입한다.

소스 및 대상 테이블의 데이터 유형이 일치해야 함.

참고 : 테이블의 기존 레코드는 영향을 받지 않는다.

```sql
INSERT INTO table2
SELECT * FROM table1
WHERE condition
```

<br>

### Sample Table

Customer 테이블

| CustomerID | CustomerName                       | ContactName    | Address                       | City        | PostalCode | Country |
| :--------- | :--------------------------------- | :------------- | :---------------------------- | :---------- | :--------- | :------ |
| 1          | Alfreds Futterkiste                | Maria Anders   | Obere Str. 57                 | Berlin      | 12209      | Germany |
| 2          | Ana Trujillo Emparedados y helados | Ana Trujillo   | Avda. de la Constitución 2222 | México D.F. | 05021      | Mexico  |
| 3          | Antonio Moreno Taquería            | Antonio Moreno | Mataderos 2312                | México D.F. | 05023      | Mexico  |

<br>

Suppliers 테이블

| SupplierID | SupplierName               | ContactName      | Address        | City        | Postal Code | Country |
| :--------- | :------------------------- | :--------------- | :------------- | :---------- | :---------- | :------ |
| 1          | Exotic Liquid              | Charlotte Cooper | 49 Gilbert St. | Londona     | EC1 4SD     | UK      |
| 2          | New Orleans Cajun Delights | Shelley Burke    | P.O. Box 78934 | New Orleans | 70117       | USA     |
| 3          | Grandma Kelly's Homestead  | Regina Murphy    | 707 Oxford Rd. | Ann Arbor   | 48104       | USA     |

<br>

### 예시

Suppliers를 Customers로 복사한다. (데이터가 채워지지 않은 열은 Null이 포함된다.)

```sql
INSERT INTO Customers (CustomerName, City, Country)
SELECT SupplierName, City, Country FROM Suppliers;
```

<br>

Suppliers를 Customers로 복사한다. (모든 열 채우기)

```sql
INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
SELECT SupplierName, ContactName, Address, City, PostalCode, Country FROM Suppliers;
```

<br>

'독일' 공급업체만 Customers로 복사한다.

```sql
INSERT INTO Customers (CustomerName, City, Country)
SELECT SupplierName, City, Country FROM Suppliers
WHERE Country = 'Germany';
```

