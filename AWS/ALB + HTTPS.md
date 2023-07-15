## 1. AWS ELB(Elastic Load Balancing)란?

- 가용영역에 있는 대상으로 들어오는 트래픽을 자동으로 분산시켜주는 서비스이다.
    
- OSI 계층 별로 제공하는 여러 서비스가 있다.
    
    - **Classic Load Balancer (**4.7 계층에서 동작)
        
        - 보통 EC2-classic을 사용할 때 사용
    - **Gateway Load Balancer** (3계층의 게이트웨이 로드밸런싱 + 4계층 로드 밸런싱)
        
        - 먼가 애매함, 리스너는 IP 리스너만 지원함, 게이트웨이는 3계층 장비임
    - **Network Load Balancer** (4계층에서 동작)
        
    - **Application Load Balancer** (7계층에서 동작)
        
        - 더 높은 계층에서의 로드밸런서가 더 많은 기능들을 제공

### 1-1. 왜 각 계층별로 제공하는 로드밸런서가 존재할까?

- 각 계층별로 확인할 수 있는 정보가 다르기 때문이다.
    
    - 3~4계층에서 동작하는 Gateway Load Balancer는 MAC주소, IP주소를 기반으로 로드밸런싱을 할 수 있다.
        
    - 4계층에서 동작하는 Network Load Balancer는 MAC주소, IP주소, port번호를 기반으로 로드밸런싱 할 수 있다.
        
    - 7계층에서 동작하는 Application Load Balancer는 MAC주소, IP주소, port번호, URL을 기반으로 로드밸런싱 할 수 있다. 또한 HTTP 헤더 정보를 통해서도 분산이 가능하다.
        
- 이처럼 높은 계층에서의 로드밸런서가 좀 더 많은 정보를 기반으로 세부적으로 로드밸런싱 할 수 있다.
    
- 이외에도 여러가지 이유가 있는데 이는 문서를 확인하자.
    

### 1-2. AWS ALB(Application Load Balancer)란?

- AWS Elastic Load Balancing이라는 서비스가 있고, 이 서비스에서 지원하는 로드밸런서 중 하나가 Application Load Balancer 이다.
    
- Application Load Balancer는 7계층에서 동작하며 트래픽을 분산시켜주는 역할을 수행하는 로드밸런서다.
    
- 등록된 대상의 상태를 모니터링하면서, 문제 없는 대상으로만 트래픽을 라우팅한다.
    
- 라우팅 할 때는 기본적으로 라운드 로빈 알고리즘을 사용한다. 자세한건 아래에서 살펴보자.
    

### 1-3. AWS ELB, ALB 구조

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb1.png)

- ALB를 구성할 때 가용 영역을 선택한다. 선택한 가용 영역에 ELB가 ALB의 노드를 생성한다. 즉 각 가용 영역당 하나의 ALB 노드가 존재한다.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb2-1.png)

- 위 그림처럼 각 가용 영역마다 ALB 노드가 트래픽을 분산하게 되면, 각 인스턴스마다 받는 트래픽이 달라지는 문제점이 있다.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb2.png)

- 위 문제를 해결하기 위한 기능이 교차 영역 로드밸런싱(Cross Zone Load Balancing)이다.
    
- AZ를 구분하지 않고 트래픽을 분산시킨다.
    
- ALB 경우 기본적으로 활성화 되어 있으며, NLB는 기본적으로 비활성화 되어있다.
    

### 1-4. ALB 내부 간단한 그림

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb3.png)

#### 1-4-1. Load balancer

- 클라이언트에 대한 단일 진입점 역할을 수행한다.
    
- 클라이언트는 로드밸런서에 요청을 전송하고, 로드밸런서는 EC2 인스턴스 같은 대상으로 요청을 라우팅한다.
    
- 로드 밸런서를 구성하기 위해서는 Target group과 Listener가 필요하다.
    

#### 1-4-2. Listener

- Listener는 구성한 프로토콜 및 포트를 사용하여 연결 요청을 확인하는 프로세스다.
    
- 리스너에 정의한 규칙에 따라 로드밸런서가 EC2 같은 대상으로 요청을 라우팅한다.
    
    - 정의할 수 있는 규칙은 예로 아래와 같은 것들이 있다.
        
        - 특정 URL로 인입된 요청을 다른 URL로 리다이렉트
            
        - http로 들어온 요청을 https로 리다이렉트
            
        - 각 Target group별로 요청을 분산시킬 퍼센트 지정
            
- 7계층에서 동작하는 ALB는 HTTP, HTTPS 프로토콜을 지원한다.
    
    - HTTPS 프로토콜을 사용하는 경우 Listener에 SSL 서버 인증서를 배포해야 한다.

#### 1-4-3. Target group

- Listener 규칙을 생성할 때, Target group을 지정한다. 해당 규칙이 충족되면 지정한 Target group으로 트래픽이 전달된다.
    
- Load balancer는 Target group 단위로 상태를 확인한다. (health check)
    
    - 정상 상태인 Target group으로만 요청을 라우팅한다.

### 1-5. ELB 요청 처리 과정

- 전체적인 요청 처리 과정을 살펴보자.

1. 클라이언트가 도메인 주소를 통해 요청한다.
    
2. Amazon의 DNS 서버에 요청해서 도메인 주소를 통해 ELB의 Network Interface(ALB Node)의 IP 리스트를 클라이언트에게 전달한다.
    
3. 클라이언트는 IP중 하나를 선택한다.
    
4. 선택한 IP의 ALB 노드가 요청을 받고, 리스너에게 전달한다.
    
5. 리스너는 규칙에 맞는 Target group으로 트래픽을 전달한다.
    
6. Target group은 라운드로빈 알고리즘을 통해 특정 EC2에 트래픽을 전달하여 요청을 처리한다.
    

> 3번 과정에서 클라이언트가 IP중 하나를 선택한다고 했다.  
> 그러면 특정 IP만 계속 선택하면 결국 로드가 불균형해지는게 아닌가 싶었지만  
> 위에서 이야기한 교차 영역 로드밸런싱 때문에, 각 인스턴스가 받는 트래픽은 균형을 이루게 된다.  
>   
> 또한 EC2를 계속 이야기했지만, EC2 뿐만 아니라 람다 같은 것도 대상이 될 수 있다.

### 1-6. Target group의 라우팅 알고리즘

- Listener가 Target group으로 전달한 트래픽을, 여러 EC2 중 어떤 EC2로 트래픽을 전달할까? 그리고 어떻게 균형있게 전달할 수 있는걸까?
    
- 기본적으로 **라운드 로빈 라우팅 알고리즘**을 사용한다.
    

#### 1-6-1. 라운드 로빈 라우팅 알고리즘

- 트래픽을 순차적으로 배정한다.
    
- 각 서버가 동일한 스펙을 가지고, 세션이 오래 지속되지 않는 경우에 적합하다.
    
- 이런 이유로 ALB는 기본적으로 라운드 로빈 라우팅 알고리즘을 사용한다.
    

#### 1-6-2. LOR(Least Outstanding Requests) 알고리즘

- [하지만 라운드 로빈 알고리즘은 요청 처리 시간이 서로 다를 때 또는 대상(EC2 인스턴스, 람다 등)을 빈번하게 추가하거나 삭제할 때, Target group에서 대상을 과도하게 사용하거나 미흡하게 사용하는 경우가 발생한다.](https://aws.amazon.com/ko/about-aws/whats-new/2019/11/application-load-balancer-now-supports-least-outstanding-requests-algorithm-for-load-balancing-requests/)
    
- 이로 인해 LOR 알고리즘을 추가했다.
    
- LOR 알고리즘은 간단하다. 요청이 가장 적은 대상에 요청을 전달한다.
    

> AWS ELB 서비스에 대해 알아봤고 이제 서비스를 이용해보자.

---

## 2. 도메인 구매 및 등록

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb4.png)

- route 53 → 좌측 등록된 도메인 → 도메인 등록

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb5.png)

- 원하는 도메인 이름 선택
    - 위 사진은 이미 도메인을 구매한 후 캡쳐한거라 사용할 수 없다고 뜬다. (무시!)
- 제일 싼게 [co.uk](http://co.uk/) 같은 9달러 짜리가 있는데, 얼마 차이 안나서 그냥 .com으로 구매했다.
- 장바구니 추가 후 하단 계속 클릭
- 결제 정보 입력

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb6.png)

- 결제가 완료되면 route 53 대시보드로 이동해서 위 사진처럼 확인할 수 있다.
- AWS가 아닌 다른곳에서 도메인을 구매했다면 aws route53에 도메인을 등록해야 한다.  
    하지만 AWS에서 직접 구매하면 별도로 등록해줄 필요가 없다.

---

## 3. 인증서 발급

### 3-1. 인증서 요청

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb7.png)

- Certificate Manager로 이동

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb8.png)

- 인증서 요청

### 3-2. 인증서 정보 입력

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb9.png)

- 퍼블릭 인증서 (디폴트)

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb10.png)

- 발급받은 도메인 이름을 넣어준다.
    - 여기서 오른쪽 설명 처럼 와일드 카드를 사용해 *.도메인이름 형태로 넣어줘도 되는데  
        우리는 하나의 서버만 관리할것이므로 그냥 도메인 이름을 넣어줬다.
- 검증 방법은 DNS, 이메일 두 방법이 있는데, route 53을 사용하는 경우 그냥 DNS 검증으로 선택하면 되고, 도메인 DNS DB를 편집할 권한이 없는 경우에만 이메일 검증을 사용하라고 한다.  
    DNS 검증을 선택하자.  
    

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb11.png)

- 이후 요청 클릭

### 3-3. 도메인 소유권 검증

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb12.jpeg)

- 새로고침을 눌러주면 인증서가 하나 나올것이다.
- 해당 인증서로 들어가자.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb13.jpeg)

- 이제 도메인에 대한 소유권이 있는지 검증하는 과정이다.
- **Route 53에서 레코드 생성 버튼**을 클릭

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb14.png)

- route 53을 통해 도메인을 구매했기 때문에 자동으로 설정이 된다!
- 바로 생성 버튼을 누르자
- CNAME은 Canonical Name의 줄임말로, 도메인의 별칭이다.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb15.jpeg)

- 몇분이 지나면 검증 대기 중 상태에서, 성공 상태로 변경된 걸 볼수있다.
- 인증서 발급 끝

---

## 4. Target Group 생성

- ALB를 세팅하기 전에, 요청을 분산시켜줄 그룹이 필요하다.
    - 생성한 EC2 인스턴스들이 들어갈 그룹이고  
        로드밸런서가 그룹별로 요청을 분산시켜준다.
- ec2 대시보드 → 로드밸런싱 탭 아래에 대상 그룹 선택

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb16.png)

- 인스턴스 선택, 그룹 이름 작성
- **포트번호 선택!! 여기서 하루를 삽질했다..**
- 기본 포트번호는 80으로 설정돼있다. 많은 블로그 글들을 보았지만 기본값 그대로 사용하길래 따라했다. 하지만 이 포트번호는 **내가 띄울 서비스의 포트 번호**이다. 나는 Docker로 스프링 부트 애플리케이션을 8080포트로 띄우기 때문에, 여기서 8080포트번호를 적어줘야 한다.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb17.png)

- 그룹에 포함할 인스턴스 선택 후 **include as pending below** 클릭후 완료
- ec2 인스턴스 한대라 로드밸런싱이 의미가 없지만, https 프로토콜 적용을 위해서 로드밸런싱을 적용하는 것이므로 신경쓰지말자.

---

## 5. ALB(Application Load Balancer) 세팅

AWS에서 인증서를 발급받은 도메인을 사용하기 위해서는 로드밸런서를 이용해야 한다.

**ALB**란 Applcation Load Balancer이다. **ELB**(Elastic Load Balancer)라고도 부른다.

로드 밸런서란 간단히 이야기 하면, 여러 서버가 띄워져 있을 때 , 클라이언트로 부터 인입되는

요청을 로드밸런서 한곳에서 모두 요청을 받고, 각 서버에게 분배해주는 서버를 의미한다.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb18.png)

ALB는 각 그룹별로 요청을 분산해주고, 각 가용역역에 있는 ALB 노드가 각 인스턴스들에게 요청을

분산 시켜준다.

### 5-1. ALB 생성

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb19.png)

- ec2 대시보드에서 좌측 하단 로드밸런서 탭 → 생성

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb20.png)

- 로드밸런서 타입을 설정하는 곳이다.
- ALB를 선택

### 5-2. 기본 설정

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb21.png)

- 이름만 설정하고 나머지는 기본값을 사용
- 참고로 Scheme에서 Internal은 보통 K8S를 이용해서 노드보다 더 작은 단위와 통신하기 위해서 사용한다고 한다.

### 5-3. 가용영역 설정

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb22.png)

- 총 4개의 가용역역이 있는데, 두개 이상 선택을 권장해서 일단 두개의 가용영역을 선택했다.
- 가용영역에 대한 설명은 길어지니 [블로그](https://aws-hyoh.tistory.com/133)를 참고하자.

### 주의!

가용영역 설정 시 **인스턴스의 가용영역을 포함**시켜야 한다.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb23.png)

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb24.jpeg)


- 로드밸런서 가용영역에, ec2의 가용영역을 포함시키지 않으면 unused 상태가 계속된다.
- 편하게 하려면 그냥 가용영역 4개 다 선택해버리고 아니라면 ec2 대시보드 → 네트워크탭 에서 가용영역을 확인한 후, 해당 가용영역을 선택해줘야 한다  

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb25.png)

- 로드밸런서 대시보드로 가서, 서브넷 편집을 해주자.

### 5-4. 보안 그룹 설정

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb26.png)

- ec2랑 같은 보안그룹을 설정해도 된다.
- 나는 별도의 보안그룹을 생성해서 사용했다.
- 여기서 별도의 보안그룹을 선택한 경우, ec2의 보안그룹에 alb의 보안그룹을 추가해줘야 한다.  
    

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb27.png)

### 5-5. 리스너, 라우팅 설정

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb28.png)

- HTTPS 프로토콜 리스너를 추가
- 위에서 생성한 타겟 그룹 선택

### 5-6. 인증서 설정

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb29.png)

- 이전에 발급받은 인증서를 선택
- 하단 로드밸런서 생성 클릭 후 마무리

### 5-7. Health Check

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb30.png)

- ALB가 활성화 상태가 되고, target group에 가보면 Unhealthy 상태이다.
- 이 상태를 healthy 상태로 만들겠다고 삽질했지만, Unhealthy 상태여도 아무 상관없다.  
    서버가 살아있는지 여부에 대해 판단하기 위한 지표이다. (실제 서버는 살아있다.)
- 그래도 뭔가 불편하다. 초록색을 보고싶다면 아래처럼 하자.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb31.png)

- 아래처럼 API 서버에 간단히 200 ok 응답하는 API를 하나 만들어주고, 해당 경로에 대한 인가 설정을 해주면 위처럼 healthy 상태가 된걸 볼 수 있다. 편안..
- code
    
    ```java
    @RestController
    public class HealthController {
    
        @GetMapping("/")
        public ResponseEntity<HttpStatus> healthCheck(){
            return new ResponseEntity<>(HttpStatus.OK);
        }
    
    }
    
    ---
    
    @EnableWebSecurity
    @RequiredArgsConstructor
    public class SecurityConfig extends WebSecurityConfigurerAdapter {
    
        @Override
        protected void configure(HttpSecurity http) throws Exception {
            http
                    .authorizeRequests()
                    .antMatchers("/").permitAll()
                    .anyRequest().authenticated();
        }
    
    }
    ```
    

---

## 6. ALB와 도메인 연결

거의 다 왔다.

이제 생성한 ALB와, 구매한 도메인을 연결하는 과정이다.

### 6-1. 레코드 생성하기 전에..

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb32.png)

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb33.png)

- 레코드 생성을 클릭하자.
- 현재 레코드가 4개 존재한다.  
    

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb34.png)

- **유형 A**
    - 지금 생성할 레코드인데, 생성 후에 캡쳐한 화면이라 추가되어 있다.
    - address의 약자로 도메인이 IP주소를 바라본다.
    - 즉 yapp-togather.com으로 접속했을 때 ALB의 ip 주소로 접속하게 해주는 과정이다.
- **유형 NS**
    - Name Server의 약자로 도메인이 등록되어있는 name server를 의미한다.
    - 도메인을 생성하면 SOA유형과 함께 기본적으로 생성되는 레코드이다.
- **유형 CNAME**
    - Canonical Name의 약자로 도메인의 별칭을 의미하고  
        도메인에서 도메인 별칭을 바라보게 한다.
    - 위에 2-3에서 도메인 소유권 검증 할 때 만든 레코드이다.

### 6-2. 레코드 생성

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb35.png)

- 레코드 이름은 비워두고, 유형 A로 기본값 사용한다.
- 이제 별칭 토클을 ON 하고  
    Application/Classic Load Balancer에 대한 별칭 → region 선택 → ALB 선택

### 6-3. 끝끝끝

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb36.png)

- [https://yapp-togather.com/](https://yapp-togather.com/) 로 접속이 되는걸 확인할 수 있다.

---

## 7. http 요청 리다이렉션

API 서버라서 안해도 될 것 같지만, SSR형태로 서버를 구축해서 웹 서비스를 제공한다면

필요할 것 같다. `http://example.com` 으로 요청이 들어오면 → 자동으로

`https://example.com` 으로 리다이렉션 하도록 해주는 것이다.

애플리케이션 레벨에서 리다이렉트 할 때는 아래처럼 프로퍼티 파일을 통해 설정할

수 있는 것 같다. 이 부분은 확인하지는 않았으니 참고만 하자.

- `application.yaml`
    
    ```yaml
    server:
      tomcat:
        use-relative-redirects: true
    ```
    

### 7-1. 리다이렉션 설정

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb37.png)

- 로드밸런서의 리스너에서 규칙 편집

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb38.png)

- http로 요청들어왔을 때 https로 리다이렉션하도록 설정한다.

### 7-2. 전달 대상 설정

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/alb39.png)

- 리다이렉션 요청들을 어디로 보낼것인지!
- 여러 그룹을 설정하고, 각 그룹별로 가중치를 설정해서, 요청이 분산되는 양을 조절할 수 있다.

---

> 중간에 삽질을 조금 하긴 했지만, 다 하고보면 생각보다 간단한 것 같다.  
> 이제 Apple 로그인을 구현할 준비가 됐다.

### Ref

[AWS ELB(Elastic Load Balancing) 생성 후 EC2 연동 & 외부 도메인 연동](https://twofootdog.tistory.com/29)

[[AWS] Amazon Certificate Manager로 HTTPS 적용해보기](https://devlog-wjdrbs96.tistory.com/293)

[[AWS] EC2 인스턴스에 HTTPS 적용하기](https://kingofbackend.tistory.com/197)

[[AWS] Amazon Certificate Manager로 HTTPS 적용해보기](https://devlog-wjdrbs96.tistory.com/293)

[[AWS] EC2 인스턴스에 HTTPS 적용하기](https://kingofbackend.tistory.com/197)

[AWS SSL(HTTPS) 적용 방법 - 도메인 구입 Route 53(1)](https://nerd-mix.tistory.com/33?category=855099)

- **AWS ALB 파헤치기**
    - [https://aws-hyoh.tistory.com/128](https://aws-hyoh.tistory.com/128)
    - [ALB](https://docs.aws.amazon.com/ko_kr/elasticloadbalancing/latest/application/application-load-balancers.html)
    - [Listener](https://docs.aws.amazon.com/ko_kr/elasticloadbalancing/latest/application/load-balancer-listeners.html#rule-action-types)
    - [Target group](https://docs.aws.amazon.com/ko_kr/elasticloadbalancing/latest/application/load-balancer-target-groups.html)
    - [LOR 알고리즘](https://aws.amazon.com/ko/about-aws/whats-new/2019/11/application-load-balancer-now-supports-least-outstanding-requests-algorithm-for-load-balancing-requests/)

---
