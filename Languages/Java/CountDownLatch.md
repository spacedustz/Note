## 📘 CountDownLatch 란?

CountDownLatch는 특정 스레드가 다른 스레드에서 작업이 완료될 때까지 기다릴 수 있도록 해주는 클래스이며,

스레드간 통신이 가능하고, **Main Thread와 Reactive Stream의 처리를 동기화 하기 위해 사용**합니다.

<br>

예를 들어 CountDownLatch(3) 이라고 가정하면 3개의 Task를 실행 시키면서 countDown()를 호출해 Count 값을 감소시킵니다.

Count가 0이 되면 차단된 스레드가 해제되고 나머지 작업을 수행합니다.

**즉, CountDownLatch의 수치가 0이 될때까지 해당되는 스레드를 Block 시키면서 Latch는 Await 합니다.**

<br>

CountDownLatch의 장점은 Thread.join()보다 유연하며, 스레드의 참조가 필요하지 않습니다.

<br>

우선 예시로 3개의 클래스와 3개의 Thread를 만들어 보겠습니다.

Main Thread 내부에서 3개의 Thread를 생성, 작업을 수행하고 작업시간을 측정합니다.

<br>

> 📕 **AwaitThread**

Main Thread가 다른 스레드의 작업이 모두 완료될 때까지 기다리지 않고 결과를 출력합니다.

```java
@Slf4j  
@RequiredArgsConstructor  
public class AwaitThread {  
  
    public static void main(String[] args) {  
        Instant start = Instant.now();  
  
        log.info("Start");  
        int totalNumberOfTasks = 3;  
        BlockingQueue<Integer> queue = new LinkedBlockingQueue<>(200);  
  
        ExecutorService executorService = Executors.newFixedThreadPool(totalNumberOfTasks);  
        executorService.submit(new Producer(queue));  
  
        executorService.submit(new Consumer(queue));  
        executorService.submit(new Consumer(queue));  
  
        executorService.shutdown();  
  
        Instant finish = Instant.now();  
        long timeElapsed = Duration.between(start, finish).toMillis();  
  
        log.info("Finished");  
        log.info("Method took: " + timeElapsed + "ms");  
    }  
  
    // Producer Thread  
    public static class Producer implements Runnable {  
  
        private final BlockingQueue<Integer> queue;  
  
        public Producer(BlockingQueue<Integer> queue) {  
            this.queue = queue;  
        }  
  
        @Override  
        public void run() {  
  
            try {  
                process();  
            } catch (InterruptedException e) {  
                Thread.currentThread().interrupt();  
            }  
        }  
  
        private void process() throws InterruptedException {  
            for (int i = 0; i < 100; i++) {  
                log.info("[Producer] Put : " + i);  
                queue.put(i);  
                log.info("[Producer] Queue remainingCapacity : " + queue.remainingCapacity());  
                Thread.sleep(100);  
            }  
  
            queue.put(-1);  
        }  
    }  
  
    // Consumer Thread  
    public static class Consumer implements Runnable {  
        private final BlockingQueue<Integer> queue;  
  
        public Consumer(BlockingQueue<Integer> queue) {  
            this.queue = queue;  
        }  
  
        @Override  
        public void run() {  
            try {  
                while (true) {  
                    Integer take = queue.take();  
  
                    if (take == -1) {  
                        queue.put(-1);  
                        break;  
                    }  
                    process(take);  
                }  
            } catch (InterruptedException e) {  
                Thread.currentThread().interrupt();  
                log.error(e.getMessage());  
            }  
        }  
  
        private void process(Integer take) throws InterruptedException {  
            log.info("[Consumer]  Take : " + take);  
            Thread.sleep(500);  
        }  
    }  
}
```

<br>

> 📕 **결과값**

메인 스레드가 다른 스레드의 작업이 모두 끝날떄까지 대기하지 않고 결과를 바로 출력해 버립니다.

```
Start
Finished
[Producer] Put : 0
[Producer] Queue remainingCapacity : 199
Method took: 10ms
[Consumer] Take : 0
[Producer] Put : 1

...

[Consumer] Take : 96
[Consumer] Take : 97
[Consumer] Take : 98
[Consumer] Take : 99
```

<br>

즉, 작업의 수행시간을 측정하려던 의도대로 작동하지 않습니다.

이를 해결하기 위해 이 코드 아래에서 CountDownLatch를 이용합니다.

---
## 📘 CountDownLatch 사용

> 📕 **CountDownLatch가 적용된 AwaitThread**

```java
@Slf4j  
@RequiredArgsConstructor  
public class AwaitThread {  
  
    public static void main(String[] args) throws InterruptedException {  
        Instant start = Instant.now();  
  
        log.info("Start");  
        int totalNumberOfTasks = 3;  
        BlockingQueue<Integer> queue = new LinkedBlockingQueue<>(200);  
  
        ExecutorService executorService = Executors.newFixedThreadPool(totalNumberOfTasks);  
        CountDownLatch latch = new CountDownLatch(totalNumberOfTasks);  
  
        executorService.submit(new Producer(queue, latch));  
  
        executorService.submit(new Consumer(queue, latch));  
        executorService.submit(new Consumer(queue, latch));  
  
        executorService.shutdown();  
        latch.await();  
  
        Instant finish = Instant.now();  
        long timeElapsed = Duration.between(start, finish).toMillis();  
  
        log.info("Finished");  
        log.info("Method took: " + timeElapsed + "ms");  
    }  
  
    // Producer Thread  
    public class Producer implements Runnable {  
  
        private final BlockingQueue<Integer> queue;  
        private final CountDownLatch latch;  
  
        public Producer(BlockingQueue<Integer> queue, CountDownLatch latch) {  
            this.queue = queue;  
            this.latch = latch;  
        }  
  
        @Override  
        public void run() {  
  
            try {  
                process();  
            } catch (InterruptedException e) {  
                Thread.currentThread().interrupt();  
            }  
  
            latch.countDown();  
        }  
  
        private void process() throws InterruptedException {  
            for (int i = 0; i < 100; i++) {  
                log.info("[Producer] Put : " + i);  
                queue.put(i);  
                log.info("[Producer] Queue remainingCapacity : " + queue.remainingCapacity());  
                Thread.sleep(100);  
            }  
  
            queue.put(-1);  
        }  
    }  
  
    // Consumer Thread  
    public class Consumer implements Runnable {  
  
        private final BlockingQueue<Integer> queue;  
        private final CountDownLatch latch;  
  
        public Consumer(BlockingQueue<Integer> queue, CountDownLatch latch) {  
            this.queue = queue;  
            this.latch = latch;  
        }  
  
        @Override  
        public void run() {  
  
            try {  
                while (true) {  
                    Integer take = queue.take();  
                    if (take == -1) {  
                        queue.put(-1);  
                        break;  
                    }  
                    process(take);  
                }  
            } catch (InterruptedException e) {  
                Thread.currentThread().interrupt();  
            }  
  
            latch.countDown();  
        }  
  
        private void process(Integer take) throws InterruptedException {  
            log.info("[Consumer]  Take : " + take);  
            Thread.sleep(500);  
        }  
  
    }  
}
```

<br>

> 📕 **결과값**

다른 스레드가 모두 완료될 떄까지 메인스레드가 Block 되고 작업이 모두 완료된 후 Main스레드가 종료되었습니다.

```
Start
[Producer] Put : 0 
[Producer] Queue remainingCapacity : 199 
[Consumer] Take : 0 
[Producer] Put : 1 

... 

[Consumer] Take : 196 
[Consumer] Take : 197 
[Consumer] Take : 198 
[Consumer] Take : 199 
Finished 
Method took: 33884ms
```