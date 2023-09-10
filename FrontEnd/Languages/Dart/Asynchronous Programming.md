**Java & Kotlin과 동일한 내용은 안쓰고 새로운 내용만 작성**

---

## Asynchronous Programming

- Dart는 기본적으로 비동기로 동작한다.
- **Future**와 **Stream**을 사용해 Async Programming을 할 수 있다.

<br>

**Future**

- 함수가 종료되는 순간이 Future가 종료되는 순간이다.
- 한 함수의 반환값은 하나여야 한다.

![image-20230506221048682](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/await.png) 

**Stream**

- **직접 닫아주는 순간**이 Stream이 종료되는 순간이다.
- 여러 반환값을 Stream을 닫아줄 때까지 도중에 계속 반환받을 수 있다.
- 기본적으로 제공하는 기능이 아니어서 패키지를 불러와야 한다. `import 'dart:async';`
- import로 받아온 async에서 StreamController를 사용할 수 있게 된다.

![image-20230506221120826](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/yield.png)

---

## **Future**

### delayed

- 1번 파라미터 : 지연할 기간 (얼마나 지연할건지) Duration
- 2번 파라미터 : 지연 시간이 지난 후 실행할 **함수**

```dart
void main() {
    Future<String> name = Future.value('코드');
    Future<int> number = Future.value(1);
    Future<bool> isTrue = Future.value(true);
    
    addNums(1, 1);
}

void addNums(int number1, int number2) {
    print('계산 시작 : $number1 + $number2');
        
    Future.delayed(Duration(seconds: 2), (){
        print('계산 완료 : $number1 + $number2 = ${number1 + number2}');
    });
        
    print('함수 완료 : $number1 + $number2');
}
```

위 코드를 실행하면 결과값은 이렇게 나온다.

```
계산 시작 : 1 + 1
함수 완료 : 1 + 1
계산 완료 : 1 + 1 = 2
```

이유는 비동기를 기본적으로 지원하기 때문에 계산 시작 후 2초의 딜레이가 걸릴동안, 

함수 완료가 먼저 실행이 종료되었기 때문에, 계산 완료가 마지막에 실행이 되었다.

<br>

### **await**

- `async` 키워드를 안쓰면 `await` 키워드를 사용할 수 없다.
- `await` 키워드는 해당 함수의 다음 로직을 실행하기 전 대기 명령을 내리는 키워드이다.

```dart
void main() {
    Future<String> name = Future.value('코드');
    Future<int> number = Future.value(1);
    Future<bool> isTrue = Future.value(true);
    
    addNums(1, 1);
    addNumb(2, 2);
}

void addNums(int number1, int number2) async {
    print('계산 시작 : $number1 + $number2');
        
    await Future.delayed(Duration(seconds: 2), (){
        print('계산 완료 : $number1 + $number2 = ${number1 + number2}');
    });
        
    print('함수 완료 : $number1 + $number2');
}
```

위 코드를 실행시켰을 때의 결과값이다.

```
계산 시작 : 1 + 1
계산 시작 : 2 + 2
계산 완료 : 1 + 1 = 2
함수 완료 : 1 + 1
계산 완료 : 2 + 2 = 4
함수 완료 : 2 + 2
```

결과값이 이렇게 나온 이유는, 첫번째 `addNums(1, 1)`에서 함수를 실행하다가 await를 만나서 대기를 하낟.

대기를 하는 도중 CPU가 놀고 있으므로, 또 다른 함수인 `addNums(2, 2)`를 비동기로 실행한다.

그러므로 처음 계산 시작의 두줄의 결과가 나온다.

그 후 2초를 대기 후, 1번째 함수의 await 비동기 함수의 실행이 완료되서 `계산 완료 : 1 + 1 = 2`가 실행이 되고 1번쨰 함수는 종료한다.

2번째 함수도 마찬가지로 await 비동기 함수의 실행이 완료되어 `계산 완료 : 2 + 2 = 4`가 실행이 되고 함수가 종료되었다.

<br>

**그럼 코드 레벨이 아닌 함수레벨에서 순서대로 실행하게 하려면 어떻게 해야 할까?**

- main 메서드에 `async & await` 키워드를 부여주고 addNums 함수의 반환 타입을 Future로 바꿔주면 된다.

```dart
void main() async {
    Future<String> name = Future.value('코드');
    Future<int> number = Future.value(1);
    Future<bool> isTrue = Future.value(true);
    
    await addNums(1, 1);
    await addNumb(2, 2);
}

Future<void> addNums(int number1, int number2) async {
    print('계산 시작 : $number1 + $number2');
        
    await Future.delayed(Duration(seconds: 2), (){
        print('계산 완료 : $number1 + $number2 = ${number1 + number2}');
    });
        
    print('함수 완료 : $number1 + $number2');
}
```

---

## Stream

- import package를 통해 StreamController 사용 가능하다.



### Listen

- 파라미터로 **함수**를 받는다.
- Listening(대기) 하다가 값이 들어오면 파라미터의 함수가 실행이 된다.
- 아래 예시에서 함수의 첫번째 파라미터인 `val`에 들어온 값을 받을 수 있다.

```dart
import 'dart:async';

void main() {
    final controller = StreamController();
    
    final stream = controller.stream;
    
    // Listener 1
    final streamListener1 = stream.listen( (val){ print('Listener 1 : $val'); } );
    
    // Stream에 값 넣기
    controller.sink.add(1);
    controller.sink.add(2);
    controller.sink.add(3);
}
```

결과값

```
Listener 1 : 1
Listener 1 : 2
Listener 1 : 3
```

<br>

**StreamListening을 여러번 하고 싶을 경우 예시**

- stream에 `asBroadcastStream()`을 붙여주면 여러번 리스닝이 가능하다.

```dart
import 'dart:async';

void main() {
    final controller = StreamController();
    
    final stream = controller.stream.asBroadcastStream();
    
    // Listener 1
    final streamListener1 = stream.listen( (val){ print('Listener 1 : $val'); } );
    
    // Listener 2
    final streamListener2 = stream.listen( (val){ print('Listener 2 : $val'); } );
    
    // Stream에 값 넣기
    controller.sink.add(1);
    controller.sink.add(2);
    controller.sink.add(3);
}
```

결과값

```
Listener 1 : 1
Listener 2 : 1
Listener 1 : 2
Listener 2 : 2
Listener 1 : 3
Listener 2 : 3
```

<br>

**Functional Programming의 대부분 기능도 같이 사용 가능하다.**

- Listener 1은 짝수, Listener 2는 홀수만 받게 변경

```dart
import 'dart:async';

void main() {
    final controller = StreamController();
    
    final stream = controller.stream.asBroadcastStream();
    
    // Listener 1
    final streamListener1 = stream
        .where((val) => val % 2 == 0)
        .listen( (val){ print('Listener 1 : $val'); } );
    
    // Listener 2
    final streamListener2 = stream
        .where((val) => val % 2 == 1)
        .listen( (val){ print('Listener 2 : $val'); } );
    
    // Stream에 값 넣기
    controller.sink.add(1);
    controller.sink.add(2);
    controller.sink.add(3);
}
```

결과값

```
Listener 2 : 1
Listener 1 : 2
Listener 2 : 3
Listener 1 : 4
Listener 2 : 5
```

<br>

### 함수로 Stream을 제공해주는 방법

- 일반적인 Future에서 Stream으로 바꾸는 방법은 Stream을 반환하고 `async*` 키워드를 함수에 붙여주면 된다.
- yield가 실행될때마다, calculate 함수를 Listening 하고있는 Listener에 값을 보낼 수 있다.
- 일반적인 Future async 함수를 `async*` 함수에서 사용할 수 있는 방법은 `await`를 이용하면 된다.

```dart
import 'dart:async';

void main() {
    calculate(1).listen( (val){ print('calculate(1) : $val'); } );
}

Stream<int> calculate(int number) async* {
    for (int i=0; i<5; i++) {
        yield i * number;
        
        await Future.delayed(Duration(seconds: 1));
    }
}
```

결과값

```
calculate(1) : 0
calculate(1) : 1
calculate(1) : 2
calculate(1) : 3
calculate(1) : 4
```

<br>

### 함수레벨에서 순서대로 실행시키는 방법

- `yield`는 원래 값을 하나하나 순서대로 가져올때 사용했었다.
- `yield*`은 해당 스트림의 모든값이 반환될 때까지 대기한다. (Future의 await와 비슷한 기능)
- 즉, 첫번째 스트림이 완전히 종료된 후 두번째 스트림을 실행한다.

```dart
void main() {
    runAllStream().listen( (val){ print(val); } );
}

Stream<int> runAllStreams() async* {
    yield* calculate(1);
    yield* calculate(1000);
}
```

결과값

```
0
1
2
3
4
0
1000
2000
3000
4000
```

