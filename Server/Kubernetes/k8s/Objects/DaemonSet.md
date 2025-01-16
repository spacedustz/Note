## **💡 DaemonSet**

클러스터 전체에서 **공통적으로 사용되는 pod**를 띄울때 사용하는 컨트롤러

ex: 로그수집기나 노드를 모니터링하는 pod 등 클러스터 전체에 항상 실행시켜 둬야 하는 pod를 실행할때 사용

taint와 tolleration을 사용하여 특정 노드들에만 실행가능 **(tolleration은 taint보다 우선순위가 더 높다)**

<br>

### **Yaml 생성**

```yaml
# DaemonSet 생성

apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: test-elasticsearch
  namespace: kube-system
  labels:
    k8s-app: test-logging
spec:
  selector:
    matchLabels:
      name: test-elasticsearch
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        name: test-elasticsearch
    spec:
      containers:
      - name: container-elasticsearch
        image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
      terminationGracePeriodSeconds: 30
```

- apiVersion apps/v1 → 쿠버네티스의 apps/v1 API를 사용 
- kind: DaemonSet → DaemonSet의 작업으로 명시
- metadata.name → DaemonSet의 이름을 설정
- metadata.namespace → 네임스페이스를 지정 합니다. kube-system은 쿠버네티스 시스템에서 직접 관리하며 보통 설정 또는 관리용 파드를 설정
- metadata.labels → DaemonSet를 식별할 수 있는 레이블을 지정
- spec.selector.matchLabels → 어떤 레이블의 파드를 선택하여 관리할 지 설정
- spec.updateStrategy.type → 업데이트 방식을 설정
  이 코드에서는 롤링 업데이트로 설정 돼었으며 OnDelete 등의 방식으로 변경이 가능
  롤링 업데이트는 설정 변경하면 이전 파드를 삭제하고 새로운 파드를 생성
- spec.template.metadata.labels.name → 생성할 파드의 레이블을 파드명: "" 으로 지정
- spec.template.spec.containers → 하위 옵션들은 컨테이너의 이름, 이미지, 메모리와 CPU의 자원 할당
- terminationGracePeriodSeconds 30 → 기본적으로 kubelet에서 파드에 SIGTERM을 보낸 후
  일정 시간동안 graceful shutdown이 되지 않는다면 SIGKILL을 보내서 파드를 강제 종료
  이 옵션은 그레이스풀 셧다운 대기 시간을 30초로 지정하여 30초 동안 정상적으로 종료되지 않을 경우 SIGKILL을 보내서 강제 종료 시킴

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/k8s_daemonset.png)