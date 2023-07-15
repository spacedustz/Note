## **💡 배열**

- 부득이하게 많은 수의 변수를 할당해야 할 때
- ex: 1달동안의 일별 최고 기온 / 강수여부 = 공통점 최고기온:double / 강수여부:boolean 의 값을 가짐
- 이런 각 값들이 같은 타입을 가지는 경우, 배열을 사용하여 단 하나의 변수만으로 값들을 저장 및 참조가능
- 즉, 배열이란 동일한 타입의 값들을 하나의 묶음으로 묶은 자료 구조를 의미하며, 묶여진 값들을 배열이라고 함

------

**배열에서의 차원이란?**

- 배열을 사용할때 1,2차원 배열을 흔히 사용하며, 필요에 따라서는 3,4차원 배열도 만들어 사용할 수 있음
- '차원'이란 배열이 중첩된 정도를 의미하며, 즉 배열이 중첩되었다 함은 배열의 요소가 또 다른 배열일 경우임
- 1차원 배열 - 배열의 요소가 배열이 아닌 경우
  - ex: { 1, 2, 3, 4 }
  - 배열의 각 요소는 1,2,3,4로 모두 int값

- 2차원 배열 - 배열이 한번 중첩된 경우 = 배열의 요소가 배열인 경우
  - ex: { { 1, 2, 3, 4 } , { 5, 6, 7, 8 } }

------

### **1차원 배열의 선언과 초기화**

- 타입 뒤에 대괄호 []를 붙여서 선언하고 초기화 할 수 있음
- **ex:** double[] temperatureOfJuly;
  temperatureOfJuly = new double [31];

<br>

**위 예시가 실행될때 내부 동작**

- 첫번째줄은 배열을 가리킬 참조변수 temperatureOfJuly를 선언
- 두번째 줄의 new double [31];은 총 31개의 double 타입의 값을 저장할 수 있는 배열 생성
- ※ 이때 배열의 모든 요소는 double형의 기본값인 0.0으로 초기화되어짐
- 두번째줄 전체는 대입연산자 = 에 의해 생성된 배열 첫 번째 요소의 주소값이 참조변수 temp~에 할당
- 즉, 참조변수 temperatureOfJuly는 배열의 맨 첫번째 요소를 가리킴

<br>

**※** **왜 temperatureOfJuly는 참조 변수여야 할까?**

\- Java에서 배열은 참조타입. double []이라는 배열 선언문법으로 선언한 temperatureOfJuly는 선언 후

  생성될 배열의 주소값을 담을 참조 변수가 됨

<br>

**배열의 선언 =** double[] temperatureOfJuly;

**배열의 선언/초기화 =** double[] temperatureOfJuly = new double[31];

<br>

**※ 이때 배열은 double 타입의 기본값인 0.0으로 초기화되어있음. 29.6,32.1와 같은 실제값을 넣은 초기화 방법은?**

<br>

**1.** double[] tempertureOfJuly = new double[] { 29.6, 32.1, 33.9, 31.2 }; 

※ 참조변수 선언 - 배열생성되고 중괄호 내의 값으로 배열 요소들의 값 초기화 - 첫번째 요소의 주소값=참조변수에 할당

<br>

**2.** double[] tempertureOfJuly = { 29.6, 32.1, 33.9, 31.2 }; 

※ 2번과 같이 **선언과 초기화를 한 문장으로 할때 new double[] 생략 가능**

------

### **배열의 길이or크기**

- 1차원 배열
  - length()
- 2차원 배열
  - length() -> 전체 배열의 개수
  - 참조변수[i].length -> 2차원 배열의 length()

------

### **배열의 두가지 출력 방법**

- 반복문으로 출력

```java
for (int i=0; i<arr.length; i++) {

  System.out.println(arr[i]);

// 결과값
// 각 배열의 index값을 읽어서, 값 출력
1
2
3
4
5
```

<br>

- java.util.Arrays의 toString() 메소드 사용

```java
import java.util.Arrays;

public class PrintArray {

  public static void main(String[] args) {

    int[] arr = { 1, 2, 3, 4, 5 };

    System.out.println(Arrays.toString(arr));

//결과값, 파라미터로 배열을 입력받아서, 배열에 정의된 값들을 문자열 형태로 리턴
[1, 2, 3, 4, 5]
```

------

### **1차원 배열 예제 풀어보기**

- 배열 참조 변수 num을 선언하고, int형의 값 1, 2, 3, 4, 5를 요소로 가지는 배열을 생성하여 num에 할당해보세요.
- 배열 참조 변수 favoriteThings를 선언하고, 자신이 가장 좋아하는 것들을 요소로 가지는 문자열 배열을 생성해 favoriteThings에 할당해보세요.
- 배열 참조 변수 isRainy를 선언하고, 앞으로 일주일 동안 비가 올지 안올지의 여부를 요소로 가지는 boolean형 배열을 생성해 isRainy에 할당해보세요.
- int[] num = new int[] { 1, 2, 3, 4, 5 };  <- **선언과 동시에 초기화 하면 new int[]  <- 대괄호에 숫자 안써도 됨**
- String[] favoriteThings = new String[2] { fruits, computer, };
- boolean[] isRainy = new boolean[3] { True,True,Flase }; 

------

### **2차원 배열의 선언과 초기화**

ex: int[] [] kcal;  /  kcal = new int[5] [2];  /  int[] [] kcal = new int[5] [2];

<br>

- 실행이 되면 다음에 같은 2차원 배열이 생성됨.
- 내부 배열은 int형의 기본값인 0을 2개 포함하며 외부배열은 내부배열 ( { 0, 0 } ) 를 5개 저장
- 즉, 내부배열은 2개의 0을 요소로 가지지만 외부배열은 각 요소의 내부배열의 주소값을 저장함

```java
{
  { 0, 0 },
  { 0, 0 },
  { 0, 0 }
}
```

<br>

**값을 넣어 초기화 하는 경우의 코드 작성**

```java
// 선언과 초기화를 한번에 할시 new int[] [] 생략 가능
int[] [] kcal = new int[][]
{
  { 135, 247, 368 },
  { 312, 534, 521 },
  ...
  { 517, 772, 962 }
};

// or

// 2차원 배열의 모든 요소를 10으로 초기화
for (int i=0; i<score.length; i++) {
  for (int j=0; j< score[i].length; j++) {
    score[i][j] = 10;
  }
}

// or

for (int[] tmp : kcal) {
  for (int i : tmp) {
    sum += i;
  }
}
```

<br>

**2차원 배열 예제** 

- 1차원 배열을 설명할 때 제시했던 그림처럼, 이 콘텐츠에서 제시한 열량 기록 배열(kcal)이 메모리 상에 어떻게 생성되어져 있을지 직접 그려보세요.
  - 힌트 : 아래 두 코드를 실행해보고, 차이점을 분석해보세요.
    - System.out.println(Arrays.toString(kcal));
    - System.out.println(Arrays.toString(kcal[0]));

------

### **가변배열**

- 2차원 이상의 다차원에서는 마지막 차수에 해당하는 배열의 길이를 고정하지 않아도 됨

```java
ex: int[][] ages = new int[5][];

ages[0] = new int[4]
ages[1] = new int[2]
ages[2] = new int[7]
ages[3] = new int[3]
ages[4] = new int[2]

System.out.println("Arrays.toString(ages) = " + Arrays.toString(ages));

// 결과값
Arrays.toString(ages) = [null, null, null, null, null]
```

<br>

내부 배열을 생성하려면 new int[] 를 사용하여 외부 배열의 각 요소에 할당

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java25.png) 

<br>

가변 배열도 일반적인 배열과 같이 생성과 동시에 초기화 가능

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java26.png)**반복문을 통한 배열 탐색**

배열의 각 요소들의 총합을 구하는 예제를 통해 반복문을 사용해 배열을 탐색하는법을 배워보자

<br>

예제

![img](https://blog.kakaocdn.net/dn/yA8QF/btrK4Uuk6b2/LZLP8pK4q6KSwdZKlSd6H0/img.png)

<br>

for문으로 배열 순회 총합

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java27.png)

<br>

while문을 통한 배열 순회 총합

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java28.png)

<br>향상된 for문을 통한 배열의 각 요소 접근가능![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java29.png)

<br>

**향상된 for 문으로 배열을 사용할 시 주의사항**

배열의 값을 읽어오는것만 가능하고, 배열을 순회하면서 배열의 값 수정은 못함

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java30.png)