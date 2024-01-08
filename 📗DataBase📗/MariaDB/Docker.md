## Mariadb Docker

```
## 컨테이너 생성
docker run -d --name {name} -e MYSQL_ROOT_PARRWORD={} -p 5001:3306 mariadb

## 컨테이너 DB 접속
docker exec -it {Container-Name} mariadb -u root -p
```