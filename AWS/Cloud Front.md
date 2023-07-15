## 💡 CloudFront

-   Edge Location의 주변 Orogin Server의 컨텐츠를 Edge Location에 캐싱하고,
-   각 Edge Location간 공유를 통해 컨텐츠 전달
-   각 Edge Location간 백본 네트워크를 통한 매우 빠른 속도의 캐시 전달 가능
-   외부 서버의 캐싱 가능(Custom Origin)
-   TTL을 조절하여 캐시 주기 통제 가능

<br>

### 컨텐츠 제공 방법

- 사용자의 웹사이트 or 액세스 하고있는 이미지 or HTML 요청 (정적 데이터)
- DNS가 최적의 요청 처리를 할 수 있는 CloudFront Edge Location으로 요청 라우팅
- Edge Location에서 해당 캐시에 요청된 파일이 있는지 확인하고, 없으면 오리진 서버에 요청후 전달 & 캐시적재

<br>

### OAI (Origin Access Identity)
- S3를 오리진 서버로 사용 시, CloudFront를 제외하고 다른 경로의 S3접근을 막는 방법
- OAI 설정시 각각의 Distribution이 별도의 Identity를 갖게 되고, S3의 버킷 정책을 수동 & 자동으로 수정 가능

<br>

### Presigned URL
- 인증된 사용자만이 해당 Distribution을 사용할 수 있도록 제어하는 기능
- 만료 날짜 & 시간까지 설정 가능
- CloudFront 설정 시 Presigned URL 사용과 CloudFront Key Pair를 계정의 보안자격증명에서 생성해야함
- 이를 조합해 URL 서명 생성 & 해당 URL을 통한 CloudFront 접근 가능