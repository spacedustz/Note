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

이런 계층 구조이며, 아래는 코드입니다.

<br>

**VaultHackerThread**

자세한 코드 설명은 아래에 있습니다.

```java
@Slf4j  
public class VaultHackerThread {  
  
    public static final int MAX_PASSWORD = 9999; // 비밀번호의 최대값  
  
    // 금고 클래스  
    private static class Vault {  
        private int password;  
  
        public Vault(int password) {  
            this.password = password;  
        }  
  
        // 비밀 번호가 맞는지 확인하는 함수  
        public boolean isCorrectPassword(int guess) {  
            try {  
                Thread.sleep(5);  
            } catch (InterruptedException e) {  
            }  
  
            return this.password == guess;  
        }  
    }  
  
    // 해커 스레드  
    private static abstract class Hacker extends Thread {  
        protected Vault vault;  
  
        public Hacker(Vault vault) {  
            this.vault = vault;  
            this.setName(this.getClass().getSimpleName());  
            this.setPriority(Thread.MAX_PRIORITY);  
        }  
  
        @Override  
        public void start() {  
            log.info("Starting Thread : {}", this.getName());  
            super.start();  
        }  
    }  
  
    // 해커 스레드를 확장하는 비밀번호를 오름차순으로 추측하는 클래스  
    // 모든 해커 스레드와 스레드 기능을 가져옵니다.  
    private static class AscendingHackerThread extends Hacker {  
  
        public AscendingHackerThread(Vault vault) {  
            super(vault);  
        }  
  
        @Override  
        public void run () {  
            for (int guess = 0; guess < MAX_PASSWORD; guess++) {  
                if (vault.isCorrectPassword(guess)) {  
                    log.info("{} 스레드가 비밀번호 추측에 성공하였습니다. 입력한 비밀번호 : {}", this.getName(), guess);  
                    log.info("프로그램을 종료합니다.");  
                    System.exit(0);  
                }  
            }  
        }  
    }  
  
    // 해커 스레드를 확장하며 비밀번호를 내림차순으로 추측하는 클래스  
    // 모든 해커 스레드와 스레드 기능을 가져옵니다.  
    private static class DescendingHackerThread extends Hacker {  
  
        public DescendingHackerThread(Vault vault) {  
            super(vault);  
        }  
  
        @Override  
        public void run() {  
            for (int guess = MAX_PASSWORD; guess >= 0; guess--) {  
                if (vault.isCorrectPassword(guess)) {  
                    log.info("{} 스레드가 비밀번호 추측에 성공하였습니다. 입력한 비밀번호 : {}", this.getName(), guess);  
                    log.info("프로그램을 종료합니다.");  
                    System.exit(0);  
                }  
            }  
        }  
    }  
  
    // 경찰 스레드, Thread를 직접 확장 합니다.  
    // 캡슐화된 모든 기능을 해커 스레드에 가져올 수 없습니다.  
    private static class PoliceThread extends Thread {  
  
        @Override  
        public void run() {  
            for (int i = 10; i > 0; i--) {  
                try {  
                    Thread.sleep(1000);  
                } catch (InterruptedException e) {  
                }  
                log.info(String.valueOf(i));  
            }  
  
            log.info("잡았다 요놈!");  
            log.info("프로그램을 종료합니다.");  
            System.exit(0);  
        }  
    }  
  
    public static void main(String[] args) {  
        // Random 객체 생성  
        Random random = new Random();  
  
        // 0 ~ MAX_PASSWORD 사이의 임의 비밀번호 설정
        Vault vault = new Vault(random.nextInt(MAX_PASSWORD));  
  
        // Thread List에 Thread 들을 넣고 각 스레드를 실행시킵니다.  
        List<Thread> list = new ArrayList<>();  
        list.add(new AscendingHackerThread(vault));  
        list.add(new DescendingHackerThread(vault));  
        list.add(new PoliceThread());  
  
        for (Thread thread : list) {  
            thread.start();  
        }  
    }  
}
```

<br>

> 📌 **코드 동작 흐름**

1. `VaultHackerThread` 클래스는 메인 애플리케이션 클래스입니다. 이 클래스 안에는 금고(`Vault`)를 나타내는 내부 클래스와 해커(`Hacker`) 및 경찰(`PoliceThread`) 스레드를 정의하는 내부 클래스들이 있습니다.

2. `Vault` 클래스는 금고를 나타내며, 비밀번호를 가지고 있습니다. `isCorrectPassword` 메서드는 주어진 추측(`guess`)이 금고의 비밀번호와 일치하는지 확인합니다.

3. `Hacker` 클래스는 해커 스레드를 추상 클래스로 정의하며, `Vault` 객체를 이용해 비밀번호를 추측합니다. `AscendingHackerThread`와 `DescendingHackerThread`는 이 클래스를 확장하여 비밀번호를 오름차순 및 내림차순으로 추측하는 스레드를 생성합니다.

4. `PoliceThread` 클래스는 경찰 스레드를 직접 확장합니다. 이 스레드는 잠시 대기한 뒤, 일정 시간이 지나면 "잡았다 요놈!" 메시지를 출력하고 프로그램을 종료합니다.

5. `main` 메서드에서는 다음을 수행합니다:

    - `Random` 객체를 생성하여 무작위로 비밀번호를 생성합니다.
    - `Vault` 객체를 생성하고, 이 비밀번호로 초기화합니다.
    - `AscendingHackerThread`, `DescendingHackerThread`, 그리고 `PoliceThread`를 생성하고 리스트에 추가합니다.
    - 모든 스레드를 시작합니다.

<br>

> 📌 **실행 시나리오**

- `AscendingHackerThread`는 비밀번호를 오름차순으로 추측하며, 만약 비밀번호를 추측에 성공하면 메시지를 출력하고 프로그램을 종료합니다.
- `DescendingHackerThread`는 비밀번호를 내림차순으로 추측하며, 비슷한 방식으로 작동합니다.
- `PoliceThread`는 시작하면 10초 동안 카운트다운 메시지를 출력한 뒤 "잡았다 요놈!" 메시지를 출력하고 프로그램을 종료합니다.

비밀번호가 정확히 추측되거나 경찰 스레드가 해커 스레드를 찾으면 프로그램이 종료됩니다.

<br>

**10초 안에 오름차순, 내림차순 해커 스레드가 비밀번호 추측에 성공하면 메시지를 출력합니다.**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/hacker.png)

<br>

**해커 스레드가 10초 동안 비밀번호 추측에 실패할 경우 경찰 스레드가 메시지를 출력합니다.**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/police.png)