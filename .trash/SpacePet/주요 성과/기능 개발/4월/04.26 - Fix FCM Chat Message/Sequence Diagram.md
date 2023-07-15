## Sequence Diagram

- 객체들 사이에서 시간에 따라 발생하는 상호작용을 보여주는 다이어그램
- 문제 해결에 필요한 객체를 정의, 객체간 송/수신 메시지의 순서를 시간의 흐름에 따라 표시
- 일반적으로 화면 요구사항과 클래스 다이어그램 기반으로 작성
- 시퀀스 다이어그램과 클래스 다이어그램 크로스 체크

---

### 구성요소

![image-20230427101848741](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence.png)

**1. 액터(Actor)** : 시스템으로부터 서비스를 요청하는 외부 요소로 사람이나 외부시스템을 의미

**2. 객체(Object) :** 클래스의 객체

**3. 생명선(Lifeline) :** 객체의 생성, 소멸, 활성화될 때를 나타내는 선 (위 -> 아래, 점선)

**4. 활성 박스(Activation Box) :** 객체가 다른 객체와 상호작용하며 활성화 되고 있음을 표현 (직사각형)

**5. 메세지(Message) :** 객체간 주고 받은 데이터, 일반적으로 요청(request)과 응답(response)로 구성

---

### 메시지 표기법

![image-20230427101933175](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence2.png)

| 유형                              | 의미                                                         |
| --------------------------------- | ------------------------------------------------------------ |
| 동기 메시지(Synchronous message)  | 메시지 전송 객체가 계속하기 전까지 동기 메시지에 대한 응답을 기다림. 프로그램 내 일반적인 함수 호출과 동일한 동작 방식의 메시지를 표현 |
| 비동기 메시지(Async message)      | 메시지 전송 객체가 계속하기 전까지 응답을 요구하기 않는 메시지. 전송 객체의 호출만을 표시.보통 개별 쓰레드 간의 통신 및 새 쓰레드의 생성에 사용 |
| 자체 메시지(Self message)         | 인스턴스간의 상호작용 뿐만 아니라 하나의 인스턴스에서 처리를 하는 방법도 종종있습니다. 이럴때는 self 메시지를 사용할 수 있습니다. self message는 본인의 lifeline으로 재귀 하는 화살표를 가지고 있습니다. 자신에게 보낸 메시지입니다. 결과로 생성된 실행 발생이 전송 실행 위에 나타남. |
| 반환 메시지(Reply/Return message) | 이전 호출의 반환을 기다리는 객체에게 다시 반환되는 메시지.   |

<br>

![image-20230427102101200](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence3.png)

**✔️ 동기 메시지 (Synchronous message)**

실선 + 내부가 채워진 화살표로 표기

리턴 받을 때까지 다른 동작없이 대기

 <br>

**✔️ 비동기 메시지 (As ynchronous message)**

실선 + 내부가 채워지지 않은 화살표로 표기

리턴을 기다리지 않고 다른 작업을 수행 

<br>

![image-20230427102210097](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence4.png)

**✔️ 자체 메시지 (Self message)**

본인의 Lifeline으로 회귀하는 화살표를 그림

 <br>

**✔️ 반환 메시지 (Reply/Return message)**

점선과 선으로 이뤄진 화살표로 표현

---

**✔️ 가드(Guard)**

: guard는 단일 메시지에 대해서 조건을 명시할 수 있는 방법

 조건을 명시 -> **[조건] 처리메시지**

<br>

가드(Guard)

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence5.png) 

<br>

**✔️ 프래그먼트(Fragment)**

guard가 한 메시지에 대해서 조건을 명시했다면, sequnce fragments는 범위로 조건을 명시할 수 있다.

즉, 특정 부분에 대해서 일정 부분의 메시지를 반복하던지 조건을 명시하던지 할때는 sequence fragments가 명확할 수 있다.

프래그먼트에는 대안(alt), 옵션(opt), 반복(loop),병렬(Par), 참조(Ref)가 있다.

<br>

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence6.png) 

<br>

**✔️ (1) 대안(alt)**

다중 조건문, else if 같은 대안이 있는 조건문

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence7.png) 

<br>

**✔️ (2) 옵션(opt)**

단일 조건문, if, switch

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence8.png) 

<br> 

**✔️ (3) 반복(loop)**

반복문, for, while

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence9.png) 

#### <br>

**✔️(4) 병렬(Par)**

병렬처리, 분리된 몇 개의 상호작용이 동시에

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence10.png) 

<br>

**✔️ (5) 참조(Ref)**

외부에서 정의된 시퀀스 다이어그램을 포함

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence11.png)

------

### **✔️ 시퀀스 다이어그램과 클래스 다이어그램 크로스 체크 필수!**

일반적으로 시퀀스 다이어그램은 클래스 다이어그램 기반으로 작성되기 때문에 작성 후 클래스 다이어 그램과 크로스 체크가 필요합니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Sequence12.png)