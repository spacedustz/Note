## 💡 Any & All

Any & All 함수는 주로 서브쿼리에서 사용하는 다중 행 연산자이다.

Any는 조건을 만족하는 값이 하나라도 있다면 결과를 반환한다.

All은 모든 조건을 만족하는 결과를 리턴한다.

<br>

### Sample Table

<br>

Products 테이블

| ProductID | ProductName                     | SupplierID | CategoryID | Unit                | Price |
| :-------- | :------------------------------ | :--------- | :--------- | :------------------ | :---- |
| 1         | Chais                           | 1          | 1          | 10 boxes x 20 bags  | 18    |
| 2         | Chang                           | 1          | 1          | 24 - 12 oz bottles  | 19    |
| 3         | Aniseed Syrup                   | 1          | 2          | 12 - 550 ml bottles | 10    |
| 4         | Chef Anton's Cajun Seasoning    | 2          | 2          | 48 - 6 oz jars      | 22    |
| 5         | Chef Anton's Gumbo Mix          | 2          | 2          | 36 boxes            | 21.35 |
| 6         | Grandma's Boysenberry Spread    | 3          | 2          | 12 - 8 oz jars      | 25    |
| 7         | Uncle Bob's Organic Dried Pears | 3          | 7          | 12 - 1 lb pkgs.     | 30    |
| 8         | Northwoods Cranberry Sauce      | 3          | 2          | 12 - 12 oz jars     | 40    |
| 9         | Mishi Kobe Niku                 | 4          | 6          | 18 - 500 g pkgs.    | 97    |

<br>

OrderDetails 테이블

| OrderDetailID | OrderID | ProductID | Quantity |
| :------------ | :------ | :-------- | :------- |
| 1             | 10248   | 11        | 12       |
| 2             | 10248   | 42        | 10       |
| 3             | 10248   | 72        | 5        |
| 4             | 10249   | 14        | 9        |
| 5             | 10249   | 51        | 40       |
| 6             | 10250   | 41        | 10       |
| 7             | 10250   | 51        | 35       |
| 8             | 10250   | 65        | 15       |
| 9             | 10251   | 22        | 6        |
| 10            | 10251   | 57        | 15       |

<br>

### 예시

OrderDetails 테이블에서 Quantity가 10인 레코드를 찾으면 ProductName을 반환한다.

True 반환

```sql
SELECT ProductName
FROM Products
WHERE ProductID = ANY(
    SELECT ProductID 
    FROM OrderDetails 
    WHERE Quantity = 10);
```

<br>

OrderDetails 테이블에서 Quantity가 99보다 큰 레코드가 있으면 ProductName을 반환한다.

True 반환

```sql
SELECT ProductName
FROM Products
WHERE ProductID = ANY(
    SELECT ProductID 
    FROM OrderDetails 
    WHERE Quantity > 99);
```

<br>

OrderDetails 테이블에서 Quantity가 1000보다 큰 레코드가 있으면 ProductName 반환한다.

False 반환

```sql
SELECT ProductName
FROM Products
WHERE ProductId = ANY(
    SELECT ProductId 
    FROM OrderDetails 
    WHERE Quantity > 1000);
```

<br>

OrderDetails 테이블에 있는 모든 레코드의 Quantity가 10인 경우 ProductName을 반환한다.

제품의 수량이 전부 10이 아니므로 False 반환

```sql
SELECT ProductName
FROM Products
WHERE ProductId = ALL(
    SELECT ProductId 
    FROM OrderDetails 
    WHERE Quantity = 10);
```

