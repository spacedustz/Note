## **💡 Docker**

<br>

### **명령어**

- docker cp /[direction] [file-name] [container-name]:/[direction] (로컬 -> 컨테이너 파일이동)
- docker pull & docker push (이미지 pull & push)
- docker run -d --privileged --name [name] -p 8080:80 centos:7 /sbin/init (컨테이너 백그라운드 실행)
- docker start CID or Name & stop CID or Name (컨테이너 시작 & 중지)
- docker rmi (이미지 삭제)
- docker rm (컨테이너 삭제)
- docker ps (실행중인 컨테이너 조회) & docker ps -a (실행 & 종료된 컨테이너 조회)
- rm /var/lib/docker/network/files/local-kv.db (컨테이너 포트 캐시 삭제)
- docker commit [CID] [name]:[tag]

<br>

### **Presistent Volume Claims**

- Application은 로그를 /log/app.log 에 저장
- emptyDir 은 emptyDir pod 가 삭제되면 데이터가 사라짐.
- spec.containers.volumeMounts.mountPath → 실행될 컨테이너 안에 마운트할 경로.
  컨테이너 안에 해당 디렉토리가 없더라도 자동으로 생성.
- spec.containers.volumeMounts.mountPath → 마운트할 볼륨의 이름.
- spec.voluems → 위에 작성한 emptydir-volume을 사용하도록 지정.
- hostPath는 노드의 디스크에 볼륨을 생성하여 Pod가 삭제 되더라도 볼륨에 있던 데이터는 유지.
- spec.containers.volumeMounts.mountPath → 실행된 컨테이너 안에 마운트할 경로.
  컨테이너 안에 해당 디렉토리가 없더라도 자동으로 생성 해줍니다.
- spec.containers.volumeMounts.name → 마운트할 볼륨의 이름.
- spec.voluems.name → 위에 작성한 hostpath-volume을 사용하도록 지정.
- spec.voluems.hostPath → 노드에 마운트할 경로를 정해주고 해당 경로는 Directory 라는것을 명시.
  해당 디렉토리는 노드에 생성되어 있어야 하며,
  DirectoryOrCreate를 사용할 경우 디렉토리가 존재하지 않으면 디렉토리를 생성 해줌.
  주의해야할 점은 여러개의 워커노드를 사용중인 환경이라면 가장 밑에 있는 부분 중
  DirectoryOrCreate가 아닌, Directory를 사용했을 경우 Pod가 실행될 노드의
  path에 작성한 디렉토리가 있어야 하므로 잘 확인해주어야 함
- 만약, Directory를 명시하고 path에 작성한 디렉토리가 없을 경우 ContainerCreating 상태에서 생성되지 않음.

```yaml
apiVersion: v1
kind: Pod
metadata:
name: webapp
spec:
containers:
- name: event-simulator
image: kodekloud/event-simulator
env:
- name: LOG_HANDLERS
value: file
volumeMounts:
- mountPath: /log <-- 이부분
name: log-volume

volumes:
- name: log-volume
hostPath:
# directory location on host
path: /var/log/webapp <-- 이부분
# this field is optional
type: Directory
```

<br>

### **On Linux (Centos 7)**

- yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
- yum list docker-ce --showduplicates
- yum -y install docker-ce containerd
- mkdir /etc/docker && vi /etc/docker/daemon.json

```json
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2",
"storage-opts": [
"overlay2.override_kernel_check=true"
]
}
```

- mkdir -p /etc/systemd/system/docker.service.d
- systemctl daemon-reload && systemctl start docker && systemctl enable docker && docker --version

<br>

docker &amp; docker-compose 설치

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker12.png) 

<br>

Container Httpd 내부에 Pacman 게임 삽입

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker13.png) 

<br>

컨테이너 커밋 후 이미지 조회

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/Docker14.png) 

### **aws instance**

- amazon-linux-extras install docker
- usermod -a -G docker root
- chkconfig docker on
- reboot
- curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
- chmod +x /usr/local/bin/docker-compose
- ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose (bin에 심볼릭링크 생성)

------

## **💡 Docker Private Registry**

<br>

### **Docker Private Registry**

- yum -y install docker-registry
- docker start
- dcker pull registry:latest
- docker run -d --name [name] -p 5000:5000 --restart always && netstat -lntp | grep 5000
- curl -X GET http://localhost:5000/v2/_catalog
- vi /etc/docker/daemon.json
  {
  "insecure-registries": ["192.168.0.172:5000"]
  }
- systemctl restart docker
- docker image tag [pre_imgname] [cur_imgname]
- firewall-cmd --permanent --zone=external --change-interface=" "
- firewall-cmd --permament --zone=internal --change-interface=" "
- firewall-cmd --reload

<br>

### **Docker MacVlan Network**

- Node1
  - docker network create -d macvlan --subnet=192.168.0.0/24 --ip-range=192.168.0.64/28 --gateway=192.168.0.1 /
    -o macvlan_mode=bridge -o parent=eth0 [set_network_id]
- Node2
  - docker network create -d macvlan --subnet=192.168.0.0/24 --ip-range=192.168.0.128/28 --gateway=192.168.0.1 /
    -o macvlan_mode=bridge -o parent=eth0 [set_network_id]

------

## **💡 Docker File Syntax**

<br>

### **Docker File**

- FROM : Docker Base Image (기반이 되는 이미지, <이미지 이름>:<태그> 형식으로 설정)
- MAINTAINER : 메인테이너 정보 (작성자 정보)
- RUN : Shell Script 또는 명령을 실행
- CMD : 컨테이너가 실행되었을 때 명령이 실행
- LABEL : 라벨 작성 (docker inspect 명령으로 label 확인할 수 있습니다.)
- EXPOSE : 호스트와 연결할 포트 번호를 설정한다.
- ENV : 환경변수 설정
- ADD : 파일 / 디렉터리 추가
- COPY : 파일 복사
- ENTRYPOINT : 컨테이너가 시작되었을 때 스크립트 실행
- VOLUME : 볼륨 마운트
- USER : 명령 실행할 사용자 권한 지정
- WORKDIR : "RUN", "CMD", "ENTRYPOINT" 명령이 실행될 작업 디렉터리
- ARG : Dockerfile 내부 변수
- ONBUILD : 다른 이미지의 Base Image로 쓰이는 경우 실행될 명령 수행
- SHELL : Default Shell 지정

<br>

### **Build**

- mkdir [임의의 디렉토리명]
- vi Dockerfile
- docker build -t newpac:1**.**1 **.** <- 현재 위치를 의미하는 '**.**' 붙여주기

------

## **추가 정보 **

https://www.44bits.io/ko/post/building-docker-image-basic-commit-diff-and-dockerfile