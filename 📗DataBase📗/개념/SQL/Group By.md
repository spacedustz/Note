## 💡 Group By

Group By는 보통 Count, Max Min Sum Avg 함수화 함께 사용되며, 결과 집합을 하나 이상의 열로 그룹화 한다.

즉, 데이터를 원하는 그릅으로 나눌 수 있다.

나누고자 하는 그룹의 컬럼명을 Select과 Group By 뒤에 추가하면 된다.

집계함수와 함께 사용되는 상수는 Group By문에 추가하지 않아도 된다. (중요)

```sql
SELECT column_name(s)
FROM table_name
WHERE condition
GROUP BY column_name(s)
ORDER BY column_name(s)
```

<br>

### Group By 예시

각 국가의 고객 수를 반환한다.

```sql
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country;
```

<br>

각 국가의 고객 수를 높은 순서대로 나열

```sql
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
ORDER BY COUNT(CustomerID) DESC;
```

<br>

### Join을 사용한 Group By 에시

각 배송업체가 보낸 주문의 수를 나열한다.

```sql
SELECT Shippers.ShipperName, COUT(Orders.OrderID) AS NumberOfOrders
FROM Orders
LEFT JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
GROUP BY ShipperName;
```

