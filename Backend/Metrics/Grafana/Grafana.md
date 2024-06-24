## Prometheus & Grafana - Status Monitoring

각 서버들의 상태 metric들을 수집하는 **Prometheus**와 그 metric 데이터들을 시각화 해주는 **Grafana** 구축 방법을 포스팅 합니다.

저는 현재 메인 서버가 있고 메인 서버에서 Prometheus를 이용해,

하위 서버들의 Metric을 받아 Grafana Dashboard를 통해 서버의 Resource들을 모니터링 할 예정이고,

툴 선정하기 전 가볍게 써보고 정하자는 생각으로 일단 간단하게 만들어 보았습니다.

---
## Metric 수집 대상 서버 설정

**Linux Server**

Main Server를 설정하기 전, 메트릭 수집을 원하는 서버에 `node-exporter` 컨테이너를 실행시켜 주면 Sub Server는 설정 완료입니다.

Linux에서 Exporter의 기본 포트는 9100 입니다.

```bash
sudo docker run -d --name=metric --restart=unless-stopped --net=host prom/node-exporter
```

<br>

**Windows Server**

[Windows Node Exporter](https://github.com/prometheus-community/windows_exporter/releases) 위 사이트에서 Windows 전용 Exporter 설치 파일인 msi 파일이 있는 곳에서 터미널을 관리자 권한으로 열어줍니다.

터미널에서 아래 명령을 입력해 설치합니다.

Windows 전용 Exporter에는 memory가 기본 Metric 수집 항목에 빠져있기 때문에 기본 메트릭으로 등록해주는 작업입니다.

```shell
msiexec /i windows_exporter-0.26.0-amd64.msi ENABLED_COLLECTORS="ad,adfs,cache,cpu,cpu_info,cs,container,dfsr,dhcp,dns,fsrmquota,iis,logical_disk,logon,memory,msmq,mssql,netframework_clrexceptions,netframework_clrinterop,netframework_clrjit,netframework_clrloading,netframework_clrlocksandthreads,netframework_clrmemory,netframework_clrremoting,netframework_clrsecurity,net,os,process,remote_fx,service,system,tcp,time,vmware" TEXTFILE_DIR="C:\custom_metrics" LISTEN_PORT="9182"
```

---
## Root Server 설정

우선 Prometheus 설정 파일인 `prometheus.yml`을 작성하기 위해 `~/metrics` 경로에 `prometheus` 디렉터리를 생성하고 파일을 만들어줍니다.

<br>

디렉터리 구조는 아래와 같습니다.

granafa와 prometheus 디렉토리 내부에는 아무 파일도 없지만 컨테이너가 실행되고,

설정 파일들을 작성 후, grafana, prometheus Container를 재시작 하면 해당 디렉토리들의 설정파일이 컨테이너 내부에 적용됩니다.

- docker-compose 파일은 metrics 디렉터리 내부에 있으며, compose up 시 이곳에서 진행합니다.
- grafana 디렉토리 : Grafana 설정 파일인 `defaults.ini`를 Container의 볼륨과 마운트합니다.
- grafana/data 디렉토리 : Grafana 컨테이너의 데이터 마운트
- prometheus 디렉토리 : Prometheus 설정 파일인 `prometheus.yml`을 Container의 볼륨과 마운트합니다.

```
/home/skw/metrics
├── docker-compose.yml
├── grafana
│   └── data (디렉토리)
│   └── defaults.ini
└── prometheus
    └── prometheus.yml
```

<br>

**docker-compose.yml**

Prometheus와 Grafana 컨테이너를 띄우기 위한 Docker Compose를 작성합니다.

Grafana Web 기본 비밀번호는 1234로 지정하고 현재 서버에서 3000번 포트는 사용중이어서 10000으로 포트포워딩 하였습니다.

`depends_on` 옵션은 프로메테우스 컨테이너에 의존한다는 의미로, 컨테이너 실행순서를 제어하는 옵션입니다.

```yaml
version: '3.7'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - /home/dains/metrics/prometheus:/etc/prometheus
    command:
      - --config.file=/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    depends_on:
      - prometheus
    volumes:
     - /home/skw/metrics/grafana/defaults.ini:/usr/share/grafana/conf/defaults.ini
     - /home/skw/metrics/grafana/data:/var/lib/grafana
    ports:
      - "10000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=1234
    restart: unless-stopped
```

<br>

Docker Compose를 실행하기 전 컨테이너 권한 설정 후, 이제 컨테이너들을 올려주고 잘 실행중인지 확인합니다.

```bash
# docker-compose.yml 파일 실행
docker-compose up -d

# 컨테이너 확인
docker ps
```

![](./1.png)

![](./2.png)

<br>

**prometheus.yml 파일 작성**

- 컨테이너가 실행됬으니 이제 prometheus 디렉토리에 `prometheus.yml` 파일을 작성해줍니다.
- Root 서버, Jetson 서버, 윈도우 서버 이렇게 3개의 스크랩으로 나누었으며, 임시로 4개 서버만 등록 하였습니다.
- 작성 완료 후, Prometheus 컨테이너를 재시작 하면 아래 설정이 컨테이너 내부로 들어가 적용됩니다.

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'Root'
    static_configs:
      - targets: ['192.168.0.5:9090'] # Root Server

  - job_name: 'Test'
    static_configs:
      - targets: ['192.168.0.6:9100'] # 하위 Linux 서버

  - job_name: 'Independence'
    static_configs:
      - targets: ['192.168.0.15:9100'] # 하위 Linux 서버

  - job_name: 'Local'
    static_configs:
      - targets: ['192.168.0.215:9182'] # 하위 왼도우 서버
```

<br>

**Grafana 설정 파일 수정 - defaults.ini**

- 만약 볼륨 마운트를 진행하지 않고 컨테이너 내부에서 파일을 뺴오는 방식으로 할 때
	- 우선 초기 파일이 없으므로 `docker cp Granafa:/usr/share/grafana/defaults.ini /home/skw/metrics/grafana` 명령을 통해 설정 파일을 복사합니다.
	- 그리고, 해당 설정파일에서 Grafana Panel Embedding을 위한 defaults.ini 설정을 수정합니다.
	- 나중에 Grafana Dashboard의 각 Panel을 다른 Web UI로 Embed를 하기 위해,
	- grafana 디렉토리(볼륨 마운트된)의 defaults.ini를 수정후 Grafana 컨테이너만 재실행 해주면 설정이 적용됩니다.
- 볼륨 마운트 옵션을 사용할 때는 아래 내용의 defaults.ini 파일을 만들고 볼륨 마운트를 해줍니다.

```
[server]
http_port = 3000
protocol = http
domain = 인스턴스 IP
root_url = %(protocol)s://%(domain)s:%(http_port)s/

[security]
allow_embedding = true

[auth.anonymous]
enabled = true
```

---
## Prometheus

Root Server에 띄운 Prometheus의 Port인 `http://{서버IP}:9090`으로 진입해 Prometheus 서버에 접속합니다.

상단의 Status - Targets를 클릭해보면 하위 서버들이 Online 상태인 걸 볼 수 있습니다.

![](./3.png)

<br>

### Prometheus Query(PromQL) 설정

수집할 데이터를 쿼리하는 곳이며, Prometheus Web 상단 Graph를 클릭 후, Add Panel 버튼을 클릭해 쿼리를 1개씩 추가해줍니다.

프로메테우스 **윈도우 전용 쿼리는** [여기](https://github.com/prometheus-community/windows_exporter?tab=readme-ov-file)에 자세히 나와있습니다.

제가 수집할 메트릭은 아래와 같습니다.

이렇게 Prometheus에 등록한 Panel은 Grafana의 Dashboard에서 등록 할 수 있습니다.

```promql
# 서버의 Online/Offline 상태
up

# CPU 사용량 (리눅스, 윈도우 서버 전체 조회)
(
  100 - (avg by (instance, job) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
) or (
  100 - (avg by (instance, job) (rate(windows_cpu_time_total{mode="idle"}[5m])) * 100)
)

# 메모리 사용량 (리눅스, 윈도우 서버 전체 조회)
(
  (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
) or (
  100 - ((windows_memory_available_bytes / windows_cs_physical_memory_bytes) * 100)
)
```

![](./4.png)

---
## Grafana Dashboard

이제 `http://{메인서버IP}:10000`으로 Grafana에 접속해 admin / 1234로 로그인 해줍니다.

로그인 후, 왼쪽 사이드바의 `Connections - DataSources`로 진입해서 데이터 소스를 추가해줍니다.

데이터 소스는 메인 서버의 Prometheus 포트인 `http://{메인서버IP}:9090` 으로 설정해줍니다.

![](./5.png)

<br>

데이터 소스를 추가했으면 저장하고 나옵니다.

정상적으로 Prometheus 컨테이너가 실행 중 이라면 바로 성공 할 겁니다.

![](./6.png)

<br>

데이터 소스를 설정하고, 다시 왼쪽 사이드바에서 `Dashboard` 탭을 클릭해 Add Dashboard를 선택후 Add Visualization을 선택합니다..

![](./7.png)

![](./8.png)

<br>

DataSource는 자동으로 아까 지정한 Prometheus가 지정되어 있을거고 이걸 클릭해줍니다.

![](./9.png)

<br>

이제 Dashboard에서 보여줄 Panal들을 하나씩 만들거고, Prometheus에 등록한 쿼리를 그대로 입력하면 아래와 같이 나오게 됩니다.

- **Query** : 하단 메뉴로, Prometheus에 등록한 쿼리 그대로 입력 후 Label Filter를 설정해 원하는 서버의 상태를 등록합니다.
- **Override Fields** : 각 메트릭 서버의 Display 이름을 바꿔주었습니다.
- **Thresholds** : 1이라는 값을 On으로, 0 값을 Off로 매핑해주었습니다.
- **Gauge 부분** : 우측 싱딘 그래프 유형을 선택합니다. 저는 게이지로 선택했습니다.
- **Apply** : 우측 최상단 Apply를 클릭해 Panel을 임시 대시보드에 저장합니다.

아래 사진은 예시로 `up`이라는 쿼리를 등록해 서버들의 상태를 Gauge Graph를 이용해 모니터링 합니다.

![](./10.png)

<br>

위처럼 Panel을 설정하고 우측 상단 Apply를 클릭하면, 임시 Dashboard에 패널이 1개 추가됩니다.

원하는 패널이 더 있으면 Add Panal을 통해 추가로 다른 메트릭도 등록합니다.

![](./11.png)

<br>

이번엔 프로메테우스에 추가했던 CPU 사용량 쿼리인 

```promql
(
  100 - (avg by (instance, job) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
) or (
  100 - (avg by (instance, job) (rate(windows_cpu_time_total{mode="idle"}[5m])) * 100)
)
```

쿼리를 등록해서 이번엔 Bar Chart로 선택 후, 2개의 Linux 서버와 1개의 윈도우 서버의 최근 CPU 사용량이 나오게 됩니다.

![](./12.png)

<br>

이렇게 2개의 Panel을 추가했고 저장 버튼을 눌러 Dashboard를 저장해주면 끝입니다.

나머지 메모리, 디스크 등도 추가하고 싶은 메트릭을 써서 패널들을 추가하기만 하면 됩니다.

![](./13.png)

<br>

### Grafana Panel Embedding

이 Dashboard의 각 Panel들을 Embedding도 가능한데 Dashboard에서 Panel의 점 3개 옵션을 눌러 share를 선택 후,

Embed 옵션에 있는 HTML을 활용하면 됩니다.

CPU, Memory, Disk 3개의 Panel Embedding iframe을 임시 HTML을 만들어서 대충 기능 확인만 하려고 Embed 해보았습니다.

<br>

저는 만약 Grafana를 쓰더라도 Grafana의 Web UI는 쓰지 않을 것 같고,

각 Panel들의 그래프만 별도 프론트엔드 서버에서 가져와 쓸것 같아서,

Embed를 통해 Panel UI만 옮기는 기능이 있는지 알아보다가 발견하게 되었습니다.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grafana Dashboard Embed</title>
</head>
<body>
    <h1>CPU</h1>
    <iframe src="http://192.168.0.5:10000/d-solo/fdpc1y3a30dmoe/server-metric?orgId=1&from=1718912236448&to=1718933836448&panelId=2" width="750" height="500" frameborder="0"></iframe>

    <h1>Memory</h1>
    <iframe src="http://192.168.0.5:10000/d-solo/fdpc1y3a30dmoe/server-metric?orgId=1&refresh=1m&from=1718916269337&to=1718937869337&panelId=3" width="750" height="500" frameborder="0"></iframe>

    <h1>Disk</h1>
    <iframe src="http://192.168.0.5:10000/d-solo/fdpc1y3a30dmoe/server-metric?orgId=1&refresh=1m&from=1718916302848&to=1718937902848&panelId=4" width="750" height="500" frameborder="0"></iframe>
</body>
</html>
```

![](./14.png)