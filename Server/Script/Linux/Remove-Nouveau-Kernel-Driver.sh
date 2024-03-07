```bash
#!/bin/bash

sudo apt-get -y remove nvidia* && sudo apt -y autoremove
sudo apt install -y dkms build-essential linux-headers-generic pkg-config libglvnd-dev
sudo echo -e "blacklist nouveau\nblacklist lbm-nouveau\noptions nouveau modeset=0\nalias nouveau off\nalias lbm-nouveau off" | sudo tee -a /etc/modprobe.d/blacklist.conf
sudo update-initramfs -u
reboot
```