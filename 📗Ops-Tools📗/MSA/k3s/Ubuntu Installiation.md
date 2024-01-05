## Lightweight Kubernetes

k3s 설치는 CLI로 진행하여 CLI Arguments에 실행옵션을 다양하게 줄 수 있습니다.

또한 CLI Argument 대신 `/etc/rancher/k3s/config.yaml`에 파일을 생성해도 적용됩니다. 

[K3s CLI Arguments](https://docs.k3s.io/kr/installation/configuration)

<br>

> **다중 Configuration 적용**

- 기본적인 Config 파일은 알파벳 순서로 읽힙니다.
- `/etc/rancher/k3s/config.yaml.d/*.yaml` 키의 마지막 값이 사용됩니다.

## Installation

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

> **사용 포트**

- 일반적인 경우 6443만 열면 됩니다.

|규약|포트|원천|목적지|설명|
|---|---|---|---|---|
|TCP|2379-2380|서버|서버|etcd가 내장된 HA에만 필요합니다.|
|TCP|6443|자치령 대표|서버|K3s 감독자 및 Kubernetes API 서버|
|UDP|8472|모든 노드|모든 노드|Flannel VXLAN에만 필요|
|TCP|10250|모든 노드|모든 노드|Kubelet 측정항목|
|UDP|51820|모든 노드|모든 노드|IPv4를 사용하는 Flannel Wireguard에만 필요합니다.|
|UDP|51821|모든 노드|모든 노드|IPv6를 사용하는 Flannel Wireguard에만 필요합니다.|