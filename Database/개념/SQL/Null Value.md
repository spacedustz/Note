## 💡 Null Value

값이 없는 필드.

Is Null 연산자는 빈값을 테스트하는데 사용된다.

Is Not Null 연산자는 비어 있지 않은 값을 테스트하는데 사용된다.

테이블의 필드가 선택 사항인 경우, 이 필드에 값을 추가하지 않고,
새 레코드를 삽입하거나 레코드를 업데이트 할 수 있고 그러면 필드가 NULL 값으로 저장된다.

<br>

### Null값을 테스트하는 방법

=, < 또는 <>와 같은 비교 연산자를 사용하여 NULL 값을 테스트할 수 없다.

IS NULL 및 IS NOT NULL을 사용하여 테스트해야 한다.

```sql
SELECT column_names
FROM table_name
WHERE column_name IS NULL;
```

```sql
SELECT column_names
FROM table_name
WHERE column_name IS NOT NULL;
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

값이 Null인 레코드 선택

```sql
SELECT CustomerName, ContactName, Address
FROM Customers
WHERE Address IS NULL;
```

<br>

값이 비어있지 않은 레코드 선택

```sql
SELECT CustomerName, ContactName, Address
FROM Customers
WHERE Address IS NOT NULL;
```

