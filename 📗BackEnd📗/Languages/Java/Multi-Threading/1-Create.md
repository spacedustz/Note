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

---

## 📘 Thread를 확장한 Class

Runnable을 직접 구현하지 않고 Runnable을 구현한 Thread를 상속받아 확장한 Class로 스레드를 생성합니다.

이렇게 스레드를 생성하면 현재 스레드와 직접적으로 관련된 많은 데이터/메서드를 사용할 수 있습니다.

<br>

Runnable을 직접 구현한 Thread의 경우, Thread 인스턴스에 접근하려면 `Thread.getCurrentThread()`를 호출해야 했습니다.

하지만, Thread를 확장하면 `this`로 매우 많은 정보와 메서드에 접근이 가능하게 됩니다.

```java
@Slf4j  
public class ImplementRunnable {

	/* Thread를 확장한 Thread */
	public static void extendedThread() {  
    Thread thread = new ExtendedThread();  
    thread.setName("Extend-1");  
    thread.start();  
	}

	/* Thread를 확장한 Private Class */
	private static class ExtendedThread extends Thread {  
    @Override  
    public void run() {  
        log.info("Thread를 확장한 Class의 Thread 이름 : {}" , this.getName());  
    }  
	}

  public static void main(String[] args) {   
        extendedThread();
  }
}
```

<br>

**출력값**

```
02:08:36.073 [Extend-1] INFO com.thread.create.ImplementRunnable -- Thread를 확장한 Class의 Thread 이름 : Extend-1
```

---

## 📘 Thread 상속

하나의 예시를 들어, 돈을 보관할 안전한 금고를 설계한다고 가정해 봅시다.

그리고 해커들이 코드를 추측해서 금고를 여는데 얼마나 걸리는지 알아보겠습니다.

동시에 금고의 코드를 깨려는 헤커 스레드를 몇개 만들고, 경찰 스레드도 추가합니다.

경찰 스레드는 10초 안에 해커를 잡으러 옵니다.

만약 해커들이 그동안 돈을 훔쳐서 도망가지 않는다면 경찰이 해커를 체포합니다.

10초를 세는동안 경찰 스레드는 도착 상황을 화면에 띄워 보여줄 겁니다.

<br>

위 예시의 계층을 정리해 보자면,

- 최상위 Runnable 인터페이스
- Runnable을 구현한 Thread
- Thread를 확장한 **Hacker Thread** / **Police Thread** (이때, Hacker Thread는 금고 객체에 대한 Referense를 가지고 있음)
- HackerThread를 확장한 **AscendingHackerThread** / **DescendingHackerThread** (둘다 금고 객체에 대한 참조를 가짐)

이런 계층 구조입니다.
