## 📘 Race Condition

Race Condition이란 공유된 리소스에 접근하는 여러 스레드가 있을 때,

최소 2개 이상의 스레드가 동시에 공유 리소스에 접근하려고 하는 경우로,

스레드 스케줄링의 순서나 시점에 따라 결과가 달라지는 상황을 말합니다.

<br>

위 문제의 핵심은 공유 리소스에 비원자적 연산이 실행되는 문제입니다.

Race Condition의 솔루션으로는 지난번 포스팅 했던 글을 봤을떄,

Race Condition이 일어나는 Critical Section을 동기화 블럭에 넣어 보호한다고 배웠습니다.

```java
public synchronized void increment() {
	// 임계 영역 진입점
	items++;
	// 임계 영역 진출점
}

public synchronized void decrement() {
	// 임계 영역 진입점
	items--;
	// 임계 영역 진출점
}
```

---
## 📘 Data Race

그럼 Data Race는 무엇일까요?

아래 예시 코드의 SharedClass는 2개의 스레드로 실행될 것입니다.

Thread A는 `increment()`를 실행시키고 Thread B는 `checkForDataRace()`를 실행시켜 불변성을 체크합니다.

```java
@Slf4j  
public class SharedClass {  
    int x = 0;  
    int y = 0;  
  
    public void increment() {  
        x++;  
        y++;  
    }  
  
    /* 불변성 체크 함수 */    
    public void checkForDataRace() {  
        if (y > x) {  
            log.error("불가능한 상황 발생");  
        }  
    }  
}
```

<br>

위 코드에서 x와 y가 두 스레드에 의해 실행될 때 함수가 **InterLeave**하지 않으면 `x == y`가 됩니다.

> 😯 **InterLeaving 이란?**

병렬처리를 위한 기법으로 InterLeaving과 Overlapping이 있습니다.

**Interleaving**은 처리기가 하나여도 여러 개의 프로세스를 번갈아 실행하며,

마치 병렬적으로 처리되고 있는듯 보이게 하는 **멀티프로그래밍 기법**입니다.

**OverLapping**은 여러개의 처리기로 동시에 여러 작업을 처리하는 **멀티프로세싱 기법**입니다.