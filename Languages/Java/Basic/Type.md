## 💡 타입

어떤값의 유형 및 종류를 의미하며 타입에 따라 **값이 차지하는 메모리 크기**와**, 값이 저장되는 방식** 결정

<br>

**값이 차지하는 메모리 공간의 크기**

- 정수형 타입의 데이터 = 4byte
- 문자형 타입의 데이터 = 1byte

**값이 저장되는 방식**

- 값을 그대로 저장하는 기본타입, 저장값을 임의의 메모리 공간에 저장후, 그 메모리 공간의 주소를 저장하는 참조타입

<br>

### **기본타입(primitive type)**

- 값을 저장할때, 데이터의 실제 값이 저장됨.
- 정수(byte,short,int,long) , 실수(float,double) , 문자타입(char) , 논리 타입(boolean)

<br>

### **참조타입(reference type)**

- 값을 저장할때, 데이터가 저장된 곳을 나타내는 주소값이 저장됨.
- 객체의 주소를 저장, 8개의 기본형을 제외한 나머지 모든타입

<br>

의사코드로 표현한 예시

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/img.png?token=A633OJKRGVVEUUCS6W4EMVDEEZXFI) 

- 위 예시에서 참조타입변수는 저장하고자 하는것이 존재하는 위치를 저장함.
- 객체를 어떤 변수에 저장한다면 그 변수에는 객체가 존재하는 메모리 주소를 값으로 가짐
- 즉, 객체의 주소값이 변수에 저장되어있음

<br>

실제코드로 표현한 예시

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java4.png) 

<br>

**출력값**

**> Task :Test.main()**

**1**

**java.lang.Object@626b2d4a     <- 참조타입변수의 객체에 저장된 메모리 주소**

<br>

### **정수 타입**

byte, short, int, long

<br>

**정수형의 오버 & 언더플로우**

ex) byte type = -128 ~ 127

- 127 이상으로 값이 넘어갈경우 오버플로우
- -128 이하로 내려갈경우 언더플로우

최대값인 127을 넘어갈경우 최소값인 -128로 순환됨

최소값인 -128을 내려갈경우 최대값인 127로 순환됨

<br>

### **실수 타입**

float, double

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java5.png)

<br>

#### **실수타입의 오버 & 언더플로우**

- 값이 음의 최소범위 또는 양의 최대범위를 넘어갔을때 발생, 이때 값은 무한대
- 값이 음의 최대범위 또는 양의 최소범위를 넘어갔을때 발생, 이때 값은 0

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java6.png)

<br>

### **논리 타입**

boolean

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java7.png)

<br>

### **문자 타입**

char

- 문자 타입의 변수를 선언하면 해당 변수에 오직 하나의 문자형 리터럴을 지정할 수 있음.
- 문자형 리터럴은 ' '(작은 따옴표)만 사용가능

<br>

**ex) 문자형 char letter1 = 'a';**

숫자를 문자형 변수에 할당 char letter = 65;

java는 문자를 유니코드로 저장 a -> 유니코드 a의 숫자반환

65 -> 유니코드 65의문자 반환

<br>

### **타입변환**

boolean을 제외한 기본타입 7개는 타입 변환가능하며, 자동/수동 타입변환 방법이 있음

<br>

#### **자동타입변환**

바이트 크기가 작은 타입에서 큰타입으로 변환할 때 (ex: byte -> int)

덜 정밀한타입에서 더 정밀한 타입으로 변환할 때 (ex: int -> float)

<br>

float이 정수형보다 뒤에있는 이유는 float으로 표현할 수 있는 값이 모든 정수형보다 더 정밀하기 때문

byte(1) - short(2)/char(2) - int(4) - long(8) - float (4) -> double(8)

<br>

#### **수동타입변환**

- 바이트 크기가 큰타입에서 작은타입으로 자동변환 X
- 큰 -> 작은 = 자동변환불가,캐스팅이라고 불림

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java8.png)