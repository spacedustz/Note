## **💡 Select**

데이터베이스에서 데이터를 선택하는데 사용

```sql
SELECT column1, column2
FROM table_name;
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

CustomerName과 City 열을 선택

```sql
SELECT CustomerName, City
FROM Customers;
```

City 열을 선택

```sql
SELECT City
FROM Customers;
```

------

## **💡 Select Distinct**

중복된 데이터를 제거한 값만 반환할때 사용

```sql
SELECT DISTINCT column1, column2
FROM table_name;
```

<br>

### **예시**

Country 열에서 중복된 값을 제거한 값들만 반환

```sql
SELECT DISTINCT Country
FROM Customers;
```

서로 다른(구별된) 고객 국가의 수 반환

```sql
SELECT COUNT(DISTINCT Country)
FROM Customers;
```