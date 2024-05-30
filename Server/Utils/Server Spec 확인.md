## Ubuntu Server Spec 확인

```bash
# CPU Core 수 확인
cat /proc/cpuinfo | egrep 'siblings|cpu cores' | head -2

# CPU 확인
/cat /proc/cpuinfo

# RAM 확인
free -h

# GPU 확인
lspci | grep VGA

# DISK 확인 : loop는 제외하고 nvme0nl로 시작하는것만 체크
# 0은 SSD / 1은 HDD
lsblk -d -o name,rota
# or
fdisk -l
```