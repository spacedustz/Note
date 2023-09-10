## 무중단 배포 -  Blue Green Deployment

지난번에 구축한 Jenkins + Github Webhook Trigger + AWS EC2, RDS ELB를 연동해서 간단한 CICD 배포 성공을 하고,

사내 요구사항 변경으로 무중단 배포(zero-downtime)를 구축한 기록을 작성합니다.

<br>

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/bluegreen.png)

<br>

### 설계할 배포 구조

1. 새로운 버전이 Git에 병합되면, **Github Webhook**을 통해 Jenkins에 신호가 들어오고, 젠킨스는 **최신 버전의 Jar 파일을 빌드**합니다.
2. 젠킨스는 **Blue에 Health check**를 합니다. Blue가 살아있다면 신버전을 Green에 배포하면 되고, 살아있지 않다면 Blue에 배포하면 됩니다.
3. 그림상 Blue가 살아있는 것으로 판단됩니다. 따라서 젠킨스는 Green에 배포를 하겠습니다.
4. 젠킨스는 **Green에 맨 처음 빌드해둔 Jar 파일을 전송**하고, 원격지에서 **실행**합니다.
5. Green의 애플리케이션이 구동되었는지 **10초 주기로 Health Check**를 합니다. Green 애플리케이션이 기동됨을 확인하면 (6)으로 넘어갑니다.
6. **Nginx의 리버스 프록시 방향을 Blue에서 Green으로 변경**합니다. 이제 클라이언트의 모든 트래픽이 신버전 애플리케이션으로 향합니다.
7. Blue 인스턴스의 애플리케이션 프로세스를 죽입니다.

<br>

**build.gradle.kts**

```groovy
implementation ("org.springframework.boot:spring-boot-starter-actuator")
```

<br>

**application.yml**

```yaml
management:  
  endpoints:  
    web:  
      exposure:  
        include: health
```

<br>

설정 후 /actuator/health 의 엔드포인트로 컨테이너의 Health Check를 할 수 있습니다.

---

### Nginx Reverse Proxy 설정

가용성을 위해 Nginx의 포트 리다이렉트를 8080 실패 시 8081로 포트 2개를 설정하였습니다.

Nginx Logging을 위해 로그 설정도 해주었습니다.

<br>

**nginx.conf**

```php
upstream docker-spring {  
      server localhost:8080 weight=10 max_fails=3 fail_timeout=10s;  
      server localhost:8081 weight=5 max_fails=3 fail_timeout=10s;  
}

server {
    listen 80;
    server_name localhost;

    include /etc/nginx/conf.d/service-url.inc;

    location / {
        proxy_pass $service_url;
        proxy_redirect     off;
        proxy_http_version 1.1;
        proxy_set_header   Host $http_host;
        proxy_set_header   Connection "";
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Host $server_name;
    }

		client_max_body_size 100M;

		access_log /var/log/nginx/access.log;
		error_log /var/log/nginx/error.log;
}
```

<br>

위 설정을 보면 `include` 라는 지시어를 사용하는 것을 볼 수 있습니다. 

이는 외부에서 설정 파일을 불러올 수 있는 Nginx 의 기능입니다.

`location`의 `proxy_pass` 를 보면, `$service_url` 로 리버스 프록시 요청을 보내는 것을 알 수 있는데,

`service-url.inc` 에서 이 `$service_url` 변수 값을 채워줍니다.

**service-url.inc**
```php
set $service_url http://XXX.XXX.XXX.XXX:8080;
```

<br>

**_location_**
- proxy_pass : 사용중인 프록시 URL을 입력 해줍니다.
- proxy_redirect : 프록시 리다이렉트는 사용을 하지 않겠습니다.
- proxy_http_version : HTTP 1.1을 사용합니다.

---

### Jenkins 설정

**_환경변수 설정_**
- nginx_ip, blue_ip, green_ip 3개의 변수를 만들어 각각 인스턴스 IP 주소를 값으로 넣어줍니다.

<br>

**_도커 네트워크 생성_**

제 경우에는 각각의 인스턴스가 아닌 컨테이너 끼리 Blue, Green 배포를 할것이고 Jenkins의 환경변수에 IP를 작성해야 합니다.

그래서 도커 네트워크를 만들어 줌으로써, Container의 IP를 고정시켜서 변경되지 않게 합니다.

기본 bridge0에 할당되어 있으면 컨테이너는 재시작 할때마다 IP가 바뀌게 됩니다.

즉, 새로운 Docker Bridge를 만들고 컨테이너들을 기본 bridge0이 아닌 Custom Bridge에 할당시킵니다.

<br>

```bash
docker network create --gateway 172.20.0.1 --subnet 172.20.0.0/16 deploy
```

이 후, docker run을 할 때 --network deploy 옵션과 --ip 172.20.0.X 로 아이피를 할당하면 됩니다.

새로 만든 Docker Bridge Network에 Blue 컨테이너가 할당된 모습

<br>

<img src="https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/bluegreen2.png" height="80%" width="80%" />

<br>

**_스크립트 수정_**

```bash
#!/bin/bash  
  
# Blue & Green 타겟 지정 변수  
target=2  
deployment_target_ip=""  
blue_ip=""  
green_ip=""  
  
# Gradlew 권한 부여  
chmod 500 ./gradlew  
  
# 빌드  
#./gradlew clean build --exclude-task test  
  
# 테스트용 빠른 빌드  
./gradlew bootJar  
  
# Blue Health Check  
if curl -s "http://$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' blue):8080/ttt" > /dev/null; then  
 deployment_target_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' green)  
 green_ip=$deployment_target_ip  
 target=0  
else  
 deployment_target_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' blue)  
 blue_ip=$deployment_target_ip  
 target=1  
fi  
  
# Target과 일치하는 가동중인 Spring Boot 컨테이너 중지 & 삭제  
if [ "$target" -eq 0 ]; then  
 if docker ps -a --filter "name=green" | grep -q green; then  
  docker stop green  
  docker rm green  
  fuser -k 8080/tcp  
 fi  
  
 # 기존 Spring Boot Image 중 이미지가 기존과 똑같은게 있으면 이미지 삭제  
 if docker images | awk '{print $1":"$2}' | grep -q "localhost:5000/green:1.0"; then  
   docker rmi -f localhost:5000/green:1.0  
  fi  
  
elif [ "$target" -eq 1 ]; then  
  if docker ps -a --filter "name=blue" | grep -q blue; then  
  docker stop blue  
  docker rm blue  
  fuser -k 8080/tcp  
 fi  
  
 # 기존 Spring Boot Image 중 이미지가 기존과 똑같은게 있으면 이미지 삭제  
 if docker images | awk '{print $1":"$2}' | grep -q "localhost:5000/blue:1.0"; then  
   docker rmi -f localhost:5000/blue:1.0  
  fi  
else  
 echo "Invalid target Value"  
fi  
  
# Docker Hub Login & 파라미터는 젠킨스에서 설정한 전역변수 사용  
echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin  
  
# 도커파일 빌드  
if [ "${deployment_target_ip}" == "${blue_ip}" ]; then  
 docker build --no-cache -t localhost:5000/blue:1.0 -f ./spacepet-deploy/test/blue .  
  
 # Container Registry에 이미지 Push 
 docker push localhost:5000/blue:1.0  
  
 # Push한 이미지 삭제  
 docker rmi localhost:5000/blue:1.0  
  
 # Container Registry에서 이미지 Pull 
 docker pull localhost:5000/blue:1.0  
  
 # Docker Container 생성  
 docker run -d -v /root/docker_volumn/blue:/app --network deploy --ip 172.20.0.2 --privileged --name blue -p 8080:8080 localhost:5000/blue:1.0  
  
elif [ "${deployment_target_ip}" == "${green_ip}" ]; then  
 docker build --no-cache -t localhost:5000/green:1.0 -f ./spacepet-deploy/test/green .  
  
 # Container Registry에 이미지 Push 
 docker push localhost:5000/green:1.0  
  
 # Push한 이미지 삭제  
 docker rmi localhost:5000/green:1.0  
  
 # Container Registry에서 이미지 Pull 
 docker pull localhost:5000/green:1.0  
  
 # Docker Container 생성  
 docker run -d -v /root/docker_volumn/green:/app --network deploy --ip 172.20.0.3 --privileged --name green -p 8080:8080 localhost:5000/green:1.0  
else  
 echo "Invalid target Value"  
fi  
  
# 사용하지 않는 불필요한 이미지 삭제 = 겹치는 이미지가 존재하면 이미지를 삭제한다  
dangling_images=$(docker images -f "dangling=true" -q)  
if [[ -n "$dangling_images" ]]; then  
    docker rmi -f "$dangling_images" || true  
fi

# Nginx Reverse Proxy 방향 (타겟 컨테이너) 변경
ssh root@${nginx_ip} "echo 'set \\\$service_url http://${deployment_target_ip}:8080;' > /etc/nginx/conf.d/service-url.inc && service nginx reload"
echo "Switch the reverse proxy direction of nginx to ${deployment_target_ip} 🔄"
```

---

### Jenkinsfile 

```groovy
pipeline {  
  agent any  
  
  stages {  
  
    stage('Clean Workspace') {  
      steps {  
        deleteDir()  
      }  
    }  
  
    stage('Checkout') {  
      steps {  
        script {  
          checkout([$class: 'GitSCM',  
  
          branches: [[name: '<branch-name>']],  
          userRemoteConfigs: [[  
          url: 'git@github.com:<user-name>/<repo-name>.git',  
          branch: 'SPACEPET-TEST',  
          credentialsId: '<jenkins-credentials-id>']]])  
        }  
      }  
    }  
  
    stage('Build') {  
      steps {  
        script {  
          def gitTags = sh(returnStdout: true, script: 'git tag --contains HEAD')  
          if (gitTags.contains('cicd')) {  
            sh 'chmod 500 spacepet-deploy/test/script.sh'  
            sh './spacepet-deploy/test/script.sh'  
          } else {  
            echo 'No tag containing "cicd" found.'  
          }  
        }  
      }  
    }  
  }  
}
```

---

### Dockerfile

```dockerfile
FROM openjdk:11  
RUN mkdir -p /app    
WORKDIR /app    
VOLUME /app    
EXPOSE 8080
ARG JAR=dangnyang-1.7.08-SNAPSHOT.jar    
COPY ../../build/libs/${JAR} /koboot.jar  
RUN chmod +x /koboot.jar  
ENTRYPOINT ["java","-jar","-Dspring.profiles.active=test","-Xmx6144M","/koboot.jar"]
```