## Dump

**_Parameters_**

- local_user : local DB의 user명.
- database_name : local DB명.
- local_password : local DB의 비밀번호 `(p다음에 공백없이 비밀번호를 입력해야 한다!)`
- RDS_user : AWS RDS DB 인스턴스의 DB user
- port_number : AWS RDS DB 인스턴스의 포트 번호  `ex) mysql : 3306`
- host_name : AWS RDS DB 인스턴스의 Host URL(Endpoint).
- RDS_password : AWS RDS DB 인스턴스의 비밀번호 `(p다음에 공백없이 비밀번호를 입력해야 한다.)`

<br>

**_Options_**

- single-transaction : mysqldump가 local DB의 데이터를 읽어들일 때 local DB가 다른 트랜잭션들을 수용하며 dump의 데이터는 무결성을 유지하게 해주는 옵션. innoDB의 스냅샷을 가져오는 하나의 트랜잭션으로 받아들이기 때문이다.  
    _`간단히 말하자면, DB에 Lock을 걸지 않아도 마이그레이션 되는 데이터들의 무결성이 유지된다.`_
- compress : AWS RDS로 마이그레이션 하기 전 local에서 데이터를 압축하여 네트워크 대역폭을 줄임.
- order-by-primary : local DB의 각 테이블마다 primary key를 기준으로 조회하여 dump 시간 단축.
- no-triggers : local DB 테이블들의 trigger를 dump하지 않음. `(밑에 있는 주의할 점 참고)`
- no-routines : local DB 테이블들의 procedure를 dump하지 않음. `(밑에 있는 주의할 점 참고)`

<br>

## 주의할점

1. sys, performance_schema 및 information_schema 스키마는 mysqldump 유틸리티에서 기본적으로 dump에서 제외한다. 즉, DB의 사용자와 권한들을 다시 설정해줘야 한다.
2. Amazon RDS 데이터베이스에서 저장 프로시저, 트리거, 함수 또는 이벤트를 수동으로 만들어야 한다. 개인적으로 Datagrip을 통해 모든 트리거나 프로시저의 create SQL을 따로 저장 후 실행하였다.

<br>

```shell
mysqldump -u <local_user> \
    --databases <database_name> \
    --single-transaction \
    --compress \
    --order-by-primary  \
    --routines=0 \
    --triggers=0 \
    --events=0 \
    -p <local_password> | mysql -u <RDS_user> \
        --port=<port_number> \
        --host=<host_name> \
        -p<RDS_password>
```


```shell
mysqldump -u root \
    --databases pet_db \
    --single-transaction \
    --compress \
    --order-by-primary  \
    --routines=0 \
    --triggers=0 \
    --events=0 \
    -p  | mysql -u petdb \
        --port=13306 \
        --host=spacepet-db.czdnwcp6gbpd.ap-northeast-2.rds.amazonaws.com \
        -p dnwnvptdkqcnr100%
```


```bash
#!/bin/bash

# MySQL 접속 정보
rds_endpoint="RDS-Endpoint"
rds_port="3306"
rds_db="database-name"
rds_password="password"

# .sql 파일 찾기
sql_files=$(find . -maxdepth 1 -type f -name "*.sql")

# 각 .sql 파일에 대해 import 수행
for sql_file in $sql_files; do

    # 파일명 출력
    echo "Importing $sql_file"

    # 비밀번호 입력을 위한 파일 디스크립터 설정
    exec 3<&0

    # MySQL 명령 실행 및 비밀번호 입력
    {
        echo "$rds_password"
        cat
    } | mysql -h "$rds_endpoint" -P "$rds_port" -u petdb -p"$rds_password" "$rds_db" < "$sql_file"

    # 파일 디스크립터 복구
    exec 0<&3

    # 구분선 출력
    echo "---------------------"
done
```