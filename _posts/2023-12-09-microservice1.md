---
title: "[MicroService] 1. MicroService"

tags:
    - MicroService

toc: true
toc_sticky: true

date: 2023-12-09
last_modified_at: 2023-12-14
---

## 비즈니스 민첩성 : 자신의 특화된 서비스를 빠르게 제공하고, 피드백을 반영해 서비스를 빠르게 개선

- 빠른 배포 주기 : 비즈니스 민첩성을 간접적으로 보여주는 지표 → 어떻게 빠른 비즈니스 속도를 가질 수 있을까?


### 클라우드 인프라 (```Cloud Infra```)의 등장 : 아마존의 ```AWS```, 구글의 구글 클라우드 플랫폼
- 비용 측면 : 클라우드의 사용량에 따라 비용을 유연하게 조정할 수 있음 → 사용한 만큼만 비용을 지불
- 어플리케이션 측면 : 어플리케이션을 여러 개의 블록처럼 관리해 효율성을 극대화
  - 사용량 증가에 따른 성능 및 가용성을 ```Scale-up```, ```Scale-out``` → 특정 부분만 탄력성 있게 확장 가능

### 어떤 서비스가 클라우드 인프라에 적합할까 : 클라우드 프랜들리? 클라우드 네이티브?
- 클라우드 프렌들리 (```Cloud Friendly```) : 시스템을 하나의 큰 덩어리로 만들어 클라우드 인프라에 올리는 것
- 클라우드 네이티브 (```Cloud Native```) : 시스템을 여러 개의 블록 단위로 나누어 클라우드 인프라에 올리는 것

## 마이크로서비스 (```MicroService```) : 여러 서비스 인스턴스가 하나의 비즈니스 어플리케이션 구성
- 서비스가 갖는 저장소가 각각 다르므로 업무 단위로 모듈 경계가 명확하게 구분
  - 확장하거나 변경할 때에는 특정 기능별로 독립적으로 작업한 뒤에 빌드해서 배포하면 됨
  - 각 서비스가 독립적이기에 서로 다른 언어, 데이터, 기술로도 개발 가능 → 폴리글랏 (```Polyglot```)

> 마이크로서비스 이전에는? : 모노리스 (```Monolith```)
> - 전체 시스템이 하나의 단위로 개발되는 일체식 어플리케이션
> - 일반적으로 클라이언트, 어플리케이션, 데이터베이스의 ```3-tier``` 시스템으로 구성
> - 아무리 작은 변화에도 새로운 버전으로 전체를 빌드해서 배포해야 함
> - 단일 프로세스에서 실행되므로, 확장이 필요할 경우에 전체 어플리케이션을 동시에 확장해야 함
>   - 로드밸런서를 앞에 두고 여러 인스턴스 위에 큰 덩어리를 복제해 스케일 아웃

### 마이크로서비스를 위한 조건은 무엇인가?

1. #### 업무 기능 중심 팀
- 콘웨이 법칙 (```Conway’s law```) : 시스템을 개발할 때 항상 시스템의 모양이 팀 의사소통 구조를 반영
  - 마이크로서비스를 만드는 팀은 역할이나 기술이 아닌, 업무 기능을 중심으로 한 팀이 되어야 함
- 기획자, 디자이너, 프론트엔드 개발자, 백엔드 개발자, 테스터 등 다양한 역할의 인원으로 구성
  - 서비스를 처음부터 끝까지 만들기 위한 모든 단계의 역할을 갖추고 있음
  - 같은 공간, 같은 시간을 공유하기에 의사소통이 원활하고 빠르게 진행할 수 있음
  - 여러 기능들이 모여 있다는 의미에서 다기능 팀 (```Cross-Functional Team```)이라고도 부름

1. #### 자율적인 분권 거버넌스
- 각 마이크로서비스 팀은 빠르게 서비스를 만드는 것을 최우선 목적으로 함
  - 중앙의 강력한 표준이나 절차 준수를 강요받지 않음
  - 스스로 효율적인 방법론과 도구, 기술을 찾아 적용 → 폴리글랏 프로그래밍, 폴리글랏 저장소

1. #### 제품 중심의 생명 주기
- 개발 모델이 프로젝트 단위가 아니라 제품 단위로 구성됨 → 개발 조직과 운영 조직이 결합
- 소프트웨어를 완성해야 할 기능들의 집합이 아닌, 비즈니스를 제공하는 제품 (```Product```)로 봄
  - 우선 빠르게 개발한 뒤에 반응을 보고 개선하는 방식으로 개발
  - 프로젝트 형태의 워터풀 (```WaterFall```) 개발 방식이 아닌, 제품 중심의 에자일 (```Agile```) 개발 방식 채용
  - 2~3주 단위의 스프린트 (```Sprint```)를 통해 소프트웨어에 피드백을 즉각적으로 반영

1. #### ```CI/CD``` 파이프라인의 자동화
- 개발과 운영을 동시에 수행하는 데비옵스 (```DevOps```)를 궁극적으로 가능하게 함
- 각각의 ```CI/CD``` 파이프라인 프로세스는 ```CI/CD``` 파이프라인 도구를 통해 자동화가 이루어짐
  - ‘```Infrastructure as Code```’ : 코드를 이용해 인프라 구성부터 어플리케이션 빌드 및 배포를 정의

1. #### 분권 데이터 관리
- 폴리글랏 저장소 (```Polyglot Persistence```) 접근법 : 서비스별로 데이터베이스를 갖도록 설계
  - 각각의 저장소가 서비스별로 분산되어 있으며, 다른 서비스에 ```API```를 통해 접근함
- 결과적 일관성 (```Eventual Consistency```) : 일시적으로 다른 두 서비스의 데이터가 결국엔 동일해짐
  - 여러 트랜잭션을 하나로 묶지 않고, 별도의 로컬 트랙잭션을 수행
  - 각 저장소 내 데이터의 비즈니스 정합성을 위해 데이터 일관성이 다른 부분을 보상 트랙잭션으로 맞춤

1. #### 내결함성을 고려한 설계
- 내결함성 (```Fault Tolerance```) : 시스템은 언제든 실패할 수 있는 가능성이 존재한다.
  - 시스템이 실패해서 더는 진행할 수 없을 때에도, 자연스럽게 대응할 수 있도록 설계하여야 함
- 다양한 실패에 대비해 완벽히 테스트할 수 있는 환경을 마련해야 함
- 시스템의 실패를 감지하고 대응하기 위한 실시간 모니터링 체계 또한 갖춰야 함
- 장애를 일부러 발생시키는 카오스 몽키 (```Chaos Monkey```)를 만들어 아키텍처 동작을 점검하기도 함

> Reference
>
> - <a href="https://www.aladin.co.kr/m/mproduct.aspx?ItemId=285280054">도메인 주도 설계로 시작하는 마이크로서비스 개발</a>