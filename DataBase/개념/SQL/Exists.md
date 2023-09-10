## 💡 Exists

하위 쿼리에 레코드가 있는지 테스트하는 데 사용된다.

Exists 하위 쿼리가 하나 이상의 레코드를 반환하면 True를 반환한다.

<br>

### Sample Table

Products 테이블

| ProductID | ProductName                  | SupplierID | CategoryID | Unit                | Price |
| :-------- | :--------------------------- | :--------- | :--------- | :------------------ | :---- |
| 1         | Chais                        | 1          | 1          | 10 boxes x 20 bags  | 18    |
| 2         | Chang                        | 1          | 1          | 24 - 12 oz bottles  | 19    |
| 3         | Aniseed Syrup                | 1          | 2          | 12 - 550 ml bottles | 10    |
| 4         | Chef Anton's Cajun Seasoning | 2          | 2          | 48 - 6 oz jars      | 22    |
| 5         | Chef Anton's Gumbo Mix       | 2          | 2          | 36 boxes            | 21.35 |

<br>

Suppliers 테이블

| SupplierID | SupplierName               | ContactName      | Address                   | City        | PostalCode | Country |
| :--------- | :------------------------- | :--------------- | :------------------------ | :---------- | :--------- | :------ |
| 1          | Exotic Liquid              | Charlotte Cooper | 49 Gilbert St.            | London      | EC1 4SD    | UK      |
| 2          | New Orleans Cajun Delights | Shelley Burke    | P.O. Box 78934            | New Orleans | 70117      | USA     |
| 3          | Grandma Kelly's Homestead  | Regina Murphy    | 707 Oxford Rd.            | Ann Arbor   | 48104      | USA     |
| 4          | Tokyo Traders              | Yoshi Nagase     | 9-8 Sekimai Musashino-shi | Tokyo       | 100        | Japan   |

<br>

### 예시

제품 가격이 20 미만인 Supplier를 반환한다.

```sql
SELECT SupplierName
FROM Suppliers
WHERE EXISTS 
(SELECT ProductName 
 FROM Products 
 WHERE Products.SupplierID = Suppliers.SupplierID 
 AND Price < 20);
```

<br>

제품 가격이 22인 Supplier를 반환한다.

```sql
SELECT SupplierName
FROM Suppliers
WHERE EXISTS
(SELECT ProductName
FROM Products
WHERE Products.SupplierID = Suppliers.SupplierID
AND Price = 22);
```

