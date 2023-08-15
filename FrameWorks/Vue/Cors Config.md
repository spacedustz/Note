## Vue 로컬 테스트 시 Cors Proxy 우회

Vue를 사용한 프론트엔드 서버에서 백엔드 서버의 Parsing된 Json 데이터를 받아오는 연습을 하던 도중 CORS 에러를 만났습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/cors.png)

<br>

코드는 이렇게 작성했습니다.

복잡하게 테스트할 필요 없이 단순히 v-for를 이용해 들어오는 데이터를 Reactive 변수에 넣어 Loop를 돌리고,

컴포넌트가 마운트 될 때 데이터를 출력하게만 해두었습니다.

```js
<template>  
  <div>  
    <h1>데이터 가져오기 연습</h1>  
    <ul>  
      <li v-for="item in items" :key="item.id">  
        <h3>Event ID: {{ item.id }}</h3>  
        <p>Frame ID: {{ item.frameId }}</p>  
  
        <div v-if="item.extra">  
          <h4>Extra Information</h4>  
          <p>Bbox Height : {{ item.extra.bbox.height }}</p>  
          <p>Bbox Width : {{ item.extra.bbox.width }}</p>  
  
          <h4>Vertices</h4>  
          <ul>  
            <li v-for="vertex in item.extra.vertices" :key="vertex.id">  
              Vertex ID: {{ vertex.id }}  
              <p>X: {{ vertex.x }}</p>  
              <p>Y: {{ vertex.y }}</p>  
            </li>  
          </ul>  
        </div>  
      </li>  
    </ul>  
  </div>  
</template>  
  
<script>  
export default {  
  name: "RequestBackend"  
}  
</script>  
  
<script setup>  
import { ref, onMounted } from 'vue';  
import axios from 'axios';  
  
// 데이터를 저장할 리액티브 변수 생성  
const items = ref([]);  
  
// 데이터 가져오는 함수  
const fetchData = async () => {  
  try {  
    const response = await axios.get('http://localhost:8081/api/json', { withCredentials: true });  
    items.value = response.data; // 데이터를 리액티브 변수에 저장  
    console.log(response.data);  
  } catch (error) {  
    console.error('데이터를 가져오는 동안 오류 발생:', error);  
  }  
};  
  
// 컴포넌트가 마운트되면 데이터 가져오기 함수 실행  
onMounted(() => {  
  fetchData();  
});  
</script>
```

<br>

백엔드만 할땐 몰랐었는데 프론트엔드를 하다가 만나니 또 새로운 기분입니다.

이 CORS 에러를 해결하는 방법은 2가지가 있습니다.

<br>

### Backend에서 CORS 설정하기

간단하게 백엔드에서 WebMvcConfigurer를 이용하면 CORS 에러를 가볍게 지나칠 수 있습니다.

로컬 테스트니까 Spring Security를 적용할 필요도 없이 그냥 간단하게만 사용했습니다.

```java
@Configuration  
@EnableWebMvc  
public class CorsConfig implements WebMvcConfigurer {  
  
    @Override  
    public void addCorsMappings(CorsRegistry registry) {  
        registry.addMapping("/api/**")  
                .allowedOrigins("http://localhost:8080") // 허용할 origin (프론트엔드 주소)  
                .allowedMethods("GET", "POST", "PUT", "DELETE") // 허용할 HTTP 메서드  
                .allowedHeaders("*") // 허용할 헤더  
                .allowCredentials(true); // Credentials (쿠키 등) 허용 여부  
    }  
}
```

<br>

### Axios Proxy 우회

프론트엔드 서버에서 vue.config.js 파일에 해당 코드를 적어줍니다.

<br>

- `proxy` 객체: 이 객체는 개발 서버의 프록시 설정을 정의합니다. 프록시는 클라이언트(브라우저)가 개발 서버로 요청을 보낼 때, 개발 서버가 이 요청을 받아 백엔드 서버로 전달하는 역할을 합니다.
    
- `'/api'`: 이는 프록시를 사용하여 요청을 중개할 경로를 지정합니다. 예를 들어, 클라이언트가 `/api/some-endpoint`로 요청을 보내면 개발 서버는 이를 백엔드 서버의 `/some-endpoint`로 전달합니다.
    
- `target`: 요청을 중개할 목적지(백엔드 서버)의 주소를 설정합니다. 여기서는 `http://localhost:8081`로 설정되었습니다. 클라이언트가 `/api` 경로로 요청을 보내면, 개발 서버는 해당 요청을 백엔드 서버로 프록시하여 전달합니다.
    
- `changeOrigin`: 이 옵션은 목적지 서버로 요청을 보낼 때 원본(origin)을 변경할 지 여부를 설정합니다. 보통 `true`로 설정하여 원본을 변경합니다.
    
- `pathRewrite`: 이 옵션은 요청 경로를 수정하는 역할을 합니다. 여기서는 `^/api`를 빈 문자열(`''`)로 바꿔서 요청 URL에서 `/api` 부분을 제거합니다. 따라서 클라이언트가 `/api/some-endpoint`로 요청하면, 개발 서버는 백엔드 서버에 `/some-endpoint`로 요청을 전달합니다.

```javascript
module.exports = { 
	devServer: { 
		proxy: { 
			'http://localhost:8081': { // 백엔드 서버 주소 
				target: 'http://localhost:8081', // 백엔드 서버 주소 (여기서는 동일한 주소) 
				changeOrigin: true, 
				pathRewrite: { 
					'^/api': '/api', // 요청 URL에서 '/api'를 '/api'로 변경합니다. 
				}, 
			}, 
		}, 
	}, 
};
```

<br>

### 해결

2가지 방법 모두 시도해봤는데 프론트에서 백엔드의 Rest API를 통해,

Reactive 변수인 Items에 Json 객체를 Looping해서 총 3개의 결과값을 잘 받아오고 있습니다.

받아온 데이터가 각각의 Template에서 v-for, v-if를 통해 출력됩니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img2/cors2.png)