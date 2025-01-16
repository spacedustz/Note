## 💡 Kubernetes Dashboard 

Prometheus & Grapana 설치는 추후 쓸 예정(귀찮)

<br>

### 사전 준비 사항

1. Docker Hub 회원가입
2. 테스트용 가상머신 준비 (VMware or VirtualBox) * Network Interface를 2개로 생성 NAT(external), Host Only(internal)
3. Linux (Centos or Ubuntu) 서버 설치

<br>

### 쿠버네티스 설치 전 패키지 & Docker 설치 & 서버 세팅 (master , worker 노드 모두 설정)

1. yum -y install epel-release yum-utils device-mapper-persistent-data lvm2

 ㄴ vi /etc/yum.repos.d/epel.repo (epel 저장소 적용)

 ㄴ sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux (Selinux Disable로 변경)

 ㄴ systemctl stop firewalld && systemctl disable firewalld (firewall 사용중지)

 ㄴ swapoff -a / vi /etc/fstab 에 swap 부분 # 처리

 ㄴ echo '1' > /proc/sys/net/ipv4/ip_forward (패킷 포워딩 enable)

 ㄴ modprobe br_netfilter && vi /etc/modules-load.d/k8s.conf  // br_netfilter 기입후 :wq (netfilter 모듈 적재)

 ㄴ lsmod | grep br_netfilter (모듈 적재 확인)

 ㄴ vi /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1

​    net.bridge.bridge-nf-call-iptables = 1    :wq
 ㄴ sysctl --system (apply 확인)

 ㄴ yum update

 ㄴ rdate -s time.bora.net

 ㄴ vi /etc/hosts (master node 포함 모든 노드 상호간 ssh 접근 작업 실행)
```bash
MasterIP  MasterHostname

NodeIP  NodeHostname

Node2IP  NodeHostname
```

<br>

### Docker 설치

 ㄴ yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo  (docker repository 추가)

 ㄴ yum list | grep docker-ce && yum list docker-ce --showduplicates && yum -y install docker-ce  (버전&유무확인&설치)

 ㄴ vi /etc/docker/daemon.json (docker의 cgroup 값을 kubernetes의 container runtime 기본값인 systemd 로 변경)

```json
{
 "exec-opts": ["native.cgroupdriver=systemd"],
 "log-driver": "json-file",
 "log-opts": {
  "max-size": "100m"
 },
 "storage-driver": "overlay2",
 "storage-opts": [
  "overlay2.override_kernel_check=true"
 ]
}
```

 ㄴ mkdir -p /etc/systemd/system/docker.service.d

 ㄴ systemctl daemon-reload

 ㄴ systemctl start docker && systemctl enable docker

 ㄴ docker --version && docker info | grep -i cgroup (docker version과 cgroup 값 확인)

 ㄴ docker pull nginx:1.21-alpine && docker login (도커 정상 동작 확인 테스트)

 ㄴ docker info | grep Username (docker hub 로그인 확인)

 ㄴ docker run -d -p 8001:80 --name=test nginx:1.21-alpine (컨테이너 테스트 접속)

 ㄴ curl localhost:8001

 ㄴ docker stop (cid) && docker rm (cname) && docker rmi (image)

<br>

### 쿠버네티스 설치

 ㄴ vi /etc/yum.repos.d/kubernetes.repo

```bash
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
:wq
```

 ㄴ yum repolist

 ㄴ yum list | grep kubernetes kubeadm kubectl kubelet

 ㄴ yum list kubeadm --showduplicates | grep 1.23 (이번 실습은 1.23.5로 설치.)

 ㄴ yum -y install kubeadm-1.23.5 kubectl-1.23.5 kubelet-1.23.5 --disableexclude=kubernetes  
(disable option = k8s와 관련없는 패키지 배제하고 설치(버전지정))

 ㄴ yum list installed | grep kubernetes

 ㄴ systemctl daemon-reload && systemctl start kubelet && systemctl enable kubelet

--------- 여기까지 하고 가상머신 복제(mac 안겹치게) 해서 worker node로 사용 ---------

---

## 💡 Cluster 구성

### Master node 설정

 ㄴ kubeadm init --pod-network-cidr=10.96.0.0/12 --apiserver-advertise-address=192.168.0.10 <-master ip

<br>

[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`

에러가 발생할 시 docker 와 kubernetes 버전이 상이하여 발생함. 버전 맟추고 다시 실행해보자

1.24 버전은 dockerd가 아닌 cri-dockerd를 사용하므로 docker가 아닌 cri-docker를 설치하여 init 작업 수행.

<br>

 ㄴ mkdir -p $HOME/.kube
 ㄴ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
 ㄴ sudo chown $(id -u):$(id -g) $HOME/.kube/config

 ㄴ export KUBECONFIG=/etc/kubernetes/admin.conf

 ㄴ init을 실행하여 나온 클러스터 조인 해시값을 포함한 명령 복사 & 노드에 붙여넣기

ex) kubeadm join 192.168.56.100:6443 --token e6in6u.bljujemlalxxpifh \
--discovery-token-ca-cert-hash sha256:eefd122c2d9a4fac1bb8d4b98eb2191d3e5fb45ae3dd01325ed1b010271399d7 

 ㄴ source <(kubectl completion bash) (kubectl 에 tab 기능 추가)
 ㄴ echo "source <(kubectl completion bash)" >> .bashrc

 ㄴ curl -O [https://docs.projectcalico.org/manifests/calico.yaml  (CNI (calico) 설치](https://docs.projectcalico.org/manifests/calico.yaml))
 ㄴ kubectl apply -f [https://docs.projectcalico.org/manifests/calico.yaml  (CNI Pod 생성)](https://docs.projectcalico.org/manifests/calico.yaml)

 ㄴ kubectl get pod -A  (calico pod running 상태 확인)

<br>

### worker node 설정

 ㄴ kubeadm join 192.168.56.100:6443 --token e6in6u.bljujemlalxxpifh \
--discovery-token-ca-cert-hash sha256:eefd122c2d9a4fac1bb8d4b98eb2191d3e5fb45ae3dd01325ed1b010271399d7

 ㄴ mkdir -p /root/.kube && scp 192.168.0.10:/root/.kube/config /root/.kube/

 ㄴ kubectl get nodes (노드 목록 정상 출력되는지 확인되면 클러스터 조인 완료)

---

## 💡 Kubernetes Dashboard 생성 (2.5.0)

 ㄴ https://github.com/kubernetes/dashboard/releases (2.5.0 설치)

 ㄴ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml

 ㄴ kubectl cluster-info (해서 나오는 coreDNS 주소정보를 대시보드에 적용)



Kubernetes control plane is running at https://192.168.56.100:6443
CoreDNS is running at https://192.168.56.100:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

<br>

   ### Dashboard 기동 방법
​    ㄴ proxy (8001) -> 접근시 token( 보안성 X) -> 브라우저 접근에 인증서 필요
​    ㄴ NodePort (30000~)
​    ㄴ api server (6443) -> 접근시 token -> openssl로 인증서 생성후 윈도우에 배포 (certmgr)에 등록



 ㄴ kubectl get clusterrole cluster-admin (admin role 조회)



 Resources Non-Resource URLs Resource Names Verbs
 --------- ----------------- -------------- -----
 *.*    []         []       [*]
       [*]        []       [*]



 ㄴ kubectl describe clusterrole cluster-admin

 ㄴ kubectl get sa -n kubernetes-dashboard kubernetes-dashboard

​        ㄴ cluster-admin 과 sa(default)가 보유햔 super 권한을 "kubernetes-dashboard"에 연결
​        ㄴ clusterrolebinding

ㄴ kubectl describe sa -n kubernetes-dashboard kubernetes-dashboard (token확인)

<br>

### dashboard 에 admin 권한 적용

 ㄴ mkdir dashboard_token && cd $_

 ㄴ vi ClusterRoleBinding.yaml

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
 name: kubernetes-dashboard2
 labels:
  k8s-app: kubernetes-dashboard
roleRef:
 apiGroup: rbac.authorization.k8s.io
 kind: ClusterRole
 name: cluster-admin
subjects:
\- kind: ServiceAccount
 name: kubernetes-dashboard
 namespace: kubernetes-dashboard
:wq
```

<br>

### 토큰 생성

 ㄴ kubectl get secrets -n kubernetes-dashboard

\------------------------------------------------------------------------------------------------------------------

NAME                TYPE                 DATA  AGE
default-token-d6jwq        kubernetes.io/service-account-token  3   22m
kubernetes-dashboard-certs     Opaque                0   22m
kubernetes-dashboard-csrf     Opaque                1   22m
kubernetes-dashboard-key-holder  Opaque                2   22m
kubernetes-dashboard-token-l7b59  kubernetes.io/service-account-token  3   22m

\------------------------------------------------------------------------------------------------------------------

 ㄴ kubectl describe secret -n kubernetes-dashboard kubernetes-dashboard-token-l7b59

 ㄴ 토큰 복사해두기 (대시보드 웹페이지 접속 토큰)

<br>

### cert,key gen

 ㄴ grep 'client-certificate-data' ~/.kube/config | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.crt
 ㄴ grep 'client-key-data' ~/.kube/config | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.key
 ㄴ cd dashboard_token
 ㄴ mv ../kubecfg.crt .
 ㄴ mv ../kubecfg.key .
 ㄴ openssl pkcs12 -export -clcerts -inkey kubecfg.key -in kubecfg.crt -out kubecfg.p12 -name "kubernetes-admin"
 ㄴ cp /etc/kubernetes/pki/ca.crt .



### Linux 에서 발급한 인증서를 Windows로 cert 등록

 ㄴ winscp 이용하여 key file 윈도우로 이동

 ㄴ powershell 관리자 권한 실행

 ㄴ certutil.exe -addstore "Root" D:\k8s\dashboard_token\ca.crt

 ㄴ certutil.exe -p dkqcnr100% -user -importPFX D:\k8s\dashboard_token\kubectl.p12

 ㄴ win+r -> certmgr.msc (인증서 등록)

 ㄴ https://192.168.0.10:6443/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

\* 접속 안되면 브라우저 완전 kill & cache 삭제 후 재접속 *