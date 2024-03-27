## 📘 Critical Section & Synchronized with Lock

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

## 📘 Synchronized 란?

Concurrency 문제를 해결하는 가장 간단한 솔루션은 Java에서 지원하는 `synchronized` 키워드를 이용해,

함수를 동기화 시키는 것입니다.

<br>

> 🚩 **synchronized 키워드란?**

- **여러 개의 스레드가 코드 블럭이나 전체 메서드에 액세스 할 수 없도록** 설계된 **Locking Mechanism** 입니다.

---

## 📘 Synchoronized의 첫번째 사용법 - 전체 함수를 임계영역으로 지정

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
/* Item을 관리하는 Counter */
private static class Counter {  
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

<br>

**출력값**

```
20:14:38.740 [main] INFO com.thread.share.InventoryCounter -- 현재 아이템 개수 : 0

Process finished with exit code 0
```

이제 여러 스레드가 공유된 객체에서 함수를 실행함에도 불구하고,

1번에 스레드 1개씩 임계 영역을 실행하는 걸 제한할 수 있게 되었습니다.

---

## 📘 **Synchoronized의 두번째 사용법 - 함수의 특정 부분만 임계영역으로 지정**

임계 영역으로 간주되는 코드 블럭을 정의하고 synchronized 키워드를 이용해,

전체 함수가 아닌 특정 영역의 액세스만 제어하는 방법입니다.

```java
public class ClassWithCriticalSections {
	Object lockingObject = new Object();
	
	public syncronized void function1() {
		synchronized(lockingObject) {
			... 
			Critical Section
			...
		}
	}
	...
}
```

<br>

이 방법을 사용하려면 **Lock의 역할을 할 동기화될 객체**를 만들어야 합니다.

어떠한 객체든 가능하며,

동일한 객체 상에서 동기화된 모든 코드 블럭은 해당 블럭 안에서 1개의 스레드만 실행을 허용합니다.

<br>

즉, 전체 함수를 동기화할 필요 없이 로직을 실행하는데 필요한 최소한만 남겨두고 최소화 하는게 좋습니다.

그럼 더 많은 코드가 여러 스레드로 동시에 실행될 수 있고, **스레드 간 동기화에 필요한 코드는 더 적어집니다.**

<br>

이전 포스팅 코드를 예시로 2번쨰 방법을 다뤄보겠습니다.

**클래스 내부에 Lock 객체를 만들고, Synchronized 블럭을 만들어서 Lock 객체에 동기화를 시켜주었습니다.**

```java
@Slf4j  
public class InventoryCounter {  
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
  
    /* Item을 관리하는 Counter */    
    private static class Counter {  
        private int items = 0;  
        Object lock = new Object(); // Lock 객체  
  
        public void increment() {  
            synchronized (this.lock) {  
                items++;  
            }  
        }  
        public synchronized void decrement() {  
            synchronized (this.lock) {  
                items--;  
            }  
        }  
        public synchronized int getItems() {  
            synchronized (this.lock) {  
                return items;  
            }  
        }  
    }
```

<br>

**출력값**

```
20:29:10.575 [main] INFO com.thread.share.InventoryCounter -- 현재 아이템 개수 : 0

Process finished with exit code 0
```

<br>

함수 내부에 필요한 영역만 임계영역으로 최소화해 지정했음에도 정확한 결과값인 0이 나오고 있습니다.

---

## 📘 Synchronized Lock

동기화 락과 관련해 중요한 점은,

동기화 블럭이나 함수는 Reentrant. 즉, 재진입 할 수 있는 요소라는 점입니다.

<br>

Thread A가 이미 다른 동기화 함수나 블럭에 있는 상태에서 또 동기화된 함수에 액세스 하면,

별 문제 없이 추가로 진입한 동기화 함수에 액세스 할 수 있게 됩니다.

<br>

기본적으로 스레드는 자신이 임계영역에 진입하는 걸 막지 못합니다.

<br>

> 🚩 **배운 점**

- Concurrency 문제에 대한 정의와 어떤 상황일 때 발생하는지 알게 됨
- 원자적으로 실행해야 하는 코드를 판단하고 해당 코드 블럭을 임계영역으로 선언하는 방법을 알게 됨
- 그리고 그 임계영역을 Protect 하는 방법으로 Java의 Synchronized 키워드를 사용할 수 있게 됨
- 그 Synchronized의 2가지 사용법에 대한 학습
    - 키워드를 함수 이름 앞에 넣는 Monitor 방식
    - 동기화를 적용할 명시적인 객체를 사용하는 방식 (유연성과 세분화 장점)

