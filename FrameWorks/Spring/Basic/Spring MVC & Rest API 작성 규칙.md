## **💡 Spring Web MVC**

- Spring의 모듈중 하나로 Suvlet API를 기반으로 웹계층을 담당
- 클라이언트의 요청을 편리하게 처리해주는 프레임워크

<br>

### **서블릿(Servlet)이란?**

서블릿에 대해서는 ‘Spring Framework을 배워야 하는 이유’ 챕터에서 잠깐 언급을 한적이 있다.
서블릿은 클라이언트의 요청을 처리하도록 특정 규약에 맞추어서 Java 코드로 작성하는 클래스 파일이다.
그리고 아파치 톰캣(Apache Tomcat)은 이러한 서블릿들이 웹 애플리케이션으로 실행이 되도록 해주는
서블릿 컨테이너(Servlet Container) 중 하나임.

<br>

### **Model**

- Spring MVC 에서 'M' 에 해당
- 처리한 **작업의 결과** **데이터**를 의미함

<br>

### **View**

- Spring MVC 에서 'V'에 해당
- 화면에 보여지는 리소스를 제공하는 역할
- View에는 다양한 View기술이 포함되어 있는데 View의 형태는 아래와 같이 나눌 수 있음
  - **HTML 출력**
    - 클라이언트에 보여질 HTML을 직접 렌더링해서 전송
    - 즉, 기본적인 HTML 태그로 구성된 페이지에 Model 데이터를 넣고 최종 페이지를 만들어서 넘김
    - MVC에서 지원하는 HTML 지원 기술 = Thymeleaf, FreeMarket, JSP+JSTL, Tiles 등이 있다
  - **PDF, Excel 등의 문서 형태로 출력**
    - Model 데이터를 가공해서 PDF문서나 Excel 문서를 만들어서 클라이언트 측에 전송
    - 문서 내에 데이터가 동적변경이 이루어져야하는 경우 사용
  - **XML, JSON 등 특정 형식의 포맷 변환**
    - Model 데이터를 특정 프로토콜 형태로 변환 -> 변환된 데이터 클라이언트로 전송
    - 이 방식은 특정 형식의 데이터만 전송하고, 이 데이터를 기반으로 HTML을 만드는 방식
    - 장점 : 영역구분으로 유지보수 용이, 프론트에서 비동기 클래이언트 어플리케이션 생성 가능

<br>

### **Controller**

- Spring MVC에서 'C'에 해당
- 클라이언트 측 요청을 직접적으로 받는 엔드포인트로, Model과 View의 중간 상호작용 역할
- 즉, 요청 받고 비즈니스 로직을 거쳐 Model 데이터가 만들어지면 View로 전달

------

## **💡 Spring MVC 동작방식 & 구성요소**  

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_MVC.png)Front Controller Pattern

- (1) 클라이언트가 요청을 전송하면 DispatcherServlet이라는 클래스에 요청 전달
- (2) DispatcherServlet은 **클라이언트의 요청을 처리할 Controller의 검색**을 HandlerMapping 인터페이스에게 요청
- (3) HandlerMapping은 **클라이언트 요청과 매핑되는 핸들러 객체를 다시 DispatcherServlet에게 리턴**

<br>

**핸들러 객체는 해당 핸들러의 Handler 메서드 정보를 포함**

**Handler 메서드는 Controller 클래스 안에 구현된 요청 처리 메서드를 의미함**

- (4) 요청을 처리할 Controller 클래스를 찾았으니 이제는 요청을 처리할 Handler 메서드를 찾아서 호출. DispatcherServlet은 Handler 메서드를 직접 호출하지 않고, HandlerAdpater에게 Handler 메서드 호출을 위임
- (5) HandlerAdapter는 DispatcherServlet으로부터 전달 받은 Controller 정보를 기반으로
  **해당 Controller의 Handler 메서드를 호출**

<br>

**이제 전체 처리 흐름의 반환점을 돌았으니 반대로 돌아가보자**

- (6) Controller의 Handler 메서드는 비즈니스 로직 처리 후 리턴 받은 Model 데이터를 HandlerAdapter에게 전달
- (7) HandlerAdapter는 전달받은 **Model 데이터와 View 정보를 다시 DispatcherServlet에게 전달**
- (8) DispatcherServlet은 전달 받은 View 정보를 다시 ViewResolver에게 **전달해서 View 검색을 요청**
- (9) ViewResolver는 View 정보에 해당하는 View를 찾아서 **View를 다시 리턴**
- (10) DispatcherServlet은 ViewResolver로부터 전달 받은 View 객체를 통해 Model 데이터를 넘겨주면서 클라이언트에게 전달할 **응답 데이터 생성을 요청**
- (11) View는 응답 데이터를 생성해서 다시 DispatcherServlet에게 전달
- (12) DispatcherServlet은 **View로부터 전달 받은 응답 데이터를 최종적으로 클라이언트에게 전달**

------

## **💡 Rest API URI 작성 규칙**  

- URI의 마지막이 '/'로 끝나면 안됨
- Default 소문자, 언더바 X 하이픈 O
- 동사 X 명사 O
- 단수형 X 복수형 O
- 파일의 확장자는 URI에 미 포함



### **리소스 간의 관계를 URI로 표현하는 예시**

```
'http://www.itivllage.tistory.com/members'는 전체 회원에 대한 리소스를 의미합니다. 
'http://www.itivllage.tistory.com/members/1'는 1이라는 ID를 가지는 회원에 대한 리소스를 의미합니다. 
'http://www.itivllage.tistory.com/members/1/orders'는 1이라는 ID를 가지는 회원의 주문에 대한 리소스를 의미합니다.
```

 출처: https://itvillage.tistory.com/35 [IT Village:티스토리]  <- 블로그 추천

---

## 💡 서블릿(Servlet)

- Java Servlet 자체를 사용하는 기술은 현재 거의 사용하고 있지 않지만 **Servlet은 Spring MVC 같은 Java 기반의 웹 애플리케이션 내부에서 여전히 사용**이 되고 있음.
- Servlet에 대해서 더 알고 싶다면 아래 링크를 클릭
  - 자바 서블릿: https://ko.wikipedia.org/wiki/자바_서블릿

<br>

### **서블릿 컨테이너(Servlet Container)란?** 

- 서블릿 컨테이너(Servlet Container)는 서블릿(Servlet) 기반의 웹 애플리케이션을 실행해주는 것부터 시작해서 Servlet의 생명 주기를 관리하며, 쓰레드 풀(Thread Pool)을 생성해서 Servlet과 Thread를 매핑 시켜주기도 함
- 서블릿 컨테이너에 대한 자세한 내용이 궁금하다면 아래 링크를 클릭
  - 서블릿 컨테이너: https://ko.wikipedia.org/wiki/웹_컨테이너
- **아파치 톰캣(Apache Tomcat)**은 서블릿 컨테이너의 한 종류로써 Spring MVC 기반의 웹 애플리케이션 역시 **기본적으로 아파치 톰캣에서 실행**이 됨.
- 아파치 톰캣에 대한 내용은 아래 링크에서 확인
  - 아파치 톰캣
    - https://ko.wikipedia.org/wiki/아파치_톰캣
    - https://tomcat.apache.org/

- 객체 지향 설계 원칙
  - 객체지향 설계 원칙에 대해 학습을 하고 싶다면 아래 링크를 클릭.
    - SOLID(객체 지향 설계 원칙): https://ko.wikipedia.org/wiki/SOLID[(객체지향_설계)](https://ko.wikipedia.org/wiki/SOLID_(객체_지향_설계))
    - SOLID 요약: https://itvillage.tistory.com/entry/객체지향-설계-원칙-SOLID-원칙