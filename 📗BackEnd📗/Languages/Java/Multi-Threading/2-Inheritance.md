## 📘 Thread 상속

하나의 예시를 들어, 돈을 보관할 안전한 금고를 설계한다고 가정해 봅시다.

그리고 해커들이 코드를 추측해서 금고를 여는데 얼마나 걸리는지 알아보겠습니다.

동시에 금고의 코드를 깨려는 헤커 스레드를 몇개 만들고, 경찰 스레드도 추가합니다.

경찰 스레드는 10초 안에 해커를 잡으러 옵니다.

만약 해커들이 그동안 돈을 훔쳐서 도망가지 않는다면 경찰이 해커를 체포합니다.

10초를 세는동안 경찰 스레드는 도착 상황을 화면에 띄워 보여줄 겁니다.

<br>

위 예시의 계층을 정리해 보자면,

- 최상위 Runnable 인터페이스
- Runnable을 구현한 Thread
- Thread를 확장한 **Hacker Thread** / **Police Thread** (이때, Hacker Thread는 금고 객체에 대한 Referense를 가지고 있음)
- HackerThread를 확장한 **AscendingHackerThread** / **DescendingHackerThread** (둘다 금고 객체에 대한 참조를 가짐)

이런 계층 구조입니다.
