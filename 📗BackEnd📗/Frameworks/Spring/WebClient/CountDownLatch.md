## 📘 CountDownLatch

Spring WebClient의 CountDownLatch를 이용해 Thread를 대기시키는 방법에 대해 포스팅 하겠습니다.

우선 예시로 3개의 클래스와 3개의 Thread를 만들어 보겠습니다.

Main Thread 내부에서 3개의 Thread를 생성, 작업을 수행하고 작업시간을 측정합니다.

<br>

**Thread Pool 생성**

우선 Thread Pool를 생성해주고 MaxThreadPool을 3으로 설정 해줍니다.

```java
@Bean  
public TaskExecutor executor() {  
    ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();  
    executor.setCorePoolSize(props.getCorePoolSize());  
    executor.setMaxPoolSize(props.getMaxPoolSize());  
    executor.setQueueCapacity(props.getQueueCapacity());  
    executor.setThreadNamePrefix(props.getNamePrefix());  
    executor.initialize();  
  
    return executor;  
}
```

<br>

**AwaitThread**

Main Thread가 다른 스레드의 작업이 모두 완료될 때까지 기다리지 않고 결과를 출력합니다.

```java
@Slf4j  
@RequiredArgsConstructor  
public class AwaitThread {  
    private final TaskExecutor executor;  
  
    public static void main(String[] args) {  
        Instant start = Instant.now();  
        log.info("Test Start");  
  
        int totalNumOfTasks = 3;  
  
        BlockingQueue<Integer> queue = new LinkedBlockingQueue<>(200);  
  
        executor.execute(new Producer(queue));  
        executor.execute(new Consumer(queue));  
        executor.execute(new Consumer(queue));  
    }  
  
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
                System.out.println("[Producer] Put : " + i);  
                queue.put(i);  
                System.out.println("[Producer] Queue remainingCapacity : " + queue.remainingCapacity());  
                Thread.sleep(100);  
            }  
  
            queue.put(-1);  
        }  
    }  
  
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
            System.out.println("[Consumer]  Take : " + take);  
            Thread.sleep(500);  
        }  
    }  
}
```

<br>

**결과값**

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