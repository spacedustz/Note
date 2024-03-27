## 📘 Thread Creation with Runnable

Runnable 인터페이스를 구현해 Multi-Threading을 구현합니다.

아래 예시 코드의 `new Thread(() -> {})` 람다 부분은 내부적으로 `new Runnable()`로 구성됩니다.

<br>

> 📌 **start() & sleep()**

아래 코드를 실행시켜 보면, 당연히 처음 로그는 main 스레드에서 생성했으니 이름이 main 입니다.

그 후, `thread.start()`를 거친 후의 thread name은 운영체제에서 스케줄링 되지 않았습니다.

<br>

왜냐하면 sleep으로 인해 운영체제가 비동기적으로 sleep을 실행했고,

그래서 2번쨰 스레드의 이름이 **테스트-1**이 아닌 main이 나오게 됩니다.

그리고 마지막으로 새 스레드의 코드가 실행되어 **테스트-1** 이라는 이름의 스레드가 반환되었습니다.

<br>

> 📌 **setName() & setPriority()**

그리고, Thread에 이름을 넣어주지 않으면 **Thread-1** 형식의 이름이 나오게 됩니다.

이름을 넣어주고 우선순위를 설정해 줌으로써 디버깅 등에 용이 하므로 항상 이름을 붙여주는게 좋습니다.

```java
@Slf4j  
public class ImplementRunnable {  

		/* Implement Runnable */
    public static void create() throws InterruptedException {  
        // Thread()안의 파라미터는 내부적으로 new Runnable()로 실행됩니다.  
        Thread thread = new Thread(() -> {  
            // 어떤 코드를 넣던 운영 체제가 스케줄링 하자마자 새로운 스레드로 실행됩니다.  
            log.info("Thread 이름 : {}", Thread.currentThread().getName());  
            log.info("{} Thread's Priority : {}", Thread.currentThread().getName(), Thread.currentThread().getPriority());  
        });  
  
        // Thread Naming & Set Priority  
        thread.setName("테스트-1");  
        thread.setPriority(Thread.MAX_PRIORITY);  
  
        // 실행  
        log.info("실행 전 Thread 이름 : {}", Thread.currentThread().getName());  
        thread.start();  
        log.info("실행 후 Thread 이름 : {}", Thread.currentThread().getName());  
  
        // InterruptedException - Sleep는 반복되는 명령이 아닙니다.  
        Thread.sleep(10000);  
    }  
  
    public static void main(String[] args) {  
        try {  
            create();  
        } catch (InterruptedException e) {  
            throw new RuntimeException(e);  
        }  
    }  
}
```

<br>

**출력값**

```
> Task :ImplementRunnable.main()
01:30:29.555 [main] INFO com.thread.create.ImplementRunnable -- 실행 전 Thread 이름 : main
01:30:29.559 [main] INFO com.thread.create.ImplementRunnable -- 실행 후 Thread 이름 : main
01:30:29.559 [테스트-1] INFO com.thread.create.ImplementRunnable -- Thread 이름 : 테스트-1
01:30:29.559 [테스트-1] INFO com.thread.create.ImplementRunnable -- 테스트-1 Thread's Priority : 10
```

---

## 📘 Thread Class Capabilities

보통 Java에서 **Unchecked Exception**은 개발자가 직접 Catch 해서 처리하지 않으면 전체 스레드를 다운시킵니다.

이런 상황을 방지하기 위해 처음부터 전체 스레드에 해당하는 Exception Handler를 지정할 수 있습니다.

`thread.setUncaughtExceptionHandler((t, e) -> {})`람다는 내부적으로 `new Thread.UncaughtExceptionHandler()` 으로 구성됩니다.

<br>

Thread 내에서 발생한 예외가 어디에서도 Catch 되지 않으면 핸들러가 호출됩니다.

그럼 개발자는 Catch 되지 않은 스레드와 Exception을 출력하고 추가 데이터를 로깅하기만 하면 됩니다.


```java
@Slf4j  
public class ImplementRunnable {  
  
    /* 캐치되지 않은 Exception Handler */    public static void handler() {  
        Thread thread = new Thread(() -> {  
            // 고의적으로 예외 발생  
            throw new RuntimeException("예외 처리 테스트");  
        });  
  
        thread.setName("예외-테스트");  
        thread.setUncaughtExceptionHandler((t, e) ->  {  
            log.info("{} Thread 내부에 치명적인 에러 발생, 에러 메시지 : {}", Thread.currentThread().getName(), e.getMessage());  
        });  
        thread.start();  
    }  
  
    public static void main(String[] args) {  
        handler();  
    }  
}
```

<br>

**출력값**

```
01:50:58.746 [예외-테스트] INFO com.thread.create.ImplementRunnable -- 예외-테스트 Thread 내부에 치명적인 에러 발생, 에러 메시지 : 예외 처리 테스트
```