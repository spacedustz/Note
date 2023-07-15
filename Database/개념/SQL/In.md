## 💡 In 연산자

Where 연산자에 여러 값을 지정할 수 있다.

```sql
SELECT column_name(s)
FROM table_name
WHERE column_name IN (value1, value2 ...);

// 또는

SELECT column_name(s)
FROM table_name
WHERE column_name IN (SELECT STATEMENT);
```

<br>

### 예시

국가가 "Germany", "France" 또는 "UK"인 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE Country IN ('Germany', 'France', 'UK');
```

<br>

국가가 "Germany", "France" 또는 "UK"가 아닌 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE Country NOT IN ('Germany', 'France', 'UK');
```

<br>

Suppliers 컬럼의 국가와 동일한 국가인 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE Country (SELECT Country FROM Suppliers);
```

