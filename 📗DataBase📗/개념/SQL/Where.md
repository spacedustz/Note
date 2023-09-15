## **💡 Where**

레코드를 필터링 하는데 사용, 지정된 조건을 충족하는 레코드만 추출하는데 사용한다.

```sql
SELECT column1, column2
FROM table_name
WHERE condition;
```

<br>

### **Sample Table**

| CustomerID | CustomerName                       | ContactName        | Address                       | City        | PostalCode | Country |
| ---------- | ---------------------------------- | ------------------ | ----------------------------- | ----------- | ---------- | ------- |
| 1          | Alfreds Futterkiste                | Maria Anders       | Obere Str. 57                 | Berlin      | 12209      | Germany |
| 2          | Ana Trujillo Emparedados y helados | Ana Trujillo       | Avda. de la Constitución 2222 | México D.F. | 05021      | Mexico  |
| 3          | Antonio Moreno Taquería            | Antonio Moreno     | Mataderos 2312                | México D.F. | 05023      | Mexico  |
| 4          | Around the Horn                    | Thomas Hardy       | 120 Hanover Sq.               | London      | WA1 1DP    | UK      |
| 5          | Berglunds snabbköp                 | Christina Berglund | Berguvsvägen 8                | Luleå       | S-958 22   | Sweden  |

<br>

### **예시**

국가가 Mexico인 모든 레코드 선택

```sql
SELECT *
FROM Customers
WHERE Country='Mexico';
```

국가가 Berlin이 아닌 모든 레코드 선택

```sql
SELECT *
FROM Customers
WHERE NOT City='Berlin'
```

CustomerID가 32인 레코드 선택

```sql
SELECT *
FROM Customers
WHERE CustomerID = 32;
```

City가 Berlin이고 PostalCode가 12209인 모든 레코드 선택

```sql
SELECT *
FROM Customers
WHERE City = 'Berlin'
AND PostalCode = 12209;
```

City가 Berlin 이거나 London인 모든 레코드 선택

```sql
SELECT *
FROM Customers
WHERE City = 'Berlin'
OR City = 'London';
```

<br>

### **Where의 연산자**

| Operator | Description                                                  | Example                                                      |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| =        | Equal                                                        | [Try it](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_equal_to) |
| >        | Greater than                                                 | [Try it](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_greater_than) |
| <        | Less than                                                    | [Try it](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_less_than) |
| >=       | Greater than or equal                                        | [Try it](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_greater_than2) |
| <=       | Less than or equal                                           | [Try it](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_less_than2) |
| <>       | Not equal. **Note:** In some versions of SQL this operator may be written as != | [Try it](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_not_equal_to) |
| BETWEEN  | Between a certain range                                      | [Try it](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_between) |
| LIKE     | Search for a pattern                                         | [Try it](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_like) |
| IN       | To specify multiple possible values for a column             | [Try it](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_in) |