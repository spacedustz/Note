## 📘 Process 내부 구조

운영체제에서 모든 프로그램은 실행을 하면 메모리로 올라와서 프로세스로 올려집니다.

> **프로세스의 구조**

- MetaData (PID, Mode, Priority ... 등등)
- Data(Heap)
- Files
- Code
- MainThread (Stack, Instruction Pointer)
  - Stack은 메모리 영역으로 지역 변수가 저장되고 기능이 실행되는 영역입니다.
  - Instruction Pointer는 스레드가 실행할 다음 명령어 주소의 포인트 역할만 합니다.

<br>

프로세스의 Stack, Instruction 부분만 제외하면 나머지 모든 스레드들이 MetaData, Data, Files, Code를 공유합니다.

- **Responsiveness (응답성)****Performance(성능)**

**Concurrency (병행성)**

---

## 📘 Context Switch

각각의 어플리케이션과 프로세스는 독립적으로 실행됩니다.

운영체제에서는 일반적으로 코어보다 프로세스가 훨씬 많고, 각각의 프로세스는 1개 이상의 스레드를 가집니다.

그리고 모든 스레드는 CPU 실행을 두고 서로 경쟁합니다.

즉 CPU에서는 스레드 실행 - 멈춤 - 다른 스레드 실행 - 멈춤 을 반복합니다.

위처럼 스레드를 스케줄링 하면서 다시 실행 시키는 것이 Context Switch 입니다.

<br>

> **Context Switch를 이해해야 하는 중요한 이유**

동시에 많은 스레드를 다룰때는 효율성이 떨어지는데 이것이 동시성을 위한 대가입니다.

<br>

## Thread Scheduling

<br>

## Threads vs Processes