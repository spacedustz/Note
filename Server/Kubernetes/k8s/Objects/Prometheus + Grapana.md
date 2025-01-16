## Prometheus + Grapana

Helm을 이용해 설치합니다.

---

## Install

설치에 앞서 사용할 namespace를 생성합니다.

```bash
kubectl create namespace monotoring
```

<br>

helm repo에 Prometheus 커뮤니티 helm-chard를 등록해줍니다.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

<br>

등록된 repo 정보를 업데이트 합니다.

```bash
helm repo update
```

<br>

Prometheus & Grapana를 설치합니다.

```bash
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
```

🚨 설치가 안되는 경우  [여기](https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml) 를 클릭해 내용을 복사한 뒤 values.yaml 파일을 생성하고 아래 명령어를 실행합니다.

```bash
helm install prometheus prometheus-community/kube-prometheus-stack -f "values.yaml" --namespace monitoring
```

<br>

성공적으로 설치가 완료되면 해당 Pod들이 떠있는지 확인합니다.

```bash
kubectl --namespace monitoring get pods -l "release=prometheus"
```

<br>

웹에 접속해 그라파나에 접근해 정상 동작하는지 확인합니다. 

❗ **_<ip주소:3000>_**

<br>

포트가 안열려있다면 포트를 열고 포워딩을 해줍니다.

```null
kubectl port-forward service/prometheus-grafana 3000:80 --namespace monitoring
```

<br>

정상적으로 접근이 되면 아래와 같은 로그인 화면이 출력됩니다.

Default 접속 계정/비밀번호는 **_admin : prom-operator_** 입니다.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/monitoring.png)

---

## 모니터링 설정

왼쪽 탭에서 Dashboard - New Dashboard 선택 후 필요한 지표를 직접 구성해서 꾸밀 수 있습니다.

이 예시에서는 다른사람이 만들어놓은 대시보드를 Import 하겠습니다.

[Dashboards]([https://grafana.com/grafana/dashboards/?search=kubernetes](https://grafana.com/grafana/dashboards/?search=kubernetes)) 링크에서 마음에드는 대시보드는 선택한 뒤 Copy ID를 눌러 복사합니다.

<br>

왼쪽 탭 Dashboard - Import를 선택하고 복사한 ID를 붙여넣고 Load를 눌러줍니다.

그러면 아래 그림처럼 Import할 수 있는 화면으로 변경됩니다.

저는 이미 Import를 해서 Override 하라고 뜨네요.

<br>

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/monitoring2.png)

<br>

Import 한 뒤 대시보드에서 Import한걸 선택하면 아래처럼 모니터링 대시볻가 출력됩니다.

![](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/monitoring3.png)