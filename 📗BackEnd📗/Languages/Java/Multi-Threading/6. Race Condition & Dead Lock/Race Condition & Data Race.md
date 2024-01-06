## 📘 Race Condition & Data Race

Race Condition이란 공유된 리소스에 접근하는 여러 스레드가 있을 때,

최소 1개의 스레드가 공유 리소스를 수정하는 경우로,

스레드 스케줄링의 순서나 시점에 따라 결과가 달라지는 상황을 말합니다.

<br>

위 문제의 핵심은 공유 리소스에 비원자적 연산이 실행되는 문제입니다.

Race Condition의 솔루션으로는 지난번 포스팅 했던 글을 봤을떄,

Race Condition이 일어나는 Critical Section을 동기화 블럭에 넣어 보호한다고 배웠습니다.

```java
public synchronized void increment() {
	// 임계 영역 진입점
	items++;
	// 임계 영역 진출점
}

public synchronized void decrement() {
	// 임계 영역 진입점
	items--;
	// 임계 영역 진출점
}
```

<br>

그럼 Data Race는 무엇일까요?

