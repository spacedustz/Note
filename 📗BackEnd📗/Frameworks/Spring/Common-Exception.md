**CommonException**

```java

import lombok.Getter;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

public class CommonException extends RuntimeException {

    @Getter
    private HttpStatus status;

    public CommonException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }
}
```

<br>

**CommonExceptionResponse**

```java
public class CommonExceptionResponse {
    private int code;
    private String message;

    public CommonExceptionResponse(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}
```

<br>

**GlobalErrorHandler**

```java
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalErrorHandler {
    private static final Logger log = LogManager.getLogger(GlobalErrorHandler.class);

    @ExceptionHandler(CommonException.class)
    public ResponseEntity<CommonExceptionResponse> commonExceptionHandler(CommonException e) {
        CommonExceptionResponse error = new CommonExceptionResponse(e.getStatus().value(), e.getMessage() != null ? e.getMessage() : "나도 몰라요");
        return ResponseEntity.status(e.getStatus()).body(error);
    }
}
```