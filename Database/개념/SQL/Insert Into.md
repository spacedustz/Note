## 💡 Insert Into

테이블이 새 레코드를 삽입하는데 사용한다.

Insert Into 구문은 2가지 방법으로 작성할 수 있다.

<br>

1. 삽입할 열 이름과 값을 모두 지정

```sql
INSERT INTO table_name (column1, column2, column3 ...)
VALUES (value1, value2, value3 ...);
```

2. 테이블의 모든 열에 대한 값을 추가하는경우, SQL 쿼리에서 열 이름을 지정할 필요는 없다.
   값의 순서가 테이블의 열과 같은 순서인지 확인이 필요하다.

```sql
INSERT INTO table_name
VALUES (value, value2, value3 ...);
```

<br>

### Sample Table

| CustomerID | CustomerName         | ContactName     | Address                     | City     | PostalCode | Country |
| :--------- | :------------------- | :-------------- | :-------------------------- | :------- | :--------- | :------ |
| 89         | White Clover Markets | Karl Jablonski  | 305 - 14th Ave. S. Suite 3B | Seattle  | 98128      | USA     |
| 90         | Wilman Kala          | Matti Karttunen | Keskuskatu 45               | Helsinki | 21240      | Finland |
| 91         | Wolski               | Zbyszek         | ul. Filtrowa 68             | Walla    | 01-012     | Poland  |

<br>

### 예시

위의 예시 테이블이 컬럼을 하나 추가해 보자.

```sql
INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES ('Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway');
```

| CustomerID | CustomerName         | ContactName     | Address                     | City      | PostalCode | Country |
| :--------- | :------------------- | :-------------- | :-------------------------- | :-------- | :--------- | :------ |
| 89         | White Clover Markets | Karl Jablonski  | 305 - 14th Ave. S. Suite 3B | Seattle   | 98128      | USA     |
| 90         | Wilman Kala          | Matti Karttunen | Keskuskatu 45               | Helsinki  | 21240      | Finland |
| 91         | Wolski               | Zbyszek         | ul. Filtrowa 68             | Walla     | 01-012     | Poland  |
| 92         | Cardinal             | Tom B. Erichsen | Skagen 21                   | Stavanger | 4006       | Norway  |

<br>

지정한 열에만 데이터 삽입, 지정하지 않은 열에는 NULL이 들어간다.

```sql
INSERT INTO Customers (CustomerName, City, Country)
VALUES ('Cardinal', 'Stavanger', 'Norway')
```

| CustomerID | CustomerName         | ContactName     | Address                     | City      | PostalCode | Country |
| :--------- | :------------------- | :-------------- | :-------------------------- | :-------- | :--------- | :------ |
| 89         | White Clover Markets | Karl Jablonski  | 305 - 14th Ave. S. Suite 3B | Seattle   | 98128      | USA     |
| 90         | Wilman Kala          | Matti Karttunen | Keskuskatu 45               | Helsinki  | 21240      | Finland |
| 91         | Wolski               | Zbyszek         | ul. Filtrowa 68             | Walla     | 01-012     | Poland  |
| 92         | Cardinal             | null            | null                        | Stavanger | null       | Norway  |