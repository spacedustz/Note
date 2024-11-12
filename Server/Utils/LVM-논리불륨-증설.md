```bash
# 현재 논리 볼륨 크기 확인
sudo lvdisplay /dev/mapper/ubuntu--vg-ubuntu--lv

# 논리 볼륨 300G 확장
sudo lvextend -L +300G /dev/mapper/ubuntu--vg-ubuntu--lv

# 파일시스템 확장 (ext4 기준)
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv

# LVM에 여유 공간이 없으 경우 새 디스크 추가 시
sudo pvcreate /dev/sdX # 새 디스크 이름으로 대체
sudo vgextent ubuntu-vg /dev/sdX
```

