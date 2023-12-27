```bash
## 그래픽 카드 확인
lspci

## gcc 설치
apt -y install build-essential

## Graphic Driver 설치 전 종속성 라이브러리 설치
apt -y install pkg-config libglvnd-dev

## 그래픽 드라이버 설치 전 Nvidia 관련 삭제
sudo apt-get -y remove nvidia* && sudo apt -y autoremove
sudo apt install dkms build-essential linux-headers-generic
sudo echo -e "blacklist nouveau\nblacklist lbm-nouveau\noptions nouveau modeset=0\nalias nouveau off\nalias lbm-nouveau off" | sudo tee -a /etc/modprobe.d/blacklist.conf
sudo update-initramfs -u
reboot

## Cuda 12.2 설치, 그래픽 드라이버는 별도 설치하였으므로 그래픽 드라이버는 빼고 설치
wget https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/cuda_12.2.0_535.54.03_linux.run
export PATH=/usr/local/cuda-12.2/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:$LD_LIBRARY_PATH

## OpenGL Version 확인
sudo apt-get -y install build-essential freeglut3-dev libglu1-mesa-dev mesa-common-dev mesa-utils
glxinfo | grep "OpenGL version"
```

<br>

> **기존 그래픽 드라이버 커널 모듈 해제**

```bash
systemctl isolate multi-user.target
modprobe -r nvidia-drm

lsof /dev/nvidia*
kill -9 {NVIDIA Process}

systemctl start graphical.target
```