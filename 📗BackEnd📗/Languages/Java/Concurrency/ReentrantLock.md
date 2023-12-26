## 📘 ReentrantLock

일을 하던 중 ReentrantLock을 사용해 Concurrency한 환경에서 여러 Thread간 안전하게 Lock을 사용 & 제공하며,

Interrupt

> 📕 **Synchronization**

ReentrantLock의 **lock()** & **unLock()** & **tryLock()** 을 이용해 Thread간 Race Condition을 방지하고,

**lockInterruptibly()** 를 사용해 Lock을 획득할 때 다른 Thread에 의해 해당 Thread가 Interrupte 되면 InterruptException을 발생 시킵니다.

<br>

> 📕 **Interrupt 처리**

아래 코드에서 쓰인 **lockInterruptibly()** 를 사용해서 Lock을 획득하고,

센서 동작중에 다른 Thread에 의해 Interrupt 되면 센서의 동작을 중단시키고 Lock을 해제 시킵니다.

<br>

> 📕 **방에 움직임이 있을 때 조명을 계속 켜두는 Light Sensor Class**

방에 움직임이 있으면 불을 계속 켜두는 센서가 있고,

더이상 움직임이 없을때 불을 끄기 위해 작동하는 TurnOffLight Thread가 있습니다.

<br>

TurnOffLights Thread는 Lock을 얻기위해 **tryLock()** 을 사용합니다.

Lock을 얻을 수 없으면 500ms 동안 프로세스가 지연되고, lastSignal Thread는 5초동안 Lock 획독을 차단합니다.

그 후, TurnOffLights Thread는 Lock을 얻고 조명을 끌 수 있게 되는 구조입니다.

<br>

따라서 이 경우, TurnOffLights Thread는 5초 동안 센서에 움직임이 감지가 되지 않는 경우,

조명을 끌 수 있도록 허용됩니다.

<br>

또한, 이전 신호를 차단하기 위해 `lock.lockInturruptibly()`를 사용합니다.

```java
/**  
 * ReentrantLock : Concurrency 제어를 위한 Lock 객체  
 * lastSignal Thread : 마지막으로 수신된 신호를 추적하기 위한 Thread  
 */
 @Slf4j  
public class LightSensor {  
    private static volatile Lock lock = new ReentrantLock();  
    private static volatile Thread lastSignal = null;  
    private static Sensor sensor = new Sensor();  
  
    /**  
     *  Sensor Class     
     *  이전 신호를 무효화하고 현재 신호를 설정하는 invalidatePreviousSignalAndSetUpCurrent() 호출  
     *  작업 완료 후 Thread Lock 해제  
     */  
    private static class Sensor implements Runnable {  
        // 센서가 신호를 처리중인지 나타내는 상태 변수  
        private static Boolean preparing = false;  
  
        // 센서가 현재 작업을 처리중인지 확인하는 함수  
        public static Boolean isPreparing() { return preparing; }  
  
        @Override  
        public void run() {  
            log.info("Signal Send : {}", Thread.currentThread().getName());  
  
            try {  
                invalidatePreviousSignalsAndSetUpCurrent();  
                Thread.sleep(5 * 1500);  
            } catch (InterruptedException e) {  
                log.info("Signal interrupted : {}" + Thread.currentThread().getName());  
                return;  
            } finally {  
                lock.unlock();  
            }  
        }  
  
        /* 이전 신호를 무효화하고 현재 신호를 설정하는 함수 */        
        private static synchronized void invalidatePreviousSignalsAndSetUpCurrent() throws InterruptedException {  
            preparing = true;  
  
            // 마지막으로 수신된 신호가 있으면 해당 신호를 Interrupt 시킴  
            if (lastSignal != null) lastSignal.interrupt();  
  
            // 현재 스레드를 마지막으로 수신된 신호로 설정하고 Lock 시도  
            lastSignal = Thread.currentThread();  
            lock.lockInterruptibly();  
            preparing = false;  
        }  
    }  
  
    /**  
     * Light를 Off 시키는 클래스  
     * Sensor의 isPreparing이 False(처리중 X)면 Lock을 시도하여 불을 끔  
     * 작업 완료 후 Lock 해제  
     */  
    private static class TurnOffLights implements Runnable {  
        @Override  
        public void run() {  
            while (true) {  
                try {  
                    Thread.sleep(500);  
                } catch (InterruptedException e) {  
                    log.info("THread Interrupted : {}", this.getClass().getName());  
                    return;  
                }  
  
                if (!Sensor.isPreparing()) {  
                    if (lock.tryLock()) {  
                        try {  
                            log.info("Turn Off Lights");  
                            break;  
                        } finally {  
                            lock.unlock();  
                        }  
                    } else {  
                        log.info("Cannot Turn Off Lights Yet");  
                    }  
                } else {  
                    log.info("Cannot Turn Off Lights Yet");  
                }  
            }  
        }  
    }  
  
    /**  
     * 10번의 Loop를 돌아 40번의 광 센서 신호를 보냄  
     */  
    public static void main(String[] args) throws InterruptedException {  
        Thread turnOffLights = new Thread(new TurnOffLights());  
  
        for (int x=0; x<10; x++) {  
            new Thread(sensor).start();  
            new Thread(sensor).start();  
            new Thread(sensor).start();  
            new Thread(sensor).start();  
            Thread.sleep(250);  
        }  
  
        turnOffLights.join();  
    }  
}
```