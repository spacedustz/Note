## Docker Data Path 수정

데이터 경로 변경 시, 이미지 / 컨테이너 등 전부 다시 세팅 필요

```bash
sudo vi /etc/docker/daemon.json
```

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3",
    "labels": "production_status",
    "env": "os,customer"
  }
}
```

```bash
sudo systemctl restart docker
```