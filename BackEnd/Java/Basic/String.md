## **💡 String**

자바에서 문자열을 다루는 클래스이며, 유용한 메서드들을 많이 제공한다.

<br>

 **" "(큰따옴표)를 사용한다.**

- 자바는 다른타입과는 다르게 문자열만 class를 통해 다룸
- class는 그 자체로 타입으로 사용될 수 있으며, 연관된 기능들을 묶을 수 있음
- 즉, String class = 문자열 타입이며 , 그 안에 있는 메소드들을 통해 여러 문자열 관련 메소드 사용 가능

<br>

String Type의 변수 선언 / 문자열 리터럴 할당

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java9.png)

<br>

**위의 2가지의 공통점과 차이점**

- class로 instance를 찍어내고자 할때 new 연산자를 사용
- String 타입의 변수는 String 변수명; 으로 선언 가능
- 선언한 변수에 문자열을 할당하는 방법
  - 문자열 리터럴 : 변수 = "문자열";
  - String 클래스의 인스턴스를 생성하여 할당 : 변수 = new String("문자열");

<br>

**공통점**

- 참조타입의 변수에 할당됨
- 문자열의 내용을 값으로 가지고 있는게 아니라, 문자열이 존재하는 메모리 공간상의 주소값을 저장하고있음.
-  하지만 출력해보면 주소값이 아닌 문자열의 내용 출력됨

<br>

**Why?**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java10.png)

------

### **equals()**

-  . 앞의 변수가 저장하고 있는 문자열의 내용과 ()안의 문자열의 내용이 같은지 비교하여 boolean 값 출력
- 내용이 같은지만 비교하는 메서드

<br>

**1번 방법**

- name1 / name2는 1번의 방법인 문자열 리터럴을 String 타입의 변수에 직접 할당함.
- 동일한 문자열리터럴을 두 변수에 할당하는경우, 두 변수는 같은 문자열의 참조값 공유

<br>

**2번방법**

- String 클래스의 인스턴스를 생성하여 String 타입의 변수에 할당하는 방법
- 클래스의 인스턴스를 생성하면 문자열의 내용이 같아도, 별개의 인스턴스가 따로 생성됨
- name3 / name4가 할당받은 인스턴스의 참조값은 서로 다름. 즉 서로 다른 주소값 저장하고 있음

------

### **Comparison()**

**Comparison1**

\- name1은 Kim Coding 이라는 문자열 리터럴을 **직접할당**, 우항 또한 같은내용이기에(같은 주소값) true 반환

<br>

**Comparison2**

\- name1 / name2도 내용이 같은 문자열 리터럴 **직접할당** 받은 변수, 두 변수는 같은 문자열의 참조값이므로 true 반환

<br>

**Comparison3**

\- name3에서 **인스턴스를 생성**하여 할당받은 변수이며, 주소값이 달라서 false 반환

<br>

**Comparison4**

\- String 클래스토 인스턴스를 생성하면 항상 별개의 인스턴스 생성 = 다른 주소값 = false 반환

<br>

**Comparison5**

\- equals() 는 내용이 같은지만 비교하므로 true (참조값도 같음)

<br>

**Comparison6**

\- equals()는 내용이 같은지만을 비교하므로 true (참조값 다름)

<br>

**Comparison7**

\- equals()는 내용이 같은지만을 비교하므로 true (참조값 다름)

------

### **charAt()**

- 해당 문자열의 특정 인덱스에 해당하는 문자 반환
- 해당 문자열의 길이보다 큰 인덱스나 음수를 전달하면 오류 발생

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java11.png)문자열의 각 문자를 charAt() 메소드를 이용하여 하나씩 출력하는 예제

------

### **compareTo()**

- 해당 문자열을 인수로 전달된 문자열과 사전 편찬 순으로 비교함.
- 문자열 비교 시 대소문자 구분
- 두 문자열이 같다면 0 반환, 해당 문자열이 인수로 전달된 문자열보다 작으면 음수, 크면 양수 반환
- 대소문자를 구분하지 않기를 원한다면 compareToIgnoreCase() 를 사용

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java12.png)

------

### **concat()**

- 문자열의 뒤에 인수로 전달된 문자열을 추가한 새로운 문자열 반환
- concat은 concatenate의 약자로 사전적으로 연결을 의미
- 인수로 전달된 문자열의 길이가 이면, 해당 문자열을 그대로 반환

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java13.png)

**출력값**

문자열 : Java
Java수업
concat() 메서드 호출 후 문자열 : Java

------

### **indexOf()**

- 문자열에서 특정문자나 문자열이 처음으로 등장하는 위치의 인덱스 반환
- 문자열에 전달된 문자나 문자열이 포함되어 있지 않으면 -1을 반환

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java14.png)

**출력값**

문자열 : Oracle Java
-1
2
7
indexOf() 메서드 호출 후 원본 문자열 : Oracle Java

------

### **trim()**

- 문자열의 맨앞과 맨뒤에 포함된 모든 공백문자 제거

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java15.png)

**출력값**

문자열 : Java   
 Java   |
Java|
trim() 메서드 호출 후 문자열 : Java  

------

### **toLowerCase() 와 toUpperCase()**

- toLowerCase() 문자열의 모든 문자를 소문자 변환
- toUpperCase() 문자열의 모든 문자를 대문자 변환

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java16.png)

**출력값**

문자열 : Java
java
JAVA
두 메서드 호출 후 문자열 : Java