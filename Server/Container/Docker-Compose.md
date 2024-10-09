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