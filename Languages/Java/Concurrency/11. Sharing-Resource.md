## 📘 스레드 간 리소스 공유

이번에는 Heap에 있는 변수를 공유해 서로 다른 스레드로 비 원자적인 작업을 동시에 수행하는 작업을 구현해 보았습니다.

이런 작업을 수행할때 생길 수 있는 문제점을 아래 예시 코드와 같이 작성하였습니다.

<br>

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
- 그래서 작업 중간의 처리 과정을 볼 수 있는 방법도 없습니다.

<br>

> 🚩 **`items++`이 Atopic Operation이 아닌 이유**

- `items++`작업은 1개의 작업이 아닌 내부적으로 3개의 작업을 처리합니다.
- 먼저, 메모리에 저장된 items의 현재 값을 가져옵니다. - `currnutValue = 0`
- 현재 값에 1을 더합니다. - `new Value <- currentValue + 1 = 1`
- 더한 결과를 items 변수에 저장합니다. - `items <- newValue = 1`

<br>

그럼 생각해 볼 수 있는게 위 예시 코드처럼 2개의 스레드에서 각각 더하고, 빼는 작업을 수행할때를 생각해보면,

2개의 스레드니까 각자 작업을 할것이고, 실행되는 순서는 스레드를 스케줄링하는 방식에 따라 달라집니다.

그래서 매번 다른 결과값이 나오게 되는 것입니다.

만약 스레드의 실행순서를 아래와 같이 했다고 가정 해 봅니다.

| 실행 스레드 | increment / decrement |
| ---- | ---- |
| **increment** | current <- items =0 |
| **increment** | new <- current + 1 = 1 |
| decrement | current <- items = 0 |
| decrement | new <- current - 1 = -1 |
| **increment** | new <- current + 1 = 2 |
| **increment** | new <- current + 1 = 3 |

위 표에서 **increment**부분만 보면 increment 스레드는 decrement가 무슨 작업을 수행 하는지 전혀 모르고,

메모리에 있는 items를 가져와 현재 값에 1을 더하기만 할 뿐입니다.

<br>

실행 순서가 엉망이고 만약 두 스레드의 마지막 작업이 increment이며 더해진 마지막 값은 4632라고 한다면,

결국 마지막 결과값인 items의 값은 4632로 overwirte되어 4632가 나오게 됩니다.

decrement가 작업한 감소 작업은 모두 없어진것과 같은 결과입니다.