## **💡 API Documentation**  (Spring Restdocs)

Swagger에 비해 Spring RestDocs는 기능 구현과 관련된 코드에 API 문서 생성을 위한,
어노테이션같은 어떠한 정보도 추가되지 않음
클라이언트에서 REST API 기반의 백엔드 어플리케이션의 사용을 위한 정보

<br>

### **API Documentation의 자동화가 필요한 이유**

- 사람의 실수로 인한 업데이트된 정보의 누락
- 수기 작성의 비효율성
- 생산성 향상

<br>

### **Swagger vs Spring Rest Docs**

- Swagger
  - 장점 - API 요청 툴로써 기능 사용 가능 
  - 단점 - Swagger는 기능 구현과 관계없는 많은 어노테이션 사용으로 인한 코드 간결성 저하
- Spring Rest Docs
  - 장점 - 테스트와 구현한 기능에서 정보가 하나라도 일치하지 않으면 테스트 Failed 와 동시에 API 문서 생성 X
          스펙정보 불일치로 인한 문제 발생 방지
  - 단점 - 테스트케이스의 수기 작성, 모든 테스트가 Passed 되어야 함 

<br>

### **Spring Rest Docs 생성 흐름**

- 슬라이스 테스트 작성
- API 스펙 정보 작성
- Task 실행
- API 스니핏(adoc)
- 스니핏들을 포함한 API 문서
- HTML 변환 

<br>

### **@SpringBootTest vs @WebMvcTest**

- @SpringBootTest (@AutoConfigureMockMvc 와 함께 사용)
  - 모든 Bean을 ApplicationContext에 등록하여 사용, 실행 속도 Down
  - 통합 테스트 시 적합
- @WebMvcTest
  - 필요한 Bean만 ApplicationContext에 등록, 실행 속도 Up
  - 테스트 대상이 의존하는 객체가 있으면 Mock을 사용하여 의존성 제거 작업 필요
  - 슬라이스 테스트 시 적합

<br>

###  **Asciidoc 문법**

- =
  - 문서 타이틀, '=' 가 많아질수록 글자 크기 Down
- :sectnums
  - 목차 넘버링
- :toc: direction 
  - 목차 위치 지정
- :toclevels: int
  - 목차 제목의 level 지정 ('='의 개수 지정)
- :toc-title: "title"
  - 목차 타이틀 지정
- :source-highlighter: " "
  - 소스 코드 하이라이터 지정
- ***
  - 구분선 추가
- 한 라인 띄우고 들여쓰기
  - 박스 문단
- 각종 문구
  - NOTE, TIP, WARNING, IMPORTANT, CAUTION 등 사용가능
- image::'link'
  - 이미지 추가
- URL Scheme 자동 인식
  - http, https, ftp, irc, mailto, email형식
- .title
  - 스니핏 섹션 제목 표현
- include::{direction}/{directory}/{file-Name}.adoc}[]
  - 스니핏을 템플릿에 포함할때 사용

<br>

Example

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Restdocs.png) 

------

## **💡 구현**

<br>

### **build.gradle 파일 설정**

```yaml
// ⭐ [Spring Rest Docs]   

 // [플러그인 추가]
id "org.asciidoctor.jvm.convert" version "3.3.2"

 // [스니핏 생성 경로 지정]
ext {
set('snippetsDir', file("build/generated-snippets"))
}

 // [AsciiDoctor에서 사용되는 의존그룹 지정]
configurations {
asciidoctorExtensions
}

 // [Rest Docs 라이브러리]
testImplementation 'org.springframework.restdocs:spring-restdocs-mockmvc'  
asciidoctorExtensions 'org.springframework.restdocs:spring-restdocs-asciidoctor'

 // [:test task 실행 시, 스니핏 디렉토리 경로 지정]
tasks.named('test') {
outputs.dir snippetsDir
useJUnitPlatform()
}

 // [:asciidoctor 실행 시, 기능 사용을 위해 task에 asccidoctorExtensions 설정]

tasks.named('asciidoctor') {
configurations "asciidoctorExtensions"
inputs.dir snippetsDir
dependsOn test
}

 // [:build 실행 전 실행되는 task,  :copyDocument 가 실행 되면 index.html이 static 경로에 copy되며,
    그 파일은 API Docs를 파일로 외부 제공을 위한 용도로 사용 가능]
task copyDocument(type: Copy) {
dependsOn asciidoctor            // [:asciidoctor 실행 후 task 실행되도록 의존 설정]
from file("${asciidoctor.outputDir}")   // [asciidoc 경로에 생성되는 index.html copy]
into file("src/main/resources/static/docs")   // [static 경로로 index.html 추가]
}

build {
dependsOn copyDocument  // [:build 가 실행되기 전, :copyDocument 가 선행되도록 설정]
}

 // [App 실행 파일이 생성하는 :bootJar 설정]
bootJar {
dependsOn copyDocument    // [:bootJar 실행 전, :copyDocument 가 선행되도록 의존설정]
from ("${asciidoctor.outputDir}") {  // [Asciidoctor로 생성되는 index.html을 Jar에 추가]
into 'static/docs'    
}
}
```

<br>

### **프로젝트 내 템플릿 디렉토리 생성**

src/docs/index.adoc 파일 생성

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Restdocs2.png) 

<br>

### **슬라이스 테스트 코드 + api 스펙정보 코드 작성**

```java
    @Test
    public void postTest() throws Exception {

        //i given

        // Request Body 생성
        RequestDto requestDto = new RequestDto("공부하기", 1L, false);
        String content = gson.toJson(requestDto);

        // Response Body 응답
        ResponseDto responseDto = new ResponseDto(1L, "공부하기", 1L, false, "http://localhost:8080/1");

        // Mock 객체를 이용한 Data Stubbing
        given(mapper.requestToTodo(Mockito.any(RequestDto.class))).willReturn(new Todo());
        given(todoService.createTodo(Mockito.any(Todo.class))).willReturn(new Todo());
        given(mapper.todoToResponseDto(Mockito.any(Todo.class))).willReturn(responseDto);

        //i when

        // 핸들러 메소드로 Post Request 전송
        ResultActions actions = mockMvc.perform(post("/")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(content));

        //i then

        // Response에 대한 기대값 검증
        actions.andExpect(status().isCreated())
                .andExpect(jsonPath("$.title").value(requestDto.getTitle()))
                .andExpect(jsonPath("$.order").value(requestDto.getOrder()))
                .andExpect(jsonPath("$.completed").value(requestDto.getCompleted()))
                // ================== API 문서화 ======================
                .andDo(document(
                        "post-todo",  // API 문서 스니핏의 식별자 역할
                        preprocessRequest(prettyPrint()), // request에 해당하는 문서영역 전처리
                        preprocessResponse(prettyPrint()), // response에 해당하는 문서영역 전처리
                        requestFields( // 문서로 표현될 Request Body 데이터 표현
                                List.of(
                                    fieldWithPath("title").type(JsonFieldType.STRING).description("해야 할 일"),
                                    fieldWithPath("order").type(JsonFieldType.NUMBER).description("등록 순서").optional(),
                                    fieldWithPath("completed").type(JsonFieldType.BOOLEAN).description("완료 여부").optional()
                                )
                        ),
                        responseFields( // 문서로 표현될 Response Body 데이터 표현
                                List.of(
                                        fieldWithPath("id").type(JsonFieldType.NUMBER).description("Todo 식별자"),
                                        fieldWithPath("title").type(JsonFieldType.STRING).description("해야 할 일"),
                                        fieldWithPath("order").type(JsonFieldType.NUMBER).description("등록 순서"),
                                        fieldWithPath("completed").type(JsonFieldType.BOOLEAN).description("완료 여부"),
                                        fieldWithPath("url").type(JsonFieldType.STRING).description("url 정보")
                                )
                        )
                ));
    }
```

<br>

### **테스트 케이스 실행 or testTask 실행후 테스트 케이스 성공**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Restdocs3.png)

<br>

### **API 문서 스니핏(.adoc파일) 생성 - 테스트의 실행결과가 passed일 시 생성**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Restdocs4.png) 

<br>

### **API 스니핏 문서들을 이용한 API 문서 생성 (index.adoc)**

```
= Todo 어플리케이션 API 문서화
:sectnums:
:toc: left
:toclevels: 4
:toc-title: Table Of Contents
:source-highlighter: prettify

Shin KunWoo <replicaset01@gmail.com>

2022.12.18

***
== TodoController
=== Todo 등록
.curl-request
include::{snippets}/post-todo/curl-request.adoc[]

.http-request
include::{snippets}/post-todo/http-request.adoc[]

.request-fields
include::{snippets}/post-todo/request-fields.adoc[]

.http-response
include::{snippets}/post-todo/http-response.adoc[]

.response-fields
include::{snippets}/post-todo/response-fields.adoc[]

=== Todo 수정
.curl-request
include::{snippets}/patch-todo/curl-request.adoc[]

.http-request
include::{snippets}/patch-todo/http-request.adoc[]]

.request-fields
include::{snippets}/patch-todo/request-fields.adoc[]

.http-response
include::{snippets}/patch-todo/http-response.adoc[]

.path-parameters
include::{snippets}/patch-todo/path-parameters.adoc[]

.response-fields
include::{snippets}/patch-todo/response-fields.adoc[]

=== Todo 1개 조회
.curl-request
include::{snippets}/get-todo/curl-request.adoc[]

.http-request
include::{snippets}/get-todo/http-request.adoc[]

.http-response
include::{snippets}/get-todo/http-response.adoc[]

.path-parameters
include::{snippets}/get-todo/path-parameters.adoc[]

.response-fields
include::{snippets}/get-todo/response-fields.adoc[]

=== Todo 전체 조회
.curl-request
include::{snippets}/get-todos/curl-request.adoc[]

.http-request
include::{snippets}/get-todos/http-request.adoc[]

.http-response
include::{snippets}/get-todos/http-response.adoc[]

.response-fields
include::{snippets}/get-todos/response-fields.adoc[]

=== Todo 1개 삭제
.curl-request
include::{snippets}/delete-todo/curl-request.adoc[]

.http-request
include::{snippets}/delete-todo/http-request.adoc[]

.http-response
include::{snippets}/delete-todo/http-response.adoc[]

.path-parameters
include::{snippets}/delete-todo/path-parameters.adoc[]

.httpie-request
include::{snippets}/delete-todo/httpie-request.adoc[]

=== Todo 전체 삭제
.curl-request
include::{snippets}/delete-all/curl-request.adoc[]

.http-request
include::{snippets}/delete-all/http-request.adoc[]

.http-response
include::{snippets}/delete-all/http-response.adoc[]

.httpie-request
include::{snippets}/delete-all/httpie-request.adoc[]
```

<br>

### **API 문서를 HTML로 변환 (build task 실행 -> .adoc파일 HTML 변환)**

빌드 성공 시 자동 생성

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Restdocs5.png) 

<br>

### **API 문서 확인**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Spring_Restdocs6.png)