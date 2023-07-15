## 💡 CAP 이론과 Eventual Consistency

> **CAP 이론은 분산 환경에서 모두를 만족하는 시스템은 없다는 이론이다**

- Consistency(일관성)
  - ACID의 일관성과는 약간 다르며, 모든 노드가 같은 시간에 같은 데이터를 보여줘야 한다
- Availability(가용성)
  - 모든 동작에 대한 응답이 리턴되어야 함
- Partition Tolerance(분할 내성)
  - 시스템 일부가 네트워크에서 연결이 끊기더라도 동작해야 함

CAP는 해당 시스템이 이거다 라고 말하기 곤란한게 어떻게 클러스터링 하느냐에 따라 달라짐

그렇기 때문에 어떤 전략을 취할 때 어떤것을 선택했는가를 잘 알아야 함

 Eventual Consistency는 이 Consistency를 보장해주지 못하기 떄문에 나온 개념으로
Consistency를 완전히 보장하지는 않지만, 결과적으로 언젠가는 Consistency가 보장됨을 의미