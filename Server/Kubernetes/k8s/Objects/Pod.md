## **💡 Pod**

클러스터 안에서 배포되는 가장 작은 단위의 객체

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/k8s_pod.png) 

------

### **기본 개념**

- 1개 이상의 컨테이너를 모아놓은 것으로 쿠버네티스 어플리케이션의 최소 단위
- Pod는 노드IP와 별개로 고유IP를 할당 받으며, Pod 안의 Container들은 그 IP를 공유한다
- 파드 안의 컨테이너들은 동일한 볼륨과 연결이 가능하다
- Pod의 Lifecycle
  - Pending 단계로 시작해서 컨테이너 실행이 성공하면 OK, 실패시 Pendind & Failed
  - Pod 실행 실패 시 kubectl logs [pod-name] | events 을 입력해 실패 이벤트 로그를 확인

<br>

#### **Kubectl 기반 Pod 생성 & 관리**

```bash
# Pod 생성
kubectl run [pod-name] --image=[image-name] --dry-run=client -o yaml > [yaml-name].yaml

# Yaml 파일 기반 생성
kubectl create / apply -f [yaml-name].yaml

# Pod 접속
kubectl exec -it [pod-name] /bin/bash

# Pod Network Check
kubectl get pods -o wide
curl [pod-ip]

# Pod 정보 확인
kubectl describe pod [pod-name]
```

<br>

#### **Yaml 기반 Pod 생성**

```yaml
# Yaml 기반 Pod 생성
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  containers:
  - name: nginx-container
    image: nginx
```

------

### **Pod Life Cycle**

쿠버네티스에서 파드의 생명 주기는 크게 **네 가지 단계**로 구분된다.

1. Pending : 클러스터 내 파드 생성이 승인되었지만 아직 내부의 컨테이너가 완전히 시작되기 전이며, 아직 노드에 배치되지 않은 상태다.
2. Running : 파드가 클러스터의 특정 노드에 배치되었으며 내부의 모든 컨테이너가 생성 완료된 상태다. 하나 이상의 컨테이너가 구동되기 시작했거나 시작되는 중이다.
3. Succeeded : 파드 안의 컨테이너가 유한한 수의 작업을 실행한 후 종료되도록 설계되었을 때에만 볼 수 있다. 이 경우는 파드에 있는 모든 컨테이너가 해당 작업을 정상적으로 마치고 종료된 것이다.
4. Failed : 역시 파드 안의 컨테이너가 유한한 수의 작업을 실행한 후 종료되도록 설계되었을 때에만 볼 수 있다. 이 경우는 파드에 있는 컨테이너 중 하나 이상이 비정상 종료되었을 때 발생한다.

이 외에도 특수한 경우에만 파드에 부여되는 상태 정보(.status.phase)가 추가로 존재한다.

- unknown : 파드의 상태 확인이 불가한 경우다. 대개 해당 노드의 네트워크 문제로 발생한다.
- terminating : 파드를 삭제시켰을 때 볼 수 있다. 일반적으로 파드는 30초의 유예 시간 후에 완전히 삭제되며, 즉시 삭제를 원한다면 kubectl delete 명령에 --force 옵션을 더하면 된다. 이 항목은 파드의 생명 주기로 취급되지 않는다.

파드의 생명 주기와 현재 상태는 kubelet이 주기적으로 모니터링한다. 이렇게 모니터링된 상태 정보는 kubectl get pods의 출력 결과 중 STATUS 필드에서 볼 수 있다. 해당 파드 오브젝트의 .status.phase 필드에서도 확인 가능하며, 이때 필요한 명령어는 다음과 같다.

```bash
kubectl get pod <파드명> -o jsonpath='{.status.phase}'
```

------

### **파드 안 컨테이너의 Restart Policy**

파드에 포함된 모든 컨테이너는 **오류가 생겼을 때 재시작하기 위한 정책**을 가지고 있다

정책은 3종류로 구분되며, 파드의 Yaml 중 spec.restartPolicy를 통해 부여한다

1. Always : 컨테이너가 정상/비정상 종료 시 항상 재시작한다. **기본값**이다.
2. Onfailure : 컨테이너가 오직 비정상 종료되었을 때에만 재시작한다.
3. Never : 재시작하지 않는다.

컨테이너의 재시작 설정은 일정한 **지연 시간**을 두고 이루어진다.

이 지연 시간은 **최대 300초 한도 내에서 10초의 지수 단위로 반영**된다.

예를 들어 첫번째 재시작 시도는 10초 후에, 그 다음번의 재시작 시도는 20초 후에,
그 다음은 40초 후에 이루어지는 식이다.

만약 재시작에 성공한 컨테이너가 10분 동안 이상 없이 구동 상태를 유지한다면 해당 지연 시간은 초기화된다.

------

### **컨테이너 상태 진단을 위한 프로브(Probe) 활용**

프로브가 컨테이너의 상태를 진단할 때에는 아래의 세 가지 방식이 쓰인다.

1. **HTTP 방식** : HTTP GET 요청을 보내서 2XX 또는 3XX 응답이 오는지 체크한다.
2. **TCP 방식** : TCP의 [3-Way Handshake](https://velog.io/@averycode/네트워크-TCPUDP와-3-Way-Handshake4-Way-Handshake#-tcp의-3-way-handshake)가 잘 맺어졌는지 체크한다.
3. **Exec 방식** : 컨테이너에 특정 명령을 실행해서 종료 코드가 0인지 체크한다.