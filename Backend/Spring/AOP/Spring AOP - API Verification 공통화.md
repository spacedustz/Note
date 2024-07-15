## 📚 Spring AOP - API Verification 공통화

이번에 코드 리팩터링 도중 이전에 구현 해두었던 API Filter에서 JWT만 검증하고, 

나머지 Request를 요청하는 유저의 권한 등등을 컨트롤러 마다 검증 private method를 쓰거나, 공통 클래스에 넣어서 썼었습니다.

Rest Controller 마다 다양한 검증 로직이 존재 하는 상태이고, 그 중 공통화를 할 수 있는 로직들만 묶고 싶어서 알아보다가 

기존에 개념만 알고 있던 AOP를 한번 써보자 해서 구현 해보았습니다.

<br>

검증 로직을 공통화 하기위해 Aspect 기능을 사용하여 검증할 값들을 Security Filter에서 Header로 넣고 API 호출 전, Aspect 클래스에서 검증하는 방향으로 잡았습니다.

<br>

기본 흐름은 API Request가 들어오면 Security Filter를 먼저 거치고, 

Controller의 Method를 호출하기 전에 Aspect가 요청을 가로채 검증을 먼저 수행 후 실제 비즈니스 로직이 실행됩니다.

---

## 📚 Controller Aspect 구현

자세한 설명은 구현하며 **주석**으로 적었고, 구현한 Controller Aspect를 요약하면 아래와 같습니다.

- API Request가 들어오면 API Filter를 먼저 거치고, Controller의 Method를 거치기 전 Aspect가 요청을 가로채 검증을 먼저 수행합니다.
- Security Filter인 API Filter에서 유저의 Role과 JWT Token을 검사해 헤더에 Role과 Token의 상태 등 4개의 헤더값을 넣어 주었습니다.
- 위에 만들어둔 Security API Filter에서 유저의 Request 헤더 4개 중, 2개인 **User Role**과 **Token Status**를 검증하도록 로직을 짰습니다.
- Token Status는 `Valid`, `Invalid`, `Expired` 3가지의 상태를 가지는 Enum으로 만들었으며 Valid가 아니면 전부 Exception을 Throw 합니다.
- 실제 Exception을 던지는 곳은 Controller Aspect이고, API Filter에서는 헤더에 상태만 주입합니다.
- Aspect 시작 - 끝 응답속도와 클래스명, 함수명, 파라미터를 로그에 찍습니다.

<br>

**@Around**

- `@Around("execution(public * com.ys.admin.controller.*.*(..))")` : `com.ys.admin.controller` 패키지 내의 모든 컨트롤러의 Public Method를 대상으로 한다는 포인트컷 표현식입니다.



```java
/**  
 * @author 신건우  
 * @desc Controller AOP 공통 로직 - Request Header를 통해 유저 권한, 토큰 상태 검증  
 */  
@Slf4j  
@Aspect  
@Component  
@RequiredArgsConstructor  
public class ControllerAspect {  
    private final UserGroupService userGroupService;  
  
    /**  
     * @author 신건우  
     * @desc  
     * 1. 사용자의 Header에 넣은 Token Status, User Role 2개의 값을 가져와 토큰 상태 Enum에 정의 해놓은 Valid 상태가 아니면 Throw Exception  
     * 2. 두번쨰 헤더의 값인 User Role을 가져와 해당 Role에 해당하는 권한(ViewGroup)의 Y/N을 Map에 매핑 -> 잘못된 Role 일 시 Throw Exception  
     * 3. Custom Annotation인 PreAuth의 코드를 가져와 해당 코드에 존재하는 권한 리스트 체크  
     * 4. 응답속도, Class, Method, Parameter 로깅  
     */  
    @Around("execution(public * com.ys.admin.controller.*.*(..))")  
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {  
        Object result = null;  
        Object[] paramValues;  
        StringBuilder paramValueStr = new StringBuilder();  
        long startTime = System.currentTimeMillis();  
  
        try {  
            String userRoleStr = null;  
            String tokenStatusStr = null;  
  
            TokenStatus tokenStatus = TokenStatus.Invalid;  
            UserRole role = UserRole.OTHER;  
  
            boolean hasRight = false;  
            Map<Integer, CustomAuth> authMap = new HashMap<Integer, CustomAuth>();  
  
            // TODO 1: Request Header에서 TOKEN_STATUS, USER_ROLE을 가져와서 String 값과 객체로 변수화  
            // 컨트롤러의 모든 파라미터를 배열로 받음 - PathVariable, RequestParam, RequestBody 모두 해당  
            paramValues = joinPoint.getArgs();  
  
            // 컨트롤러의 파라미터들을 1줄의 String으로 append 시키면서 ","로 구분  
            if (paramValues != null && paramValues.length > 0)  
                Arrays.stream(paramValues).forEach(param -> paramValueStr.append(param).append(","));  
  
            // Request를 처리하는 컨트롤러 클래스명, 함수형을 로그로 찍음  
            String classNameWithPackageName = joinPoint.getTarget().getClass().getCanonicalName(); // 패키지명을 포함한 클래스명  
            String classNameWithoutPackageName = classNameWithPackageName.substring(classNameWithPackageName.lastIndexOf(".") + 1); // 패키지명을 제외한 클래스명  
  
            log.info("[ Aspect Req ] - Class : {}, Method : {} , Param Value : {}", classNameWithoutPackageName, joinPoint.getSignature().getName(), paramValueStr);  
  
            // 요청(HttpServletRequest)의 헤더에 넣었던 토큰 상태, 유저 권한 가져오기  
            for (int i = 0; i < Objects.requireNonNull(paramValues).length; i++) {  
                if (paramValues[i] instanceof HttpServletRequest) {  
                    tokenStatusStr = ((HttpServletRequest) paramValues[i]).getHeader(UserConstants.TOKEN_STATUS);  
                    userRoleStr = ((HttpServletRequest) paramValues[i]).getHeader(UserConstants.USER_ROLE);  
                    break;  
                }  
            }  
  
            // TODO 2: TOKEN_STATUS 헤더 값 검증 - Valid가 아니라면 Throw Exception            
            if (StringUtils.hasText(tokenStatusStr)) tokenStatus = TokenStatus.valueOf(tokenStatusStr);  
  
            switch (tokenStatus) {  
                case Invalid -> {  
                    log.error("[ Aspect Error ] - Invalid Token Status : {}", tokenStatusStr);  
                    throw new CommonException(ExceptionCode.INVALID_TOKEN);  
                }  
                case Expired -> {  
                    log.error("[ Aspect Error ] - Expired Token Status : {}", tokenStatusStr);  
                    throw new CommonException(ExceptionCode.EXPIRED_TOKEN);  
                }  
            }  
  
            // TODO 3: USER_ROLE에 해당하는 권한(ViewGroup)을 GrantAuthority를 구현한 CustomAuth를 이용해 Map에 권한의 Y/N 여부 매핑  
            if (StringUtils.hasText(userRoleStr) && !userRoleStr.equals(UserRole.ADMIN.name())) {  
                role = UserRole.valueOf(userRoleStr);  
                authMap = userGroupService.findUserGroup(role);  
            }  
  
            // TODO 4: API에 붙인 Custom으로 생성한 PreAuth Annotation의 View ID 검증을 위해 Method Signature 조회 후 PreAuth로 매핑  
            MethodSignature signature = (MethodSignature) joinPoint.getSignature();  
            Method method = signature.getMethod();  
  
            PreAuth preAuth = method.getAnnotation(PreAuth.class);  
  
            // TODO 5: 매핑된 PreAuth의 멤버로 있는 권한 배열을 AuthorizationType 배열로 변수화  
            AuthorizationType[] userAuthMethodArray = preAuth.authorization();  
  
            // TODO 6: API에 붙인 PreAuth의 View ID를 가져와 View가 가지고 있는 권한 리스트를 체크 해 어떤 권한을 가졌는지 체크 후 hasRight True/False 설정  
            // 0은 JWT Authentication Filter에서 검증 예외로 지정된 URL(NO_NEED_TOKEN_API)에 붙이는 값이므로 이 값에 해당되는 Endpoint를 가진 API는 hasRight 통과시킴  
            if (preAuth.viewId() == 0) {  
                hasRight = true;  
            } else {  
                // View ID가 0번이 아닌 경우  
                if (authMap.containsKey(preAuth.viewId())) {  
                    CustomAuth auth = authMap.get(preAuth.viewId());  
  
                    // 가져온 View의 권한 리스트를 돌며 권한을 체크하고 4개 모두 권한이 없을 경우 hasRight는 false로 ACCESS_DINIED Exception을 던짐  
                    for (AuthorizationType authType : userAuthMethodArray) {  
                        switch (authType) {  
                            case Create -> {  
                                if (auth.isCreate()) hasRight = true;  
                            }  
                            case Read -> {  
                                if (auth.isRead()) hasRight = true;  
                            }  
                            case Update -> {  
                                if (auth.isUpdate()) hasRight = true;  
                            }  
                            case Delete -> {  
                                if (auth.isDelete()) hasRight = true;  
                            }  
                            case NoCheck -> hasRight = true;  
                        }  
                    }  
                }  
            }  
  
            if (hasRight) {  
                result = joinPoint.proceed();  
            } else {  
                throw new CommonException(ExceptionCode.ACCESS_DENIED);  
            }  
        } catch (Throwable tr) {  
            throw tr;  
        } finally {  
            // 클래스명, 함수명, 응답 시간 기록  
            String classNameWithPackageName = joinPoint.getTarget().getClass().getCanonicalName();  
            String classNameWithoutPackageName = classNameWithPackageName.substring(classNameWithPackageName.lastIndexOf(".") + 1);  
            log.info("[ Aspect Res ]  - 소요시간 : {} ms, Class : {}, Method : {} , Param Value : {}", (System.currentTimeMillis() - startTime), classNameWithoutPackageName, joinPoint.getSignature().getName(), paramValueStr);  
        }  
        return result;  
    }  
}
```

---
## 📚 API 호출

아래 API를 사용하여 임시로 Developer User Group을 생성 해보았습니다.

Request 시 API Filter를 거쳐 Request Header에 유저의 권한과 JWT 토큰의 Valid 여부를 넣어주고, Aspect를 거쳐 Request가 넘어갑니다.

Aspect에서 검증이 완료되고 나서야 비즈니스 로직이 실행되어 User Group이 DB에 저장되었고,

로그를 확인 해 보면 Aspect가 종료 된 후 응딥시간, 클래스명, 함수명, 파라미터의 값을 로깅합니다.

```java
@PreAuth(viewId = 0, authorization = AuthorizationType.NoCheck)  
@PostMapping  
@Operation(summary = "Create Group", description = "유저 그룹 생성")  
@ApiResponse(responseCode = "201", description = "유저 그룹 정보 반환")  
public ResponseEntity<ApiResponseDto> createGroup(CustomHttpServletRequest request, @RequestBody UserGroupDto.Create dto) {  
    return new ResponseEntity(ApiResponseDto.makeResponse(userGroupService.createGroup(dto)), HttpStatus.CREATED);  
}
```

![](./1.png)