
Ubuntu 22.04 LTS 버전에서 **Nvidia Graphic Driver & Cuda Toolkit & OpenGL** 설치 중 에러를 만났습니다.

이미 존재하는 nouveau 커널 드라이버와 설치하려는 그래픽 드라이버와 충돌이 나서 Installation이 자꾸 실패합니다.

로그를 보면 Nouveau Kernel Driver가 현재 사용중이라고 뜨고 있습니다.

```
$ cat /var/log/nvidia-installer.log
nvidia-installer log file '/var/log/nvidia-installer.log'
creation time: Wed Apr  6 01:20:18 2022
installer version: 510.60.02

PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

nvidia-installer command line:
    ./nvidia-installer

Using: nvidia-installer ncurses v6 user interface
-> Detected 32 CPUs online; setting concurrency level to 20.
-> Installing NVIDIA driver version 510.60.02.
ERROR: The Nouveau kernel driver is currently in use by your system.  This driver is incompatible with the NVIDIA driver, and must be disabled before proceeding.  Please consult the NVIDIA driver README and your Linux distribution's documentation for details on how to correctly disable the Nouveau kernel driver.
-> For some distributions, Nouveau can be disabled by adding a file in the modprobe configuration directory.  Would you like nvidia-installer to attempt to create this modprobe file for you? (Answer: No)
ERROR: Installation has failed.  Please see the file '/var/log/nvidia-installer.log' for details.  You may find suggestions on fixing installation problems in the README available on the Linux driver download page at www.nvidia.com.
```