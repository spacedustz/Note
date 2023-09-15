## **💡 문제 풀면서 알게된 것들**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code1.png) 

<br>

### **BufferedReader 클래스**

입력 -> readLine() 사용 * 리턴값 string으로 고정이기에 string이 아닌 타입을 받으려면 형변환 필수

입력 -> 예외처리 필수, readLine()을 할때마다 try&catch를 활용하여 예외처리를 해줘도 되지만

입력 -> 보통 throws IOException을 통하여 작업함

<br>

throw 이용 시 -> import java.io.IOException;

main 클래스 옆에 throws IOException 작성

<br>

문자열로 먼저 저장되기 때문에 형변환 필수
입력값이 엔터만 인식, 한 라인에 여러가지 입력하려면 stringtokenize 필수(없이하면 공백을 문자열로 인식)
IOEception을 던져야함 (throws)
입력과 동시에 초기화
buffer size 8192

```java
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.BufferedReader;

public class bufferedreader {

	//IOException을 던져야함
	public static void main(String[] args) throws IOException{
		//bufferedreader는 설명에서처럼 inputstreamreader에 buffer를 추가하는 것이기 떄문에 
		//inputstreamreader를 받아와야한다.
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		//bufferedreader는 무조건 우선 문자열로 저장하기 때문에 다른 형으로 저장하고 싶으면 형 변환을 해줘야한다.
		int N = Integer.parseInt(br.readLine());
		//문자열로 저장할거면 형변환 없이 그냥 저장하면 된다.
		String S = br.readLine();
		
		System.out.println(N);
		System.out.println(S);
	}

}
```



**parseInt()**

- parseInt(String, radix)

**string**

- 숫자로 변환할 문자열

**radix**

- optional
- string 문자열을 읽을 진법(수의 진법 체계의 진법)
- 2~36의 수

<br>

**리턴 값** 

string을 정수로 변환한 값을 리턴합니다.

만약, string의 첫 글자를 정수로 변경할 수 없으면 **NaN(Not a Number)** 값을 리턴합니다.

------

## **💡 CodeUp 1 ~ 30**

**[1011] Scanner 클래스는 char형이 없으므로 아래와 같이 char 타입 데이터 선언**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code2.png) 

<br>

**[1012] Scanner 클래스중 nextFloat() 메소드에서 소수점 이하자리 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code3.png) 

<br>

**[1013] 정수 2개 입력받아서 그대로 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code4.png) 

<br>

**[1014] 문자 2개 입력받아서 순서 바꿔 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code5.png) 

<br>

**[1015] 실수 입력받아 둘째 자리까지 출력하기**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code6.png) 

<br>

**[1017] 정수 1개 입력받아 3번 출력하기**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code7.png) 

<br>

**[1018] 시간 입력받아 그대로 출력하기**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code8.png) 

<br>

**[1019]
parseInt(): 원시데이터인 int 타입을 반환
valueOf(): Integer 래퍼(wrapper)객체를 반환**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code9.png) 

<br>

**[1020] 주민번호 321-321 을 입력받아 - 가 없이 숫자만 출력**

**replaceAll( )을 통해 "-" 문자열을 ""로 치환하여 출력한다.**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code10.png) 

<br>

**[1021] String Type의 데이터 그대로 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code11.png) 

<br>

**[1022] nextLIne() 메소드를 사용하여 String Type의 입력데이터 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code12.png) 

<br>

**[1023] String.format() or printf() 를 활용한 실수형,정수형 데이터 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code13.png) 

<br>

**[1024] 단어를 입력받아 한줄에 1개씩 ' ' 로 묶어서 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code14.png) 

<br>

**[1025]**

다섯 자리의 숫자를 문자열 형태로 먼저 입력받은 후, 반복문을 통해 data 배열에 각 숫자를 정수형으로 저장한다.

반복문을 통해 data 배열의 요소를 하나씩 꺼내와 number와 곱해 출력한다.

출력을 완료하면 number 값을 10으로 나눈 몫으로 갱신한다

char 타입을 int형으로 바꾸면 아스키코드가 되는데&nbsp; 아스키코드 '0' 만 뺴주면 int숫자 그대로 출력가능

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code15.png) 

<br>

**[1026] 시:분:초 를 입력받아 분만 출력하기**

시분초 형식으로 입력받아 split( )을 통해 ':' 를 기준으로 나눠 value 배열에 저장한다.

만약 분에 해당하는 값이 00일 경우 0을 출력하고, 그렇지 않은 경우 value의 1번째 값을 그대로 출력한다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code16.png) 

<br>

**[1027] 년.월.일 입력받아 형식 바꿔 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code17.png) 

<br>

**[1028] 정수 1개를 입력받아 그대로 출력하기2 (int의 범위를 넘어선 정수)**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code18.png) 

<br>

**[1029] float의 범위를 넘어서는 소수값 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code19.png) 

<br>

**[1030] int의 범위를 넘어서는 정수 그대로 출력**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/code20.png) 