## 📚 Global Exception Handling

**Base Error Code**\

```java
public interface BaseErrorCode {  
    HttpStatus getHttpStatus();  
    String getCode();  
    String getMsg();  
    void setMsg(String msg);  
}
```

<br>

**ExceptionCode**

```java
@Getter  
@AllArgsConstructor  
public enum ExceptionCode implements BaseErrorCode {  
        SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "-1", "서버 에러"),  
        INVALID_PARAMETER(HttpStatus.BAD_REQUEST, "-2", "유효하지 않은 파라미터"),  
        ACCESS_DENIED(HttpStatus.FORBIDDEN, "-3", "권한 에러, 유저의 권한이 부족합니다."),  
        CONNECTION_FAILURE(HttpStatus.BAD_REQUEST, "-4", "통신 에러, 연결을 확인 해주세요."),  
        DATABASE_EXCEPTION(HttpStatus.BAD_REQUEST, "-5", "SQL 에러, 데이터 저장에 실패 하였습니다."),  
        ;  
  
        private final HttpStatus httpStatus;  
        private final String code;  
        private String msg;  
  
        @Override  
        public void setMsg(String msg) {  
            this.msg = msg;  
        }  
}
```

<br>

**CommonException**

```java
@Getter  
public final class CommonException extends RuntimeException {  
    private BaseErrorCode errorCode;  
    private String originalMessage;  
  
    public CommonException(BaseErrorCode errorCode) {  
        super(errorCode.getMsg());  
        this.errorCode = errorCode;  
        this.originalMessage = errorCode.getMsg();  
    }  
  
    public CommonException(BaseErrorCode errorCode, String message) {  
        super(message);  
        this.errorCode = errorCode;  
        this.originalMessage = message;  
    }  
}
```

<br>

**CommonDto**

```java
public class CommonDto {  
    @Data  
    public static class ErrorResponse {  
        private String field;  
        private String desc;  
    }  
}
```

<br>

**Global Exception Handler**

```java
@Slf4j  
@RestControllerAdvice  
public class GlobalExceptionHandler {  
    @ExceptionHandler(MethodArgumentNotValidException.class)  
    public ResponseEntity handleValidationExceptions(MethodArgumentNotValidException ex, HttpServletRequest request) {  
        log.warn("MethodArgumentNotValidException 발생. url:{}", request.getRequestURI());  
        BindingResult result = ex.getBindingResult();  
        ExceptionCode exceptionCode = ExceptionCode.INVALID_PARAMETER;  
  
        ApiResponseDto apiResponseDto = new ApiResponseDto();  
  
        if(result.hasErrors()) {  
            List<CommonDto.ErrorResponse> errorResponseList = new ArrayList<>();  
  
            result.getFieldErrors().stream().forEach(p->{  
                        CommonDto.ErrorResponse errorResponse = new CommonDto.ErrorResponse();  
  
                        errorResponse.setField(p.getField());  
                        errorResponse.setDesc(p.getDefaultMessage());  
  
                        errorResponseList.add(errorResponse);  
                    }  
            );  
  
            apiResponseDto.setCode(exceptionCode.getCode());  
            apiResponseDto.setMsg(exceptionCode.getMsg());  
            apiResponseDto.setData(errorResponseList);  
        }  
  
        return new ResponseEntity(apiResponseDto, exceptionCode.getHttpStatus());  
    }  
  
    /**  
     * @requestParam required=true -> 일반 데이터 타입  
     * @param ex  
     * @param request  
     * @return  
     */  
    @ExceptionHandler(MissingServletRequestParameterException.class)  
    public ResponseEntity handleMissingParamsExceptions(MissingServletRequestParameterException ex, HttpServletRequest request) {  
        log.warn("MissingServletRequestParameterException 발생. url:{}", request.getRequestURI());  
        String parameterName = ex.getParameterName();  
        ExceptionCode exceptionCode = ExceptionCode.INVALID_PARAMETER;  
  
        ApiResponseDto apiResponseDto = new ApiResponseDto();  
  
        if(!parameterName.isEmpty()) {  
            CommonDto.ErrorResponse errorResponse = new CommonDto.ErrorResponse();  
            errorResponse.setField(parameterName);  
            errorResponse.setDesc(parameterName + "값을 입력해주세요.");  
  
            apiResponseDto.setCode(exceptionCode.getCode());  
            apiResponseDto.setMsg(exceptionCode.getMsg());  
            apiResponseDto.setData(errorResponse);  
        }  
  
        return new ResponseEntity(apiResponseDto, exceptionCode.getHttpStatus());  
    }  
  
    /**  
     * @requestParam required=true -> File  
     * @param ex  
     * @param request  
     * @return  
     */  
    @ExceptionHandler(MissingServletRequestPartException.class)  
    public ResponseEntity handleMissingPartExceptions(MissingServletRequestPartException ex, HttpServletRequest request) {  
        log.warn("MissingServletRequestPartException 발생. url:{}", request.getRequestURI());  
        String parameterName = ex.getRequestPartName();  
        ExceptionCode exceptionCode = ExceptionCode.INVALID_PARAMETER;  
  
        ApiResponseDto apiResponseDto = new ApiResponseDto();  
  
        if(!parameterName.isEmpty()) {  
            CommonDto.ErrorResponse errorResponse = new CommonDto.ErrorResponse();  
            errorResponse.setField(parameterName);  
            errorResponse.setDesc(parameterName + "을 첨부해주세요.");  
  
            apiResponseDto.setCode(exceptionCode.getCode());  
            apiResponseDto.setMsg(exceptionCode.getMsg());  
            apiResponseDto.setData(errorResponse);  
        }  
  
        return new ResponseEntity(apiResponseDto, exceptionCode.getHttpStatus());  
    }  
  
    /**  
     * @author 신건우  
     * @desc Uncatched Common Exception Handler  
     */    @ExceptionHandler(CommonException.class)  
    public ResponseEntity<ApiResponseDto> handleCommonException(CommonException ex) {  
        ExceptionCode exceptionCode = (ExceptionCode) ex.getErrorCode();  
        HttpStatus status = ex.getErrorCode().getHttpStatus();  
  
  
        ApiResponseDto apiResponseDto = new ApiResponseDto();  
        apiResponseDto.setCode(exceptionCode.getCode());  
        apiResponseDto.setMsg(exceptionCode.getMsg());  
        apiResponseDto.setData(ex.getOriginalMessage());  
  
        return new ResponseEntity(apiResponseDto, status);  
    }  
}
```

<br>

**API Response DTO**

```java
@Data  
@Slf4j  
@NoArgsConstructor  
@AllArgsConstructor  
@Schema(title = "[ Global ] API Response", description = "전역 API Response")  
public class ApiResponseDto<T> implements Serializable {  
  
    @Schema(description = "응답 코드", example = "0")  
    private String code;  
  
    @Schema(description = "응답 메시지", example = "success")  
    private String msg;  
  
    @Schema(description = "응답 데이터")  
    private T data;  
  
    public static String makeSuccessResponse() {  
        ObjectMapper objectMapper = new ObjectMapper();  
  
        Map<String, Object> response = new LinkedHashMap<String, Object>();  
  
        String result = "";  
  
        response.put("code", ApiContants.RESPONSE_SUCCESS_CODE);  
        response.put("msg", ApiContants.RESPONSE_SUCCESS_MSG);  
  
        try {  
            result = objectMapper.writeValueAsString(response);  
        } catch (Exception e) {  
  
        }  
  
        return result;  
    }  
  
    public static String makeFailResponse() {  
        ObjectMapper objectMapper = new ObjectMapper();  
  
        Map<String, Object> response = new LinkedHashMap<String, Object>();  
  
        String result = "";  
  
        response.put("code", ApiContants.RESPONSE_FAILURE_CODE);  
        response.put("msg", ApiContants.RESPONSE_FAILURE_MSG);  
  
        try {  
            result = objectMapper.writeValueAsString(response);  
        } catch (Exception e) {  
  
        }  
  
        return result;  
    }  
  
    public static String makeCustomFailResponse(String msg) {  
        ObjectMapper objectMapper = new ObjectMapper();  
  
        Map<String, Object> response = new LinkedHashMap<String, Object>();  
  
        String result = "";  
  
        response.put("code", ApiContants.RESPONSE_FAILURE_CODE);  
        response.put("msg", msg);  
  
        try {  
            result = objectMapper.writeValueAsString(response);  
        } catch (Exception e) {  
  
        }  
  
        return result;  
    }  
  
    public static String makeResponse(Object data) {  
        ObjectMapper objectMapper = new ObjectMapper();  
        Map<String, Object> response = new LinkedHashMap<String, Object>();  
        String result = "";  
  
        response.put("code", ApiContants.RESPONSE_SUCCESS_CODE);  
        response.put("msg", ApiContants.RESPONSE_SUCCESS_MSG);  
        response.put("data", data);  
  
        try {  
            result = objectMapper.writeValueAsString(response);  
        } catch (Exception e) {  
            log.error("[makeResponse] {}", e.getMessage());  
        }  
  
        return result;  
    }  
  
    /**  
     * CommonErrorCode 해당하는 결과 객체 생성  
     *  
     * @param commonException  
     * @return  
     */  
    public static String makeResponse(CommonException commonException)  
    {  
        ObjectMapper objectMapper = new ObjectMapper();  
        Map<String, Object> response = new LinkedHashMap<String, Object>();  
        String result = "";  
  
        response.put("code", commonException.getErrorCode().getCode());  
        response.put("msg", commonException.getErrorCode().getMsg());  
  
        try {  
            result = objectMapper.writeValueAsString(response);  
        } catch (Exception e) {  
  
        }  
  
        return result;  
    }  
}
```