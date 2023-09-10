## **💡 Thread**

데이터와 어플리케이션이 확보한 자원을 활용하여 소스코드 실행 즉, 하나의 코드 실행 흐름

<br>

**Thread**

- 프로세스에서 실행 제어만 분리한 것
- 프로세스로부터 자원을 할당받고 그 자원을 이용하는 실행의 단위
- 프로세스의 Stack만 할당받고 코드 & 데이터 & 힙영역은 공유하기 떄문에 좀 더 효율적인 통신 가능
- 캐시 메모리를 비우지 않아도 되서 더 빠름
- 자원 공유로 인한 문제가 발생할 수 있으니 이를 염두에 둔 프로그래밍을 해야함
- 한 프로세스에 여러개의 스레드가 생성될 수 있음
- 즉, 캐시 메모리나 PCB에 저장해야하는 내용이 적고 비워야 하는 내용도 적기 때문에 상대적으로 더 빠른 컨텍스트 스위칭

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java70.png) 

------

## **💡 구현과 실행**

### **Thread 클래스를 상속하는 방법 (다른 클래스 상속 불가, 권장 X)**

- Thread 클래스를 상속받은 자손 클래스의 인스턴스 생성
- Thread 클래스를 상속받으면 메서드 직접 호출 가능

```java
/* Thread의 run()을 오버라이딩 */
public class ExtendsThread extends Thread {
    public void run() {
        // 상속받은 Thread의 getName() 호출
        for (int i=0; i<5; i++) {
            System.out.println(getName());
        }
    }
}
```

<br>

### **Runnable 인터페이스를 구현하는 방법 (재사용성 & 일관성 좋음, 권장)**

- Runnable 인터페이스를 구현한 new ImplementsRunnable 인스턴스를 생성한 뒤,
  이 인스턴스를 Thread 클래스의 생성자 파라미터로 넘겨줘야 한다.
- Runnable을 구현했을때 Thread의 메서드를 호출 하려면
  static Method인 currentThread()를 호출하여,
  스레드에 대한 참조를 얻어 와야만 호출이 가능하다.

```java
/* Implements Runnable Interface */
public class ImplementsRunnable implements Runnable{
    @Override
    public void run() {
        for (int i=0; i<5; i++) {
            // Thread.curruneThread() - 현재 실행중인 Thread를 반환한다.
            System.out.println(Thread.currentThread().getName());
        }
    }
}
```

<br>

**Main 메서드**

```java
public class ThreadEx {
    public static void main(String[] args) {
        // 1. Thread의 자손 클래스 인스턴스 생성
        ExtendsThread t1 = new ExtendsThread();

        // 2. Runnable을 구현한 클래스의 인스턴스 생성
        // 생성자 Thread(Runnable target)
        Thread t2 = new Thread(new ImplementsRunnable());

        t1.start();
        t2.start();
    }
}
```

<br>

### **실행**

start()

- start()가 실행되었다고 바로 실행되는것이 아닌 순서가 와야 실행이 된다.
- 만약 스레드가 종료되고 1번 더 실행되어야 한다면 스레드를 다시 생성해야 한다.

```java
ExtendsThread t1 = new ExtendsThread();
t1.start();
t1 = new ExtendsThread();
t1.start();
```

------

## **💡 Start()와 Run()의 차이**

새로 생성한 스레드에서 고의로 예외를 발생시키고 printStackTrace()를 이용해서,
예외가 발생한 당시의 호출스택을 출력하는 예제이다.

<br>

### **start()**

- 새로운 스레드가 작업을 실행하는데 필요한 호출스택을 생성한 후 run()을 호출해서,
  생성된 호출스택에 run()을 올린다.
- 호출스택의 첫번째 메서드가 main이 아닌 run 메서드이다.
- 한 스레드에 예외가 발생해서 종료되어도 다른 스레드에 영향을 미치지 않는다.
- 실행결과에 main 스레드의 호출스택이 없는 이유는 main 스레드가 종료되었기 때문이다.

```java
/* Thread의 run()을 오버라이딩 */
public class ExtendsThread extends Thread {
    public void run() {
        throwException();
    }

    public void throwException() {
        try {
            throw new Exception();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
public class ThreadEx {
    public static void main(String[] args) {
        // Thread의 자손 클래스 인스턴스 생성
        ExtendsThread t1 = new ExtendsThread();
        t1.start();
    }
}
```

<br>

**실행 결과**

```java
java.lang.Exception
    at thread.ExtendsThread.throwException(ExtendsThread.java:15)
    at thread.ExtendsThread.run(ExtendsThread.java:6)
```

<br>

### **run()**

- main 메서드에서 run()을 호출하는 것은 생성된 스레드를 실행시키는것이 아닌,
  다순 클래스에 선언된 메서드를 호출하는 것일 뿐이다.
- 위의 예제와 달리 스레드가 새로 생성이 되지 않았고 그냥 run()이 실행되었을 뿐이다.
- 호출스택에 main 메서드가 포함되어 있음

```java
/* Thread의 run()을 오버라이딩 */
public class ExtendsThread extends Thread {
    public void run() {
        throwException();
    }

    public void throwException() {
        try {
            throw new Exception();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
public class ThreadEx {
    public static void main(String[] args) {
        // Thread의 자손 클래스 인스턴스 생성
        ExtendsThread t1 = new ExtendsThread();
        t1.run();
    }
}
```

<br>

**실행 결과**

```java
java.lang.Exception
    at thread.ExtendsThread.throwException(ExtendsThread.java:15)
    at thread.ExtendsThread.run(ExtendsThread.java:6)
    at thread.ThreadEx.main(ThreadEx.java:7)
```

------

## **💡 Thread 이름 조회**

스레드의참조값.getName()

```java
Thread thread3 = new Thread(new Runnable() {
    public void run() {
        System.out.println("Get Thread Name");
    }
});

thread3.start();
System.out.println("thread3.getName() = " + thread3.getName());
Get Thread Name
thread3.getName() = Thread-0
```

------

## **💡 Thread 이름 설정**

스레드의참조값.setName()

```java
Thread thread4 = new Thread(new Runnable() {
    public void run() {
        System.out.println("Set And Get Thread Name");
    }
});

thread4.start();
System.out.println("thread4.getName() = " + thread4.getName());

thread4.setName("First Thread");
System.out.println("thread4.getName() = " + thread4.getName());
```

------

## **💡 Thread 동기화**

멀티스레드의 경우, 두 스레드가 동일한 데이터를 공유하는 과정에서 문제가 발생하여 동기화 필요

<br>

**멀티스레드의 데이터 공유 과정중 발생하는 문제에 대한 예시**

try { Thread.sleep(1000); } catch (Exception error) {} 에 대한 설명을 읽고 예시를 보자
\- Thread.sleep(1000);

1. 스레드를 일시정지 시키는 메소드. ※ 스레드가 정지되면 대기열에서 대기중인 다른 스레드가 실행됨
2. Thread.sleep()는 반드시 try .. catch문의 try 블럭내에 작성
3. 간단하게 말하면, 스레드의 동작을 1초동안 멈추는 코드

\- try { ... } catch ( ~ ) { ... }

1. 예외처리에 사용되는 문법
2. try 블록 내 코드를 실행하다 예외&에러 발생시 catch문 내의 코드 실행
3. Thread.sleep(1000); 의 동작을 위해 형식적으로 사용한 문법요소임

```java
public class ThreadExample3 {
    public static void main(String[] args) {

        Runnable threadTask3 = new ThreadTask3();
        Thread thread3_1 = new Thread(threadTask3);
        Thread thread3_2 = new Thread(threadTask3);

        thread3_1.setName("김코딩");
        thread3_2.setName("박자바");

        thread3_1.start();
        thread3_2.start();
    }
}

class Account {

    // 잔액을 나타내는 변수
    private int balance = 1000;

    public int getBalance() {
        return balance;
    }

    // 인출 성공 시 true, 실패 시 false 반환
    public boolean withdraw(int money) {

        // 인출 가능 여부 판단 : 잔액이 인출하고자 하는 금액보다 같거나 많아야 합니다.
        if (balance >= money) {

            // if문의 실행부에 진입하자마자 해당 스레드를 일시 정지 시키고, 
            // 다른 스레드에게 제어권을 강제로 넘깁니다.
            // 일부러 문제 상황을 발생시키기 위해 추가한 코드입니다.
            try { Thread.sleep(1000); } catch (Exception error) {}

            // 잔액에서 인출금을 깎아 새로운 잔액을 기록합니다.
            balance -= money;

            return true;
        }
        return false;
    }
}

class ThreadTask3 implements Runnable {
    Account account = new Account();

    public void run() {
        while (account.getBalance() > 0) {

            // 100 ~ 300원의 인출금을 랜덤으로 정합니다. 
            int money = (int)(Math.random() * 3 + 1) * 100;

            // withdraw를 실행시키는 동시에 인출 성공 여부를 변수에 할당합니다. 
            boolean denied = !account.withdraw(money);

            // 인출 결과 확인
            // 만약, withraw가 false를 리턴하였다면, 즉 인출에 실패했다면,
            // 해당 내역에 -> DENIED를 출력합니다. 
            System.out.println(String.format("Withdraw %d₩ By %s. Balance : %d %s",
                    money, Thread.currentThread().getName(), account.getBalance(), denied ? "-> DENIED" : "")
            );
        }
    }
}
Withdraw 100₩ By 김코딩. Balance : 600 
Withdraw 300₩ By 박자바. Balance : 600 
Withdraw 200₩ By 김코딩. Balance : 400 
Withdraw 200₩ By 박자바. Balance : 200 
Withdraw 200₩ By 김코딩. Balance : -100 
Withdraw 100₩ By 박자바. Balance : -100 
```

위의 예제는 멀티스레드 생성 후 1000원의 잔액을 가진 계좌에서 100~300원을 인출하며, 인출금&잔액을 출력한다.
이 멀티 스레드는 Account 객체를 공유하게 된다.

------

## **💡 Critical Section & Lock**

임계영역은 하나의 스레드만 코드를 실행할 수 있는 코드의 영역을 의미한다
락은 임계영역을 포함하는 객체에 접근할 수 있는 권한을 의미한다

<br>

### **메서드 전체를 임계영역으로 지정하는 예시**

```java
class Account {
    ...
    public synchronized boolean withdraw(int money) {
        if (balance >= money) {
            try { Thread.sleep(1000); } catch (Exception error) {}
            balance -= money;
            return true;
        }
        return false;
    }
}
```

<br>

### **특정영역을 임계영역으로 지정**

```java
class Account {
    ...
    public boolean withdraw(int money) {
            synchronized (this) {
                if (balance >= money) {
                    try { Thread.sleep(1000); } catch (Exception error) {}
                    balance -= money;
                    return true;
                }
                return false;
            }
    }
}
```

------

## **💡 Multi-Thread Programming**

**하나의 프로세스에서 여러개의 스레드를 만들어 자원의 생성과 관리의 중복을 최소화하는것을 의미한다**

즉, 프로그램을 여러개 키는것 보다 하나의 프로그램에서 여러 작업을 해결하는 것

<br>

- 장점
  - 멀티 프로세스에 비해 메모리 소모가 줄어듬 (자원의 효율성 증대)
  - 스레드 간 데이터를 주고받는것이 간단해지고 시스템 자원 소모가 줄어들고 그로인해 프로세스의 컨텍스트 스위칭보다도 빠르다
  - 힙 영역을 통해서 스레드간 통신이 가능, 프로세스간 통신보다 간단함
- 단점
  - 힙 영역에 있는 자원을 사용할 때는 동기화를 해야함
  - 동기화를 위해 락을 과도하게 사용하면 성능이 저하될 수 있음
  - 하나의 스레드가 비정상적으로 동작하면 다른 스레드도 종료될 수 있음
  - ****스레드 간의 자원 공유는 전역 변수(데이터 세그먼트)를 이용하므로 함께 사용할 때 충돌 발생 가능****

------

## **💡 Thread-Safe**

**두 개 이상의 스레드가 Race Condition(경쟁 상태)에 들어가거나 같은 객체에 동시에 접근해도 연산결과의 정합성이 보장될 수 있게끔 메모리 가시성이 확보된 상태를 의미함**

- java.util.concurrent 패키지 하위의 클래스 사용
- 인스턴스 변수를 두지 않음
- Singleton 패턴을 사용함 (이 때, 일반적으로 구현하는 Singleton Pattern은 Thread-Safe 하지 않음) (https://github.com/ksundong/TIL/blob/master/DesignPattern/singleton-pattern.md)
- 동기화 블럭에서 연산을 수행함

---

## **💡 Single & Multi Thread**

### **싱글코어 스레드**

수행시간의 쉬운 측정을 위해 new String 사용 (작업 수행속도 낮춤)

```java
public class CountThreadTimeMillis {
    public static void main(String[] args) {
        long startTime = System.currentTimeMillis();

        for (int i=0; i<300; i++) {
            System.out.printf("%s", new String("-"));
        }
        System.out.print("소요시간 1:" + (System.currentTimeMillis() - startTime));

        for (int i=0; i<300; i++) {
            System.out.printf("%s", new String("|"));
        }
        System.out.print("소요시간 2:" + (System.currentTimeMillis() - startTime));
    }
}
```

<br>

출력 결과

```java
thread.CountThreadTimeMillis
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------소요시간 1:31||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||소요시간 2:47
```

------

### **멀티코어 스레드**

두개의 스레드가 작업을 하나씩 나누어서 작업을 수행하는 예시

- 두개의 스레드로 작업하는데도 시간이 오래 걸리는 이유는 2가지 이다.
  - 스레드를 번갈아 가며 실행하기 때문에 컨텍스트 스위칭에 소요되는 시간
  - 한 스레드가 화면에 출력할 동안 다른 스레드는 기다리는 대기시간

```java
public class MultiCoreThread {
    static long startTime = 0;

    public static void main(String[] args) {
        CountThreadMillis t1 = new CountThreadMillis();
        t1.start();

        startTime = System.currentTimeMillis();

        for (int i=0; i<300; i++) {
            System.out.printf("%s", new String("-"));
        }
        System.out.print("소요시간 1:" + (System.currentTimeMillis() - MultiCoreThread.startTime));
    }

    public static class CountThreadMillis extends Thread {
        public void run() {
            for (int i=0; i<300; i++) {
                System.out.printf("%s", new String("|"));
            }
            System.out.print("소요시간 2:" + (System.currentTimeMillis() - MultiCoreThread.startTime));
        }
    }
}
```

<br>

Single Core 출력 결과

```java
thread.multicore.MultiCoreThread
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|||||||||||||||||--------------------------------------------------------------------------------------------------------------|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||소요시간 1:32소요시간 2:32
```

<br>

MultiCore 출력 결과

```java
thread.multicore.MultiCoreThread
----||||||||||----||||||||||||--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||---------------------------------------------------|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||-------------------------------|||||||||||||||||||||||------------------------------------------------------------------------------|||||||||||||||||||||||||||||||||||||---------------------------------------------------------------------------------------|||||||||||||||||||||||||||||||||||||||||||||||-------------------------------------------소요시간 2:32소요시간 1:47
```

------

## **💡 차이점**

싱글코어

- 멀티스레드라도 하나의 코어가 번갈아 가며 작업한다.

멀티코어

- 멀티스레드로 두 작업 수행 시, 동시에 두 스레드가 실행될 수 있으므로
  두 작업이 겹치는 부분이 발생한다.

그래서 화면(console)이라는 자원을 놓고 두 스레드가 경쟁하게 된다.

위의 결과는 실행할때마다 다른결과가 나온다.

<br>

그 이유는 프로세스는 OS의 프로세스 스케쥴러의 영향을 받기 때문이다.

JVM의 스레드 스케쥴러에 의해 어떤 스레드가 얼마동안 실행될 것인지 결정하는것과 같이
프로세스도 OS의 프로세스 스케쥴러에 의해 실행순서 & 시간이 결정되기 때문에
매 순간 상황에 따라 프로세스에게 할당되는 실행시간이 일정하지 않고 스레드에게
할당되는 시간 역시 일정하지 않게 된다.

자바가 OS독립적이라고 하지만 OS 종속적인 부분도 존재하며 스레드도 그 중 하나이다.

------

## **💡 두 스레드가 서로 다른 자원을 사용하는 작업의 경우**

싱글스레드 프로세스보다 멀티 스레드 프로세스가 더 효율적이다.

<br>

예를 들면,

사용자로부터 데이터를 입력받는 작업, 네트워크로 파일을 주고받는 작업, 프린터로 파일을 출력하는 작업과 같이 외부기기와의 입출력을 필요로 하는 경우가 이에 해당한다.

만약 사용자로부터 입력받는 작업(A)과 화면에 출력하는 작업(B)을 하나의 스레드로 처리한다면

사용자가 입력을 마칠 때까지 아무일도 못하고 기다리기만 해야 한다.

이 때, 두개의 스레드로 작업을 한다면 사용자의 입력을 기다리는 동안 다른 스레드가 작업을 처리할 수 있기 때문에 보다 효율적인 CPU 사용이 가능하다.

<br>

### **싱글스레드 예시**

```java
public class SingleThreadIO {
    public static void main(String[] args) throws Exception {
        String input = JOptionPane.showInputDialog("아무 값이나 입력하세요.");
        System.out.println("입력하신 값은 " + input + "입니다.");

        for (int i=10; i>0; i--) {
            System.out.println(i);
            try {
                Thread.sleep(1000); // 1초간 시간 지연
            } catch (Exception e) {}
        }
    }
}
```

<br>

출력 결과

```java
입력하신 값은 abc입니다.
10
9
8
7
6
5
4
3
2
1
```

<br>

### **멀티스레드 예시**

```java
public class MultiThreadIO {
    public static void main(String[] args) throws Exception {
        TempThread t1 = new TempThread();
        t1.start();

        String input = JOptionPane.showInputDialog("아무 값이나 입력하세요.");
        System.out.println("입력하신 값은 " + input + "입니다.");
    }

    public static class TempThread extends Thread {
        public void run() {
            for (int i=10; i>0; i--) {
                System.out.println(i);
                try {
                    sleep(1000);
                } catch (Exception e) {}
            }
        }
    } // run()
}
```

<br>

출력 결과

```java
thread.multicore.MultiThreadIO
10
9
8
입력하신 값은 abc입니다.
7
6
5
4
3
2
1
```