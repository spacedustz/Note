## **💡 Exception Handler**  

**예외 발생 가능성이 있는 상황**

- 클라이언트 요청 데이터에 대한 유효성 검증에서 발생하는 예외
- 서비스 계층의 비즈니스 로직에서 던져지는 의도된 예외
- 런타임 예외

<br>

### **UserController에 Exception Handler 적용**

-  RequestBody에 유효하지않은 데이터 요청이 오면, 유효성 검증에 실패
- 유효성 검증에 실패시 내부적으로 던져진 예외인 MethoddArgumentNotValidException을 handleException() 이 받음
- 그 후, MethodArgumentNotValidException 개체에서 getBindingResult(), getFieldErrors() 를 통해,
  발생한 에러 정보를 리스트로 확인 가능
- 객체에서 얻은 정보인 filedErrors를 ResponseEntity를 통해 ResponseBody로 전달

<br>

UserController에 ExceptionHandler 적용

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Exception.png) 

<br>

HTTP Request를 보내 ExceptionHandler 적용 확인

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Exception3.png) 

```json
[
    {
        "codes": [
            "Email.userPostDto.email",
            "Email.email",
            "Email.java.lang.String",
            "Email"
        ],
        "arguments": [
            {
                "codes": [
                    "userPostDto.email",
                    "email"
                ],
                "arguments": null,
                "defaultMessage": "email",
                "code": "email"
            },
            [],
            {
                "arguments": null,
                "defaultMessage": ".*",
                "codes": [
                    ".*"
                ]
            }
        ],
        "defaultMessage": "올바른 형식의 이메일 주소여야 합니다",
        "objectName": "userPostDto",
        "field": "email",
        "rejectedValue": "asdad23@",
        "bindingFailure": false,
        "code": "Email"
    }
]
```

 <br>

**하지만, 반환값에는 알수없는 정보를 전부 포함한 내용은 제외하고 싶다.**
**ErrorResponse 클래스를 따로 만들어서 원하는 출력정보만 나오게 해보자.**

- 유효성 검증 실패 시, 실패한 필드에대한 Error정보만 담아서 응답으로 전송하기 위한 클래스
- 위의 Exception 정보를 리턴받은 값을 보면 **배열**로 되어있다.
  유효성 검증에 실패하는 멤버 변수가 하나 이상이 될 수 있기 때문.
- 그렇기 때문에, 유효성 검증에 실패한 에러 정보를 담기위해 List객체를 이용하며, 이 한개의 필드 에러 정보는
  Error_Detail 이라는 별도의 static class를 Error클래스의 멤버 클래스로 정의
  Error는 에러 정보만 담는 클래스이기 때문에 필드의 에러 정보를 담는 Error_Detail클래스 역시,
  에러라는 **공통 관심사**를 가지고 있으므로 Error의 멤버로 표현하는것이 적절하다.

<br>

공통 관심사를 처리할 Error 클래스 작성

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Exception4.png) 

<br>

UserController 내부 ExceptonHandler 수정 -> Error 객체를 응답으로 전송

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Exception5.png) 

<br>

원하는 에러 정보만 표시

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Exception6.png) 

<br>

### **Exception Handler의 단점**

@ExceptionHandler Annotation 사용 시 문제점

- 각각의 컨트롤러에서 @ExceptionHandler를 사용해야 하므로 코드중복 발생
- 컨트롤러에서 Validation에 대한 예외뿐 아니라 여러가지 예외 처리를 해야하므로 핸들러 메소드의 증가
- 해결법은? **RestControllerAdvice를 사용한 예외 처리 공통화**

------

## **💡 RestControllerAdvice를 사용한 예외 처리 공통화**

어떤 클래스에 @RestControllerAdvice를 추가하면 여러개의 컨트롤러에서
@ExceptionHanndler, @InitBinder, @ModelAttribute가 추가된 메소드를 공유해서 사용 가능

<br>

ApplyExceptionAdviceAllControllers 클래스 생성하여 공통 처리

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Exception7.png)