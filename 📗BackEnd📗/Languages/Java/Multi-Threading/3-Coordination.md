## 📘 Thread Coordination

이번에 배워볼 건 스레드를 조정하는 방법입니다.

그 중 하나의 스레드를 다른 스레드에서 멈추게 하는 작업 (Thread Termination)이죠.

<br>

이 Thread Termination에는 몇가지 방법이 있습니다.

- **interrupt() 를 사용하는 방법**
- **Daemon Thread를 사용하는 방법**

<br>



일단 스레드를 왜/언제 멈춰야 하는지부터 알아보겠습니다.

- 스레드는 아무 동작을 안해도 메모리와 일부 커널 리소스를 사용합니다.
- 그리고 CPU 타임과 CPU 캐시 공간도 사용합니다.
- 따라서 생성하

