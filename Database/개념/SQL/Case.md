## 💡 Case

Case When 형식으로 When과 같이 자주 쓰이며 프로그래밍의 if - else 문과 비슷하다.

When의 평가식은 '필드 = 값' 처럼 조건을 지정하는 식을 말한다.

처리 순서는 처음에 있는 When의 평가식부터 평가되고, 
조건이 맞으면 Then 에 지정된 식이 리턴되며 Case식 전체가 종료된다.

만약 조건이 맞지 않으면 다음 When 으로 이동해 같은 처리를 반복한다.

<br>

### 기본 형식

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;
```

<br>

### 예시

OrderDetails 테이블의 OrderId와 Quantity를 돌면서 조건에 만족하면 End As 에 Then의 문구를 담아서 반환한다.

```sql
SELECT OrderID, Quantity,
CASE
    WHEN Quantity > 30 THEN 'The Quantity is Greager Than 30'
    WHEN Quantiry = 30 THEN 'The Quantity is 30'
    ELSE 'The Quantity is Under 30'
END AS QuantityText
FROM OrderDetails;
```

<br>

결과

| OrderID | Quantity | QuantityText                    |
| :------ | :------- | :------------------------------ |
| 10248   | 12       | The quantity is under 30        |
| 10248   | 10       | The quantity is under 30        |
| 10248   | 5        | The quantity is under 30        |
| 10249   | 9        | The quantity is under 30        |
| 10249   | 40       | The quantity is greater than 30 |
| 10250   | 10       | The quantity is under 30        |
| 10250   | 35       | The quantity is greater than 30 |
| 10250   | 15       | The quantity is under 30        |

<br>

고객을 도시별로 주문하며, 도시가 Null이면 국가별로 주문한다.

```sql
SELECT CustomerName, City, Country
FROM Customers
ORDER BY
(CASE
    WHEN City IS NULL THEN Country
    ELSE City
END);
```

