## 📘 Atomic Operation의 판단 기준

원자적인 연산(Atomic Operation)을 판단하는 기준이 뭘까요?

전 글에서 예시를 들며 학습 했었지만 아직 크게 와 닿지는 않습니다.

<br>

그래서 어떤 연산지 원자적인지 모르니까 모든 함수를 synchronized를 이용해 동기화 한다고 가정해봅니다.

즉, 공유 변수에 액세스할 수 있는 모든 함수를 동기화 시킵니다.

그럼 병렬로 실행되는 코드의 개수를 최소화 해주게 되는데요.

<br>

예를 들어 동시 실행 될 거라 짐작하는 스레드를 4개 만들어서 실행하면,

모든 함수가 동기화 된 상태라 한번에 1개의 스레드만 실행 되고 나머지 3개는 Suspend 상태로 있게 됩니다.

이러면 사실상 스레드 1개만 있는것과 다를게 없습니다.

<br>

더 안 좋은 점은 여러 스레드를 유지하기 위한 컨텍스트 스위칭 & 메모리 오버헤드까지 발생해

오히려 단일 스레드로 사용하는 것 보다 훨씬 좋지 않은 성능을 가지게 됩니다.

<br>

제가 원하는 방향은 대부분의 스레드가 동시 실행되면서 정해진 시간에 스레드 하나만 실행될 때보다,

더 많은 작업을 수행할 수 있게 되는 방향입니다.

핵심만 말하면 함수를 동기화 할떄 **동기화 하는 부분을 최소화**해야 한다는 점입니다.

<br>

> 🚩 **어떤 연산지 원자적인지에 대한 판단**

**Reference 할당**

- 모든 Reference 할당은 Atomic Operation(원자적 연산)입니다.
- 즉, 참조를 하는 객체는 단일 연산을 통해 안전하게 변경할 수 있습니다.
- 예를 들어 Reference를 가져오거나 배열,문자열 등 객체에 설정하는 작업인 Getter / Setter가 원자적 연산의 대표적인 예입니다.
- 위 Getter / Setter의 경우 동기화를 시킬 필요가 없습니다.

<br>

**long & double을 제외한 원시형에 대한 모든 할당**

- 이 경우도 Atomic Operation에 해당합니다.
- 위 원시형 타입 외 **int,short,byte,float,char,boolean** 모두 동기화 할 필요 없이 안전하게 Read / Write가 가능합니다.

<br>

> 🚩 **long / double이 Atomic Operation이 아닌 이유**

- long과 double은 길이가 64비트여서 Java에서 데이터 일관성을 보장 해주지 않습니다.
- 64비트 기반 컴퓨터의 경우에도 long이나 double에 Write 작업을 하면 실제로 CPU 2개를 사용해 연산을 할 가능성이 높습니다.

<br>

위의 이유로 long / double 을 사용할 때 `volatile` 키워드를 사용하면 해당 변수의 Read / Write 작업이,

Thread Safe한 원자적 연산을 가능하게 됩니다.

내부적으로 보면 2개의 하드웨어 연산이 아닌, 1개의 하드웨어 연산으로 작업을 수행하는걸 보장합니다.

---

## 📘 Use Case - Metrics Capturing

어플리케이션 제작 단계에서 앱을 실행할 때

중요한 연산이나 코드 작업 시간이 얼마나 걸리는지 측정하는 경우가 많습니다.

```java
public class SomeBusinessLogicClass {
    public void time() {
        long start = System.currentTimeMillis();
        // Important Operation
        long end = System.currentTimeMillis();

        long duration = end - start;
        captureMetrics(duration);
    }
}
```

이런 작업의 소요 시간은 클라이언트의 입력값 데이터와 코드가 실행되는 HW, OS 환경 등 여러 요인에 의해 달라집니다.

해당 연산들의 Duration을 잘 캡쳐해서 성능 문제를 찾아내야 합니다.

<br>

> 🚩 **스레드의 수행 시간(Duration)을 캡쳐하는 간단한 프로그램 예시**

아래 코드에서 눈여겨 봐야할 건 Metrics 클래스의 `average` 변수 옆에 붙은 `volatile` 키워드와,

바로 아래 `synchronized` 키워드가 적용된 동기화 함수입니다.

<br>

우선 **동기화된 appSample 함수**는 코드 자체가 synchronized가 없으면,

여러 스레드가 동시에 average와 count를 수정할때 데이터의 일관성을 보장하기 힘들게 때문에 동기화 시켜 주었습니다.

<br>

그리고 Metrics 클래스의 average 변수에 붙은 `volatile` 키워드를 붙인 이유는 다음과 같습니다.

- 단순히 외부에서 Getter를 쓸때 Reference & Primitive 타입의 Read 작업은 동기화가 필요없습니다.
- 하지만, double 형은 Thread-Safe한 다른 Primitive 형과 달리 long, double은 Thread-Safe 보장이 안됩니다.
- 그래서 `volatile` 키워드를 사용해 변수를 메인 메모리에 직접 저장하고 읽을떄도 메인 메모리에서 읽도록 보장해주는 키워드입니다.
- 즉, 메인 메모리에서 값을 읽고 씀으로써 항상 최신의 값을 보장하여 가시성 문제를 방지합니다.

```java
@Slf4j  
public class TimeAverage {  
    public static void main(String[] args) {  
        Metrics metrics = new Metrics();  
  
        BusinessLogic business1 = new BusinessLogic(metrics);  
        BusinessLogic business2 = new BusinessLogic(metrics);  
        MetricsPrinter printer = new MetricsPrinter(metrics);  
  
        business1.start();  
        business2.start();  
        printer.start();  
    }  
  
    /* 샘플의 평균값을 가지고 있는 클래스 */    
    @Getter  
    public static class Metrics {  
        private long count = 0; // 지금까지 캡쳐된 샘플의 개수를 추적하는 Count 변수  
        private volatile double average = 0.0; // 모든 샘플의 총합을 개수로 나눈 평균값  
  
        // 새로운 Sample 값을 받아 새로운 평균값을 업데이트 해주는 함수  
        public synchronized void addSample(long sample) {  
            double currentSum = average * count; // 기존 평균값  
            count++;  
            average = (currentSum + sample) / count; // 새로운 평균값  
        }  
    }  
  
    /* 시작 & 종료 시간을 캡쳐해 샘플을 추가하는 클래스 */    
    @RequiredArgsConstructor  
    public static class BusinessLogic extends Thread {  
        private final Metrics metrics;  
        private Random random = new Random();  
  
        @Override  
        public void run() {  
  
            while (true) {  
                long start = System.currentTimeMillis();  
  
                try {  
                    Thread.sleep(random.nextInt(10));  
                } catch (InterruptedException e) {  
                    log.error("Thread Interrupted");  
                }  
  
                long end = System.currentTimeMillis();  
  
                metrics.addSample(end - start);  
            }  
        }  
    }  
  
    /* BusinessLogic 클래스와 병렬로 실행되며 BusinessLogic의 평균 시간을 캡쳐 후 출력하는 클래스 */ 
    @RequiredArgsConstructor  
    public static class MetricsPrinter extends Thread {  
        private final Metrics metrics;  
  
        @Override  
        public void run() {  
            while (true) {  
                try {  
                    Thread.sleep(100);  
                } catch (InterruptedException e) {  
                    log.error("Thread Interrupted");  
                }  
  
                double currentAverage = metrics.getAverage();  
  
                log.info("현재 Average 값 : {}", currentAverage);  
            }  
        }  
    }  
}
```

<br>

**출력값**

```
22:42:31.171 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 4.975
22:42:31.277 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.012195121951219
22:42:31.377 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.049586776859504
22:42:31.478 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.100628930817612
22:42:31.578 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.1794871794871815
22:42:31.679 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.413333333333336
22:42:31.779 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.42145593869732
22:42:31.880 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.427609427609432
22:42:31.980 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.42388059701493
22:42:32.081 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.448648648648649
22:42:32.182 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.463054187192118
22:42:32.286 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.37250554323725
22:42:32.386 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.3117408906882595
22:42:32.487 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.333333333333331
22:42:32.588 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.319298245614034
22:42:32.689 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.263843648208466
22:42:32.789 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.315789473684206
22:42:32.890 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.338235294117644
22:42:32.991 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.393258426966289
22:42:33.092 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.422818791946306
22:42:33.192 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.432778489116517
22:42:33.293 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.427350427350428
22:42:33.394 [Thread-2] INFO com.thread.share.TimeAverage -- 현재 Average 값 : 5.442488262910798
```

---
## 📘 Summary

위 코드를 토대로 어떤 연산이 동기화 없이도 안전하게 수행될 수 있는지, 원자적 연산인지에 대해 좀 더 알아 보았습니다.

위 작업은 double / long을 제외한 Primitive Type에 대한 할당 작업과 Reference에 대한 할당 작업,

volatile 키워드를 사용한 double / long에 대한 할당 작업 구별할 수 있는 예시 프로그램입니다.

<br>

원자적 연산에 대한 판단은 멀티스레딩 환경에서 수 많은 작업을 병렬 실행하면서,

정확한 결과값을 도출할 수 있고 고성능 어플리케이션을 구축하는데 있어 핵심입니다.

<br>

> 🚩 **학습한 점**

- volatile 변수는 변수의 값을 항상 메인 메모리에서 직접 읽히도록 한다.
- volatile 변수에 새 값이 대입되면 이 값은 언제나 메인 메모리로 즉시 쓰여진다.
- 이 동작은 다른 CPU 에서 동작하는 다른 쓰레드에게 항상 volatile 변수의 최신 값이 읽히도록 보장한다. 
- volatile 변수의 값은 CPU 캐시가 아닌 메인 메모리로부터 직접 읽히게 된다.
- volatile 변수는 논 블로킹이다.
- volatile 변수로의 쓰기는 원자적 연산이고, 다른 쓰레드가 끼어들 수 없다.
- 하지만 volatile 변수라 할지라도 연속적인 읽기-값 변경-쓰기 동작은 원자적이지 않다.
- 둘 이상의 쓰레드에 의해 수행된다면 여전히 경합을 유발한다

<br>


volatile에 대해서는 다음에 더 자세히 다뤄볼 예정입니다.