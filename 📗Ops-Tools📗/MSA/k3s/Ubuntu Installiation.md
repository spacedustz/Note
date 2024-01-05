## 📘 Lightweight Kubernetes

일을 하던 도중 컨테이너가 많아짐에 따라 쿠버네티스를 도입하기로 했는데

k8s는 아직 다루고 있는 컨테이너의 수에 비해 무겁다고 느껴져서 알아보던중 경량 쿠버네티스인 k3s를 발견하였습니다.

<br>

쿠버네티스의 Default Container Runtime Engine은 `containerd`를 사용하지만,

저는 Nvidia Container Runtime을 설치하였고 k3s는 이 엔진을 자동으로 적용합니다.

> 🚩 **Nvidia Container Runtime Engine 인식 확인 방법**

```bash
grep nvidia /var/lib/rancher/k3s/agent/etc/containerd/config.toml
```

```
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes."nvidia"]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes."nvidia".options]
  BinaryName = "/usr/bin/nvidia-container-runtime"
```



> 🚩 **설치 스크립트 실행**

- k3s 설치는 curl 명령 1번으로 간단하게 설치됩니다.

```bash
sudo apt -y update
sudo apt -y install curl wget
sudo curl -sfL https://get.k3s.io | sh -
```

<br>

> 🚩 **Node 추가 방법**

```bash
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -

sudo mkdir ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config && sudo chown $USER ~/.kube/config
sudo chmod 600 ~/.kube/config && export KUBECONFIG=~/.kube/config
```

<br>

> 🚩 **사용 포트**

- 일반적인 경우 Kubernetes API Server 포트인 6443만 열면 됩니다.

|규약|포트|원천|목적지|설명|
|---|---|---|---|---|
|TCP|2379-2380|서버|서버|etcd가 내장된 HA에만 필요합니다.|
|TCP|6443|자치령 대표|서버|K3s 감독자 및 Kubernetes API 서버|
|UDP|8472|모든 노드|모든 노드|Flannel VXLAN에만 필요|
|TCP|10250|모든 노드|모든 노드|Kubelet 측정항목|
|UDP|51820|모든 노드|모든 노드|IPv4를 사용하는 Flannel Wireguard에만 필요합니다.|
|UDP|51821|모든 노드|모든 노드|IPv6를 사용하는 Flannel Wireguard에만 필요합니다.|

---
## 📘 Configuration

[K3s CLI Arguments](https://docs.k3s.io/kr/installation/configuration)

k3s 설치는 CLI로 진행하여 CLI Arguments에 실행옵션을 다양하게 줄 수 있습니다.

또한 CLI Argument 대신 `/etc/rancher/k3s/config.yaml`에 파일을 생성해도 적용됩니다. 

```yaml
write-kubeconfig-mode: "0644"  
tls-san:  
- "foo.local"  
node-label:  
- "foo=bar"  
- "something=amazing"  
cluster-init: true
```

<br>

> 🚩 **다중 Configuration 적용**

- 기본적인 Config 파일은 알파벳 순서로 읽힙니다.
- `/etc/rancher/k3s/config.yaml.d/*.yaml` 이름에서 특정키의 마지막 값이 사용됩니다.

```yaml
# config.yaml  
token: boop  
node-label:  
- foo=bar  
- bar=baz  
  
  
# config.yaml.d/test1.yaml  
write-kubeconfig-mode: 600  
  
  
# config.yaml.d/test2.yaml  
write-kubeconfig-mode: 777  
node-label:  
- other=what  
- foo=three
```

위에서 여러개의 Yaml을 선언했으며 최종 적용된 yaml은 test2.yaml 파일 입니다.

---
## 📘 CNI (Container Network Interface)

K3s의 기본 CNI Plugin은 Flannel을 사용합니다.

CNI는 쿠버네티스의 노드간 네트워킹을 수행하는 네트워크 인터페이스이며,

모든 노드가 동일한 CNI를 사용해야 정상적으로 노드간 통신이 가능합니다.

<br>

**Flannel 특징**

- 서버 노드에서만 설정할 수 있으며 클러스터의 **모든 노드**의 CNI가 동일해야 합니다.
- Flannel의 기본 Backend는 `vxlan`이며 암호화를 적용하려면 `wireguard-native` Backend를 사용해야 합니다.
- `wiregurad`를 사용하려면 Linux 배포판마다 추가 모듈이 필요 할 수 있습니다. [WireGuard 설치 가이드](https://www.wireguard.com/install/)

<br>

저는 따로 Calico 같은 다른 CNI를 사용 안하고 기본 CNI인 Flannel을 사용합니다.

---
## 📘 Private Container Registry

Private Container Registry는 별도의 네임스페이스에서 구성하겠습니다.

PVC와 PV를 이용해 **로컬 디스크 <-> Registry Pod**와 마운트 시켜줄겁니다.

```bash
sudo kubectl create namespace hub
sudo mkdir hub && cd hub
```

<br>

> 🚩 **StorageClass 생성**

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: hub-storage
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
```

<br>

> 🚩 **PVC 생성 : hub-pvc.yaml**

- Storage Class로 hub-sc를 사용합니다.
- 영구 스토리지에 위해 10GB를 할당 합니다.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: hub-pvc
  namespace: hub
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: hub-sc
  resources:
    requests:
      storage: 20Gi
```

<br>

**PVC, PV가 생성 / 생성됐는지 확인**

```bash
kubectl apply -f hub-pvc.yaml
kubectl get pvc -n hub
kubectl get pv -n hub
```