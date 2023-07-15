## **💡 문제 풀면서 알게된 것들**

2진수, 8진수 16진수를 Scanner로 받으려면 String 데이터타입 또는 int데이터타입을 이용하면된다.

<br>

**String에서 n진수로 변환**

- 2진수 : Integer.valueOf(String s, 2);, return : int
- 8진수 : Integer.valueOf(String s, 8);, return : int
- 16진수 : Integer.valueOf(String s, 16);, return : int

**10진수에서 n진수로 변환**

- 2진수 : Integer.toBinaryString(int i), return : String
- 8진수 : Integer.toOctalString(int i), return : String
- 16진수 : Integer.toHexString(int i), return : String

- [10진수를 2, 8, 16 진수로 변환하는 소스코드](https://effortguy.tistory.com/6)

**n진수에서 10진수로 변환**

- 2진수 : Integer.parseInt(String s, 2);, return : int
- 8진수 : Integer.parseInt(String s, 8);, return : int
- 16진수 : Integer.parseInt(String s, 16);, return : int
- [2진수처리 비교 - 정수를 입력받아 2진수 비트연산하여 10진수로 출력하기](https://sowon-dev.github.io/2020/10/11/201012al-c1059)

------

## **💡 Codeup 31~ 60**

**[1031] 10진수 -> 8진수 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code21.png) 

<br>

**[1032] 10진수 -> 16진수 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code22.png) 

<br>

**[1033] 10진수 -> 16진수(대문자) 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code23.png) 

<br>

**[1034] 8진수입력 -> 10진수출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code24.png) 

<br>

**[1035] 16진수입력 -> 8진수출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code25.png) 

<br>

**[1036] 영문자 1개(아스키코드) 입력받아 10진수 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code26.png) 

<br>

**[1037] 정수 입력받아 아스키코드로 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code27.png) 

<br>

**[1038] 정수 2개 입력받아 합 출력하기**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code28.png) 

<br>

**[1039] 정수 2개 입력받아 합 출력하기2 (위 문제랑 똑같은 코드)**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code29.png) 

<br>

**[1040] 정수 1개 입력받아서 부호 바꿔 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code30.png) 

<br>

**[1041] 문자 1개 입력받아 다음문자 출력**

영문자 1개를 입력받아 1을 더해준 뒤 문자형으로 변환해줌으로써 그 다음 문자를 출력할 수 있다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code31.png) 

<br>

**[1042] 정수 2개 입력받아 나눈 몫 출력하기**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code32.png) 

<br>

**[1043] 정수 2개 입력받아 나머지 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code33.png) 

<br>

**[1044] 정수 1개 입력받아 1 더한 값 출력**

++ 가 앞에 있어야함

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code34.png) 

<br>

**[1045] 정수 2개 입력받아 자동 계산**

나눈 값의 경우, String.format() 을 통해 소수점 이하 셋째 자리에서 반올림해 둘째 자리까지 출력하도록 한다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code35.png) 

<br>

**[1046] 정수 3개 입력받아 합과 평균 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code36.png) 

<br>

**[1047] 정수 1개 입력받아 2배 곱해 출력 (시프트연산자 사용)**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code37.png) 

<br>

**[1048] 한번에 2의 거듭제곱 배로 출력하기**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code38.png) 

<br>

**[1049] 두 정수 입력받아 비교하기**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code39.png) 

<br>

**[1050] 두 정수 입력받아 비교하기2**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code40.png) 

<br>

**[1051] 두 정수 입력받아 비교하기3      OutputStreamWriter, flush() 공부하자**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code41.png)

<br>

**[1052]**

![img](https://blog.kakaocdn.net/dn/bi2Cck/btrNhhgRmwM/co5FUNbvr8o8G2Ufvc7070/img.png)

<br>

**[1053] 참 거짓 바꾸기**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code42.png)

<br>

**[1054] 둘 다 참일 경우만 참 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code43.png)

<br>

**[1055] 하나라도 참이면 참 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code44.png)

<br>

**[1056] 참/거짓이 서로 다를때에만 참 출력하기**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code45.png)

<br>

**[1057] 참/거짓이 서로 같을때에만 참 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code46.png)

<br>

**[1058] 둘 다 거짓일 경우만 참 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code47.png)

<br>

**[1059] 비트단위로 NOT 하여 출력 ~n = -n -1 / -n = ~n +1**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code48.png) 

<br>

**[1060] 비트단위로 AND 하여 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code49.png) 