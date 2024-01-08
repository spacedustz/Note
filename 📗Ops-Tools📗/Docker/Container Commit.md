```bash
docker stop {Container-Name}
docker commit {Container-Name} {New-Image-Name}:{Tag}
docker save -o {Name}.tar {Saved-Image-Name}

## 백업된 이미지를 다른 환경에 복원
docker load -i {Tar-File-Name}.tar
```