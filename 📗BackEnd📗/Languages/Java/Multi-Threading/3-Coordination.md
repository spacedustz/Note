## 📘 Thread Coordination

이번에 배워볼 건 스레드를 조정하는 방법입니다.

그 중 하나의 스레드를 다른 스레드에서 멈추게 하는 작업 (Thread Termination)이죠.

<br>

이 Thread Termination에는 몇가지 방법이 있습니다.

- **interrupt() 를 사용하는 방법**
- **Daemon Thread를 사용하는 방법**

<br>



> 📌 **스레드를 언제/왜 멈춰야 할까요?**

- **스레드는 아무 동작을 안해도 메모리와 일부 커널 리소스를 사용합니다.**
- 그리고 CPU 타임과 CPU 캐시 공간도 사용합니다.
- 따라서 생성한 스레드가 이미 작업을 완료했는데 어플리케이션이 동작중이라면 미사용 스레드가 잡아먹는 리소스를 정리해야 합니다.
- 또, **스레드가 오작동 할 시**에도 스레드를 중지해야 합니다.
- 예를 들어 응답이 없는 서버에 계속 요청을 보낸다거나 하는 등의 행위입니다.
- 그리고 마지막 이유는, **어플리케이션 전체를 중단하기 위해서** 입니다.
- 스레드가 하나라도 실행 중 이라면, 어플리케이션은 종료되기 않기 때문입니다. 
- _(메인스레드가 이미 멈췄다고 하더라도 다른 스레드가 실행중이면 어플리케이션은 종료되지 않습니다.)_
- 따라서 어플리케이션을 종료하기 전, 모든 스레드를 중단할 기능이 필요합니다.

---

## 📘 Thread.interrupt()

모든 스레드는 `interrupt`라는 메서드를 가집니다.

만약 A,B 두개의 스레드가 실행 중이라고 가정하고, A에서 B.interrupt()를 실행하면 B 스레드가 멈춥니다.

<br>

> 📌 **어떤 상황일 때 interrupt()를 쓸 수 있을까요?**

**첫번째는**, 스레드가 InterruptedException을 발생시키는 메서드를 실행시키는 경우

**두번째는**, 스레드의 코드가 Interrupt Signal를 명시적으로 처리하는 경우

이유를 봐도 무슨 말인지 잘 모르니 예시를 봅시다.

<br>

**BlockingTimeThread**

이 코드는 main 스레드가 종료 되었음에도 BlockingTask 스레드는 sleep(500000) 동안 종료되지 않고 계속 실행됩니다.

그래서 메인 스레드에서 sleep()으로 5초 후 **orderStopThread** 스레드를 추가로 만들어서,

BlockingTask 스레드를 interrupt 시키는 동작을 추가로 수행 후에야 BlockingTask 스레드가 종료 되었습니다.

```java
package com.thread.coordination;  
  
import lombok.extern.slf4j.Slf4j;  
  
@Slf4j  
public class BlockingTimeThread {  
  
    // Runnable을 구현하며 잘못된 시간을 차단하는 작업을 수행하는 스레드  
    private static class BlockingTask implements Runnable {  
  
        @Override  
        public void run() {  
            try {  
                Thread.sleep(500000);  
            } catch (InterruptedException e) {  
                log.info("Blocking Thread 종료");  
            }  
        }  
    }  
  
    public static void main(String[] args) {  
        Thread thread = new Thread(new BlockingTask());  
        thread.start();  
  
        try {  
            Thread.sleep(5000);  
        } catch (InterruptedException e) {  
            throw new RuntimeException(e);  
        }  
  
        Thread orderStopThread = new Thread(thread::interrupt);  
        orderStopThread.start();  
    }  
}
```

<br>

아래 코드는 거듭제곱을 계산하는 스레드를 실행하는 코드입니다.

```java
@Slf4j  
public class BlockingTimeThread {  
  
    // Runnable을 구현하며 잘못된 시간을 차단하는 작업을 수행하는 스레드  
    private static class BlockingTask implements Runnable {  
  
        @Override  
        public void run() {  
            try {  
                Thread.sleep(500000);  
            } catch (InterruptedException e) {  
                log.info("Blocking Thread 종료");  
            }  
        }  
    }  

		// 거듭제곱을 수행하는 스레드
    private static class LongComputationTask implements Runnable {  
  
        private BigInteger base; // 밑수  
        private BigInteger power; // 제곱  
  
        public LongComputationTask(BigInteger base, BigInteger power) {  
            this.base = base;  
            this.power = power;  
        }  
  
        // 밑과 제곱을 올리는 함수  
        private BigInteger pow(BigInteger base, BigInteger power) {  
            // 결과만 선언하고 1초 초기화  
            BigInteger result = BigInteger.ONE;  
  
            // 그리고, 0부터 제곱의 값까지 반복  
            for (BigInteger i = BigInteger.ZERO; i.compareTo(power) != 0; i = i.add(BigInteger.ONE)) {  
                // 각각의 반복에서는 이전 반복에서 도출된 결과에 밑수를 곱해 새로운 결과를 계산합니다.  
                result = result.multiply(base);  
            }  
  
            // 결과 반환  
            return result;  
        }  
  
        // 밑수와 제곱을 계산해 결과를 반환하는 스레드 실행  
        @Override  
        public void run() {  
            log.info("{} * {} = {}", base, power, pow(base, power));  
        }  
    }  
  
    public static void main(String[] args) {  
        /* BlockingTask 실행 코드 *///        
//        Thread thread = new Thread(new BlockingTask());  
//        thread.start();  
//  
//        try {  
//            Thread.sleep(5000);  
//        } catch (InterruptedException e) {  
//            throw new RuntimeException(e);  
//        }  
//  
//        Thread orderStopThread = new Thread(thread::interrupt);  
//        orderStopThread.start();  
  
  
        /* LongComputationTask 실행 코드 */        
        Thread thread = new Thread(new LongComputationTask(new BigInteger("2"), new BigInteger("10")));  
        // 2의 10제곱 계산  
        thread.start();  
    }  
}
```