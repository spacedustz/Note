## **💡 Secret**

ConfigMap과 비슷하게 Volumn과 환경변수 방식으로 Pod에 정보를 주입한다.

<br>

### **정의**

- Password, API Key, SSH Key등 보안이 중요한 정보를 컨테이너에 주입해야 할 때 사용
- ConfigMap과 사용법이 비슷하지만 Secret은 ConfigMap에 비해 민감한 정보를 주입하는게 목적이다.
- Kubernetes는 기본적으로 Secret의 값을 etcd에 저장하며 Base64 인코딩을 한다.
- RBAC를 이용해 Secret 오브젝트에 대한 읽기 권한을 잘 설정해야 한다.
  ex: ConfigMap과 Secret을 구분 보관하여 사용자별로 권한을 나눠준다.

<br>

### **종류**

- **OPaque (Generic)**
  - 일반적인 용도의 시크릿
  - ConfigMap과 동일한 목적으로 사용 가능
  - 민감한 데이터를 컨테이너에 전달하는 목적으로도 사용 가능
- **DockerConfigJson**
  - 도커 이미지 저장소 인증 정보
  - Docker Hub나 ECR같은 레지스트리 서비스는 Private 이미지를 가져올 때 추가 인증 필요
  - 그 인증에 필요한 정보를 Secret에 생성하고, Pod를 띄울때마다 이미지 Pull에 필요한
    Secret을 사용할 수 있게 해야함.
- **TLS**
  - TLS 인증서를 Secret으로 관리하고자 할 때 사용
  - Pod나 Service같은 오브젝트에서 TLS를 이용해 통신 암호화가 가능하다.
- **Service-Account-Token**
  - RBAC 리소스인 ServiceAccount와 연관이 있다.
  - ServiceAccount는 Pod에 연결되어 해당 Pod의 권한을 설정해주는 역할을 한다.
  - ServiceAccount가 연결이 되면 ServiceAccount에 대한 인증 정보를 담은 토큰이 자동생성된다.

------

## **💡 생성**

ConfigMap과의 차이점

ConfigMap은 명령어 커맨드 전달 시에 종류(타입)를 명시할 필요가 없었는데,
Secret은 종류를 추가로 기입해줘야 한다는 점이다.

<br>

### **envFrom 방식**

envFrom방식에는 configMapRef와 secretRef 2가지 옵션이 있다.

여기엔 순서가 중요하며, 뒤에 나오는게 앞의 것을 덮어씌울 수 있다.

그래서 각 옵션에 중복되는 Key가 있다면 배치를 잘 해야 한다.

apply도 ConfigMap과 Secret을 먼저 해준 수 Deployment를 적용해줘야 한다.

<br>

**Kubectl 기반 생성**

```bash
$ kubectl create secret {secret 종류} {secret 이름} --dry-run -o yaml
$ kubectl create secret {secret 종류} {secret 이름} --from-file {파일명/파일경로} --dry-run -o yaml
$ kubectl create secret {secret 종류} {secret 이름} --from-file {key}={파일명/파일경로} --dry-run -o yaml
$ kubectl create secret {secret 종류} {secret 이름} --from-file {key}={파일명/파일경로} --dry-run -o yaml
$ kubectl create secret {secret 종류} {secret 이름} --from-file {key}={파일명/파일경로} --dry-run -o yaml --from-literal {key}={value}
```

<br>

**Yaml 기반 생성 (선언형)**

아래의 예시는 ConfigMap과 Secret의 생성 예시이다.

ConfigMap에는 민감정보인 Password를 빼서 Secret에 넣었다.

Secret의 stringData 하단에 환경변수를 세팅해주지 않으면 Base64 인코딩 에러가 발생한다.

```yaml
# ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-cm
data:
  MYSQL_DATABASE: kubernetes


# Secret
apiVersion: v1
kind: Secret
metadata:
  name: my-sc
stringData:
  MYSQL_ROOT_PASSWORD: 1234
# data:
  # MYSQL_ROOT_PASSWORD: YmFrdW1hbmRv
$ kubectl create secret generic my-sc --from-literal MYSQL_ROOT_PASSWORD=1234 --dry-run -o yaml
```

<br>

**Deployment에 Secret 추가**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      name: mysql
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mariadb:10.7
        envFrom:
        - configMapRef:
            name: my-cm
        - secretRef:
            name: my-sc
```

<br>

**배포된 Pod의 환경변수 확인**

```bash
$ kubectl exec -it deploy/mysql bash
$ echo $MYSQL_ROOT_PASSWORD
$ echo $MYSQL_DATABASE
```

------

### **Volume 방식**

위에서 생성한 ConfigMap & Secret을 활용한 Deployment 내의 Pod 컨테이너 볼륨 마운트 예시이다.

env가 아닌, envFrom을 황용하여 ConfigMap과 Secret을 전체 참조한다.

volumns의 mysql-config는 만든 ConfigMap을 참조하고 mysql-secret은 만든 Secret을 참조한다.

volumnMounts는 volumns에서 참조하는 데이터를 마운트하는 옵션이다.

mysql-config와 mysql-secret이라는 이름의 volumn을 각각 지정한 경로에 마운트한다.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      name: mysql
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mariadb:10.7
        envFrom:
        - configMapRef:
            name: my-cm
        - secretRef:
            name: my-sc
        volumeMounts:
        - mountPath: /tmp/config
          name: mysql-cm
        - mountPath: /tmp/secret
          name: mysql-sc
      volumes:
      - name: mysql-config
        configMap:
          name: my-cm
      - name: mysql-secret
        secret:
          secretName: my-sc    
```

------

## **💡 Secret의 선언적 관리**

Secret을 Yaml 명세에 코드로 담는 선언적 관리 방식의 편의성은 아주 좋지만,

이를 Git과 같은 버전관리 시스템에서 관리하면 기밀정보의 유출이 될 수 있다.

보안관점에서 안전하면서 선언적 관리의 이점을 동시에 취할수 있는지 알아보자.

<br>

### **External Secrets**

- HshiCorp Valut, AWS Secret Manager 등과 통합하여 문제를 해결하는 방식이다.
- ExternalSecret 오브젝트를 생성하면 컨트롤러가 Provider로부터 기밀 값을 가져와서
  Secret 오브젝트를 생성해준다.
- 클라우드 서비스같이 외부 도구를 이용한 암호화 방식이다.

<br>

### **Sealed Secrets**

- SealedSecret 오브젝트를 생성하면 컨트롤러가 복호화하여 Secret 오브젝트를 생성하는 방식이다.
- Sealed Secret을 사용하면kubeseal CLI라고 하는 또 다른 커맨드 툴을 사용해야 하는데
  이 툴이 컨트롤로와 통신하며 데이터를 암호화 한다.
- SealedSecret은 클러스터 상에서만 복호화된 Secret 오브젝트가 사용될 수 있게 관리해준다.
- 즉, Git과 같은 공간에 데이터가 암호화된 상태로 올라가기 때문에 보안성을 챙길 수 있다.
- 내부적으로 라이브러리만 사용하여 암호화하는 방식이다.