## **💡 IntelliJ CAcert 검증 오류**



**"CertPathValidatorException"**

스프링 부트 버전 변경에 따른 스프링 부트의 내부동작중 SSL 관련하여 어떤 문제가 생긴것 같았다
근데 로컬인데 SSL이 쓰일일이 있나? 하면서 검색.
인증서 관련으로 몇시간 삽질함.
결국 application.yml에 server ssl enabled설정을 false로 바꾸니 해결됐다.

<br>

Spring Boot 3.0.0 부터 JDK는 17을 사용해야함

<br>

SSL 인증서 검증 오류

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cert.png)

<br>

### **PXIX Path Validation Failed Error**

- CA 인증서 생성 or 가져오기
- Open Windows CMD
- cd C:\Program Files\JetBrains\IntelliJ<Version>\jre64 or jbr\bin
- Option 1
  - keytool -keystore cacerts -importcert -alias <alias-name> -file <.cer File Location>
- Option 2
  - keytool.exe -import -trustcacerts -noprompt -keystore ..\lib\security\cacerts -storepass changeit -alias <Alias-Name> Server -file <.cerFile Location>
- Option 3
  - curl -O https://gist.githubusercontent.com/lesstif/cd26f57b7cfd2cd55241b20e05b5cd93/raw/InstallCert.java
  - javac InstallCert.java - 컴파일
  - java -cp ./ InstallCert <인증서를 받아올 호스트명 입력>
  - cd C:\Program Files\Zulu\zulu-11\lib\security
  - keytool -exportcert -keystore cacerts -storepass <인증서PW> -file <output.cert> -alias <alias_name>
  - keytool -importcert -keystore cacerts -storepass <인증서PW> -file <output.cert> -alias <alias_name>

<br>

DER로 인코딩된 바이너리 X.509 .cer 파일

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cert2.png) 

<br>

가져온 인증서(.cer 파일) 적용

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cert3.png)

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cert4.png)

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/cert5.png)