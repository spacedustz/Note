## **💡 Test**

JUnit은 표준 테스트 프레임워크이다

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Testing.png)

- 기능 테스트
  - 테스트의 범위 중 제일 큰 테스트, 어플리케이션 전체에 걸친 테스트
- 통합 테스트
  - 테스트 주체가 어플리케이션 제작 개발팀 or 개발자 단위 테스트, 클라이언트 툴 없음
- 슬라이스 테스트
  - 어플리케이션을 특정 계층으로 나눠서 테스트
- 단위 테스트
  - 어플리케이션의 핵심 비즈니스 로직 메소드의 독립적인 테스트

<br>

### **단위 테스트의 F.I.R.S.T 원칙**

- Fast
- Independent
- Repeatable
- Self-validating
- Timely

<br>

### **given - when - then Pattern**

- given
  - 테스트에 필요한 전제조건 포함
- when
  - 테스트 동작 지정
- then
  - 테스트 결과 검증, 값 비교 (Assertion)

<br>

### **Hamcrest를 사용한 Assertion**

- Assertion을 위한 Matcher를 자연스러운 문장으로 이어지도록 하며, 가독성 향상
- 테스트 실패 시 손쉬운 원인 파악 가능, 다양한 Matcher 제공

<br>

### **Controller Test**

- MockMvc, Gson @Autowired 주입
- 테스트 대상 핸들러 메소드 호출 throws Exception
- Dto 호출, 객체 생성, 데이터 삽입
- gson.toJson() 데이터 변환
- ResultAction 타입의 mockMvc.preform을 이용한 컨트롤러 정보 입력
  post(), accept(), contentType(), content()를 이용해 requestbody 설정
- MvcResult 타입의 actions.andExcept("$.data.멤버"), .andRetuen()을 이용해 데이터 검증

<br>

### **Data Test**

- @DataJpaTest
- Repo Autowired
- Entity 객체 생성 -> 데이터 set
- save
- Assertion

------

## **💡 구현**

<br>

### **Packages**

- import static org.assertj.core.api.Assertions.*; [assertj]
- import static org.junit.jupiter.api.Assertions.*; [junit]
- import static org.junit.jupiter.api.Assumptions.*; [Assumptions]
- import static org.hamcrest.MatcherAssert.*; [Hamcrest]
- import static org.hamcrest.Matchers.*; [Hamcrest Matcher]
- import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*; [Controller 테스트]
- import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*; [Controller 테스트]
- import org.mockito.Mockito; [Mockito]
- import static org.mockito.BDDMockito.given; [Mockito_given]

<br>

### **Class, Method**

- Junit
  - assertEquals(a,b) - *값비교*
  - assertNotNull(대상, 실패시 메시지) - *Null 여부 체크*
  - assertThrows(Exception.class, () -> 테스트대상 메소드) - *예외 발생 테스트*assertDoesNotThrow(() -> Do) - *예외 발생 X 테스트*

<br>

- AsserJ

<br>

- Assumption
  - assumeTrue() - 파라미터의 값이 true이면, 아래 로직 실행

<br>

- Hamcrest
  - asserThat(a, is(equalTo(b))) - 비교
  - asserThat(a, is(notNullValue())) - Null 검증
  - asserThat(대상.class, is(예상Exception.class)) - 예외 검증

<br>

- URI
  - UriComponentBuilder.newInstance().path().buildAndExpand().toUri - Build Request URI

<br>

- ResultActions - 기대 HTTP Status, Content 검증
  - mockMvc.perform(get & post 등등)

<br>

- MvcResult - Response Body의 HTTP Status, 프로퍼티 검증
  - ResultActions의 객체를 이용 

<br>

### **Annotations**

@BeforeEach - *init()* 사용, 테스트 실행 전 전처리
@BeforeAll - *initAll()* 사용, 테스트 케이스가 실행되기전 1번만 실행
@DisplayName - 테스트의 이름 지정
@SpringBootTest - Spring Boot 기반 Application Context 생성
@AutoConfigureMockMvc - Controller를 위한 앱의 자동 구성 작업, MockMvc를 이용하려면 필수로 추가해야함
@DataJpaTest - @Transactional을 포함하고 있어서, 하나의 테스트케이스 종료시 저장된 데이터 RollBack
@MockBean - Application Context에 있던 Bean을 Mockito Mock 객체를 생성 & 주입
@ExtendWith - Spring을 사용하지않고 Junit에서 Mockito의 기능을 사용하기 위해 추가
@Mock - 해당 필드의 객체를 Mock 객체로 생성
@InjectMocks - @InjectMocks를 설정한 필드에 @Mock으로 생성한 객체를 주입

------

### **Controller Test**

```java
package com.solo.soloProject.test;

import com.google.gson.Gson;
import com.jayway.jsonpath.JsonPath;
import com.solo.soloProject.todo.entity.Todo;
import com.solo.soloProject.todo.repository.TodoRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.List;

import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.startsWith;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class ControllerTest {

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private Gson gson;
    @Autowired
    private TodoRepository todoRepository;


    /* Post Todo Test */

    @Test
    void postTodoTest() throws Exception {

        //i given RequestBody -> Json 변환
        TodoDto.Post post = new TodoDto.Post("abc",1, false);

        String content = gson.toJson(post);

        /* i when
         * Controller의 핸들러 메소드에 요청을 전송하기 위해서 perform()를 호출해야 하며,
         * perform() 내부에 Controller 호출을 위한 세부 정보 포함
         *
         * MockMvcRequestBuilders 클래스를 이용해 빌더패턴으로 HTTP Request 정보 입력 = perform
         * post() = HTTP Method + Request URL 설정
         * accpet() = 클라이언트에서 응답 받을 데이터 타입 설정
         * contentType() = 서버에서 처리 가능한 데이터 타입 지정
         * content() = Request Body 데이터 지정
         */

        ResultActions actions = mockMvc.perform(
                post("/v1/todos")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(content));

        /* i then
         * when의 perform()은 ResultActions 타입의 객체를 리턴
         * 이 ResultActions 객체를 이용해 테스트로 전송한 Request에 대한 검증 수행
         * 첫 andExpect()에서 Matcher를 이용해 예상되는 기대 값 검증
         * status().isCreated() = Response Status가 201인지 검증
         *
         * header().string("", is(startsWith("URI")))에 대한 설명
         * HTTP Header에 추가된 Localtion의 문자열 값이 "/v1/todos"로 시작하는지 검증
         */
        actions.andExpect(status().isCreated())
                .andExpect(header().string("Location", is(startsWith("/v1/todos"))));
    }

    /* Patch Todo Test */

    @Test
    void patchMemberTest() throws Exception {

        Todo member = new Todo("abc", 1, false);
        Todo savedTodo = todoRepository.save(member);
        long todoId = savedTodo.getTodoId();

        TodoDto.Patch patch = new TodoDto.Patch(1, "aaa", 2, true);

        String patchContent = gson.toJson(patch);

        URI patchUri = UriComponentsBuilder.newInstance().path("/v1/todos/{todo-id}").buildAndExpand(todoId).toUri();

        ResultActions actions = mockMvc.perform(patch(patchUri)
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(patchContent));

        actions.andExpect(status().isOk())
                .andExpect(jsonPath("$.data.title").value(patch.getTitle()))
                .andExpect(jsonPath("$.data.order").value(patch.getOrder()))
                .andExpect(jsonPath("$.data.completed").value(patch.isCompleted()));
    }

    /* Get Todo Test */

    @Test
    void getMemberTest() throws Exception {

        TodoDto.Post post = new TodoDto.Post("abc", 1, false);
        String postContent = gson.toJson(post);

        ResultActions postActions = mockMvc.perform(post("/v1/todos")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(postContent));

        long memberId;

        //i postMember()의 response에 전달되는 Location Header를 가져옴 = "/v1/todos/1
        String location = postActions.andReturn().getResponse().getHeader("Location");

        //i 위에서 얻은 Location Header 값 중 memberId에 해당하는 부분만 추출
        memberId = Long.parseLong(location.substring(location.lastIndexOf("/")+1));

        //i Build Request URI
        URI getUri = UriComponentsBuilder.newInstance().path("/v11/members/{member-id}").buildAndExpand(memberId).toUri();

        mockMvc.perform(
                //i 기대 HTTP Status가 200 인지 검증
                get(getUri).accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                //i Response Body의 프로퍼티가 응답으로 받은 프로퍼티의 값과 일지하는지 검증
                .andExpect(jsonPath("$.data.title").value(post.getTitle()))
                .andExpect(jsonPath("$.data.order").value(post.getOrder()));
    }

    /* Get Todos Test */
    @Test
    @DisplayName("Get Todos Test")
    public void getTodosTest() throws Exception {
        Todo todo1 = new Todo("abc", 1, false);
        Todo todo2 = new Todo("aaa", 2, false);
        Todo save1 = todoRepository.save(todo1);
        Todo save2 = todoRepository.save(todo2);

        long todoId1 = save1.getTodoId();
        long todoId2 = save2.getTodoId();

        String page = "1";
        String size = "5";
        MultiValueMap<String, String> queryparams = new LinkedMultiValueMap<>();
        queryparams.add("page", page);
        queryparams.add("size", size);

        URI getUri = UriComponentsBuilder.newInstance().path("/v1/todos").build().toUri();

        ResultActions actions = mockMvc.perform(get(getUri)
                .params(queryparams)
                .accept(MediaType.APPLICATION_JSON));

        MvcResult result = actions.andExpect(status().isOk())
                .andExpect(jsonPath("$.data").isArray())
                .andReturn();

        List list = JsonPath.parse(result.getResponse().getContentAsString()).read("$.data");

        assertThat(list.size(), is(2));
    }

    /* Delete Todo Test */

    @Test
    @DisplayName("Delete Todo Test")
    public void deleteTodoTest() throws Exception {
        Todo todo1 = new Todo("abc",1,false);

        Todo saveTodo = todoRepository.save(todo1);

        long todoId = saveTodo.getTodoId();

        URI uri = UriComponentsBuilder.newInstance().path("/v1/todos/{todo-id}").buildAndExpand(todoId).toUri();

        mockMvc.perform(delete(uri))
                .andExpect(status().isNoContent());
    }
}
```

------

### **Mockito Test**

```java
package com.solo.soloProject.test;

import com.google.gson.Gson;
import com.solo.soloProject.todo.entity.Todo;
import com.solo.soloProject.todo.mapper.TodoMapper;
import com.solo.soloProject.todo.service.TodoService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;

import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.startsWith;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class MockitoTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private Gson gson;

    @MockBean
    private TodoService todoService;

    @Autowired
    private TodoMapper mapper;


    /* Use Mockito Post Todo Test */

    @Test
    @DisplayName("Mockito를 이용한 Post Todo Test")
    public void mockPostTest() throws Exception {

        TodoDto.Post post = new TodoDto.Post("abc", 1, false);

        Todo todo = mapper.TodoPostToTodo(post);
        todo.setTodoId(1L);

        given(todoService.createTodo(Mockito.any(Todo.class))).willReturn(todo);

        String content = gson.toJson(post);

        ResultActions actions = mockMvc.perform(post("/v1/todos")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(content));

        actions.andExpect(status().isCreated())
                .andExpect(header().string("Location", is(startsWith("/v1/todos"))));
    }
}
```