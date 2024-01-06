## 📘 스레드 간 리소스 공유 & 임계 영역

> 🚩 **프로세스 내에서 공유할 수 있는 리소스**

- 힙에 할당된 모든 항목
- 객체, 클래스 멤버, static 변수
- 프로세스 외부에 있는 모든 항목

---

## 📘 Thread 실행 순서 제어를 통한 예시

Thread.join()을 이용해 바로 예시 코드를 보겠습니다.

```java
@Slf4j  
public class InventoryCounter {  
    public static void main(String[] args) throws InterruptedException {  
        Counter counter = new Counter();  
        IncrementingThread increment = new IncrementingThread(counter);  
        DecrementingThread decrement = new DecrementingThread(counter);  
  
        increment.start();  
        increment.join();  
  
        decrement.start();  
        decrement.join();  
  
        log.info("현재 아이템 개수 : {}", counter.getItems());  
    }  
  
    /* Item을 관리하는 Counter */    
    private static class Counter {  
        private int items = 0;  
  
        public void increment() { items++; }  
        public void decrement() { items--; }  
        public int getItems() { return items; }  
    }  
  
    /* Item을 10000개 증가 시키는 스레드 */    
    @RequiredArgsConstructor  
    public static class IncrementingThread extends Thread {  
        private final Counter counter;  
  
        @Override  
        public void run() {  
            for (int i=0; i<10000; i++) {  
                counter.increment();  
            }  
        }  
    }  
  
    /* Item을 10000개 감소 시키는 스레드 */    
    @RequiredArgsConstructor  
    public static class DecrementingThread extends Thread {  
        private final Counter counter;  
  
        @Override  
        public void run() {  
            for (int i=0; i<10000; i++) {  
                counter.decrement();  
            }  
        }  
    }  
}
```

```
19:02:35.885 [main] INFO com.thread.share.InventoryCounter -- 현재 아이템 개수 : 0

Process finished with exit code 0
```

<br>

위 코드를 실행하면 Item 10000개를 추가하고 10000개를 감소 시켜서 main 스레드의 값은 0 으로 나옵니다.

하지만 Thread의 실행순서를 이렇게 제어 하면 어떻게 나올까요?

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

```
18:54:57.036 [main] INFO com.thread.share.InventoryCounter -- 현재 아이템 개수 : -1625

Process finished with exit code 0
```

출력값이 전혀 맞지않고 숫자도 랜덤하게 나오게 됩니다.

<br>

> 🚩 **이유는?**

-  Counter 내부 클래스의 items 변수는 Heap에 속하는 클래스 멤버이기 떄문에 스레드 간 공유됩니다.
- 스레드 내부에서 실행시키는 `items++`, `items--` 작업은 동시에 실행되므로 각각 단일 작업이 아닙니다.
- 즉 , 원자(Atomic)적인 작업이 아니며 이 부분이 치명적인 결함입니다.

<br>

> 🚩 **원자적 작업이란? (Atomic Operation)**

- 하나 또는 여러 작업의 집합으로 외부 시스템이 보기에 **동시에 실행된 것처럼 보이는 작업**을 의미합니다.
- 