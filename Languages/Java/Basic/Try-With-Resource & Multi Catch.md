## **💡 Try-With-Resource**

JDK 1.7 부터 try-catch의 변형인 try-with-resources가 추가되었다.

주로 입출력에 필요한 클래스들 중 사용 후 닫아줘야 하는것들을 자동으로 닫아준다.

그래야 사용했던 자원(resources)가 반환되기 때문이다.

<br>

아래 예시는 DataInputStream을 이용해 파일로부터 데이터를 읽는 코드이다.

데이터를 읽는 도중 예외가 발생하더라도 Stream이 닫히도록 finnaly 안에 close()를 넣었다.

<br>

별 문제가 없어 보이는 코드지만 진짜 문제는, **close()가 예외를 발생시킬 수 있다**는데 있다.

```java
try {
    fis = new FileInputStream("score.dat");
    dis = new DataInputStream(fis);
} catch (IOException ie) {
    ie.printStackTrace();
} finally {
    dis.close();
}
```

<br>

아래 예시는 try-catch문을 추가해서 **close()에서 발생할 수 있는 예외를 처리하도록 추가된 코드**이다.

```java
try {
    fis = new FileInputStream("score.dat");
    dis = new DataInputStream(fis);
} catch (IOException ie) {
    ie.printStackTrace();
} finally {
    try {
        if (dis != null) dis.close();
    } catch (IOException ie) {
        ie.printStackTrace();
    }
}
```

위 코드는 코드가 복잡해서 보기에 좋지 않고 더 나쁜 것은 try, finally에서 모두 예외가 발생하면,
try의 예외는 **무시**된다는 것이다.

이러한 점을 개선하기 위해 try-with-resource 문이 추가됬다.

<br>

### **이제 위의 코드를 try-with-resource문으로 바꿔보자.**

try() 괄호 안에 객체를 생성하는 문장을 넣으면,
이 객체는 따로 close()를 해주지 않아도 try를 벗어나는 순간 자동으로 close()가 호출된다.

```java
// 괄호 안에 두 문장 이상 넣을경우 ';'로 구분한다.
try (FileInputStream fis = new FileInputStream("score.dat");
    DataInputStream dis = new DataInputStream(fis)) {
    while (true) {
        score = dis.readInt();
        System.out.println(score);
        sum += score;
    } catch (EOFException e) {
        System.out.println("점수의 총합은 " + sum + "입니다.");
    } catch (IOException ie) {
        ie.printStackTrace();
    }
}
```

이처럼 try-with-resource문에 의해 자동으로 close()가 호출될 수 있으려면,

클래스가 **AutoCloseable 인터페이스를 구현한 클래스**여야만 한다.

<br>

그런데 위의 코드를 잘 보면 close()도 Exception을 발생시킬 수 있다.

<br>

만약 자동 호출된 close()에도 Exception이 발생하면 어떻게 될까?

예제를 먼저 실행시켜보자.

```java
class TryWithResourceEx {
    public static void main(String[] args) {

        try (CloseableResource cr = new CloseableResource()) {
            cr.exceptionWork(false); // 예외가 발생하지 않는다.
        } catch (WorkException e) {
            e.printStackTrace();
        } catch (CloseException e) {
            e.printStackTrace();
        }
        System.out.println();


        try (CloseableResource cr = new CloseableResource()) {
            cr.exceptionWork(true); // 예외가 발생한다
        } catch (WorkException e) {
            e.printStackTrace();
        } catch (CloseException e) {
            e.printStackTrace();
        }
    }

    class CloseableResource implements AutoCloseable {
        public void exceptionWork(boolean exception) throws WorkException {
            System.out.println("exceptionWork("+exception+")가 호출됨");

            if (exception)
                throw new WorkException("Work Exception 발생!");
        }

        public void close() throws CloseException {
            System.out.println("close()가 호출됨");
            throw new CloseException("Close Exception 발생!");
        }
    }

    class WorkException extends Exception {
        WorkException(String msg) { super(msg); }
    }

    class CloseException extends Exception {
        CloseException(String msg) { super(msg); }
    }
}

/* 실행 결과
exceptionWork(false)가 호출됨
close()가 호출됨
CloseException: Close Exception 발생!
    at CloseableResource.close(TryWithResourceEX.java:33)
    at TryWithResourceEX.main(TryWithResource.java:6)

exceptionWork(true)가 호출됨
close()가 호출됨
WorkException: Work Exception 발생!
    at CloseableResource.exceptionWork(TryWithResourceEX.java:28)
    at TryWithResourceEx.main(TryWithResourceEX.java:15)
    Suppressed: CloseException: Close Exception 발생!
        at CloseableResource.close(TryWithResourceEX.java:33)
        at TryWithResourceEX.main(TryWithResourceEX.java:14)
*/
```

main 메서드에 두개의 try-catch문이 있다.

<br>

첫번쨰는 close()에서만 예외를 발생시킨다.

두번째는 exceptionWork()와 close() 에서 모두 예외를 발생시킨다.

<br>

첫번째는 일반적인 예외 발생할때와 같은 형태로 출력되었지만,
두번째는 출력형태가 다르다.

<br>

먼저 exceptionWork()에서 발생한 예외에 대한 내용이 출력되고,

close()에서 발생한 예죄는 **'억제된(Suppressed)'**라는 의미의 머리말과 함께 출력되었다.

<br>

두 예외가 동시에 발생할 수 없기에 실제 발생한 예외를 WorkException으로 하고,
CloseException은 억제된 예외로 다룬다.

<br>

억제된 예외에 대한 정보는 실제로 발생한 예외인 WorkException에 저장된다.

Throwable 클래스에는 억제된 예외와 관련된 메서드가 정의되어 있다.

```java
void addSuppressed(Throwable exception) // 억제된 예외 추가
Throwable[] getSuppressed() // 억제된 예외(배열) 반환
```

만일 기존의 tyr-catch 문을 사용했다면,
먼저 발생한 WorkException은 무시되고 마지막 발생한 CloseException만 출력되었을 것이다.

---

## **💡 멀티 Catch 블럭**

JDK 1.7부터 여러개의 catch 블럭을 '|'를 이용해 하나의 catch 블럭으로 합칠 수 있게 되었다.

중복 코드를 줄일 수 있으며, '|' 기호로 연결할 수 있는 예외 클래스의 개수는 제한이 없다.

```java
try {
    ...
} catch (ExceptionA | ExceptionB e) {
    e.printStackTrace();
}

// 상위,  하위 클래스가 | 기호와 같이 있다면 에러가 발생한다.
try {
    ...
} cathc (ParentException | ChildException) { // 에러
    ...
}
```

멀티 catch 블럭은 하나의 블럭으로 여러 예외를 처리하는 것이기 때문에,
발생한 예외를 처리할 때 실제로 어떤 예외가 발생한 건지 알 수 없다.

<br>

그래서 참조변수 e로 멀티 catch 블럭에 '|' 기호로 연결된
예외 클래스들의 공통 분모인 부모 예외 클래스에 선언된 멤버만 사용할 수 있다.

<br>

필요하다면, instanceof로 어떤 예외가 발생할 것인지 확인 후 개별적 처리가 가능하다.

<br>

하지만 이렇게까지 해가면서 catch 블럭을 합칠 일도 없고,
대부분 코드를 간단히 하는 정도에서 그친다.

<br>

마지막으로 멀티 catch 블럭에 선언된 참조변수 e는 상수로 변경이 불가능하다는 제약이 있다.

<br>

여러 catch 블럭이 하나의 참조변수를 공유하기 때문에 생기는 제약으로 참조변수를 바꿀 일은 없다.

```java
try {
    ...
} catch (ExceptionA | ExceptionB e) {
    e. methodA(); // 에러, ExceptionA에 선언된 methodA()는 호출 불가능

    if (e instanceof Exception A) {
        ExceptionA e1 = (Exception) e;
        e1.methodA(); // OK, ExceptionA에 선언된 메서드 호출 가능
    } else { // ExceptionB 일 경우
        ...
    }
    e.printStackTrace();
}
```