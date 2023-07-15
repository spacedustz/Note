## **💡 ELB 생성**

<br>

### **EC2 - Application LoadBalancer 생성**

Listener에 80,443 추가

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd41.png)

<br>

아래 나온 리전들 전부 선택

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd42.png)

<br>

Request new ACM Cetificate

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd43.png) 

<br>

도메인이름, DNS 검증 체크

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cicd44.png)

<br>

도메인 요청 후, Route 53에서 Record 요청
인증서 발급 완료 후 LoadBalancer에 적용
Default VPC 사용X, Custom VPC 생성
로드밸런스 그룹 이름 지정
고급 상태 검사 설정 - Success Code(201) 설정
인스턴스 지정
생성 완료
로드밸런서가 적용된 도메인으로 접속 테스트

------

## **💡 호스팅 영역에 Alias Record 생성**  

- Route53 콘솔 이동
- DNS 관리 - 호스팅 영역
- 레코드 생성 - 별칭 ON (Application/Classic LoadBalancer)
- 리전 지정
- 로드밸런서 지정
- 생성 완료

<br>

### **도메인 구입 & TLS 적용**

- [AWS - S3, CloudFront, Route53을 이용한 정적 호스팅](https://velog.io/@seongkyun/AWS-S3-CloudFront-Route53을-이용한-정적-호스팅)
- [Configuring a static website using a custom domain registered with Route 53 - Amazon Simple Storage Service](https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-custom-domain-walkthrough.html)