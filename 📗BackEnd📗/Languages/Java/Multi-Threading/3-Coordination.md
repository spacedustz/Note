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

---

## 📘 Thread.join()

다른 스레드를 시작하고 멈추는 기능 그 이상에 대해 알아보겠습니다.

특히, 신뢰하는 스레드가 예상 시간 안에 작업을 완료하게 만드는 법을 배울 겁니다.

그러려면 스레드 실행을 완전히 제어할 수 있어야 합니다.

그렇게 특정 작업들을 병렬로 실행하고 처리 속도를 높이면 안전하고 정확하게 결과를 출력할 수 있습니다.

<br>

앞서 알아본 것처럼 스레드를 실행하면 **독립적으로 동작**하며,

**스레드의 실행 순서** 역시 개발자가 제어할 수 없습니다.

<br>

동시에 시작하는 두 스레드 A,B를 예시로 들어서 예측할 수 있는 결과는 아래와 같습니다.

- A가 B보다 먼저 작업을 완료한다.
- B가 A보다 먼저 작업을 완료한다.
- A,B가 동시에 실행되거나, 병렬로 실행된다.

<br>

> 📌 **만약 한 스레드가 다른 스레드에 의존한다면?**

예를 들어 A의 계산값이 B에 입력된다고 가정해 보겠습니다.

<br>

이 때 B는 A가 계산이 완료 되었는지 어떻게 알 수 있을까요?

단순하게 B가 Loop를 돌면서 A의 계산 작업을 계속 확인하면 되지만, 굉장히 비효율적인 방법입니다.

```java
void waitForThreadA() {
	while (!threadA.isFinished()) {
		// burn CPU cycles
	}
}
```

왜냐하면, A는 CPU를 이용해 작업을 완료하려 하고, 결과값을 B에 주려는 동안,

B는 계속 Loop를 돌면서 CPU Cycle을 태워버리기 때문입니다.

즉 A의 결과값을 받으려는 B의 Loop 실행이 결과적으로 A의 계산 작업을 느리게 만들게 됩니다.

<br>

> 📌 **다른 방법**

위의 비효율적인 방법보다 B를 sleep 상태로 두고, A가 작업을 완료했을때 깨우는 편이 훨씬 낫습니다.

이 방법에 사용되는 것이 이 글의 주제인 **Thread.join()** 메서드입니다.

---
## 📘 Thread.join() 예시

특정 숫자 배열에서 각 숫자의 Factorial을 계산하는 예시 코드로 join()을 배워보겠습니다.

계승(Factorial) 계산은 곱셈 연산이 많아 CPU를 많이 사용하는 작업 중 하나입니다.

그래서 멀티스레딩을 이용해 각각의 계산을 각각 다른 스레드에 병렬로 맡길 겁니다.

<br>

**FactorialThread**

아래 코드에서 `factorial()` 함수가 종료될때마다 계산값을 리턴하는 이유는,

결과값이 너무 크면 OverFlow가 발생할 수 있어 오래 사용하지 못하기 때문입니다.

그래서 BigInteger를 사용하였습니다.

<br>

스레드가 계산을 마치면 isNinished에 true를 반환하여 클래스 밖에서 getter를 호출하고,

클래스와 호출자가 결과 준비 여부를 알아낼 수 있습니다.

<br>

메인 스레드에서는 모든 Factorial 스레드의 결과값을 로그로 찍어서 출력할 겁니다.

```java
/* 숫자 배열 - 각 숫자의 Factorial을 각각의 스레드로 병렬 계산하는 클래스 */
@Slf4j  
@Getter  
public class FactorialThread extends Thread {  
  
    private long inputNums;  
    private BigInteger result = BigInteger.ZERO;  
    private boolean isFinished = false;  
  
    public FactorialThread(long inputNums) {  
        this.inputNums = inputNums;  
    }  
  
    @Override  
    public void run() {  
        this.result = factorial(inputNums);  
        this.isFinished = true;  
    }  
  
    // 스레드가 스케줄링 되면 입력 숫자의 Factorial을 계산 후, result 변수에 저장합니다.  
    public BigInteger factorial(long n) {  
        BigInteger tempResult = BigInteger.ONE;  
  
        for (long i = n; i > 0; i--) {  
            tempResult = tempResult.multiply(new BigInteger(Long.toString(i)));  
        }  
  
        return tempResult;  
    }  
  
    public static void main(String[] args) {  
        // 숫자 배열 생성  
        List<Long> inputNums = Arrays.asList(0L, 3435L, 35435L, 2324L, 4656L, 23L, 2435L, 5566L);  
  
        // 스레드 리스트 생성  
        List<FactorialThread> list = new ArrayList<>();  
  
        // 모든 입력 숫자에 대해 각각 스레드 객체 생성  
        for (long inputNum : inputNums) {  
            list.add(new FactorialThread(inputNum));  
        }  
  
        // 스레드 리스트의 모든 스레드 시작  
        for (Thread thread : list) {  
            thread.start();  
        }  
  
        // 계산 스레드에서 결과값을 가져와 출력 - main 메서드의 역할  
        for (int i = 0; i < inputNums.size(); i++) {  
            // 각 스레드의 계산 완료 여부(isFinished)를 확인해 결과가 준비 됬는지 확인  
            FactorialThread thread = list.get(i);  
  
            // 계산이 완료됬다면, 입력값과 계산 결과값 출력  
            if (thread.isFinished) {  
                log.info("계산 완료. - {}의 Factorial은 {} 입니다.", inputNums.get(i), thread.getResult());  
            } else {  
                log.info("계산 중 입니다. - 입력값 : {}", inputNums.get(i));  
            }  
        }  
    }  
}
```

<br>

위 코드를 실행하면 아래왜 같은 출력값이 나옵니다.

```
> Task :FactorialThread.main()
16:36:47.378 [main] INFO com.thread.coordination.FactorialThread -- 계산 완료. - 0의 Factorial은 1 입니다.
16:36:47.384 [main] INFO com.thread.coordination.FactorialThread -- 계산 중 입니다. - 입력값 : 3435
16:36:47.384 [main] INFO com.thread.coordination.FactorialThread -- 계산 중 입니다. - 입력값 : 35435
16:36:47.384 [main] INFO com.thread.coordination.FactorialThread -- 계산 중 입니다. - 입력값 : 2324
16:36:47.384 [main] INFO com.thread.coordination.FactorialThread -- 계산 중 입니다. - 입력값 : 4656
16:36:47.384 [main] INFO com.thread.coordination.FactorialThread -- 계산 완료. - 23의 Factorial은 25852016738884976640000 입니다.
16:36:47.384 [main] INFO com.thread.coordination.FactorialThread -- 계산 중 입니다. - 입력값 : 2435
16:36:47.384 [main] INFO com.thread.coordination.FactorialThread -- 계산 중 입니다. - 입력값 : 5566
```

<br>

0과 23의 Factorial을 계산하는 것은 그렇게 오래 걸리지 않아서, 0과 23의 결과값은 나왔습니다.

이 현상이 어디서 많이 들어본 **Race Condition** 입니다.

<br>

Thread List를 순회하며 스레드들을 실행 시키는 2번째 for Loop와,

각 스레드의 결과값을 확인하려는 main 스레드의 Loop인 마지막 Loop 사이에서 일어나는 경쟁 상태 입니다.

```java
// 스레드 리스트의 모든 스레드 시작  
for (Thread thread : list) {  
    thread.start();  
}  
  
// 계산 스레드에서 결과값을 가져와 출력 - main 메서드의 역할  
for (int i = 0; i < inputNums.size(); i++) {  
    // 각 스레드의 계산 완료 여부(isFinished)를 확인해 결과가 준비 됬는지 확인  
    FactorialThread thread = list.get(i);  
  
    // 계산이 완료됬다면, 입력값과 계산 결과값 출력  
    if (thread.isFinished) {  
        log.info("계산 완료. - {}의 Factorial은 {} 입니다.", inputNums.get(i), thread.getResult());  
    } else {  
        log.info("계산 중 입니다. - 입력값 : {}", inputNums.get(i));  
    }  
}
```

<br>

이제 위 코드에서 **Thread.join()**을 사용해서 계산 스레드가 작업을 마칠떄까지,

결과 값을 확인하는 main 스레드를 대기하게 만들어 보겠습니다.

위에서 경쟁 상태에 들어간 2개의 For Loop 사이에 또 하나의 For Loop를 추가해줍니다.

```java
    // 스레드 리스트의 모든 스레드 시작  
    for (Thread thread : list) {  
        thread.start();  
    }  
  
    // join()을 통해 계산 스레드의 모든 작업이 완료 되었을때 아래 Loop를 실행하게 함.  
    for (Thread thread : list) {  
        try {  
            thread.join();  
        } catch (InterruptedException e) {  
        }  
    }  
  
    // 계산 스레드에서 결과값을 가져와 출력 - main 메서드의 역할  
    for (int i = 0; i < inputNums.size(); i++) {  
        // 각 스레드의 계산 완료 여부(isFinished)를 확인해 결과가 준비 됬는지 확인  
        FactorialThread thread = list.get(i);  
  
        // 계산이 완료됬다면, 입력값과 계산 결과값 출력  
        if (thread.isFinished) {  
            log.info("계산 완료. - {}의 Factorial은 {} 입니다.", inputNums.get(i), thread.getResult());  
        } else {  
            log.info("계산 중 입니다. - 입력값 : {}", inputNums.get(i));  
        }  
    }  
}
```

모든 스레드의 join() 메서드는 스레드가 반드시 종료 되어야 반환됩니다.

그래서 저렇게 사이에 join()을 수행하는 Loop를 넣게 되면 Main 스레드의 출력값 확인 Loop가 돌기 전에,

계산 스레드가 전부 작업을 마친 상태가 됩니다.

<br>

**출력값**

```
...

0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 입니다.
16:44:48.239 [main] INFO com.thread.coordination.FactorialThread -- 계산 완료. - 23의 Factorial은 25852016738884976640000 입니다.
16:44:48.239 [main] INFO com.thread.coordination.FactorialThread -- 계산 완료. - 2435의 Factorial은 513182645561128088672156736464340287524403662593648466794330042634192500265473203299719385643238690018643728904909901304742971610865224171209035401972133875496928699825980018137211793957785744272636619750074273361084919494259263407714994235148229340544283948837689491015969515026299776362802607590656

...
```

출력값은 숫자가 너무 크게 나와서 스크롤 압박이 굉장히 심하므로 이 글에서 적진 않겠지만,

실행을 시켜보면 모든 계산 작업의 결과값이 main 스레드에 의해 출력되는걸 확인하실 수 있을 겁니다.

<br>

> 📌 **Edge Case**

만약 위 Factiroal 예시에서 입력으로 들어오는 숫자 배열의 숫자 중 1개의 값이 엄청 큰 값이면 어떻게 해야 할까요?

이와 같은 상황이 되면, `join()`은 스레드가 종료되어야 반환되기 때문에,

main 메서드로 결과값을 출력하는 스레드의 실행은 엄청나게 늦춰져서 1개의 계산 스레드 때문에 모든 결과값을 받지 못하게 됩니다.

<br>

해결 방법으로는 **Thread.join()** 을 사용할 때 긴 작업 스레드가 기다릴 시간을 정하고,

그 값을 **Thread.join()** 파라미터에 값을 전달하면 됩니다.

값의 단위는 MilliSecond이며 2000으로 설정했다고 가정하면, 2초 후 스레드가 종료되지 않는다면 **Thread.join()**이 반환됩니다.

그리고, 이 긴 자