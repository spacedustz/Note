## 💡 Count() & Avg() & Sum()

Count는 ()안에 지정된 컬럼의 수를 반환한다.

Avg는 ()안에 지정된 컬럼의 평균 값을 반환한다.

Sum은 ()안에 지정된 컬럼의 총 합계를 반환한다.

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

모든 제품의 개수를 찾는다.

```sql
SELECT COUNT(ProductID)
FROM Products;
```

<br>

모든 제품 값의 평균 가격을 찾는다.

```sql
SELECT AVG(Price)
FROM Products;
```

<br>

OrderDetails 테이블의 Quantity 필드의 합계를 찾는다.

참고 : Null 값은 무시한다.

```sql
SELECT SUM(Quantity)
FROM OrderDetails;
```

