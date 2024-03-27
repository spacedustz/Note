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