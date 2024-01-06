## 📘 Atomic Operation & Volatile & Metric

원자적인 연산(Atomic Operation)을 판단하는 기준이 뭘까요?

전 글에서 예시를 들며 학습했었지만 아직 크게 와닿지는 않습니다.

<br>

그래서 어떤 연산지 원자적인지 모르니까 모든 함수를 synchronized를 이용해 동기화 한다고 가정해봅니다.

즉, 공유 변수에 액세스할 수 있는 모든 함수를 동기화 시킵니다.

그럼 