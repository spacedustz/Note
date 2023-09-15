## 💡 Between 연산자

주어진 범위 내에서 값을 선택한다.

값은 숫자, 텍스트 또는 날짜일 수 있다.

연산자 Between은 포괄적이며 시작 값과 끝 값이 포함된다.

```sql
SELECT column_name(s)
FROM table_name
WHERE column_name BETWEEN value1 AND value2;
```

<br>

### Sample Table

| ProductID | ProductName                  | SupplierID | CategoryID | Unit                | Price |
| :-------- | :--------------------------- | :--------- | :--------- | :------------------ | :---- |
| 1         | Chais                        | 1          | 1          | 10 boxes x 20 bags  | 18    |
| 2         | Chang                        | 1          | 1          | 24 - 12 oz bottles  | 19    |
| 3         | Aniseed Syrup                | 1          | 2          | 12 - 550 ml bottles | 10    |
| 4         | Chef Anton's Cajun Seasoning | 1          | 2          | 48 - 6 oz jars      | 22    |
| 5         | Chef Anton's Gumbo Mix       | 1          | 2          | 36 boxes            | 21.35 |

<br>

### 숫자 값 예시

가격이 10에서 20 사이인 모든 제품을 선택한다.

```sql
SELECT *
FROM Products
WHERE Price BETWEEN 10 AND 20;
```

<br>

가격이 10에서 20 사이가 아닌 모든 제품을 선택한다.

```sql
SELECT *
FROM Products
WHERE Price NOT BETWEEN 10 AND 20;
```

<br>

가격이 10에서 20 사이인 모든 제품을 선택하고, CategoryID가 1,2 또는 3인 제품을 선택한다.

```sql
SELECT *
FROM Products
WHERE Price BETWEEN 10 AND 20
AND CategoryID NOT IN (1,2,3);
```

---

### 텍스트 값 예시

ProductName이 "Carnarvon Tigers"와 "Mozzarella di Giovanni" 컬럼 사이에 있는 모든 제품을 선택한다.

```sql
SELECT *
FROM Products
WHERE ProductName BETWEEN 'Carnarvon Tigers' AND 'Mozzarella di Giovanni'
ORDER BY ProductName;
```

<br>

ProductName이 "Carnarvon Tigers"와 "Chef Anton's Cajun Seasoning" 사이에 있는 모든 제품을 선택한다.

```sql
SELECT *
FROM Products
WHERE ProductName BETWEEN "Carnarvon Tigers" AND "Chef Anton's Cajun Seasoning"
ORDER BY ProductName;
```

<br>

ProductName이 Carnarvon Tigers와 Mozzarella di Giovanni 사이에 있지 않은 모든 제품을 선택한다.

```sql
SELECT *
FROM Products
WHERE ProductName NOT BETWEEN 'Carnarvon Tigers' AND 'Mozzarella di Giovanni'
ORDER BY ProductName;
```

---

### 날짜 값 예시

| OrderID | CustomerID | EmployeeID | OrderDate | ShipperID |
| :------ | :--------- | :--------- | :-------- | :-------- |
| 10248   | 90         | 5          | 7/4/1996  | 3         |
| 10249   | 81         | 6          | 7/5/1996  | 1         |
| 10250   | 34         | 4          | 7/8/1996  | 2         |
| 10251   | 84         | 3          | 7/9/1996  | 1         |
| 10252   | 76         | 4          | 7/10/1996 | 2         |

<br>

OrderDate가  '01-July-1996'과 '31-July-1996' 사이인 모든 주문을 선택한다.

```sql
SELECT *
FROM Orders
WHERE OrderDate BETWEEN #07/01/1996# AND #07/31/1996#;

// 또는

SELECT *
FROM Orders
WHERE OrderDate BETWEEN '1996-07-01' AND '1996-07-31';
```

