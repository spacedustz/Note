## **💡 Route 53**

-   도메인 등록, DNS 라우팅, Health Check의 3가지 담당 & 도메인 등록 시, 12000원 정도 들고 최대 3일 정도 걸림
-   도메인을 AWS 내 서비스뿐만 아니라 외부 서비스와도 연결 가능
-   도메인 생성 후, 레코드 세트를 생성하여 하위 도메인 등록 가능
-   레코드 세트 등록 시, IP, Domain, Alias 등을 지정하여 쿼리 라우팅 가능

<br>

### Route 53의 라우팅 정책
-   Simple
    -   동일 레코드 내에 다수의 IP를 지정하여 라우팅 가능, 값을 다수 지정한 경우 무작위로 반환
-   Weighted
    -   리전 별 부하분산 가능, 각 가중치를 가진 동일이름의 A 레코드를 만들어 IP를 다르게 줌
-   Latency-based
    -   지연시간이 가정 적은, 즉 응답시간이 가장 빠른 리전으로 쿼리 요청
-   FaliOver
    -   A/S 설정에서 사용됨, Main과 DR로 나누어 Main 장애 시, DR로 쿼리
-   Geo-Proximity
    -   Traffuc Flow를 이용한 사용자 정의 DNS 쿼리 생성 가능
-   Multi-Value Answer
    -   다수의 IP를 지정한다는 것은 Simple과 비슷하지만, Health Check가 가능(실패 시, Auto Failover)

<br>

### Alias (별칭)

-   AWS만의 기능으로 고유한 확장명 제공
-   AWS의 리소스는 도메인으로 이루어져 있고, 이 도메인을 쿼리 대상으로 지정할 수 있도록 하는 기능
-   Route 53에서 별칭 레도드의 DNS쿼리를 받으면 다음 리소스로 응답 (즉, 다음 리소스로 Alias 지정 가능)
    -   CloudFront Distribution
    -   Elastic LoadBalancer
    -   Web Site Hosting이 가능한 S3 Bucket
    -   Elastic Beanstalk
    -   VPC Interface EndPoint
    -   동일한 호스팅 영역의 다른 Route 53 레코드