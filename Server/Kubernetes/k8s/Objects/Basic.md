## 💡 **Kubernetes 구성**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Kubernetes.png)

------

### **컨트롤 플레인 컴포넌트**

클러스터에 관한 전반적인 결정을 수행하고 클러스터 이벤트를 감지하고 반응한다.

- API-Server
  - Control Plane(Master) 의 중심 컨트롤 플레인 컴포넌트, 모든 역할의 출발점
- etcd
  - 모든 클러스터의 데이터가 저장 되어 있는 고가용성 Key-Value Database
  - etcd는 항상 백업해두자
- Scheduler
  - 새로 생성된 Pod를 감지하고, 컨테이너를 생성할 노드를 선택하는 컨트롤 플레인 컴포넌트
  - 결정을 위해 고려되는 요소
    - 리소스에 대한 개별 & 총체적 요구사항
    - 하드웨어, 소프트웨오, 정책적 제약
    - Affinity & Anti-Affinity 명세
    - 데이터 지역성, 데드라인
- Controller-Manager
  - 컨트롤러 프로세스를 실행하는 컨트롤 플레인 컴포넌트
  - 각 컨트롤러는 분리된 프로세스이지만 복잡성을 낯추기 위해 모두 단일 바이너리로 컴파일되고
    단일 프로세스 내에서 실행된다
  - 컨트롤러는 다음을 포함한다
    - **Node-Controller :** 노드가 다운되었을 때 통지와 대응에 관한 책임
    - **Job Controller :** 일회성 작업을 나타내는 잡 오브젝트를 감시, 작업을 완료할 때까지 동작하는 Pod 생성
    - **Endpoint-Controller :** 엔드포인트 오브젝트를 채운다 (서비스와 파드 연결)
    - **Service Account & Token-Controller :** 새로운 네임스페이스에 대한 기본 계정과 API 접근 토큰 생성

------

### **노드 컴포넌트**

동작중인 파드를 유지시키고 쿠버네티스 런타임 환경을 제공하며, 모든 노드에서 동작한다

- Kubelet
  - 각 노드의 실행 에이전트, Node & Pod의 Health Check를 담당
  - 다양한 메커니즘을 통해 제공된 PodSpec의 집합을 받아서 컨테이너가 해당 파드 스펙에 따라
    건강하게 동작하는 것을 확실히 한다.
  - 쿠버네티스를 통해 생성되지 않은 Pod는 관리하지 않는다
- Kube-Proxy
  - 각 노드의 실행되는 네트워크 프록시로 쿠버네티스의 서비스 개념의 구현부이다
  - 노드의 네트워크 규칙 유지관리
- Container Runtime
  - 쿠버네티스가 Docker 지원을 중단한다
  - containerd, CRI-O와 같은 컨테이너 런타임 및 모든 k8s CRI 구현체를 지원한다

------

### **Add-On**

쿠버네티스 리소스(데몬셋, 디플로이먼트 등)을 이용해 클러스터 기능을 구현한다

클러스터 단위의 기능을 제공하기 때문에 애드온에 대한 네임스페이스 리소스는 kube-system에 속한다

- DNS
  - 다른 애드온은 필수가 아니지만 DNS는 모든 쿠버네티스 클러스터에서 갖춰져 있어야 한다
  - 클러스터 DNS는 구성환경 내 다른 DNS 서버와 더불어, 쿠버네티스 서비스를 위해 DNS 레코드를 제공해주는 DNS 서버다
  - 쿠버네티스에 의해 구동되는 컨테이너는 DNS 검색에서 이 DNS 서버를 자동으로 포함한다
- Web UI ([Dashboard](https://kubernetes.io/ko/docs/tasks/access-application-cluster/web-ui-dashboard/))
  - 쿠버네티스 클러스터를 위한 범용 웹 기반 UI이다
  - 클러스터 뿐 아니라 클러스터에서 동작하는 어플리케이션에 대한 관리와 문제 해결을 할 수 있도록 해준다
- Container Resource Monitoring
  - [컨테이너 리소스 모니터링](https://kubernetes.io/ko/docs/tasks/debug/debug-cluster/resource-usage-monitoring/)은 중앙 DB내의 컨테이너들에 대한 포괄적인 시계열 메트릭을 기록하고
    그 데이터를 열람하기 위한 UI를 제공해준다
- Cluster-Level-Logging
  - [클러스터 레벨 로깅](https://kubernetes.io/ko/docs/concepts/cluster-administration/logging/) 메커니즘은 검색/열람 인터페이스와 함께 로그 저장소에 컨트이너 로그를 저장한다