## CA Cert

N-Cloud Load Balancer에 Certificate Manager에 등록한 SSL 인증서 적용

[Let's Encrypt 작동방식](https://letsencrypt.org/ko/how-it-works/)

[SSL 인증서 심사 수준에 따른 레벨 구분 방법 DV,OV,EV](https://cert.crosscert.com/%EF%BB%BFssl%EC%9D%B8%EC%A6%9D%EC%84%9C-%EC%8B%AC%EC%82%AC-%EC%88%98%EC%A4%80%EC%97%90-%EB%94%B0%EB%A5%B8-%EB%A0%88%EB%B2%A8-%EA%B5%AC%EB%B6%84%EB%B0%A9%EB%B2%95-dv-ov-ev/)

---

## Let's Encrypyt 설치 & 발급

<br>

CertBot 설치

```bash
yum -y install certbot
```

<br>

Apache & Nginx를 이용한 Web 인증 인증서 발급 (이 글에서는 DNS 인증을 통한 인증서 발급을 할 것임)

```bash
certbot –nginx certonly -d manvscloud.com, certbot –apache certonly -d manvscloud.com)
```

---

### **CertBot 명령어를 이용한 인증서 발급 (DNS 인증)**

- DNS 인증 및 와일드 카드 인증서 발급
- 이후 “Please deploy a DNS TXT record under the name” 아래 나오는 TXT Record 값을 해당 도메인의 네임서버에 추가
- 위의 TXT 레코드가 잘 등록되면 인증서가 발급된다. 발급이 안된다면 해외 차단 or TXT 조회 & 웹포트 차단 여부 확인
- /etc/letsencrypt/archive 경로로 이동해서 생성된 인증서 확인 가능

```bash
certbot certonly --manual -d *.newreka.co.kr -d newreka.co.kr --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
```

```bash
-rw-r--r-- 1 root root 1862 Dec  6 03:17 cert1.pem
-rw-r--r-- 1 root root 3749 Dec  6 03:17 chain1.pem
-rw-r--r-- 1 root root 5611 Dec  6 03:17 fullchain1.pem
-rw------- 1 root root 1704 Dec  6 03:17 privkey1.pem
```

- 2022-09-30부터 Let's Encrypt에서 DST Root CA X3 루트 인증서를 지원하지 않아서, **ISRG Root X1 인증서를 사용해야 한다.**

```bash
wget http://apps.identrust.com/roots/dstrootcax3.p7c
openssl pkcs7 -inform der -in dstrootcax3.p7c -out dstrootcax3.pem -print_certs
cat dstrootcax3.pem >> fullchain1.pem
```

위에 생성된 cert1, chain1, fullchain1, privkey1 pem 파일을 이용해 네이버 클라우드의 Certificate Manage 서비스에 인증이 정상등록이 안된다.

<br>

cert1.pem 인증서로부터 루트 인증서와 중간 인증서를 생성하고 체인 인증서를 만들어 보자.

- cert1.pem 파일을 cert.crt 파일로 변경
- 파일 Open - 인증경로 - 최상단 루트 인증서 선택 - 인증서 보 - 자세히 - 파일에 복사 - Base64 Encoding - 파일명 : CA.cer

<br>

그럼 CA.cer  파일이 만들어진다.

동일하게 cert.crt를 이용하여 인증경로에 최상단 루트 인증서가 아닌 중간 인증서를 Base64로 인코딩하고

Intermediate.cer 파일을 만들어준다.

<br>

그럼 지금 CA.pem, Intermediate.pem, cert1.pem **3개의 파일이 있을것이다.**

이 파일들의 확장자를 전부 .pem으로 바꿔준다.

그 후, CA.pem의 내용을 메모장으로 열어서 Intermediate.pem에 추가해 인증서 체인을 만들어준다. **(순서가 중요함)**

---

## Naver Cloud Certificate Manager

Security - Certificate Manager로 이동한다.

등록할  인증서는 총 3가지이다.

- privkey1.pem
- cert1.pem
- chain.pem **(Intermediate.pem + CA.pem)**

1. 외부 인증서 등록3
2. 각 칸에 맞는 인증서 내용을 담아준다.
3. 추가

<br>

### Load Balancer에 인증서 추가

- 