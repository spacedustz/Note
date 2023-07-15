## LocalDateTime

<br>

### truncatedTo()

이 메소드는 LocalDateTime의 시간 부분을 제거한 복사본을 반환합니다. 

시간을 제거하면 지정된 단위보다 작은 필드는 모두 0으로 설정된 원래 날짜-시간의 복사본이 생성됩니다. 

예를 들어 분 단위로 자르면 분의 초와 나노초 필드가 모두 0으로 설정됩니다. 

단위는 표준 일의 길이를 나누어 떨어지게 하는 기간이 있어야 합니다. 

이는 ChronoUnit 및 DAYS의 모든 시간 단위를 포함합니다. 

다른 단위는 예외를 throw합니다. 

이 인스턴스는 불변하며, 이 메서드 호출에 영향을받지 않습니다. 

<br>

매개 변수:

- unit - 자를 단위, null이 아님 

반환 값:

- 시간이 제거된 LocalDateTime, null이 아님 

예외: 

- DateTimeException-자르기가 불가능한 경우
- UnsupportedTemporalTypeException-단위가 지원되지 않는 경우

---

