## **💡 LazyInitializationException 발생**  

<br>

### **발생이유**

1. Proxy 객체로 채워진 Entity의 타입캐스팅을 시도할 때
2. 트랜잭션 내부에서 연관관계가 설정된 엔티티의 프로퍼티 접근이 안됬을때
3. 영속성 컨텍스트가 Transaction 범위 밖인 Controller에서 Lazy Loading을 시도할 때

<br>

N:1 관계를 예시로, 1쪽에서의 Fetch 전략은 Lazy & N쪽에서의 Cascade 전이 범위는 Persist,Remove 설정

N의 엔티티를 단건 조회했을때 Lazy Loading으로 연관된 1은 바로 초기화가 되지않고,
필요할때 정보가 채워지는 Proxy 객체로 채워진다.

<br>

그럼 N의 Request가 Entity로 변환되고 Entity -> Response로 변환이 될때 정상적으로 변환이 될까?
정답은 안된다 이다

<br>

왜냐하면 1의 값을 써서 DTO를 채워야하는데 1의 값이 초기화가 되지 않은 상태여서 DTO 생성이 안됨

<br>

### **해결**

방법 1.
Controller에서 Entity -> Response 변환하던것을
트랜잭션 범위안에 있는 Service로 가져와서
변환 시 쿼리를 날려 1의 값을 채우면 ResponseDTO가 정상적으로 만들어짐

방법 2.
임시 해결 -> open-in-view 옵션을 true로 변경 (권장 X, DB 성능 저하 및 장애 발생 가능성)
true 설정 시, 영속성 컨텍스트가 트랜잭션 범위를 넘어선 레이어까지 살아있음
false 설정 시, 트랜잭션이 종료될 경우 영속성 컨텍스트도 닫힌다



트랜잭션 내부에서 프록시 객체의 프로퍼티를 건드리니 오류가 사라지고 어플리케이션이 잘 실행되었음

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/lazy.png)

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/lazy2.png)

---

## 💡 내용 추가

Repository에서 fetch join을 하거나 Batch Size 조정을 통해 간단히 해결했다. 

위 내용처럼 프로퍼티를 건드리는 불필요한 코드 작성을 할 필요가 없음.