## **💡 데이터베이스가 필요한 이유**

<br>

-  In-Memory
  - 끄면 데이터가 사라짐
- File I/O
  - 원하는 데이터만 가져올 수 없고 항상 모든 데이터를 가져온 뒤 서버에서 필터링 필요
- Database
  - 필터링 외에도 File I/O로 구현이 힘든 관리를 위한 여러 기능들을 가지고 있는 데이터에 특화된 서버

<br>

기본 문법

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/RDBMS.png) 

------

## **💡 데이터베이스 관련 명령어**

<br>

```sql
# DB 생성 / 사용
CREATE DATABASE 디비명;
USE 디비명;


# Table 생성
CREATE TABLE user (
id INT PRIMARY KEY AUTO_INCREMENT,
name varchar(255),
email varchar(255)
);


# Table 정보 조회
DESCRIBE user;


# SELECT
# 1.일반 문자열
SELECT 'hello world';
# 2.숫자
SELECT 2;
# 간단한 연산
SELECT 15 + 3;


# FROM
# 1.특정 특성을 테이블에서 사용
SELECT 특성_1 FROM 테이블_이름;
# 2.몇가지의 특성을 테이블에서 사용
SELECT 특성_1, 특성_2 FROM 테이블_이름;
# 3.테이블의 모든 특성을 선택
SELECT * FROM 테이블_이름;


# WHERE
# 1.특정 값과 동일한 데이터 찾기
SELECT 특성_1, 특성_2 FROM 테이블_이름 WHERE 특성_1 = "특정 값";
# 2.특정 값을 제외한 값을 찾기
SELECT 특성_1, 특성_2 FROM 테이블_이름 WHERE 특성_2 <> "특정 값";
# 3.특정값보다 크거나 작은 데이터를 필터링할땐 < > 비교하는 값을 포함하는 이상,이하값은 <= >= 사용
SELECT 특성_1,특성_2 FROM 테이블_이름 WHERE 특성_1 > "특정 값"
SELECT 특성_1,특성_2 FROM 테이블_이름 WHERE 특성_1 <="특정 값"
# 4.문자열에서 특정 값과 비슷한 값들을 필터링 할때 LIKE와 \% 혹은 \* 사용
SELECT 특성_1,특성_2 FROM 테이블_이름 WHERE 특성_2 LIKE "%특정 문자열%";
# 5.리스트의 값들과 일치하는 데이터를 필터링 할때 IN 사용
SELECT 특성_1,특성_2 FROM 테이블_이름 WHERE 특성_2 IN ("특정값_1", "특정값_2");
# 6.값이 없는 경우 NULL을 찾을 때 IS 와 같이 사용
SELECT * FROM 테이블_이름 WHERE 특성_1 IS NULL;
# 7.값이 없는 경우를 제외 할때는 NOT을 추가해 사용
SELECT * FROM 테이블_이름 WHERE 특성_1 IS NOT NULL;


#ORDER BY
# 1.기본 정렬 = 오름차순
SELECT * FROM 테이블_이름 ORDER BY 특성_1;
# 2. 내림차순
SELECT * FROM 테이블_이름 ORDER_BY 특성_1;


# LIMIT
# 1.데이터 결과를 200개만 출력
SELECT * FROM 테이블_이름 LIMIT 200;


# DISTINCT
# 1.특성_1을 기준으로 유니크한 값들만 선택
SELECT DISTINCT 특성_1 FROM 테이블_이름;


# INNER JOIN (INNER JOIN 이나 JOIN으로 실행 가능)
# 1.둘 이상의 테이블을 서로 공통된 부분을 기준으로 연결
SELECT * FROM 테이블1 JOIN 테이블_2 ON 테이블_1.특성_A = 테이블_2.특성_B;


# OUTTER JOIN
# 1.LEFT OUTER JOIN으로 LEFT INCLUSIVE를 실행
SELECT * FROM 테이블_1 LEFT OUTER JOIN 테이블_2 ON 테이블_1.특성_A = 테이블_2.특성_B;
# 2.RIGHT OUTER JOIN으로 RIGHT INCLUSIVE를 실행
SELECT * FROM 테이블_1 RIGHT OUTER JOIN 테이블_2 ON 테이블_1.특성_A = 테이블_2.특성_B;
```

------

## **💡 트랜잭션(Transaction) 이란?**

데이터베이스의 상태를 변화시키는 논리적 기능수행을 위해 행하는 하나 이상의 쿼리를 모은 작업단위.

<br>

그럼 트랜잭션 발생시 안정성을 어디서 보장 할 수 있을까?

ACID를 성질을 이용한 안정성 보장이 있다.

------

## **💡 ACID 란?**

- **Atomicity (원자성)**
  - 하나의 트랜잭션 내에선 모든 연산이 성공하거나 실패할 가능성이 있으면 실패해야 함.
- **Consistency (일관성)**
  - 하나의 타랜잭션 전후에 데이터베이스의 일관된 상태유지가 되어야 함.
- **Isolcation (고립성)**
  - 각각의 트랜잭션은 독립적. 서로의 연산을 확인받거나 영향을 줄 수 없다.
- **Durability (지속성)**
  - 하나의 성공된 트랜잭션에 대한 로그가 기록되고 영구적으로 남는다.

------

## **💡 MySQL 설치**  

- https://www.mysql.com/ MySQL Community 다운로드

------

## **💡 Centos에 설치**  

- yum -y install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
- yum repolist enabled | grep "mysql.*"
- rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
- yum -y install mysql-server
- grep 'temporary password' /var/log/mysqld.log <- 임시 비밀번호 확인
- mysql -u root -p 로그인
- ALTER USER 'root'@'localhost' identified with mysql_native_password by '[pw]';
- echo 'validate_password.policy=LOW' | sudo tee -a /etc/my.cnf
  echo 'default_password_lifetime=0' | sudo tee -a /etc/my.cnf
  echo 'validate_password.length=6' | sudo tee -a /etc/my.cnf
  echo 'validate_password.special_char_count=0' | sudo tee -a /etc/my.cnf
  echo 'validate_password.mixed_case_count=0' | sudo tee -a /etc/my.cnf
  echo 'validate_password.number_count=0' | sudo tee -a /etc/my.cnf
- set global validate_password.policy=LOW;

<br>

인텔리제이 <-> 개인 리눅스 서버(mysql 연동)

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/RDBMS2.png) 