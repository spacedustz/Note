## Lightweight Kubernetes

> **설치 스크립트 실행**

```bash
sudo apt -y update
sudo apt -y install curl wget
sudo curl -sfL https://get.k3s.io | sh -
```

<br>

> **Node 추가 방법**

```bash
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -
```

<br>

