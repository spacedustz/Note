## 💡 Labels

쿠버네티스 객체를 식별할 수 있고, 그룹으로 구성 가능한 기능

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/k8s_labels.png)  

- 좋은 Use-Case는 Pod에 배치된 어플리케이션을 기반으로 그룹핑 하는것과
  환경이나 고객 & 팀 & 소유자 & 릴리즈 버전에 따라 그룹화 하는 다양한 레이블 규칙 개발 가능
- 리소스를 생성할때 레이블을 무조건 지정해서 사용하기
- 커밋 컨벤션 처럼 레이블 컨벤션을 도입하기
- Pob Template 활용, 파드 템플릿은 쿠버네티스 컨트롤러에서 파드를 생성하기 위한 manifest 파일임
- 공통적인 옵션들에 대한 레이블 리스트 만들기 (어플리케이션id, 버전, 소유자, 환경, 릴리즈 버전 등)
  - 더 광범위한 레이블 리스트 만들기
  - 쿠버네티스에서 추천하는 레이블 사용

------

### Lable List Exsample

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/k8s_labels2.png)  

```yaml
# 쿠버네티스 추천 레이블
apiVersion: v1
kind: Pod
metadata:
 labels:
    app.kubernetes.io/name: my-pod
    app.kubernetes.io/instance: Auth-1a
    app.kubernetes.io/version: “2.0.1”
    app.kubernetes.io/component: Auth
    app.kubernetes.io/part-of: my-app
    app.kubernetes.io/managed-by: helm

# Lable 수정
labels:
  app: mynginx  # 이 부분 수정 후

or

metadata:
  name: nginx-pod
  labels: # 이 부분
    app: nginx
    team: kube-team
    environment: staging

spec:
  replicas: 3
  selector:
    matchLabels: # 이 부분
      app: nginx
  template:
    metadata:
      labels: # 이 부분
        app: nginx

kubectl apply -f [pob-name].yaml

# Pod에 새로운 레이블 추가
kubectl label pod [pod-name] version=0.2

# 레이블 삭제
kubectl label pod [pod-name] version # 키 값만 입력

# 레이블 변경 team:kube-team -> team:ops
kubectl label --overwrite pods [pod-name] team=ops
```