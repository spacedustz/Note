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

이 클래스에는 내부 클래스가 총 5개가 있습니다.

- 금고 클래스
- abstract 해커 스레드 (금고에 대한 참조 보유), 경찰 스레드
- 해커 스레드를 확장한 오름차순, 내림차순 해커 스레드 (금고 참조 보유)

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
