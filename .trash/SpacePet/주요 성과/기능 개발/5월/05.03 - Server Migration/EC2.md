## EC2

![image-20230504150121000](../img/insfamily.png)

rg6 ↔ m6g 차이점

도커 컨테이너 로그 → 외부 마운트 → 관리 용이하게 (하루 차이나게 전송) ex: 2023.05.01.log

ContainerRegistry 구축 or AWS registry 알아보기. 도커용 서버 따로 (보안 중요)

Ec2 → S3로 컨테이너 로그가 나갈 시 비용 추적

CI/CD → 유지보수성, 관리 차원, 기술적 이점 등 고려

---

### 요구사항

rg6 ↔ m6g 차이점

도커 컨테이너 로그 → 외부 마운트 → 관리 용이하게 (하루 차이나게 전송) ex: 2023.05.01.log

ContainerRegistry 구축 or AWS registry 알아보기. 도커용 서버 따로 (보안 중요)

Ec2 → S3로 컨테이너 로그가 나갈 시 비용 추적

CI/CD → 유지보수성, 관리 차원, 기술적 이점 등 고려

---

### Candidates

- rg6.medium (network = 10GB, EBS) : **0.061$**
- t4g.large (network = 5GB, EBS) : **0.0832$**
- m6g.large (network = 10GB, EBS) : **0.0997$**

<br>

### rg6.medium

**Reserved Instance - 1 Year 기준**

선결제 X

- 27.96$ X 12 Month = **335.52$**

부분 선결제

- 159.87$ + (monthly 13.32 X 12 = 159.84) = **319.71$**

전체 선결제

- **313.61$**

<br>

**Reserved Instance - 3 Year 기준**

선결제 X

- 19.35$ X 12 Month = **232.20$**

부분 선결제

- 321.93$ + (monthly 8.94 X 12 = 107.28) = **429.21$**

전체 선결제

- **604.44$**

---

### m6g.large

**Reserved Instance - 1 Year 기준**

선결제 X

- 53.22$ X 12 Month = **638.64$**

부분 선결제

- 305$ (선결제) + (monthly 25.48 X 12 = 305.76) = **610.76$**

전체 선결제

- **599.00$**

<br>

**Reserved Instance - 3 Year 기준**

선결제 X

- 47.89$ X 12 Month = **574.68$**

부분 선결제

- 275$ (선결제) + (monthly 22.92 X 12 = 275.04) = **550.04$**

전체 선결제

- **539.00$**

---

![image-20230503144754286](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/ec2_2.png)

---

## rg6 vs mg6



### rg6.medium

### 메모리 집약적인 워크로드를 위한 높은 가격 대비 성능

고객은 R6g 인스턴스를 사용하여 더 높은 성능과 더 낮은 GiB당 비용을 모두 최적화할 수 있습니다. R6g 인스턴스는 Linux 배포판을 사용하는 오픈 소스 소프트웨어에 구축된 수많은 애플리케이션에 대해 현재 세대 R5 인스턴스 1 보다 최대 40% 향상된 가격 대비 성능을 제공합니다 .

### 유연성과 선택

R6g 인스턴스는 EC2 인스턴스의 가장 광범위하고 심층적인 선택 항목에 추가되어 고객이 오픈 소스 데이터베이스, 인 메모리 캐시 및 실시간 빅 데이터 분석과 같은 광범위한 메모리 집약적 워크로드를 실행할 수 있도록 합니다. 또한 개발자는 EC2에서 실행되는 유연성, 보안, 안정성 및 확장성을 활용하면서 기본적으로 클라우드에서 Arm 애플리케이션을 구축할 수 있습니다.

### 보안 강화 및 리소스 효율성 극대화

R6g 인스턴스는 AWS Graviton2 프로세서로 구동되며 AWS Nitro 시스템에 구축됩니다. AWS Graviton2 프로세서는 상시 작동 256비트 DRAM 암호화를 제공하며 1세대 AWS Graviton에 비해 코어당 암호화 성능이 50% 더 빠릅니다. AWS Nitro 시스템은 전용 하드웨어와 경량 하이퍼바이저의 조합으로 호스트 하드웨어의 거의 모든 컴퓨팅 및 메모리 리소스를 인스턴스에 제공하여 전반적인 성능과 보안을 향상시킵니다. R6g 인스턴스는 기본적으로 암호화된 EBS 스토리지 볼륨도 지원합니다.

### 광범위한 생태계 지원

AWS Graviton2 기반 EC2 인스턴스는 Amazon Linux 2, Red Hat, SUSE 및 Ubuntu를 비롯한 널리 사용되는 Linux 운영 체제에서 지원됩니다. Amazon ECS, Amazon EKS, Amazon ECR, Amazon CodeBuild, Amazon CodeCommit, Amazon CodePipeline, Amazon CodeDeploy, Amazon CloudWatch, Crowdstrike, Datadog, Docker, 드론, Dynatrace, GitLab, Jenkins, NGINX, Qualys, Rancher, Rapid7, Tenable 및 TravisCI.

<br>

### m6g.large

### 범용 워크로드에 대한 높은 가격 대비 성능

M6g 인스턴스를 사용하면 vCPU당 성능이 개선되고 비용은 절감되므로 성능과 비용 측면에서 모두 최적화할 수 있습니다. M6g 인스턴스는 Linux 배포를 활용하는 오픈 소스 소프트웨어에 구축된 많은 애플리케이션에서 M5 인스턴스보다 최대 40% 향상된 가격 대비 성능을 제공합니다.

### 유연성 및 선택권

M6g 인스턴스는 가장 포괄적이고 심층적인 EC2 인스턴스의 옵션에 추가되며, 고객은 이를 통해 애플리케이션 서버, 중간 규모의 데이터 스토어 및 마이크로서비스와 같은 다양한 워크로드를 실행할 수 있습니다. 개발자는 클라우드에서 내재적으로 Arm 애플리케이션을 구축할 수 있으며, EC2에서 실행할 때의 유연성, 보안, 안정성 및 확장성 혜택을 받을 수 있습니다.

### 향상된 보안 및 극대화된 리소스 효율성

M6g 인스턴스는 AWS Graviton2 프로세서로 구동되며, AWS Nitro System에 구축됩니다. AWS Graviton2 프로세서는 상시 구동 256비트 DRAM 암호화를 지원하며, 1세대 AWS Graviton에 비해 50% 더 빠른 코어당 암호화 성능을 제공합니다. AWS Nitro System은 전용 하드웨어와 경량 하이퍼바이저를 함께 제공합니다. 인스턴스에서 실질적으로 호스트 하드웨어의 모든 컴퓨팅 및 메모리 리소스를 사용할 수 있으므로 전반적인 성능 및 보안이 향상됩니다. M6g 인스턴스는 기본적으로 암호화된 EBS 스토리지 볼륨도 지원합니다.

### 포괄적인 에코시스템 지원

AWS Graviton2 기반 EC2 인스턴스는 Amazon Linux 2, Red Hat, SUSE, Ubuntu 등의 널리 사용되는 Linux 운영 체제에서 지원됩니다. AWS 및 ISV(Independent Software Vendor)의 널리 사용되는 많은 애플리케이션과 서비스는 Amazon ECS, Amazon EKS, Amazon ECR, Amazon CodeBuild, Amazon CodeCommit, Amazon CodePipeline, Amazon CodeDeploy, Amazon CloudWatch, Crowdstrike, Datadog, Docker, Drone, Dynatrace, GitLab, Jenkins, NGINX, Qualys, Rancher, Rapid7, Tenable 및 TravisCI를 포함하여 AWS Graviton2 기반 인스턴스도 지원합니다.

---

### Graviton 1 Graviton 2 Processor

![image-20230504145259123](../img/Graviton.png)