## 💡 **Namespace**

- 물리 클러스터 기반의 가상 클러스터, 기본 네임스페이스는 default 이다.
- 같은 네임스페이스 내에서 리소스의 이름은 중복 불가능

------

### **Kubectl 기반 Namespace 생성**

```bash
# 1. yaml의 metadata 하위 name: 에 지정해도 됨
# 2. 리소스를 생성할때 -n [namespace-name] 으로 옵션 지정도 가능
# 3. kube-node-lease, kube-system, kube-public 네임스페이스는 사용하지 않는게 좋음

# Namespace 생성
kubectl create namespace [namespace-name]

# Namespace 조회
kubectl get ns

# 기본 Namespace의 모든 Resource 조회
kubectl get all -o wide -n default

# 현재 사용중인 기본 네임스페이스 변경
kubectl config set-context --current --namespace=[namespace-name]
# 변경된 네임스페이스 확인
kubectl config view | grep namespace
```

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/k8s_namespace.png)

------

### **Yaml 기반 Namespace 생성**

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: test  
spec:
  limits:
  - default:
      cpu: 1
    defaultRequest:
      cpu: 0.5
    type: Container
```