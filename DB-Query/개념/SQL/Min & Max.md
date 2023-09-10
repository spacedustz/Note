## 💡 Min() Max()

선택한 열의 가장 큰 & 작은 값 반환

```sql
SELECT MIN(column_name)
FROM table_name
WHERE condition;
```

```sql
SELECT MAX(column_name)
FROM table_name
WHERE condition;
```

<br>

### Sample Table

| ProductID | ProductName                  | SupplierID | CategoryID | Unit                | Price |
| :-------- | :--------------------------- | :--------- | :--------- | :------------------ | :---- |
| 1         | Chais                        | 1          | 1          | 10 boxes x 20 bags  | 18    |
| 2         | Chang                        | 1          | 1          | 24 - 12 oz bottles  | 19    |
| 3         | Aniseed Syrup                | 1          | 2          | 12 - 550 ml bottles | 10    |
| 4         | Chef Anton's Cajun Seasoning | 2          | 2          | 48 - 6 oz jars      | 22    |
| 5         | Chef Anton's Gumbo Mix       | 2          | 2          | 36 boxes            | 21.35 |

<br>

### 예시

가장 값이 작은 제품의 가격을 찾는다.

```sql
SELECT MIN(Price) AS SmallestPrice
FROM Products;
```

<br>

가장 값이 높은 제품의 가격을 찾는다.

```sql
SELECT MAX(Price) AS LargestPrice
FROM Products;
```

