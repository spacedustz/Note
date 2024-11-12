## Docker-Compose - docker-py 에러 해결

```bash
# Docker Compose 및 Python Docker 삭제
sudo apt-get -y remove docker-compose
sudo pip uninstall docker
sudo pip uninstall docker-py

# 최신버전 Docker-Compose 재설치
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo pip install docker

# 선택사항 : Docker 캐시 정리
docker system prune -a

# 선택사항2 : 권한 문제 시
sudo usermod -aG docker $USER
newgrp docker

# Docker 재시작
sudo systemctl restart docker
```

```bash
version: '3'
services:
  # Admin
  ys-admin:
    build:
      context: /home/ys/server/admin
      dockerfile: Dockerfile.admin
    container_name: YS-Admin
    volumes:
      - /home/ys/log/admin:/server/log
    ports:
      - "9000:9000"
    environment:
      - APP_NAME=YS-Admin
      - LOG_DIR=/home/ys/log/admin

  # Batch
  ys-batch:
    build:
      context: /home/ys/server/batch
      dockerfile: Dockerfile.batch
    container_name: YS-Batch
    volumes:
      - /home/ys/log/batch:/server/log
    ports:
      - "9001:9001"
    environment:
      - APP_NAME=YS-Batch
      - LOG_DIR=/home/ys/log/batch


  # Event
  ys-event:
    build:
      context: /home/ys/server/event
      dockerfile: Dockerfile.event
    container_name: YS-Event
    volumes:
      - /home/ys/log/event:/server/log
    ports:
      - "9002:9002"
    environment:
      - APP_NAME=YS-Event
      - LOG_DIR=/home/ys/log/event


  # Front
  ys-front:
    build:
      context: /home/ys/server/front
      dockerfile: Dockerfile.front
    container_name: YS-Front
    ports:
      - "3000:3000"
```