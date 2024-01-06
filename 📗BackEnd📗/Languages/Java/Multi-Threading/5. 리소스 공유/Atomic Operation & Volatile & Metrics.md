## 📘 Atomic Operation의 판단 기준

원자적인 연산(Atomic Operation)을 판단하는 기준이 뭘까요?

전 글에서 예시를 들며 학습했었지만 아직 크게 와닿지는 않습니다.

<br>

그래서 어떤 연산지 원자적인지 모르니까 모든 함수를 synchronized를 이용해 동기화 한다고 가정해봅니다.

즉, 공유 변수에 액세스할 수 있는 모든 함수를 동기화 시킵니다.

그럼 병렬로 실행되는 코드의 개수를 최소화 해주게 되는데요

<br>

예를 들어 동시 실행될거라 짐작하는 스레드를 4개 만들어서 실행하면,

모든 함수가 동기화된 상태라 한번에 1개의 스레드만 실행 되고 나머지 3개는 Suspend 상태로 있게 됩니다.

이러면 사실상 스레드 1개만 있는거랑 다를게 없습니다.

<br>

더 안좋은 점은 여러 스레드를 유지하기 위한 컨텍스트를 스위칭과 메모리 오버헤드까지 발생해

오히려 단일 스레드로 사용하는것 보다 훨씬 좋지 않은 성능을 가지게 됩니다.

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

- long과 double은 길이가 64비트여서 Java에서 보장 해주지 않습니다.
- 64비트 기반 컴퓨터의 경우에도 long이나 double에 Write 작업을 하면 실제로 CPU 2개를 사용해 연산을 할 가능성이 높습니다.

<br>

위의 이유로 long / double 을 사용할 때 `volatile` 키워드를 사용하면 해당 변수에 Read / Write 작업이,

Thread Safe한 원자적 연산이 가능하게 됩니다.

내부적으로 보면 2개의 하드웨어 연산이 아닌, 1개의 하드웨어 연산으로 작업을 수행하는걸 보장합니다.

---

## 📘 Use Case - Metrics

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

Duration을 캡쳐하는 Metrics 클래스를 만들어