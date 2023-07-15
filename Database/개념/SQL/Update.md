## 💡 Update

테이블의 레코드를 수정하는데 사용한다

아래는 기본형식이며 **WHERE절에 주목**해야 한다.

WHERE로 조건을 지정 안해주면 테이블의 모든 레코드가 업데이트 되어 버린다.

```sql
UPDATE table_name
SET column1 = value1, column2 = value2 ...
WHERE condition
```

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

### 예시

테이블의 1번째 고객의 ContactName, City를 업데이트 한다.

```sql
UPDATE Customers
SET ContactName = 'Alfred Schmidt', City = 'Frankfurt'
WHERE CustomeerID = 1;
```

<br>

여러 레코드 업데이트

국가가 Mexico인 모든 레코드의 ContactNama을 Juan으로 업데이트 한다.

```sql
UPDATE Customers
SET ContactName = 'Juan'
WHERE Country = 'Mexico';
```

