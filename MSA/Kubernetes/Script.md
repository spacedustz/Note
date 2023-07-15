왠만하면 스크립트말고 직접설치 추천 (서버 환경에 따라 에러 or 오작동)

network CNI & 서버 IP는 취향따라서 스크립트 수정하셈



while true :
do
clear
echo "====================================================================================="
echo "


   "
echo -e "\033[47;31m 1. k8s_master_first\033[0m
"
echo -e "\033[47;31m 2. k8s_master_second\033[0m
"
echo -e "\033[47;31m 3. k8s_slave_first\033[0m
"
echo "

   "
echo "====================================================================================="

read -p "Number(1~3) : " code


if [ $code = 1 ]
then
hostnamectl set-hostname master

echo "192.168.0.165 master" >> /etc/hosts

yum install -y yum-utils device-mapper-persistent-data lvm2

yum -y install yum-utils

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum -y install docker-ce

systemctl start docker && systemctl enable docker

sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config 

sed -i 's/ExecStart=\/usr\/bin\/dockerd -H fd:\/\/ --containerd=\/run\/containerd\/containerd.sock/ExecStart=\/usr\/bin\/dockerd --exec-opt native.cgroupdriver=systemd/g' /usr/lib/systemd/system/docker.service

echo "FIREWALL CONFIG!!!!"

firewall-cmd --permanent --add-port=6443/tcp

firewall-cmd --permanent --add-port=10250/tcp

firewall-cmd --reload

systemctl stop firewalld && systemctl disable firewalld

swapoff -a

sed -i 's/\/dev\/mapper\/centos-swap/#\/dev\/mapper\/centos-swap/g' /etc/fstab

modprobe br_netfilter

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

yum -y install apt-transport-https ca-certificates curl

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable kubelet && systemctl start kubelet

reboot
elif [ $code = 2 ]
then
kubeadm init --pod-network-cidr=10.244.0.0/16 | tee result   

export KUBECONFIG=/etc/kubernetes/admin.conf

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

Kubectl get nodes 

kubectl get pod --all-namespaces -o wide

elif [ $code = 3 ]
then
hostnamectl set-hostname slave

echo "192.168.0.166 slave" >> /etc/hosts

yum install -y yum-utils device-mapper-persistent-data lvm2

yum -y install yum-utils

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum -y install docker-ce

systemctl start docker && systemctl enable docker

sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config 

sed -i 's/ExecStart=\/usr\/bin\/dockerd -H fd:\/\/ --containerd=\/run\/containerd\/containerd.sock/ExecStart=\/usr\/bin\/dockerd --exec-opt native.cgroupdriver=systemd/g' /usr/lib/systemd/system/docker.service

echo "FIREWALL CONFIG!!!!"

firewall-cmd --permanent --add-port=6443/tcp

firewall-cmd --permanent --add-port=10250/tcp

firewall-cmd --reload

systemctl stop firewalld && systemctl disable firewalld

swapoff -a

sed -i 's/\/dev\/mapper\/centos-swap/#\/dev\/mapper\/centos-swap/g' /etc/fstab

modprobe br_netfilter

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

yum -y install apt-transport-https ca-certificates curl

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable kubelet && systemctl start kubelet

mkdir /root/.kube/

reboot
else
    echo "wrong number!!!!!!!!!!!"
fi

done