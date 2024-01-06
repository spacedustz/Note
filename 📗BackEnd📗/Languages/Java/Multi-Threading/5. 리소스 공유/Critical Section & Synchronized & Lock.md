## 📘 Thread 간 Heap 객체를 공유할때 발생하는 임계영역 문제

[Thread 간 Resource 공유 시 발생할 수 있는 문제 - 지난 포스팅 글](https://iizz.tistory.com/432)

**위 글에서 다뤘던 코드의 문제점을 다시 한 번 살펴봅니다.**

- 2개의 스레드가 1개의 Counter를 공유하는데, 둘 다 그 카운터를 read/write 할 수 있었습니다.
- 또, 해당 작업들은 비 원자적(Atomic Operation) 입니다.

<br>

위 문제는 흔히 발생하는 문제로 일반적으로는 **여러 작업의 집합을 모두 1개의 원자적 작업**으로 보이게 만들곤 합니다.

어떠한 경우에도 2개의 스레드가 작업을 동시에 수행할 순 없기 때문입니다.

```java
void aggregateFunction() {
	operation1();
	operation1();
	operation1();
	operation1();
	...
}
```

<br>

만약 동시에 실행되지 않게 보호해야 하는 코드가 있는 영역을 **임계영역**이라고 하며,

그 임계영역을 **진입점**과 **진출점**으로 감싸

> 🚩 **Concurrency 문제**

