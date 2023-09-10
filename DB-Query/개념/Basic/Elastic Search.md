## 💡 Elastic Search

- Java로 개발된 오픈소스 검색엔진
- 보통 단독으로 사용하기 보다 ELK스택이라고 부르는 LogStash, Kibana, Beats를 추가적으로 사용함
- Inverted Index 구조로 데이터를 저장해서, 전문(Full-Text) 검색시에 RDBMS에 비해 뛰어난 성능 보장
- 다양한 용도로 사용 가능
  (저장, 문서 검색, 위치 검색, 머신러닝 기반 검색, 로그 분석, 보안 감사 분석 등)



###  Elastic Search의 Index 구조와 RDBMS의 Index 구조의 차이점

- Elastic Search는 Inverted-Index 구조로 데이터를 저장함
- 이는 책의 색인을 생각해보면 쉬운데, 특정 단어가 출현하는 Doc을 저장하는것이다
- 반면 RDBMS는 B-Tree와 그와 유사한 인덱스를 사용함
- 데이터가 어디에 존재하는지, 어떤 순서로 저장하는지의 차이
- RDBMS에도 다양한 인덱스 구조가 있으나 여기서 예로 든것은 B-Tree이다



### Elastic Search의 키워드 검색과 RDBMS의 Like 검색의 차이점

- Elastic Search의 키워드 검색은 Document를 저장할 때 수행하는 알고리즘과 동일한 알고리즘으로 키워드를 분리한다
- 그 중 랭킹 알고리즘을 통해서 가장 유사한 순서대로 결과를 나타낸다
- RDBMS에서의 Like 검색은 와일드카드로 시작하지 않는 경우에만 인덱스를 사용하고
  나머지 경우는 전체를 탐색하기 때문에 상대적으로 느리다