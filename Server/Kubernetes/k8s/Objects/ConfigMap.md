## **💡 ConfigMap (Key - Value)**



**ConfigMap & Secret** 

- 어플리케이션을 배포하다 보면 환경에 따라 다른 설정값을 사용하는 경우 사용한다
- Github Actions의 Secret처럼 컨테이너 런타임 시 변수나 설정값을 Pod가 생성될 때 넣어줄 수 있다
- ConfigMap
  - Key - Value 형식으로 저장됨
  - Config Map을 생성하는 방법은 literal로 생성하는 방법과 파일로 생성하는 2가지 방법이 있다
- ConfigMap이나 Secret에 정의하고, 이 정의해놓은 값을 Pod로 넘기는 2가지 방법이 있다
  - 값을 Pod의 환경 변수로 넘기는 방법
  - 값을 Pod의 Disk Volume으로 Mount 하는 방법

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/img.png) 

------

#### **Literal 형식 ConfigMap 생성**

- 키:값이 language : java인 ConfigMap이라고 가정한다

```bash
# kubectl create configmap [name] --from-literal=[key]=[value] 형식

kubectl create configmap hello-cm --from-literal=language=java
```

- yaml 형식 생성은 data.[key:value] 형식으로 만든다
- data 항목에 키: 값 형식으로 여러개의 값을 넣을 수 있다.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: hello-cm
data:
  language: java
```

- 아래 코드는 deployment 오브젝트에 환경변수로 적용한 yaml 설정이다

```yaml
env:
- name: LANGUAGE
  valueFrom:
    configMapKeyRef:
       name: test-configmap
       key: language
```

------

#### **File 형태 ConfigMap 생성**

위와 같이 개별 값을 공유해도 되지만, 설정을 파일 형태로 Pod에 공유하는 방법이다.

이 방법으로 생성했을때, 키는 파일명이고 값은 파일의 내용이 된다.

<br>

- profile.properties라는 파일이 있고 설정 파일 형태로 Pod에 공유한다
  myname = hello
  email = abc@abc.com
  address = seoul

```bash
# 명령어 생성
kubectl create configmap cm-file --from-file=[경로, 파일이름]
```

<br>

아래 코드는 deployment에 파일을 환경변수로 적용한 yaml 설정이다

```yaml
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: cm-file-deployment
spec:
  replicas: 3
  minReadySeconds: 5
  selector:
    matchLabels:
      app: cm-file
  template:
    metadata:
      name: cm-file-pod
      labels:
        app: cm-file
    spec:
      containers:
      - name: cm-file
        image: gcr.io/terrycho-sandbox/cm-file:v1
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
        
        # 이 부분
        env:
        - name: PROFILE
          valueFrom:
            configMapKeyRef:
               name: cm-file
               key: profile.properties
```

<br>

**디스크 볼륨으로 마운트하기**

configMap을 디스크 볼륨으로 마운트해서 사용하는 방법은 volumes 을 configMap으로 정의하면 된다.

위의 예제에서 처럼 volume을 정의할때, configMap으로 정의하고
configMap의 이름을 cm-file로 정의하여, cm-file configMap을 선택하였다.

<br>

이 볼륨을 volumeMounts를 이용해서 /tmp/config에 마운트 되도록 하였다.

이때 중요한점은 마운트 포인트에 마운트 될때, 파일명을 configMap내의 키가 파일명이 된다.

```yaml
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: cm-file-deployment-vol
spec:
  replicas: 3
  minReadySeconds: 5
  selector:
    matchLabels:
      app: cm-file-vol
  template:
    metadata:
      name: cm-file-vol-pod
      labels:
        app: cm-file-vol
    spec:
      containers:
      - name: cm-file-vol
        image: gcr.io/terrycho-sandbox/cm-file-volume:v1
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
        
        # 이 부분
        volumeMounts:
          - name: config-profile
            mountPath: /tmp/config
      volumes:
        - name: config-profile
          configMap:
            name: cm-file
```