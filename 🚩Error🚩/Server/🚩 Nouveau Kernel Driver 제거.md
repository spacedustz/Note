
## 🚩 Nouveau Kernel Driver 제거

Ubuntu 22.04 LTS 버전에서 **Nvidia Graphic Driver & Cuda Toolkit & OpenGL** 설치 중 에러를 만났습니다.

이미 존재하는 nouveau 커널 드라이버와 설치하려는 그래픽 드라이버와 충돌이 나서 Installation이 자꾸 실패합니다.

로그를 보면 Nouveau Kernel Driver가 현재 사용 중 이라고 뜨고 있습니다.

```shell
$ cat /var/log/nvidia-installer.log
```

```
nvidia-installer log file '/var/log/nvidia-installer.log'
installer version: 535.75

PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

nvidia-installer command line:
    ./nvidia-installer

Using: nvidia-installer ncurses v6 user interface
-> Detected 32 CPUs online; setting concurrency level to 32.
-> Installing NVIDIA driver version 535.75
ERROR: The Nouveau kernel driver is currently in use by your system.  This driver is incompatible with the NVIDIA driver, and must be disabled before proceeding.  Please consult the NVIDIA driver README and your Linux distribution's documentation for details on how to correctly disable the Nouveau kernel driver.
-> For some distributions, Nouveau can be disabled by adding a file in the modprobe configuration directory.  Would you like nvidia-installer to attempt to create this modprobe file for you? (Answer: No)
ERROR: Installation has failed.  Please see the file '/var/log/nvidia-installer.log' for details.  You may find suggestions on fixing installation problems in the README available on the Linux driver download page at www.nvidia.com.
```

<br>

nouveau 커널 드라이버는 GPU 코어의 온도를 확인하여 GPU Fan을 작동하고 온도 경고를 설정하는 커널 드라이버입니다.

lsmod로 확인해봐도 nouveau 모듈이 동작 중입니다.

```shell
$ lsmod | grep -i nouveau
```

```
nouveau              1949696  1
video                  49152  2 asus_wmi,nouveau
ttm                   106496  1 nouveau
drm_kms_helper        184320  1 nouveau
mxm_wmi                16384  1 nouveau
drm                   491520  4 drm_kms_helper,ttm,nouveau
i2c_algo_bit           16384  2 igb,nouveau
wmi                    32768  5 intel_wmi_thunderbolt,asus_wmi,wmi_bmof,mxm_wmi,nouveau
```

<br>

검색해본 결과 Nvidia GPU Driver를 설치 하려면 **이 커널 드라이버를 제거하고 다시 실행되지 않도록 modprobe 블랙리스트에 추가해야 합니다.**

<br>

우선 Nvidia 관련 패키지를 제거합니다.

```shell
$ sudo apt -y remove nvidia* && sudo apt -y autoremove
```

<br>

컴파일러와 Linux Header, GPU Driver를 설치하기 위한 종속성 패키지들을 설치 해 줍니다.

```shell
$ sudo apt -y install dkms build-essential linux-headers-generic pkg-config libglvnd-dev
```

<br>

nouveau 드라이버를 블랙리스트에 등록하여 활성화되지 않도록 합니다.

```shell
$ sudo echo -e "blacklist nouveau\nblacklist lbm-nouveau\noptions nouveau modeset=0\nalias nouveau off\nalias lbm-nouveau off" | sudo tee -a /etc/modprobe.d/blacklist.conf
```

<br>

initramfs를 업데이트하고 서버를 재기동합니다.

```shell
$ sudo update-initramfs -u
$ reboot
```

<br>

이제 다시 GPU Driver를 설치하고 `nvidia-smi`를 입력하면 잘 나오는 것을 확인할 수 있습니다.