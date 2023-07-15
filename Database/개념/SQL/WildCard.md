## 💡 WildCard

문자열에서 하나 이상의 문자를 대체하는데 사용한다.

보통 Like나 Where 연산자와 함께 사용한다.

열에서 지정한 패턴을 검색하기 위해 사용한다.

<br>

### 사용법

| Symbol | Description                              | Example                                                |
| :----- | :--------------------------------------- | :----------------------------------------------------- |
| %      | 0개 이상의 문자를 나타냅니다.            | bl%는 bl, black, blue 및 blob을 찾습니다.              |
| _      | 단일 문자를 나타냅니다.                  | h_t는 hot, hat 및 hit를 찾습니다.                      |
| []     | 대괄호 안의 단일 문자를 나타냅니다.      | h[oa]t는 hot 및 hat을 찾았지만 hit는 찾지 못했습니다.  |
| ^      | 대괄호에 없는 모든 문자를 나타냅니다.    | h[^oa]t는 hit를 찾았지만 hot 및 hat은 찾지 않았습니다. |
| -      | 지정된 범위 내의 단일 문자를 나타냅니다. | c[a-b]t는 cat 및 cbt를 찾습니다.                       |

<br>

### % 와일드카드 예시

"ber"로 시작하는 City를 가진 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE City
LIKE 'ber%';
```

<br>

City에 "es" 패턴을 포함하는 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE City
LIKE '%es%';
```

<br>

### _ 와일드카드 예시

임의의 문자로 시작하고 뒤에 "ondon"이 들어간 City를 가진 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE City
LIKE '_ondon';
```

<br>

"L"로 시작하는 도시, 임의의 문자, "n", 임의의 문자, "on" 순서의 City를 가진 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE City
LIKE 'L_n_on';
```

<br>

### [charlist] 와일드카드 예시

"b", "s" 또는 "p"로 시작하는 City를 가진 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE City
LIKE '[bsp]%';
```

<br>

"a", "b" 또는 "c"로 시작하는 City를 가진 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE City
LIKE '[a-c]%';
```

<br>

### [!charlist] 와일드카드 예시

"b", "s" 또는 "p"로 시작하지 않는 City를 가진 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE City
LIKE '[!bsp]%';
```

 또는

```sql
SELECT *
FROM Customers
WHERE City
NOT LIKE '[bsp]';
```



