## 📘 CountDownLatch

Spring WebClient의 CountDownLatch를 이용해 Thread를 대기시키는 방법에 대해 포스팅 하겠습니다.

우선 예시로 3개의 클래스와 3개의 Thread를 만들어 보겠습니다.

Main Thread 내부에서 3개의 Thread를 생성, 작업을 수행하고 작업시간을 측정합니다.

<br>

**Main**

```java
@Slf4j
public class InterruptTest {

	public static void main(String[] args) {
		Instant start = Instant.now();
		log.info("Test Start");

		int totalNumOfTasks = 3;

		Bloc
	}
}
```