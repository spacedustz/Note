## AWS ELB와 Nginx로 HTTPS 서버 구축하기

서버의 보안성과 프로세스 확장성을 위해 Nginx를 앞단의 웹서버로 두어, EC2 웹서버를 구축하는 것에 대해 작성해보겠습니다.

<br>

저는 AWS EC2에 서버를 배포하였으며, Route 53에서 도메인을 사용하였기에 환경이 동일한 경우 참고하길 바랍니다.  
글을 읽기 전, 아래의 링크된 document를 읽어보시는 것을 추천합니다.

[ELB를 사용하여 HTTP 트래픽을 HTTPS로 리다이렉션](https://aws.amazon.com/ko/premiumsupport/knowledge-center/redirect-http-https-elb/)

---
## Nginx란 ?

**적용에 들어가기에 앞서, Nginx란 무엇인지에 대해 알아보겠습니다.**

Nginx란 Event-driven 구조로 설계되어 비동기 방식으로 처리되는 웹서버를 말합니다. Nginx를 Apache와 많이 비교하게 되는데, 두개의 가장 큰 차이는 서버의 트래픽 처리방식에서 찾을 수 있습니다.

<br>

Apache는 Thread 기반으로 작동합니다. 서버 요청이 Thread와 1:1로 매치되어 처리되는 방식입니다.  
**Nginx는 이와 달리, Event-driven 방식으로 작동하여 여러 요청들을 비동기 방식으로 처리합니다. 따라서 동시 접속 요청이 많아도 Thread 생성 비용이 존재하지 않습니다.** (Node.js의 환경과 비슷합니다!)

<br>

실제로 Node.js를 만든 라이언 달에 의하면, Nginx를 프록시서버로 앞단에 놓고 Node.js를 뒤쪽에 놓는게 버퍼 오버플로에 대한 위협을 일부분 방지한다고 하였습니다. 직접적인 웹서버로의 접근을 차단하고 간접적으로 한 단계를 더 거침으로써 보안적인 부분을 처리할 수 있다는 것입니다.

<br>

**_버퍼 오버플로_** _또는_ **_버퍼 오버런_**_(buffer overrun)은 메모리를 다루는 데에 오류가 발생하여 잘못된 동작을 하는 프로그램 취약점이다._ [_컴퓨터 보안_](https://ko.wikipedia.org/wiki/%EC%BB%B4%ED%93%A8%ED%84%B0_%EB%B3%B4%EC%95%88)_과_ [_프로그래밍_](https://ko.wikipedia.org/wiki/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D)_에서는_ [_프로세스_](https://ko.wikipedia.org/wiki/%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4)_가_ [_데이터_](https://ko.wikipedia.org/wiki/%EB%8D%B0%EC%9D%B4%ED%84%B0)_를_ [_버퍼_](https://ko.wikipedia.org/wiki/%EB%B2%84%ED%8D%BC)_에 저장할 때 프로그래머가 지정한 곳 바깥에 저장하는 것을 의미한다. 벗어난 데이터는 인접 메모리를 덮어 쓰게 되며 이때 다른 데이터가 포함되어 있을 수도 있는데, 손상을 받을 수 있는 데이터는 프로그램 변수와 프로그램 흐름 제어 데이터도 포함된다. 이로 인해 잘못된 프로그램 거동이 나타날 수 있으며, 메모리 접근 오류, 잘못된 결과, 프로그램 종료, 또는 시스템 보안 누설이 발생할 수 있다. (출처 :위키백과)_

<br>

![](https://miro.medium.com/v2/resize:fit:700/1*ZKsENkRycHLEUsaIc4-WAw.png)

<br>

위의 이유 외에도, Nginx는 보안성에서 장점을 갖습니다. 웹서버를 reverse proxy 구조로 설계하여, 앞단에 Nginx를 가짜 서버로 두고 뒷단의 웹서버를 보호할 수 있습니다.

![](https://miro.medium.com/v2/resize:fit:700/1*TrNJZqECEj0eVuJDeNKtNQ.png)

---

## Reverse proxy 구조

이번 글의 주제인 “AWS ELB와 Nginx를 통해 https 웹서버 구축하기”는 http를 https로 리디렉션 해주는것에 더하여, **reverse proxy 웹서버**를 구축해보려 합니다. ELB와 Nginx를 통해 트래픽을 관리해주는 것입니다.

<br>

정리하면, AWS ELB를 거쳐온 트래픽은 앞단의 Nginx로 들어오고, Nginx는 이를 뒷단의 진짜 웹서버로 전달시켜 줍니다. 이러한 과정에서 http 요청을 https로 EC2에게 전달시켜주는 작업을 수행합니다. 아래에서는 이 작업들을 어떻게 수행하는지 작성하겠습니다.

<br>

**수행 과정은 이 순서와 같습니다.**  
1. EC2 배포 및 inbound 설정  
2. ACM 에서 SSL 인증서 발급  
3. ELB 생성 및 리스너 세팅  
4. Route 53에서 레코드 생성 후 ELB 연결  
5. EC2에 nginx 설치 및 세팅

<br>

**EC2 배포에 대한 설명은 건너뛰겠습니다만, EC2의 보안그룹 inbound 설정은 아래의 이미지를 참고하여 설정해주시면 됩니다.**

![](https://miro.medium.com/v2/resize:fit:700/1*NdPpMROi2kPDcXRBIkiVXw.png)

---

## ACM에서 SSL 인증서 발급

AWS console에서 ACM을 검색하여 이동하여, 새로운 인증서를 생성합니다.

![](https://miro.medium.com/v2/resize:fit:1000/1*cUXiilvrf8oOtYYSN93wqQ.png)

<br>

도메인 이름을 입력합니다.

![](https://miro.medium.com/v2/resize:fit:1000/1*VjnxPyMBa-7GdHpF8VlkfQ.png)

<br>

DNS 검증을 선택합니다.

![](https://miro.medium.com/v2/resize:fit:1000/1*mugsj6uRfsv2t55h3AgOOg.png)

<br>

검증 보류이지만, 하단 토글을 눌러 Route 53에서 레코드 생성을 누릅니다.

![](https://miro.medium.com/v2/resize:fit:1000/1*ke3BdMXonLcUt1AooM2VzQ.png)

<br>

Route 53 레코드에 CNAME 기록이 자동으로 추가됩니다. 이후, 검증이 성공된 것을 확인할 수 있습니다.

---

## ELB 생성 및 리스너 세팅

이제 Load Balancer를 생성합니다. EC2 메뉴 왼쪽 하단에 로드밸런서를 클릭합니다. 

로드밸런서를 생성을 클릭하고, **Application Load Balancer**를 선택합니다.

**첫번째 단계에서 이름을 입력하고, 리스너 탭에서 HTTPS를 추가합니다.**

![](https://miro.medium.com/v2/resize:fit:1000/1*FXAHI97mZaQZXQANt4pqcQ.png)

<br>

**로드밸런서 구성에서는 위에서 생성한 ACM 인증서를 선택합니다.**

![](https://miro.medium.com/v2/resize:fit:1000/1*-34efcdbjqOufnMWHVyhpg.png)

<br>

보안그룹 설정에서는 기존 EC2의 보안그룹을 사용합니다. 라우팅 구성에서는 새 대상그룹을 생성하고, 이외에것은 따로 수정할 필요가 없습니다.  
대상등록에서 EC2를 등록 추가한 후, 로드밸런서 설정을 마무리합니다.

<br>

**이제 생성된 로드밸런서에서 리스너 설정이 중요합니다.  
아래의 이미지에서 HTTP 리스너 ID 의 규칙 보기/편집을 클릭합니다.**

![](https://miro.medium.com/v2/resize:fit:1000/1*pcAVy74H2hdfif53EN1HmQ.png)

<br>

**규칙 편집에서 HTTP 80 PORT의 HTTPS 443 PORT로 리디렉션 합니다.  
**이 작업은 HTTP로 서버에 컨택할 시에, ELB의 리스너가 HTTPS 로 리디렉션 해주는 설정을 의미합니다.

![](https://miro.medium.com/v2/resize:fit:1000/1*XIkVQp5nWDWDhPaR9N1jDg.png)

---

## Route 53에서 레코드 생성 후 ELB 연결

다음은 Route 53으로 이동하여, 해당 도메인에서 레코드를 생성해야 합니다.  
레코드 생성을 선택하시면, 오른쪽에 생성값을 입력하는 것이 나옵니다.

<br>

![](https://miro.medium.com/v2/resize:fit:700/1*98CHQ0FkjnEEHukILvcSqw.png)

<br>

별칭에서 “예”를 선택하신 후, 위에서 생성하였던 ELB Application Load Balancer를 선택합니다.

---

## EC2에 nginx 설치 및 세팅

마지막입니다. EC2에서 nginx를 설치하고, https 설정을 해줌으로써 작업을 마무리할 수 있습니다.

EC2가 ubuntu 16.04라면,

```bash
sudo apt-get install nginx
```

<br>

EC2가 ubuntu 18.04라면,

```bash
sudo apt-get update  
sudo apt-get install nginx
```

위의 command로 nginx를 설치합니다.

<br>

이제 nginx 설정을 바꿔줍니다.  

root path에서 etc/nginx로 이동합니다. 

해당 폴더안에는 nginx.conf 파일이 있는데, 아래의 커맨드를 사용하면 nginx.conf파일을 수정할 수 있습니다.

<br>

```bash
sudo vi nginx.conf

http {

# 이 안에 아래의 코드를 붙여넣기 합니다.

# 볼드체로 되어있는 주석처리를 꼭 참고하시길 바랍니다.

}

server {       
  listen       80;  
  server_name  ~.;  # redirect https setting**  
  if ($http_x_forwarded_proto != 'https') {  
    return 301 [https://$host$request_uri](https://%24host%24request_uri/);  
  }  location / {           
    proxy_set_header X-Real-IP $remote_addr;               
    proxy_set_header HOST $http_host;  
    proxy_set_header X-NginX-Proxy true;  
    # port setting , 서버의 port와 동일한 port로 pass 시켜야 합니다.
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
    proxy_pass [http://127.0.0.1:8080;](http://127.0.0.1:8080;/)  
    proxy_redirect off;  
  }  
}
```

위의 과정들을 올바르게 진행하였다면, http 요청이 https로 리디렉션 되는것을 확인하실 수 있습니다.

> _어려운 AWS의 document들을 참고하면서 삽질도 하면서 제 스스로 배운것들을 정리하자면,_
> 
> **_ELB의 주된 목적_**_은 트래픽을 분산하는 것이지만,_ **_SSL 암호화 인증도 함께 지원_**_하여 유용하게 사용할 수 있습니다.  
> 대안으로 nginx만을 사용할 수 있지만 SSL 인증서 발급과 갱신에서 번거로움이 있을 수 있습니다. 
> 만약 개발 공부 목적에서 이 작업을 진행하신다면, ELB는 유료 서비스 이므로 요금을 참고하시길 바랍니다._
> 
> _제가 이번 작업을 수행하면서, http를 https로 리디렉션 해주는 것을 순차적으로 표현한다면.._
> 
> **_외부에서 http로 컨택하게 되면 ELB에서 http를 https로 리디렉션 해주는 작업을 수행합니다._** _(Classic ELB에서는 이 작업을 수행하지 못했지만, 새로운 ELB는 이 작업이 수행가능 합니다!) Nginx 설정 없이도 가능한 것입니다._
> 
> _하지만 Nginx까지 사용하는 경우, Nginx에서 https 리디렉션 설정을 해주는 것이 안전하다고 생각됩니다. 
> ELB를 사용하게되면 Nginx의 config 설정에서_ **_$http_x_forwarded_proto를 통해 https 인지 아닌지_**_를 알 수 있기 때문입니다. 
> 
> 여기서 만약 http로 들어온 케이스가 있다면, https로 다시 리디렉션을 해주게 됩니다.  
> 즉, 외부의 접속을 ELB가 받게 되면 https로 리디렉션되어 EC2에 전달해주지만, 혹시나 모를(?) 케이스에서 Nginx가 EC2에서 https로 리디렉션 해주는 작업을 수행하게 됩니다.

<br>

작성한 내용들에 부족함이 많지만, https를 서버에 적용시키는 분들에게 조그만한 도움이 되길 바랍니다.