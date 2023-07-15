## **💡 Docker Compose Syntax**  

- image - 이미지 지정
- service - 컨테이너를 실행하는 단위, 하위에는 서비스 이름, 서비스 옵션 순으로 내려감
- entrypoint - dockerfile 보다 docker compose의 entrypoint의 우선순위가 더 높다
- build - dockerfile 지정
- port - 포트포워딩
- volume - 바인드 마운트, 볼륨 지정
- envionment - 컨테이너의 환경변수 설정
- depends_on - 실행순서 보장 옵션
- expose - 컨테이너간 내부 포트 오픈(호스트 접근 불가)

<br>

### **설치**

- curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
- chmod +x /usr/local/bin/docker-compose
- ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose (bin에 심볼릭링크 생성)

<br>

### **명령어**

- docker-compose up -d - 빌드 & 백그라운드 실행
- docker-compose stop & down - 서비스 중지 & 다운
- docker-compose down --volume - 서비스 다운 후 볼륨 삭제
- docker-compose config - 설정 확인
- docker-compose ps - 실행중인 서비스 확인
- docker-compose logs -f - 로그 트래킹
- docker-compose logs [서비스명] - 지정 서비스 로그 확인
- docker-compose logs [서비스명] [서비스명] - 여러 서비스 로그 확인

<br>

### **설정 파일 병합**

- docker-compose.yaml & docker-compose.override.yaml 작성

<br>

### **예제 - Nginx를 Proxy서버로 둔 로드밸런싱 테스트**

- 준비 - nodejs express api 서버 3대
- dockerfile + nodejs 소스코드 + nginx.conf -> docker-compose.yaml
- docker-compose up -d && docker-compose ps
- LoadBalancer로 접근하면 RR방식으로 순서대로 노드접근

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Compose.png) 