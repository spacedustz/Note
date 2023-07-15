## **💡 UnexpectedTypeException** 

<br>

Post요청시 Exception 발생

![img](https://blog.kakaocdn.net/dn/cXCbBO/btrTgnovXSK/UOyKd1oz0la9o5l49FT5D1/img.png) 

<br>

DTO 필드에 적용한 Validation인 NotBlank 어노테이션의 비적절한 사용때문에 발생

![img](https://blog.kakaocdn.net/dn/shzru/btrTf0mWJOB/edlbjlcIYg4a7Zs3CMoOtK/img.png) 

<br>

**자바 타입에 따라 Validate Annotation을 적절하게 써야 함**

Null, "", " "  3개중 허용 범위
@NotBlank - 셋 다 비허용
@NotEmpty - " "만 허용
@NotNull - " ", "" 만 하용