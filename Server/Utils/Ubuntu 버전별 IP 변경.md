## Ubuntu 버전별 IP 변경

### Ubuntu 18.04 ~ 20.04 LTS

- `/etc/netplan/00-installer-config.yaml` 수정
- `netplan apply` 적용

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eno1:
      #dhcp4: true
      dhcp4: no
      dhcp6: no
      addresses:
        - 192.168.0.15/24
      gateway4: 192.168.0.1
      nameservers:
        addresses: [168.126.63.1] # 원하는 Name Server
```

<br>
### Ubuntu 22.04 LTS

- `/etc/netplan/00-installer-config.yaml` 수정
- `netplan apply` 적용

```yaml
network:
  ethernets:
    eno1:
      #dhcp4: true
      dhcp4: no
      addresses:
        - 192.168.0.15/24
      routes:
        - to: default
          via: 192.168.0.1
  version: 2
```