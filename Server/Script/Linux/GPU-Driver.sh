#!/bin/bash

## 기본 패키지 설치
sudo apt -y update
sudo apt -y upgrade

sudo apt -y install build-essential pkg-config libglvnd-dev freeglut3-dev libglu1-mesa-dev mesa-common-dev mesa-utils unzip wget

## Docker 설치
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt -y update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io

sudo systemctl start docker && sudo systemctl enable docker

## RabbitMQ 설치
sudo apt-get -y install curl gnupg apt-transport-https

sudo curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/com.rabbitmq.team.gpg > /dev/null
sudo curl -1sLf "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf77f1eda57ebb1cc" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg > /dev/null

sudo curl -1sLf "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/io.packagecloud.rabbitmq.gpg > /dev/null
sudo apt-get -y update

sudo apt-get install -y erlang-base \
    erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
    erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
    erlang-runtime-tools erlang-snmp erlang-ssl \
    erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl
sudo apt-get -y install rabbitmq-server --fix-missing

sudo systemctl enable rabbitmq-server
sudo rabbitmq-plugins enable rabbitmq_management
sudo rabbitmq-plugins enable rabbitmq_mqtt
sudo rabbitmq-plugins enable rabbitmq_web_mqtt
sudo rabbitmq-plugins enable rabbitmq_web_stomp
sudo firewall-cmd --permanent --add-port=15672/tcp
sudo firewall-cmd --permanent --add-port=5672/tcp
sudo firewall-cmd --reload
sudo systemctl restart rabbitmq-server

sudo rabbitmqctl add_user admin admin
sudo rabbitmqctl set_user_tags admin administrator
sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

sudo rabbitmqctl declare queue name=event x-queue-type=quorum
sudo rabbitmqctl set_queue_argument event message-ttl 3000
sudo rabbitmqctl set_policy TTL "event" '{"message-ttl":3000}' --apply-to queues
sudo rabbitmqctl bind_queue / event amq.topic 10


## FFmpeg 설치
sudo apt -y install ffmpeg

## Graphic Driver 설치
sudo ./NVIDIA-Linux-x86_64-525.147.05.run

## Nvidia Container-Toolkit 설치 & Production 저장소 구성
sudo curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

## Nvidia Container Tool Kit 설치
sudo docker info | grep -i runtimes # 런타임 엔진 확인
sudo apt-get -y update
sudo apt-get install -y nvidia-container-toolkit

## Nvidia Container Runtime Engine 구성
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart containerd

## Cuda 설치 & 환경변수 설정
sudo wget https://developer.download.nvidia.com/compute/cuda/12.0.0/local_installers/cuda_12.0.0_525.60.13_linux.run
sudo chmod +x cuda_12.0.0_525.60.13_linux.run
sudo ./cuda_12.0.0_525.60.13_linux.run
cat <<EOL >> ~/.bashrc
export PATH=/usr/local/cuda-12.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-12.0/lib64:$LD_LIBRARY_PATH
EOL

source ~/.bashrc

## Ubuntu-GUI 설치
sudo apt -y install ubuntu-desktop
reboot