## **💡 Deployments**

replicaset의 상위 오브젝트

replicaset에 없는 배포 작업의 세분화, 롤링업데이트, revision 등의 기능을 사용 가능

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/k8s_deployment.png) 

<br>

### **Yaml & kubectl 기반 Deployment 생성**

```yaml
# 생성, --replicas=3 으로 레플리카 수 지정 가능
kubectl create deployment [deploy-name] --image=[image-name] --dry-run=client -o yaml > [yaml-name]

# Yaml 생성
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

```bash
# 생성
kubectl apply -f [deployment-name].yaml

# Deployment Update
kubectl set image deployment/[deploy-name] [container-name]=[image-name]:[version]

# revision
kubectl apply -f deployment-nginx.yaml --record     * --record : revision Enable

kubectl set image deployment [deploy_name] nginx=nginx:1.11 --record   * update image & revision

kubectl rollout history deployment [deploy_name]   * revision history   1 전 / 2 최근

kubectl rollout undo deployment [deploy_name] --to-revision=1   * revision 1번으로 rolling update

# rollout 기록에 change-cause 버전 기록
metadata:
  annotations:
    kubernetes.io/change-cause: [기록할 단어]
    
# Deployment 배포 일시중지
kubectl rollout pause deployment/[deploy-name]

# Deployment 배포 재시작
kubectl rollout resume deployment/[deploy-name]

# Deployment 전체 Pod 재시작
kubectl rollout restart deployment/[deploy-name]
```

