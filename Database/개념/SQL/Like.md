## 💡 Like 연산자

테이블의 열에서 지정된 패턴을 검색하기 위해  Where와 함께 사용한다.

Like와 함께 자주 사용되는 2가지 와일드카드가 있다.

- 백분율 기호인 % 는 0개, 1개 또는 여러 문자를 나타낸다.
- 밑줄 기호인 _ 는 하나의 단일 문자를 나타낸다.

참고 : MS Access는 % 대신 *를 사용하고 _ 대신 ?를 사용한다.

```sql
SELECT column1, column2, ...
FROM table_name
WHERE columnN LIKE pattern;
```

<br>

### 연산자 사용법

| LIKE Operator                  | Description                                     |
| :----------------------------- | :---------------------------------------------- |
| WHERE CustomerName LIKE 'a%'   | "a"로 시작하는 값을 찾습니다                    |
| WHERE CustomerName LIKE '%a'   | "a"로 끝나는 값을 찾습니다.                     |
| WHERE CustomerName LIKE '%or%' | 모든 위치에 "or"이 있는 값을 찾습니다.          |
| WHERE CustomerName LIKE '_r%'  | 두 번째 위치에 "r"이 있는 값을 찾습니다.        |
| WHERE CustomerName LIKE 'a_%'  | "a"로 시작하고 길이가 2자 이상인 값을 찾습니다. |
| WHERE CustomerName LIKE 'a__%' | "a"로 시작하고 길이가 3자 이상인 값을 찾습니다. |
| WHERE ContactName LIKE 'a%o'   | "a"로 시작하고 "o"로 끝나는 값을 찾습니다.      |

<br>

### 예시

CustomerName이 "a"로 시작하는 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE CustomerName
LIKE 'a%';
```

<br>

CustomerName이 "a"로 끝나는 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE CustomerName
LIKE '%a';
```

<br>

모든 위치에 "or"이 있는 CustomerName을 가진 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE CustomerName
LIKE '%or%';
```

<br>

두번째 위치에 "r"이 있는 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE CustomerName
LIKE '_r%';
```

<br>

"a"로 시작하고 길이가 3자 이상인 CustomerName을 가진 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE CustomerName
LIKE 'a__%';
```

<br>

"a"로 시작하고 "o"로 끝나는 ContactName을 가진 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE ContactName
LIKE 'a%o';
```

<br>

"a"로 시작하지 않는  CustomerName을 가진 모든 고객을 선택한다.

```sql
SELECT *
FROM Customers
WHERE CustomerName
NOT LIKE 'a%';
```

