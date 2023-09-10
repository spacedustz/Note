## **💡 API <-> Service 연동 실습**  

API 계층에서 전달받은 DTO 객체를 서비스 계층의 도메인 엔티티 객체로 변환

1. 계층별 관심사 분리
2. 코드 구성의 단순화
3. Rest API 스펙의 독립성 확보

<br>

### **리팩터링 포인트**

**1. 컨트롤러의 핸들러가 DTO를 엔티티로 변환하는 작업까지 하고있다**

DTO를 엔티티로 변환하는 작업을 다른 클래스에게 변환 위임 = membermapper
컨트롤러는 이제 두 클래스의 변환작업을 안함 (역할 분리)

**2. 엔티티 클래스의 객체를 클라이언트의 응답으로 전송함으로써 계층간 분리 X**
클라이언트 응답을 엔티티 클래스로 전송하지말고, 엔티티의 객체를 DTO의 객체로 바꿔줌
membermapper가 엔티티를 dto로 변환해줌으로써 서비스에있는 엔티티를
 apu에서 직접 사용하는 문제 해결

------

## **💡 구현**  

<br>

### **Entity**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Service.png) 

<br>

### **ResponseDto**

응답 데이터의 역할

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Service2.png) 

<br>

### **Service**

핵심 비즈니스로직 처리

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Service3.png) 

<br>

### **Mapper**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Service4.png) 

<br>

### **MemberMapperImpl**

Mapstruct에 의해 DTO <-> Entity가 자동 매핑되어 생긴 클래스

```java
@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2022-10-24T13:51:17+0900",
    comments = "version: 1.5.3.Final, compiler: IncrementalProcessingEnvironment from gradle-language-java-7.4.1.jar, environment: Java 11.0.16 (Azul Systems, Inc.)"
)
@Component
public class MemberMapperImpl implements MemberMapper {

    @Override
    public Member memberPostDtoToMember(MemberPostDto memberPostDto) {
        if ( memberPostDto == null ) {
            return null;
        }

        Member member = new Member();

        member.setEmail( memberPostDto.getEmail() );
        member.setName( memberPostDto.getName() );
        member.setPhone( memberPostDto.getPhone() );

        return member;
    }

    @Override
    public Member memberPatchDtoToMember(MemberPatchDto memberPatchDto) {
        if ( memberPatchDto == null ) {
            return null;
        }

        Member member = new Member();

        member.setMemberId( memberPatchDto.getMemberId() );
        member.setName( memberPatchDto.getName() );
        member.setPhone( memberPatchDto.getPhone() );

        return member;
    }

    @Override
    public MemberResponseDto memberToMemberResponseDto(Member member) {
        if ( member == null ) {
            return null;
        }

        long memberId = 0L;
        String email = null;
        String name = null;
        String phone = null;

        memberId = member.getMemberId();
        email = member.getEmail();
        name = member.getName();
        phone = member.getPhone();

        MemberResponseDto memberResponseDto = new MemberResponseDto( memberId, email, name, phone );

        return memberResponseDto;
    }
}
```