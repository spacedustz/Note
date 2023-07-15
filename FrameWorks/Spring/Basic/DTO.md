## **💡 DTO (Data Transfer Object)**  

HTTP Method별로 or Request, Response 별로
받아올 필드값(Request)과 보내줄 필드값(Response)을 잘 생각해서 필드값 설정
Mapstruct로 자동매핑이 어려운 필드의 경우 서비스클래스에서 비즈니스로직으로 처리하자.

- DTO 클래스 = 요청 데이터를 하나의 객체로 전달받는 역할
- DTO를 적용하기 전엔 요청데이터를 @RequestParam을 통해 일일이 받았지만,
  데이터가 많아질수록 @RequestParam의 개수도 많아질 것이다.
- DTO 클래스를 적용함으로써 코드의 간결성을 충족시킬 수 있다.
- DTO를 쓰는 가중 중요한 이유는 **HTTP 요청의 수를 줄여 비용절감**을 하는 것
- 아래에서 볼 예시는 DTO, 데이터 유효성 검증을 받지않은 코드를 DTO & 유효성 검증을 적용 해볼것임

<br>

핸들러 메소드인&nbsp; postMember에 DTO클래스를 적용하기 전

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DTO1.png) 

<br>

DTO 클래스 생성 후 이메일에 Varidation 체크를 위한 @Email 적용

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DTO2.png) 

<br>

핸들러 메소드의 생성자 파라미터에 DTO클래스를 넣고 유효성 검증 어노테이션 추가

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DTO3.png) 