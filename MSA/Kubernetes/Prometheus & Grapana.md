

## 💡 Prometheus & Grapana

[**git clone**](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#configuration)
https://joobly.tistory.com/58
https://freestrokes.tistory.com/152
https://twofootdog.tistory.com/18

<br>

지난 장에서는 Prometheus & Node-Exporter & AlertManager를 활용한 모니터링 시스템을 구축하였다. 하지만 Prometheus로는 지표(Metric)정보를 확인하기는 많이 불편했다. 따라서 이번 장에서는 지표정보를 좀 더 쉽게 볼 수 있게 Prometheus(프로메테우스)와 Grafana(그라파나)를 연동시켜 모니터링 대쉬보드를 구축할 것이다.

<br>

### **Grafana란 무엇인가?**

그라파나(Grafana)란 지표(metric)정보를 분석/시각화하는 Open source 툴이다. 주로 인프라 정보 및 App 분석 데이터를 시각화하기 위한 대쉬보드로 주로 사용된다. 그라파나는 Graphite, Prometheus, Elasticsearch, InfluxDB와 같은 시계열데이터베이스를 풍부하게 지원하며, Google Stackdriver, Amazon Cloudwatch, Microsoft Azure와 같은 클라우드 모니터링도 지원한다.

<br>

## 💡 Grafana 적용하기

<br>

### **2-1. Prometheus & Grafana 모니터링 구성도**

이전 장에서도 한번 공유는 했지만 Prometheus와 Grafana가 적용된 모니터링 구성도는 다음과 같다. 우리는 이번 글에서 "**2. 수집된 data전송"** 및 "**3. 현황 모니터링"** 을 구현해 볼 것이다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana.png)

<br>

### **2-2. Grafana yaml파일 적용**

그럼 이제 쿠버네티스 클러스터 환경에서 그라파나(Grafana)를 적용해보도록 하겠다. 

yaml파일로 적용할 것이며 파일은 총 3개가 필요한데, ConfigMap, Deployment, Service가 필요하다. 

<br>

**grafana-datasource-config.yaml**에는 prometheus.yaml을 등록하여, 
지표(metric)정보를 수집한 프로메테우스 서버와 연동할 것이고, 
**grafana-deployment.yaml**는 그라파나 Deployment 설정 정보, g**rafana-service.yaml**에는 
그라파나 외부 포트 오픈 설정 정보가 있다.

<br>

grafana-datasource-config.yaml :

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-datasources
  namespace: monitoring
data:
  prometheus.yaml: |-
    {
        "apiVersion": 1,
        "datasources": [
            {
               "access":"proxy",
                "editable": true,
                "name": "prometheus",
                "orgId": 1,
                "type": "prometheus",
                "url": "<http://prometheus-service.monitoring.svc:8080>",
                "version": 1
            }
        ]
    }
```

<br>

grafana-deployment.yaml :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      name: grafana
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:latest
        ports:
        - name: grafana
          containerPort: 3000
        resources:
          limits:
            memory: "2Gi"
            cpu: "1000m"
          requests:
            memory: "1Gi"
            cpu: "500m"
        volumeMounts:
          - mountPath: /var/lib/grafana
            name: grafana-storage
          - mountPath: /etc/grafana/provisioning/datasources
            name: grafana-datasources
            readOnly: false
      volumes:
        - name: grafana-storage
          emptyDir: {}
        - name: grafana-datasources
          configMap:
              defaultMode: 420
              name: grafana-datasources
```

<br>

grafana-service.yaml :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: monitoring
  annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/port:   '3000'
spec:
  selector:
    app: grafana
  type: NodePort
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 30004
```

<br>

작성을 완료했으면, 해당 yaml파일을 쿠버네티스 클러스터에 적용해보자.

```bash
# kubectl apply -f grafana-datasource-config.yaml
# kubectl apply -f grafana-deployment.yaml
# kubectl apply -f grafana-service.yaml
```

<br>

적용이 완료되면 그라파나 pod가 구동된 것을 확인할 수 있다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana2.png) 

<br>

### **2-3. Grafana Dashboard Import**

다음으로 Grafana 웹페이지에 접속해보자. Grafana 웹페이지는 **http://[서버IP]:[서비스포트번호]**로 이 포스트대로 했으면 **http://[서버ip]:30004**로 접속하면 된다.

<br>

최초로 접속하게 되면 login 창이 뜨는데 **최초 id/password는 admin/admin**이다. 입력하고 들어가면 패스워드 변경 페이지가 나오는데 패스워드를 변경하고 로그인을 하자.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana3.png)  

<br>

다음으로 홈 화면에서 Create -> Import 버튼을 클릭하자.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana4.png) 

<br>

그러면 [Grafana.com](http://grafana.com/) 의 dashboard url이나 id를 입력하라는 창이 나온다. 그라파나는 직접 대쉬보드를 만들수도 있지만 남들이 만들어 놓은 대쉬보드를 import해서 쓸 수도 있다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana5.png)

<br>

쿠버네티스 용 대쉬보드를 만들기 위해 그라파나 홈페이지로 가보자(주소 : https://grafana.com/). 홈페이지에서 Grafana -> Dashboards로 이동하자.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana6.png) 

<br>

Dashboard List에서 해당 대쉬보드를 검색하고 대쉬보드 ID를 복사한다(다른 대쉬보드를 사용해도 좋다).

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana7.png)

<br>

쿠버네티스와 연동된 그라파나 웹페이지로 가서 홈 화면 -> Create -> Import 버튼을 클릭한 후 복사한 대쉬보드ID를 붙여넣고 아래와 같이 설정하고 Import 버튼을 클릭한다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana8.png) 

<br>

그러면 아래와 같이 쿠버네티스 모니터링 대쉬보드를 확인할 수 있다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana9.png) 

<br>

N/A라고 나오는 데이터는 PromQL이 내 환경과 맞지 않게 기입된 것이기 때문에 문법을 찾아가며 수정해주면 된다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana10.png) 

<br>

### **2-4. Grafana Dashboard 신규 생성**

그라파나 대쉬보드를 신규로 생성하는 방법도 크게 어렵진 않다(대쉬보드를 생성하는 것보단 대쉬보드 PromQL을 만드는 것이 더 어렵다).

우선 Create -> Dashboard를 선택한다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana11.png) 

<br>

그러면 Panel이 신규로 생성되는데 Add Query버튼을 클릭한다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana12.png)

<br>

그후 Query에서는 prometheus를 선택하고, Metrics에 그래프로 나타내고 싶은 PromQL를 입력하고 Min step은 10s로 입력한다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana13.png) 

<br>

그 다음 Visualization으로 넘어가서 그래프의 모양과 Legend(범례) 값 등을 선택한다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana14.png) 

<br>

General에서 Title 등을 변경한 후 좌측 상단의 뒤로가기 버튼을 클릭한다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana15.png)

<br>

그러면 대쉬보드에 방금 변경한 그래프가 보이게 된다. 

우측 상단의 Add Panel을 클릭하게 되면 대쉬보드에 새로운 패널이 생성되게 되고, 
위와 동일하게 수정해주면 한개의 대쉬보드에 여러 Panel이 등록되게 된다. 

<br>

이런 식으로 본인이 원하는 그라파나 대쉬보드를 생성하면 된다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Grapana16.png)

<br>

### **마치며**

해당 포스트 이후로도 추가적으로 공부를 해보고 싶다면 Actuator & Prometheus 연동(https://twofootdog.tistory.com/22), 

Ingress적용(https://twofootdog.tistory.com/23), React 컨테이너 배포(https://twofootdog.tistory.com/24) 등을 

순서대로 공부해 본다면 도움이 될 것 같다.