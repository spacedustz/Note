## 💡 RDS

-   RDBMS를 지원하며 Multi-AZ를 이용한 고가용성 데이터베이스
-   기본 인스턴스의 수행 작업(백업, 스냅샷)을 대신하여 기본 인스턴스의 부담 ↓
-   기본 인스턴스의 스냅샷을 캡쳐 후, 다른 AZ에 복원하는 '동기식' 예비 복제본 생성
-   즉, Active(AZ A) - StandBy(AZ B, C) 구조를 형성한 후 지속적인 동기화  
    
-   StandBy 전환 상황 - 전환 시 60 - 120초 소요
    -   FailOver 실시
    -   AZ 중단
    -   DB 인스턴스 소프트웨어 패치

<br>

### Read Replica
-   기본 DB 인스턴스가 읽기,쓰기를 담당한다면 Read Replica는,  
    읽기만 담당하여 Master DB Instance의 부담을 줄임
-   DB 인스턴스 스냅샷 캡쳐 후, 이를 기반으로 Replica를 생성해,  
    데이터를 Async 복제 방식을 통해 업데이트
-   리전당 최대 5개의 Read Replica 사용 가능
-   Read Replica의 독립된 인스턴스 승격 가능

<br>

### Automated Backup
-   RDS의 자동 백업으로 개별 DB를 백업 하는것이 아닌 DB 인스턴스 전체 백업
-   매일 백업이 이루어지며, 기본 보존기간은 CLI로 생성시 1일 & 콘솔로 생성시 7일, 최저 1-35일 가능
-   백업 시, 스토리지 I/O의 일시적 중단 가능성이 있음
-   최근 5분까지 특정 지점 복원 가능
<br>

### Snapshot
-   자동 백업과 마찬가지로 스냅샷도 자동생성 가능하며 수동생성도 가능하다
-   자동 백업과 달리 스냅샷 생성지점으로만 복원 가능
-   스냅샷 복원 시, DB인스턴스가 복원되는게 아닌, 개별 DB 인스턴스가 생성됨
-   스냅샷의 복사, 공유, 마이그레이션 가능

<br>

### Enhanced Monitoring
-   RDS의 지표를 실시간 모니터링하는 '강화된' 모니터링
-   모니터링 로그는 CloudWatchs Logs에 30일간 저장됨
-   일반 모니터링과의 차이점은 인스턴스 내 에이전트를 통해 지표수집, 일반 모니터링은 하이퍼바이저에서 수집
-   초 단위로 수집 가능

---

## RDS 스냅샷 내보내기

RDS 스냅샷을 내보내기 하려면 무조건 AWS S3를 거쳐야 합니다.

그러기 위해서 IAM 역할을 사용하여 S3 버킷에 대한 액세스 권한을 제공해야 합니다.

IAM 정책을 생성해서 다음 작업들을 포함시킵니다.

- `s3:PutObject*`
    
- `s3:GetObject*`
    
- `s3:ListBucket`
    
- `s3:DeleteObject*`
    
- `s3:GetBucketLocation`

<br>

정책에 다음 리소스를 포함하여 버킷에 있는 객체를 식별합니다.

다음 리소스 목록은 S3에 액세스하기 위한 리소스 이름(ARN) 형식을 보여줍니다.

- `` arn:aws:s3:::`your-s3-bucket` ``
    
- ``arn:aws:s3:::`your-s3-bucket`/*``

<br>

자세한 내용은 RDS Docs를 보면 됩니다.

[Refs](https://docs.aws.amazon.com/ko_kr/AmazonRDS/latest/UserGuide/USER_ExportSnapshot.html)

---

## EC2 <-> RDS 연동

Mysql Version : 8.0.32

만들어둔 EC2의 VPC ID와 보안그룹의 ID를 저장해 놓습니다.

vpc-067c55953834c23d0

sg-039262277aa0c76fb

<br>

RDS용 보안그룹을 새로 생성할 때 위의 VPC ID를 이용합니다.

인바운드 포트의 유형은 Mysql/Aurora 를 선택해서 3306 포트를 열어줍니다.

만약 Custom Port를 사용한다면 사용자지정 TCP로 선택하고 원하는 포트를 열어줍니다.

퍼블릭 액세스를 차단할 것이기 때문에 보안그룹의 소스는 EC2-IP/32 로 지정해줍니다.

보안그룹을 생성했으면 RDS 생성화면에서 서브넷 그룹에 적어둔 VPC ID, 보안그룹에 만들어둔 보안그룹을 적용합니다.

<br>

EC2 인스턴스에 접속해 mysql-client를 설치해줍니다.

```bash
# Mysql-Client 설치
apt-get -y install mysql-client

# RDS 접속
mysql -u <db-user> -p -h <db-host> -P 3306
```