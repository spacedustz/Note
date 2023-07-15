## Volume

도커 컨테이너는 기본적으로 안에 들어있는 데이터들이 컨테이너가 종료되면 사라진다.

그런 Stateful한 상태에서 도커 컨테이너를 운용하는건 좋지 못하다.

Stateless하게 외부에서 데이터를 마운트해서 가져오는 방법은 Volume을 이용하는거다.

---

### 호스트의 볼륨 공유

로컬의 디렉터리를 컨테이너의 볼륨과 마운트 한다.

볼륨마운트 하면서 환경변수를 넣고 포트포워딩하는 예시

```shell
docker run -it \
--name container1 \
-e MYSQL_ROOT_PASSWORD=password \
-e MYSQL_DATABASE=wordpress \
-v /home/wordpress_db:/var/lib/mysql \
-p 33006:3306 \
mysql:5.8
```

---

### **파일 단위의 공유도 가능하다**

로컬에 파일을 생성해서 컨테이너의 볼륨과 마운트 해보자.

```shell
echo hello > /home/hello.txt && echo hello2 >> /home/hello2.txt

docker run -it \
--name container2 \
-v /home/hello:/hello.txt \
-v /home/hello2:/hello2.txt \
centos:latest

cat hello.txt && hello2.txt
```

---

### Mount 옵션

`-v`와 동일한 기능을 하는 마운트 옵션도 존재한다. 그냥 알아두자.

**호스트 -> 컨테이너 마운트**

- type = volume
- source = 호스트 디렉터리
- target = 컨테이너 디렉터리

<br>

**컨테이너 -> 호스트 마운트**

- type = bind
- source = 컨테이너 디렉터리
- target = 호스트 디렉터리

---

### 컨테이너 간 마운트

컨테이너 간 마운트는 `--volumes-from {target-container}` 명령을 사용한다.

---

### 도커 볼륨을 생성하여 볼륨 마운트

도커 엔진이 관리하는 도커 볼륨을 생성한 마운트 방식이다.

위의 내용까지는 호스트 ->볼륨 컨테이너 -> 볼륨 컨테이너에게 마운트된 컨테이너 의 형식이었다.

도커 엔진이 관리하는 볼륨을 생성하는 법과 연결하는 법을 아래 예시로 보자.

```shell
# 도커 볼륨 생성
docker volume create --name my-vol

# 도커 볼륨 조회
docker volume ls

# 생성한 볼륨을 컨테이너의 /root로 마운트
docker run -it \
--name container \
-v my-vol:/root
centos:latest

# 도커 볼륨의 호스트 저장 위치
docker inspect --type volume my-vol

# 컨테이너 생성과 동시에 도커 볼륨 생성, 이렇게 할 시 볼륨의 이름은 랜덤 16진수 해시값으로 나온다.
docker run -it \
--name container \
-v /root \
centos:latest

# 컨테이너가 해당 볼륨을 사용하는지 확인
docker container inspect {container_name}
```

<br>

### 주의할 점

호스트와 컨테이너에 이미 동일한 디렉터리, 파일이 존재한다고 가정하고 볼륨 마운트를 하면,

호스트의 리소스가 컨테이너의 리소스를 덮어씌운다. 항상 확인후 볼륨 마운트를 진행할 것

---