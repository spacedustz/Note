## 📘 Critical Section을 이용한 Concurrency 문제 방지

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

그 임계영역을 **진입점**과 **진출점**으로 감싸 보겠습니다.

```java
void aggregateFunction() {
	// Enter Critical Section
	operation1();
	operation1();
	operation1();
	operation1();
	// Exit Critical Section
	...
}
```

현재 임계영역에서 실행되고 있는 스레드는 없다고 가정하며, 

새로운 **스레드 A**가 진입해 operation1,2,3을 실행할 수 있습니다.

<br>

여기서 1개의 새로운 스레드 B가 이미 스레드A가 들어가 있는 임계영역에 들어가려고 하면 액세스를 거부당하고,

처음 들어간 A스레드가 종료되어 임계영역에서 나갈 떄 까지 Suspend 될 것입니다.

이런 식으로 동작하면 Concurrency 문제를 걱정할 필요 없이 **모든 수의 개별 작업에 대한 원자성을 확보** 할 수 있습니다.

