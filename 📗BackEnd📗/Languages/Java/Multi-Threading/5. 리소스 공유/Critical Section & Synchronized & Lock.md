## 📘 Locking Machanism을 이용한 Concurrency 문제 방지

[Thread 간 Resource 공유 시 발생할 수 있는 문제 - 지난 포스팅 글](https://iizz.tistory.com/432)

**전에 포스팅한 글에서 다뤘던 코드의 문제점을 다시 한 번 살펴봅니다.**

- 2개의 스레드가 1개의 Counter를 공유하는데, 둘 다 그 카운터를 read/write 할 수 있었습니다.
- 또, 해당 작업들은 비 원자적(Atomic Operation) 입니다.

<br>

위 문제는 흔히 발생하는 문제로 일반적으로는 **여러 작업의 집합을 모두 1개의 원자적 작업**으로 보이게 만들곤 합니다.

어떠한 경우에도 2개의 스레드가 작업을 동시에 수행할 순 없기 때문입니다.

```java
void aggregateFunction() {
	operation1();
	operation1();
	operation1();
	operation1();
	...
}
```

<br>

만약 동시에 실행되지 않게 보호해야 하는 코드가 있는 영역을 **임계영역**이라고 하며,

그 임계영역을 **진입점**과 **진출점**으로 감싸 보겠습니다.

```java
void aggregateFunction() {
	// Enter Critical Section
	operation1();
	operation1();
	operation1();
	operation1();
	// Exit Critical Section
	...
}
```

현재 임계영역에서 실행되고 있는 스레드는 없다고 가정하며, 

새로운 **스레드 A**가 진입해 operation1,2,3을 실행할 수 있습니다.

<br>

여기서 1개의 새로운 스레드 B가 이미 스레드A가 들어가 있는 임계영역에 들어가려고 하면 액세스를 거부당하고,

처음 들어간 A스레드가 종료되어 임계영역에서 나갈 떄 까지 Suspend 될 것입니다.

이런 식으로 동작하면 Concurrency 문제를 걱정할 필요 없이 **모든 수의 개별 작업에 대한 원자성을 확보** 할 수 있습니다.

<br>

다행히 OS와 HW가 지원되는 JVM의 경우, 

**여러 스레드로 인한 동시 실행 액세스**로부터 임계영역을 지켜주는다영한 도구를 지원합니다.

---

## 📘 Synchronized 키워드

Concurrency 문제를 해결하는 가장 간단한 솔루션은 Java에서 지원하는 `synchronized` 키워드를 이용해,

함수를 동기화 시키는 것입니다.

<br>

> 🚩 **synchronized 키워드란?**

- **여러 개의 스레드가 코드 블럭이나 전체 메서드에 액세스 할 수 없도록** 설계된 **Locking Mechanism** 입니다.

<br>

> 🚩 **synchoronized의 첫번째 사용법**

첫번째 방법은 1개 이상의 메서드를 선언하는 것입니다.

여러 개의 스레드가 이 클래스의 동일한 객체에서 해당 메서드를 호출하려고 하면,

1개의 스레드만 메서드 중 하나를 실행할 수 있게 됩니다.

```java
public class ClassWithCriticalSections {
	public syncronized void function1() {}
	public syncronized void function2() {}
}
```

예를 들어 Thread A가 function1을 실행하면 다른 스레드인 Thread B는 function1,2 모두 실행할 수 없습니다.

쉽게 설명하면 위의 동기화된 synchronized 함수들은 1개의 방에 대한 각각의 문으로 생각하면 됩니다.

Thread A가 1번 문(function1())으로 들어가면 다른 문들은 모두 잠겨서 Thread B는 못 들어가게 되는 원리입니다.

<br>

이제 이전 포스팅 글에서 다뤘던 Counter 클래스의 메서드에 synchronized 키워드를 붙여 보겠습니다.

```java
/* Item을 관리하는 Counter */private static class Counter {  
    private int items = 0;  
  
    public synchronized void increment() { items++; }  
    public synchronized void decrement() { items--; }  
    public synchronized int getItems() { return items; }  
}
```

<br>

그리고, 다시 메인 메서드에서 실행순서를 랜덤하게 실행되도록 제어해 보겠습니다.

여러번 계속 실행해도 0으로 같은 값이 나오고 있습니다.

```java
public static void main(String[] args) throws InterruptedException {  
    Counter counter = new Counter();  
    IncrementingThread increment = new IncrementingThread(counter);  
    DecrementingThread decrement = new DecrementingThread(counter);  
  
    increment.start();  
    decrement.start();  
  
    increment.join();  
    decrement.join();  
  
    log.info("현재 아이템 개수 : {}", counter.getItems());  
}
```

**출력값**

```
20:14:38.740 [main] INFO com.thread.share.InventoryCounter -- 현재 아이템 개수 : 0

Process finished with exit code 0
```

이제 여러 스레드가 공유된 객체에서 함수를 실행함에도 불구하고,

1번에 스레드 1개씩 임계 영역을 실행하는 걸 제한할 수 있게 되었습니다.

<br>

>  🚩 **synchoronized의 두번째 사용법**

