## 📘 Thread.join()을 이용한 실행 순서 제어

다른 스레드를 시작하고 멈추는 기능 그 이상에 대해 알아보겠습니다.

특히, 신뢰하는 스레드가 예상 시간 안에 작업을 완료하게 만드는 법을 배울 겁니다.

그러려면 스레드 실행을 완전히 제어할 수 있어야 합니다.

그렇게 특정 작업들을 병렬로 실행하고 처리 속도를 높이면 안전하고 정확하게 결과를 출력할 수 있습니다.

<br>

앞서 알아본 것처럼 스레드를 실행하면 **독립적으로 동작**하며,

**스레드의 실행 순서** 역시 개발자가 제어할 수 없습니다.

하지만, join()을 이용해 특정 스레드의 작업 완료 시, 다음 스레드를 실행하게 할 수 있습니다.

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

---
## 📘 Edge Case

만약 위 Factiroal 예시에서 입력으로 들어오는 숫자 배열의 숫자 중 1개의 값이 엄청 큰 값이면 어떻게 해야 할까요?

이와 같은 상황이 되면, `join()`은 스레드가 종료되어야 반환되기 때문에,

main 메서드로 결과값을 출력하는 스레드의 실행은 엄청나게 늦춰져서 1개의 계산 스레드 때문에 모든 결과값을 받지 못하게 됩니다.

<br>

해결 방법으로는 **Thread.join()** 을 사용할 때 긴 작업 스레드가 기다릴 시간을 정하고,

그 값을 **Thread.join()** 파라미터에 값을 전달하면 됩니다.

값의 단위는 MilliSecond이며 2000으로 설정했다고 가정하면, 2초 후 스레드가 종료되지 않는다면 **Thread.join()**이 반환됩니다.

```java
// join()을 통해 계산 스레드의 모든 작업이 완료 되었을때 아래 Loop를 실행하게 함.  
for (Thread thread : list) {  
    try {  
        thread.join(2000);  
    } catch (InterruptedException e) {  
    }  
}
```

<br>

그리고, 이 긴 작업 스레드를 Interrupt 하지 않아 어플리케이션도 여전히 실행중입니다.

간단하게 스레드를 시작하는 for Loop에서 모든 스레드를 Daemon 스레드로 만들면 어플리케이션이 정상적으로 종료됩니다.

```java
// 스레드 리스트의 모든 스레드 시작  
for (Thread thread : list) {  
    thread.setDaemon(true);  
    thread.start();  
}  
```