## 💡 And & Or & Not

And, Or, Not은 Where과 결합할 수 있다.

And, Or는 둘 이상의 조건을 기반으로 레코드를 필터링 하며,
Not은 조건이 True가 아닌경우 레코드를 표시한다.

- And는 모든 조건이 True인 경우 레코드를 표시한다.
- Or는 구분된 조건 중 하나라도 True이면 레코드를 표시한다.
- Not은 조건이 True가 아닌 경우 레코드를 표시한다.

<br>

### Sample Table

| CustomerID | CustomerName                       | ContactName        | Address                       | City        | PostalCode | Country |
| :--------- | :--------------------------------- | :----------------- | :---------------------------- | :---------- | :--------- | :------ |
| 1          | Alfreds Futterkiste                | Maria Anders       | Obere Str. 57                 | Berlin      | 12209      | Germany |
| 2          | Ana Trujillo Emparedados y helados | Ana Trujillo       | Avda. de la Constitución 2222 | México D.F. | 05021      | Mexico  |
| 3          | Antonio Moreno Taquería            | Antonio Moreno     | Mataderos 2312                | México D.F. | 05023      | Mexico  |
| 4          | Around the Horn                    | Thomas Hardy       | 120 Hanover Sq.               | London      | WA1 1DP    | UK      |
| 5          | Berglunds snabbköp                 | Christina Berglund | Berguvsvägen 8                | Luleå       | S-958 22   | Sweden  |

---

### 기본 형식

And

```sql
SELECT column1, column2
FROM table_name
WHERE condition1
AND condition2
AND condition3 ...;
```

<br>

Or

```sql
SELECT column1, column2
FROM table_name
WHERE condition1
OR condition2
OR condition3 ...;
```

<br>

Not

```sql
SELECT column1, column2
FROM table_name
WHERE NOT condition;
```

---

### 예시

**And 예시**

국가가 Germany이고 도시가 Berlin인 고객의 모든 레코드 선택

```sql
SELECT *
FROM Customers
WHERE Country = 'Germany'
AND City = 'Berlin';
```

<br>

**Or 예시**

도시가 Berlin 또는 Munchen인 Customers의 모든 레코드 선택

```sql
SELECT *
FROM Customers
Where City = 'Berlin'
OR City = "Munchen";
```

국가가 Germany 또는 Spain인 고객의 모든 레코드 선택

```sql
SELECT *
FROM Customers
WHERE Country = 'Germany'
OR Country = 'Spain';
```

<br>

**Not 예시**

국가가 Germany가 아닌 고객의 모든 레코드 선택

```sql
SELECT *
FROM Customers
WHERE NOT Country = 'Germany';
```

---

### And, Or, Not 결합 예시

국가가 Germany이고 도시가 Berlin 또는 Munchen인 고객의 모든 레코드 선택

```sql
SELECT *
FROM Customers
WHERE Country = 'Germany'
AND (City = 'Berlin' OR City = 'Munchen');
```

국가가 Germany 및 USA가 아닌 고객의 모든 레코드 선택

```sql
SELECT *
FROM Customers
WHERE NOT Country='Germany'
AND NOT Country = 'USA';
```

