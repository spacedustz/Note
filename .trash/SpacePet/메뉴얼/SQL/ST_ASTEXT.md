## ST_ASTEXT()

`@Formula(value = "ST_ASTEXT(location)")`는 `location` 필드를 `ST_ASTEXT` SQL 함수를 사용하여 계산하여 매핑하는 예시입니다. `ST_ASTEXT`는 공간 데이터 타입을 텍스트로 변환하는 함수로, 보통 GIS(Geographic Information System) 관련 작업에서 사용됩니다.

따라서, 위의 코드는 `location` 필드를 `ST_ASTEXT` 함수를 이용하여 텍스트 형식으로 변환한 값을 매핑하는 것을 의미합니다. 이렇게 계산된 필드는 데이터베이스에 저장되지 않지만, 조회 시에는 해당 SQL 식을 실행하여 결과를 가져옵니다.

예를 들어, `location` 필드가 공간 데이터 타입인지라면 `@Formula` 어노테이션을 사용하여 해당 필드를 텍스트 형식으로 변환하여 사용할 수 있습니다.