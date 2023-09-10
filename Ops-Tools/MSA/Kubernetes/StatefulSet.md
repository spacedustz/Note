## **💡 StatefulSet**

어플리케이션의 상태를 저장하고 관리하는 쿠버네티스 오브젝트

replication controller와 같은 복제본을 가지고 있는 컨트롤러를 의미함

<br>

기존 Pod를 삭제하고 생성할 때 상태가 유지되지 않는 한계가 있고 삭제-생성을 하면 새로운 가상환경이 된다
하지만 StatefulSet으로 생성되는 Pod는 영구 식별자를 가지고 상태를 유지시킬 수 있다

<br>

### **Yaml 기반 생성**

```yaml
//myapp-sts.yaml

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: myapp-sts
spec:
  selector:
    matchLabels:
      app: myapp-sts
  serviceName: myapp-svc-headless
  replicas: 2
  template:
    metadata:
      labels:
        app: myapp-sts
    spec:
      containers:
      - name: myapp
        image: ghcr.io/c1t1d0s7/go-myweb
        ports:
        - containerPort: 8080
```

<br>

### **사용 시 주의 사항**

- Pod에 사용할 Storage는 PVC를 통해서만 가능하다.
  - 미리 PV를 생성해놓거나 StorageCalass를 이용한 동적 프로비저닝 사용
- StatefulSet을 삭제하거나 Pod를 삭제하더라고 볼륨은 남아있다.
  - 데이터의 안전 보장
- Headless Service 필요
  - Pod의 고유한 네트워크 식별자를 부여하기 위함.

<br>

### **Stateless Application에서의 StatefulSet**

Replication Controller & Replicaset은 상태를 저장하지 않는 쿠버네티스의 오브젝트이다.

위의 두 오브젝트는,
각각 별도의 볼륨을 사용할 수 있는 방법을 제공해주지 않아 모두 같은 볼륨으로 같은 상태를 가진다.
<br>

Stateless 어플리케이션을 예로 들면 Apache & IIS 등이 있다.

해당 서비스가 죽으면 단순 replica를 교체해주면 된다.

볼륨의 경우 같은 내용을 서비스하기 때문에 필료하다면 하나의 볼륨에 다수가 접근 가능하다.

<br>

Stateful Application은 각각의 역할이 있는데
Primary Main DB가 있고 Secondary로 Primary가 죽으면 대체할 DB가 존재하며
이를 감시하는 Arbiter가 있다.

<br>

네트워크 트래픽에서는 대체로 내부 시스템들이 데이터베이스에 사용되는데 각 앱에 특징에 맞게 들어가야 한다.

<br>

App1에는 메인DB로 Read/Write가 가능하므로 내부 시스템들이 CRUD를 모두 하려면 이곳으로 접근해야하고

App2는 Read 권한만 있기 때문에 조회만 할 때 트래픽 분산을 위해 사용할 수 있으며

App3은 Primary와 Secondary를 감시하고 있어야 하기 때문에 App1,2에 연결이 되어야 한다.

<br>

**쿠버네티스에서 마이크로서비스 구조로 동작하는 어플리케이션은 보통 무상태인 경우가 많다.**

위의 경우 단순히 Deployment, Replicaset을 통해 쉽게 배포가 가능하다.


또, DB처럼 상태를 같은 어플리케이션을 쿠버네티스에서 실행하는 것은 매우 복잡한 일이다.

왜냐하면 Pod 내부의 데이터를 어떻게 관리해야 할 지, 상태를 갖는 Pod에 어떻게 접근을 할 지 꼼꼼히 고려해야 한다.

<br>

**이 때 StatefulSet을 통해 어느정도 해결을 할 수 있다.**

즉, Pod마다 각각 다른 스토리지를 사용해 각각 다른 상태를 유지하기 위해 사용한다.

그리고 목적에 따라 해당 Pod에 연결하기 위한 Headless Service를 달아주면 된다.

<br>

**결론**

Pod의 상태를 관리하며 어플리케이션이 죽으면 완전히 동일한 Pod를 생성한다.
Pod의 순서 및 고유성을 보장하며 각각 고유의 볼륨을 가지고 있다.

|                                    | **레플리카셋**                                               | **스테이트풀셋**                                        |
| ---------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------- |
| 파드 생성시 이름 설정              | Random 이름으로 설정 cf) Pod-ska25, Pod-dk15d ...            | Ordinal index 이름으로 생성 cf) Pod-0, Pod-1, Pod-2 ... |
| 파드 생성 시 순서                  | 동시 생성                                                    | 순차 생성. 0->1->2...                                   |
| 파드 Recreate 시                   | 파드 이름 변경 cf) Pod-sdf34 -> Pod-vjng3                    | 파드 이름 유지 cf) Pod-2 -> Pod-2                       |
| 파드 삭제 시 순서                  | 동시 삭제                                                    | 인덱스 높은 순부터 순차 삭제 2->1->0                    |
| 볼륨 생성 하는 방법                | PVC를 직접 생성                                              | volumeClaimTemplates 을 통한 동적 생성                  |
| 파드의 수를 늘리면 PVC는?          | 1개의 PVC에 모두 연결                                        | 각각의 PV 를 생성한 뒤 연결                             |
| PVC 연결된 특정 파드를 죽으면?     | NodeSelector 가 설정 되어 있다면 해당 노드에 동일한 서비스로 랜덤한 파드이름 생성 (같은 노드에 PVC,파드가 생성되지 않으면 연결되지 않음) | 특정 파드와 동일한 파드를 생성 후 기존 PVC와 연결       |
| PVC가 연결된 파드 수를 0으로 하면? | PVC도 삭제함                                                 | PVC는 삭제하지 않음                                     |

<br>

### **언제 사용해야 할까?**

- 안정적이고 고유한 네트워크 식별자가 필요한 경우
- 지속적인 스토리지를 사용해야하는 경우
- 질서정연한 Pod의 배치와 확장을 원하는 경우
- Pod의 Auto Rolling Update를 사용하기 원하는경

<br>

### **문제점**

- StatefulSet과 관련된 볼륨은 삭제되지 않음 (관리 필요)
- Pod의 Storage는 PV나 StorageClass로 Provisining을 수행해야 함
- 롤링 업데이트를 하는 경우 수동으로 복구해야 할 수 있다 (기존 스토리지와 충돌로 인한 어플리케이션 오류)
- Pod Network ID를 유지하기 위해 Headless 서비스 필요 (ClusterIP를 None으로 지정하여 생성 가능)
- Headless 서비스 자체는 IP가 할당이 안되지만 서비스의 도메인 네임을 사용해 각 Pod에 접근 가능하며,
  기존의 서비스와 달리 kube-proxy가 밸런싱이나 프록시 형태로 동작하지 않음

<br>

### **Pod 이름 부여 방식**

스테이트풀셋의 각 파드 이름은 컨트롤러의 이름에 0부터 시작하는 순서 색인이 붙는다.

<br>

- 파드의 이름 형식

```
{StatefulSet-Name}-{Order}
```

<br>

- 파드 이름 예

```
mysts-0
mysts-1
```

<br>

### **Pod DNS Adress**

헤드리스 서비스와 스테이트풀셋을 같이 사용하는 경우 파드의 DNS 주소는 다음과 같다.

- 파드의 DNS 주소 형식

```
{Pod_Name}.{Governing_Service_Domain}.{Namespace}.svc.cluster.local
```

<br>

- 파드의 DNS 주소 예

```
mysts-0.mysts.default.svc.cluster.local
mysts-1.mysts.default.svc.cluster.local
```

<br>

{Governing_Service_Domain}은 statefulset.spec.serviceName에 선언하며 해당 필드에 헤드리스 서비스의 이름을 지정한다.

<br>

### **스토리지 볼륨**

스테이트풀셋의 파드는 각각 고유한 PVC를 생성해 고유한 PV를 가진다.

statefulset.spec.volumeClaimTemplates 필드에 선언하며, 미리 PV를 준비하거나, StorageClass를 통해 PV를 생성할 수 있다.

<br>

스테이트풀셋의 파드가 삭제되더라도 해당 볼륨은 안정적인 데이터 보존을 위해 자동으로 삭제되지 않눈다.

<br>

### **스케일링**

- 3개의 복제본이 있는 스테이트풀셋 파드는 0 -> 1 -> 2 순서대로 생성된다
- 파드를 scale out 하기 전 기존 파드는 Running 및 Ready 상태여야 한다.
- 파드가 scale in에 의해 삭제될 때는 역순을 진행된다.