## 💡 Delete

테이블의 기존 레코드를 삭제하는 데 사용한다.

아래는 기본 형식이며 **WHERE절에 주목**해야 한다.

WHERE로 조건을 지정 안 해주면 테이블의 모든 레코드가 삭제 되어 버린다.

```sql
DELETE FROM table_name
WHERE contidion;
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

테이블에서 고객인 Alfreds Futterkiste를 삭제한다.

```sql
DELETE FROM Customers
WHERE CustomerName = 'Alfreds Futterkiste';
```

<br>

테이블은 남겨두고 테이블의 모든 행 삭제, 테이블 구조, 속성 및 인데스가 그대로 유지된다.

```sql
DELETE FROM table_name;
```

