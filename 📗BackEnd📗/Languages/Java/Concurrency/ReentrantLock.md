## 📘 ReentrantLock

> 📕 **사용사례** : 방에 움직임이 있을 때 조명을 계속 켜두는 Light Sensor

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