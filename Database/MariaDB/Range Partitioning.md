## 📘 Table Range Partitioning

이번에 로그 테이블과 통계 처리 테이블의 효율적인 관리를 위해 테이블 파티셔닝을 사용하게 되어 작성합니다.

통계 테이블은 Redis에서 통계 처리 로직을 거친 데이터들이 들어오게 되는데,

데이터의 양이 많고 Insert가 많이 일어나는 테이블, **특정 주기를 기준(Range)**으로 파티션 테이블의 삭제 등,

로그, 통계 데이터의 관리 방법으로 테이블 파티셔닝(Range Partitioning 방식)을 선택하게 되었습니다.

<br>

> 📕 **파티션 테이블이란?**

DB 테이블의 데이터가 너무 많아서 어떤 데이터를 조회하려고 할때 시간이 너무 많이 소요될때,

여러 방법중 파티셔닝을 하는 방법을 사용할 수 있습니다.

<br>

파티션 테이블은 논리적으로 1개의 테이블이지만 물리적으로 여러개의 파티션으로 나뉘어,

각각의 세그먼트에 저장되는 테이블이라고 생각하면 됩니다.

<br>

파티션 테이블은 **Pruning** 기능이 존재해 특정 데이터를 조회할 때 그 데이터에 속한 세그먼트만 빠르게 조회 가능합니다.

뿐만 아니라 논리적으로 하나의 테이블로 간주하기 떄문에 조회 쿼리를 특별히 지정해줄 필요가 없으며,

데이터들이 물리적으로 다른 세그먼트에 저장되기 떄문에 개발, 관리 두 측면에서 장점이 있습니다.

<br>

> 📕 **파티션 테이블의 장점 & 단점**

**장점**

- Select Query Performance 향상 (ex: Table Full Scan이 필요한 Select Query)
- 디스크 장애 시 해당 파티션만 영향을 받으므로 데이터 손상 가능성 감소 / 가용성 향상
- 개별 Partition 단위 관리 가능 (DML, Load,  Import, Export, Exchange 등등)
- 논리적으로 하나의 테이블이기 떄문에 개발된 쿼리문의 변경이 필요 없음
- Join 시 파티션 간 병렬 처리 및 파티션 내의 병렬 처리 수행
- Data Access 범위를 줄여 성능 향상 / 테이블의 파티션 단위로 디스크의 I/O 부하 분산

<br>

**단점**

- 파티션 키 값 변경에 대한 별도 관리 필요
- 파티션의 기준이 되는 것이 컬럼의 일부일 때 그 컬럼을 기준으로 파티션 구성 불가, 오버헤드 컬럼이 존재해야 함
- 데이터를 입력 받았을 때 연산 오버헤드가 발생해 테이블의 Insert 속도가 느려짐
- Join에 대한 처리 비용 증가

<br>

> 📕 **파티션 키 컬럼 (파티셔닝 키)**

파티션의 키 컬럼은 보통 많이 사용되는 Range Partition Table에서 물리적으로 테이블이 나뉘는 기준이 되는 컬럼으로,

데이터가 어느 세그먼트에 들어갈 수 있는지 직관적으로 확인이 가능한 Month, Year같은 날짜(DT) 컬럼으로 많이 지정합니다.

<br>

Range Partitoning에서의 Load Banlancing은 Partition Key에 의존하므로,

파티션 키 선정 시 중요하게 고려해야 할 대상입니다.

- Primary Key 같이 데이터 구분이 안되는 컬럼은 피해야 함
- 데이터가 어디에 들어가 있는지 직관적 판단이 가능한 컬럼 (날짜 컬럼)
- I/O 병목을 줄일 수 있는 데이터 분포도가 양호한 컬럼

---

##  📘 **Table Partition 생성**

> 📕 **Partition MGMT Table**

Table Partitioning을 위한 Partition Management Table 입니다.

- **pre_creation_period** : 파티션 사전생성기간(period_type 값에 따라 일/주/월/년수.period_type이 D 이고 pre_creation_period 가 30이면 30일 사전 생성합니다.
- **retention_period** : 파티션 보유기간(period_type 값에 따라 일/주/월/년수.period_type이 D 이고 retention_period 가 30이면 30일 보관합니다.

```sql
CREATE TABLE IF NOT EXISTS `partition_mgmt` (  
    `table_name` varchar(100) NOT NULL COMMENT '파티션 테이블명',  
    `column_name` varchar(30) NOT NULL COMMENT '파티션 컬럼명',  
    `period_type` varchar(1) NOT NULL COMMENT '파티션 기간타입(D/W/M/Y)',  
    `pre_creation_period` int(11) NOT NULL,  
    `prefix_name` varchar(20) NOT NULL COMMENT '파티션 접두어명',  
    `retention_period` int(11) NOT NULL,  
    `reg_dt` datetime(3) NOT NULL COMMENT '등록일자',  
    `reg_id` int(11) NOT NULL COMMENT '등록자 ID',  
    `upd_dt` datetime(3) NOT NULL COMMENT '수정일자',  
    `upd_id` int(11) NOT NULL COMMENT '수정자 ID',  
    PRIMARY KEY (`table_name`)  
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='공통-파티션 테이블 관리'; 
```

<br>

> 📕 **Log Table Partitining**

알람 로그 기록을 위한 테이블을 5달 분량의 데이터만 보존하고, 기간이 지난 파티션 테이블을 자동으로 삭제합니다.

```sql
 CREATE TABLE IF NOT EXISTS `svc_alarm_sent_log` (  
    `alarm_sent_log_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '알람 전송 로그 ID',  
    `yyyymmdd` varchar(8) NOT NULL COMMENT '생성일자',   
    `item_id` int(11) NOT NULL COMMENT 'Item ID',  

		... 등등등
		
    `reg_dt` datetime(3) NOT NULL COMMENT '등록일자',  
    `reg_id` int(11) NOT NULL COMMENT '등록자 ID',  
    PRIMARY KEY (`alarm_sent_log_id`,`yyyymmdd`)  
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='서비스-알람전송이력'  
    PARTITION BY RANGE COLUMNS (`yyyymmdd`) (  
    PARTITION PT_202309 VALUES LESS THAN ('20231001'),  
    PARTITION PT_202310 VALUES LESS THAN ('20231101'),  
    PARTITION PT_202311 VALUES LESS THAN ('20231201'),  
    PARTITION PT_202312 VALUES LESS THAN ('20240101'),  
    PARTITION PT_202401 VALUES LESS THAN ('20240201')  
    ); 
```

<br>

> 📕 **Statistics Table Partitioning**

15초 단위의 통계 처리를 위한 테이블을 1달치 분량의 데이터만 보존하고, 기간이 지난 파티션 테이블을 자동으로 삭제합니다.

```sql
CREATE TABLE IF NOT EXISTS `svc_15sec_stats` (  
    `yyyymmdd` varchar(8) NOT NULL COMMENT '생성일자',  
    `hhmiss` varchar(6) NOT NULL COMMENT '시간분초',  
    `item_id` int(11) unsigned NOT NULL COMMENT 'Item ID',  
    
    .. 등등등 
    
    `reg_dt` datetime(3) NOT NULL COMMENT '등록일자',  
    `reg_id` int(11) NOT NULL COMMENT '등록자 ID',  
    `upd_dt` datetime(3) NOT NULL COMMENT '수정일자',  
    `upd_id` int(11) NOT NULL COMMENT '수정자 ID',  
    PRIMARY KEY (`yyyymmdd`,`hhmiss`, `camera_id`)  
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='서비스-통계(15초단위)'  
    PARTITION BY RANGE COLUMNS(`yyyymmdd`) (  
    PARTITION PT_20231001 VALUES LESS THAN ('20231002'),  
    PARTITION PT_20231002 VALUES LESS THAN ('20231003'),  
    PARTITION PT_20231003 VALUES LESS THAN ('20231004'),  
    PARTITION PT_20231004 VALUES LESS THAN ('20231005'),  
    PARTITION PT_20231005 VALUES LESS THAN ('20231006'),  
    PARTITION PT_20231006 VALUES LESS THAN ('20231007'),  
    PARTITION PT_20231007 VALUES LESS THAN ('20231008'),  
    PARTITION PT_20231008 VALUES LESS THAN ('20231009'),  
    PARTITION PT_20231009 VALUES LESS THAN ('20231010'),  
    PARTITION PT_20231010 VALUES LESS THAN ('20231011'),  
    PARTITION PT_20231011 VALUES LESS THAN ('20231012'),  
    PARTITION PT_20231012 VALUES LESS THAN ('20231013'),  
    PARTITION PT_20231013 VALUES LESS THAN ('20231014'),  
    PARTITION PT_20231014 VALUES LESS THAN ('20231015'),  
    PARTITION PT_20231015 VALUES LESS THAN ('20231016'),  
    PARTITION PT_20231016 VALUES LESS THAN ('20231017'),  
    PARTITION PT_20231017 VALUES LESS THAN ('20231018'),  
    PARTITION PT_20231018 VALUES LESS THAN ('20231019'),  
    PARTITION PT_20231019 VALUES LESS THAN ('20231020'),  
    PARTITION PT_20231020 VALUES LESS THAN ('20231021'),  
    PARTITION PT_20231021 VALUES LESS THAN ('20231022'),  
    PARTITION PT_20231022 VALUES LESS THAN ('20231023'),  
    PARTITION PT_20231023 VALUES LESS THAN ('20231024'),  
    PARTITION PT_20231024 VALUES LESS THAN ('20231025'),  
    PARTITION PT_20231025 VALUES LESS THAN ('20231026'),  
    PARTITION PT_20231026 VALUES LESS THAN ('20231027'),  
    PARTITION PT_20231027 VALUES LESS THAN ('20231028'),  
    PARTITION PT_20231028 VALUES LESS THAN ('20231029'),  
    PARTITION PT_20231029 VALUES LESS THAN ('20231030'),  
    PARTITION PT_20231030 VALUES LESS THAN ('20231031'),  
    PARTITION PT_20231031 VALUES LESS THAN ('20231101')  
    );
```