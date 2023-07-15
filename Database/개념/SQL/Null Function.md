## 💡 Null Function

Null 함수엔 IFNULL(), ISNULL(), COALESCE(), NVL() 등이 있다.

IF NULL은 해당 값이 Null일 경우 대체값을 설정해 그 값으로 변환한다.

COALESCE는 지정한 표현식들 중에 NULL이 아닌 첫번째 값을 반환한다.

<br>

### 기본 형식

**IFNULL(), ISNULL()**

자바의 Map 메서드인 getOrDefault() 와 비슷하며, IF와 IS NULL로도 Null 체크를 할 수 있다.

```sql
SELECT IFNULL(Column명, "Null일 경우 대체 값")
FROM 테이블명;

SELECT IF(IS NULL(name), "No Name", name) as name
FROM Animal_ins
```

<br>

**COALESCE**

표현식은 여러 항목 지정이 가능하고, 처음으로 만나는 NULL이 아닌 값을 출력한다.

표현식이 모두 NULL일 경우인 결과도 NULL을 반환한다.

<br>

COALESCS는 배타적 OR 관계 열에서 활용도가 높다.

엔티티에서 2개 이상의 속성(열) 중 하나의 값만 가지는 데이터일 경우

```sql
# NULL 처리 상황
SELECT COALESCE(Column명, "Null일 경우 대체 값")
FROM 테이블명;

# 배타적 OR 관계 열, Column 1~4 중 NULL이 아닌 첫번쨰 Column을 출력한다
SELECT COALESCE(Column1, Column2, Column3, Column4)
FROM 테이블명;
```

<br>

### 예시

| P_Id | ProductName | UnitPrice | UnitsInStock | UnitsOnOrder |
| :--- | :---------- | :-------- | :----------- | :----------- |
| 1    | Jarlsberg   | 10.45     | 16           | 15           |
| 2    | Mascarpone  | 32.56     | 23           |              |
| 3    | Gorgonzola  | 15.67     | 9            | 20           |

<br>

위의 테이블에서 Price를 구하는 쿼리를 작성해보자.

UnitsOnOrder의 값중 하나가 Null이라 결과는 Null이 나올 것이다.

```sql
SELECT ProductName, UnitPrice * (UUnitsInStock + UnitsOnOrder)
FROM Products;
```

<br>

IFNULL() 함수를 사용해 값이 Null인경우 대체값을 적용해보자

```sql
SELECT ProductName, UnitPrice * (UnitsInStock + IFNULL(UnitsOnOrder, 0))
FROM Products;
```

<br>

COALESCE()를 사용할 수도 있다.

```sql
SELECT ProductName, UnitPrice * (UnitsInStock + COALESCE(UnitsOnOrder, 0))
FROM Products;
```

