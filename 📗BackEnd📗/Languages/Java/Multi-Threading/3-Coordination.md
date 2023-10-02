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
public class InterruptThread {  
  
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

**아래 코드는 거듭 제곱을 계산하는 스레드를 실행하는 코드입니다.**

main 스레드에서는 작은 수인 2의 10제곱을 계산해서 계산결과가 바로 1024로 빠르게 나왔습니다.

만약 base, power에 엄청 큰 수(200000, 100000000)를 대입하게 되면 계산 시간이 엄청 오래 걸려서 스레드가 중지되지 않으며,

main 메서드에 interrupt() 메서드를 넣어도, 이를 처리할 메서드나 로직이 없기 때문에 interrupt 되지 않습니다.

```java
@Slf4j  
public class InterruptThread {  
  
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
        thread.interrupt();
    }  
}
```

<br>

이 문제를 해결하려면 거듭 제곱을 계산하는 코드 내에서 시간이 오래 걸리는 스팟을 찾아야 합니다.

이 경우는 for loop가 해당됩니다.

```java
for (BigInteger i = BigInteger.ZERO; i.compareTo(power) != 0; i = i.add(BigInteger.ONE)) {  
    // 각각의 반복에서는 이전 반복에서 도출된 결과에 밑수를 곱해 새로운 결과를 계산합니다.  
    result = result.multiply(base);  
}  
```

<br>

따라서 이 스레드가 외부에서 interrupt 당했는지 확인하는 로직을 반복이 돌떄마다 if 문을 추가합니다.

```java
for (BigInteger i = BigInteger.ZERO; i.compareTo(power) != 0; i = i.add(BigInteger.ONE)) {  
		// 조건문 추가 - Interrupt 시 계산 중지
		if (Thread.currentThread().isInterrupted()) {
			log.info("계산 중지");
			return BigInteger.ZERO;
		}

    // 각각의 반복에서는 이전 반복에서 도출된 결과에 밑수를 곱해 새로운 결과를 계산합니다.  
    result = result.multiply(base);  
}  
```

---

## 📘 Daemon Thread

Daemon Thread는 백그라운드에서 실행되는 스레드로, 메인 스레드가 종료되도 어플리케이션 종료를 막지 않습니다.

특정 시나리오에서 스레드를 Daemon으로 생성하면 앱의 백그라운드 작업을 맡게 됩니다.

Daemon 스레드는 백그라운드 작업이기 때문에 **앱의 실행이나 종료를 방해하는 일이 없어야 합니다.**

<br>

위의 Thread.interrupt() 예시를 다시 가져와서 스레드를 데몬 스레드로 먼저 만들어 줍니다.

main 메서드에서 스레드를 start 하기 전 `thread.setDaemon(true)`를 작성하면 됩니다.

```java
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
        Thread thread = new Thread(new LongComputationTask(new BigInteger("200000"), new BigInteger("10000000")));  
        // 2의 10제곱 계산  
        thread.setDaemon(true);  
        thread.start();  
        thread.interrupt();  
    }
```

<br>

그 후 다시 프로그램을 실행했을때, 

`Daemon으로 설정하기 전`에는 메인 스레드가 종료되어도 해당 스렏가 멈추지 않았지만,

`Daemon으로 설정한 후`는 main 스레드가 종료되면 전체 어플리케이션이 종료가 됩니다. 

**Daemon Thread는 어플리케이션의 종료를 방해하면 안되기 때문입니다. (Background 작업)**

<br>

> 📌 **간단한 예시 1**

사용자에게 1글자를 입력 받아 입력받은 문자가 `q`면 스레드를 종료하는 코드입니다.

이 스레드를 interrupt() 시키려면 어떻게 해야 할까요?

thread.interrupt()를 메인 메서드에 작성해도 System.in.read()에 반응하지 않습니다.

이 스레드를 멈출 유일한 방법은 이 스레드를 Daemon 스레드로 만드는 것 뿐입니다.

```java
public static void main(String [] args) {  
    Thread thread = new Thread(new WaitingForUserInput());  
    thread.setName("InputWaitingThread");  
    thread.start();  
}  
  
private static class WaitingForUserInput implements Runnable {  
    @Override  
    public void run() {  
        try {  
            while (true) {  
                char input = (char) System.in.read();  
                if(input == 'q') {  
                    return;  
                }  
            }  
        } catch (IOException e) {  
            System.out.println("An exception was caught " + e);  
        };  
    }  
}
```

<br>

> 📌 **간단한 예시 2**

이 코드에서 SleepingThread의 스레드는 sleep() 시간동안 실행될 것이며,

이 스레드를 멈출 방법은 `return;` 선언문을 catch 블록 안에 추가해야 합니다.

보통 catch 블록을 빈 상태로 두어서는 안되며, 

catch 블록의 InterruptedException을 사용해서 스레드를 효율적으로 중단하는 것이 좋습니다.

```java
public static void main(String [] args) {  
    Thread thread = new Thread(new SleepingThread());  
    thread.start();  
    thread.interrupt();  
}  
  
private static class SleepingThread implements Runnable {  
    @Override  
    public void run() {  
        while (true) {  
            try {  
                Thread.sleep(1000000);  
            } catch (InterruptedException e) {  
            }  
        }  
    }  
}
```