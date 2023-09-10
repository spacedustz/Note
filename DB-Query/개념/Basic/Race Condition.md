## 💡 **Race Condition**

**여러 개의 프로세스가 공유 자원에 동시 접근할 때 실행 순서에 따라 결과값이 달라질 수 있는 현상**



#### 임계구역은 아래의 세가지 요구조건을 만족해야 유효한 알고리즘이 된다

-   Mutual Exclusion(상호 배제)
    -   하나의 자원에는 하나의 프로세스만 접근 가능할 수 있어야 함
-   Progress(진행)
    -   임계구역이 비었으면 자원을 사용할 수 있어야 한다 (Deadlock Free)
-   Bounded Waiting(한계 대기)
    -   언젠가는 임계구역에 진입할 수 있어야 한다

\> 경쟁상태는 메모리를 공유하기 때문에 발생하며 해결방법은 스레드의 순차적 실행(동기화)을 보장하면 됨

---

### **임계구역의 일반적인 형태**

```java
do {
    wants[i] = true;     // 프로세스가 공유 자원을 사용하겠다고 선언
    while (wants[j]) {;} // 프로세스가 공유 자원을 사용중이면 진입불가 (진입구역) 
    wants[i] = false;    // 프로세스가 공유 자원 사용 왈뇨 후 반납 (퇴출구역)
} while (true)
```

---

### **Peterson's Solution**

프로세스 P1, P2가 있고 각각 자원을 사용하겠다고 선언했다고 가정.

아래의 순서로 진행될 경우 wants\[1\]과 wants\[2\]가 모두 true이기 때문에 while 문에서 무한 대기한다.

이를 DeadLock 이라고 부른다

임계구역이 비었는데 아무도 사용할 수 없으니 Progress 위반이고

무한대기 상태에 빠졌으니 Bounded Wait 위반이다

즉, 요구사항을 만족하지 않았으므로 유효하지 않은 알고리즘이라고 할 수 있다



**P1**

```
do {
    wants[1] = true;
    while (wants[2]) {;}

    wants[1] = false
} while (true)
```

**P2**

```
do {
    wants[2] = true;
    while (wants[1]) {;}
    wants[2] = false
} while (true)
```

---

### **not\_turn 변수 추가로 인한 해결책**

변수 이름처럼 ''아직 내 차례가 아님'' 을 나타내는 변수이다.

not\_turn에 대응되는 프로세스는 임계구역에 진입하지 못하며, not\_turn도 전역변수이다.

코드의 흐름을 보면 i가 자원을 사용하겠다고 선언하고 바로 다음에 i 를 Lock 걸어버린다

not\_turn은 전역변수이기 때문에 무조건 하나의 프로세스만 Lock 된다 (상호 배제 해결)

진입 직전에 not\_turn을 갱신하기 때문에 임계구역에 진입하지 못하는 상황이 없다 (한계 대기 해결)

```
for (;;) {
    wants[i] = true;
    not_turn = i;    // 아직 i 프로세스의 차례가 아님을 선언하는 변수

    while (wants[j] && not_turn == i); // 프로세스가 공유 자원 사용중이고 i 차례가 아니면 진입 못함

    wants[i] = false; // i 프로세스 공유 자원 반납
}
```

---

### **Mutual Exclusive (상호 배제)**

위의 예시는 true/true인 예시이고 이번엔 false/true , false/false 를 알아보자

```
Case 1: wants[0] = false, wants[1] = true, not_turn = 1
    // 거짓이므로 임계구역에 진입
    while (wants[0] && not_turn == 1)

    // 이 조건을 생각할 필요가 없다. 이 코드에 도달하기 위해선
    // wants[0] = true, not_turn = 0 의 과정을 먼저 거쳐야 하기 때문에
    // wants[0] = false 는 아직 프로세스 0 이 공유자원에 접근을 못했다는 의미이다
    while (wants[1] && not_turn == 0)

Case 2: wants[0] = false, wants[1] = true, not_turn = 0    
    // 거짓이므로 임계구역에 진입
    // wants[0] = false 이기 때문에 not_turn의 값에 상관없이 항상 임계구역 접근 가능
    // Case 1과 동일한 이유에서 다른 while문은 고려 대상이 아님
    while (wnats[0] && not_turn == 1)

Case 3: wants[0] = false, wants[1] = false
    /* 
      프로세스 0,1 모두 공유 자원을 사용하지 않겠다고 선언한 상태다
      이 중 하나가 공유자원 사용을 선언한다면 Case 1, Case 2와 같은 상횡이 되는 것이다
      둘 다 사용하겠다고 하면 true/true 인 상황이 되는 것이다
    */
```

---

### **P**rogress (진행), Bounded Wait (한계 대기)

not\_turn 변수는 전역변수이다

진입 직전에 not\_turn 변수를 갱신하기 때문에 임계구역에 진입하지 못하는 상황은 발생하지 않는다

not\_turn 변수 파트와 내용 동일

---

### **Peterson Solution의 단점**

-   소프트웨어적 해결책
-   Context Switching 발생 가능성
-   프로세스가 2개인 경우에만 적용 가능