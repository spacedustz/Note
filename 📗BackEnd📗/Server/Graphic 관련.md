```bash
## 그래픽 카드 확인
lspci

## gcc 설치
apt -y install build-essential

## 종속성 라이브러리 설치
apt -y install pkg-config libglvnd-dev

## Cuda 12.2 설치
wget https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/cuda_12.2.0_535.54.03_linux.run

## OpenGL Version 확인
sudo apt-get -y install build-essential freeglut3-dev libglu1-mesa-dev mesa-common-dev mesa-utils
glxinfo | grep "OpenGL version"
```