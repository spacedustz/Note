## 💡 Having

Where문에서 집계함수를 사용할 수 없어서 만들어졌다.

집계 함수를 가지고 조건비교를 할 때 사용되며 Group By와 함께 사용된다.

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

| OrderID | CustomerID | EmployeeID | OrderDate  | ShipperID |
| :------ | :--------- | :--------- | :--------- | :-------- |
| 10248   | 90         | 5          | 1996-07-04 | 3         |
| 10249   | 81         | 6          | 1996-07-05 | 1         |
| 10250   | 34         | 4          | 1996-07-08 | 2         |

<br>

| EmployeeID | LastName  | FirstName | BirthDate  | Photo      | Notes                       |
| :--------- | :-------- | :-------- | :--------- | :--------- | :-------------------------- |
| 1          | Davolio   | Nancy     | 1968-12-08 | EmpID1.pic | Education includes a BA.... |
| 2          | Fuller    | Andrew    | 1952-02-19 | EmpID2.pic | Andrew received his BTS.... |
| 3          | Leverling | Janet     | 1963-08-30 | EmpID3.pic | Janet has a BS degree....   |

<br>

### 예시

각 국가의 고객 수를 나열하며, 고객이 5명 이상인 국가만 포함한다.

```sql
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerId) > 5;
```

<br>

위의 예시의 내림차순

```sql
SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerId) > 5
ORDER BY COUNT(CustomerID) DESC;
```

<br>

10개 이상의 주문을 등록한 직원을 반환한다.

```sql
SELECT Employees.LastName, COUNT(Orders.OrderID) AS NumberOfOrders
FROM (Orders
INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID)
GROUP BY LastName
HAVING COUNT(Orders.OrderID) > 10;
```

<br>

직원 "Davolio" 또는 "Fuller"가 25개 이상의 주문을 등록했는지 여부를 반환한다.

```sql
SELECT Employees.LastName, COUNT(Orders.OrderID) AS NumberOfOrders
FROM Orders(
INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID)
WHERE LastName = 'Davolio' OR LastName = 'Fuller'
GROUP BY LastName
HAVING COUNT(Orders.OrderID) > 25;
```

