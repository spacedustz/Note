## **💡 Memory Swaping**

보통 Swap의 용량은 ram의 2배라고 알려져있고 t2.micro의 ram은 1gb, 스와핑용량 +2gb를 더해서,  
총 3gb의 메모리로 증설이 가능하다

---

### **EC2 인스턴스 내부**

```shell
# 스왑 파일 생성
$ sudo dd if=/dev/zero of=/swapfile bs=128M count=16
# bs는 블록 크기이며, count는 블록 수이므로 128mb x 16 = 2048mb 크기의 스왑 파일을 생성한다는 뜻이다.


# 스왑 파일에 대한 권한 변경
$ sudo chmod 600 /swapfile


# Linux 스왑 영역 설정
$ sudo mkswap /swapfile


# 스왑 파일을 즉시 사용하도록 변경
$ sudo swapon /swapfile


# 성공 확인
$ sudo swapon -s


# /etc/fstab 파일을 편집하여 부팅 시 스왑 파일을 활성화시킴
$ sudo vi /etc/fstab


# 편집 방법
# 1. i 눌러서 입력 활성화
# 2. /swapfile swap swap defaults 0 0
을 파일에 마지막 줄을 추가하여 작성후 esc 눌러 입력 비활성화시킴
# 3. :wq로 저장 후 종료


# free 입력하여 스와핑이 성공했는지 메모리 확인해보기
```

<br>

![img](https://raw.githubusercontent.com/spacedustz/Typora-Image-Server/main/img/ec2_memory_swaping.png)