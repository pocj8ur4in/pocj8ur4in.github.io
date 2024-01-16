---
title: "[MicroService] 4. Agile Development Process"

tags:
    - MicroService

toc: true
toc_sticky: true

date: 2024-01-15
last_modified_at: 2024-01-16
---

## 에자일 개발 프로세스 (```Agile Development Process```) : 피드백을 통한 지속적인 개선 추구

- 에자일 방법론 (```Agile Methodology```) : 신속한 반복 작업으로 소프트웨어를 지속적으로 제공하고자 함
  - ```CI/CD```, ```DevOps``` 등의 에자일 방법론 중심의 프랙티스
  - 효율적인 의사소통 구조와 협업 체계를 가진 다기능 팀으로 만듣 수 있는 결과물 → '마이크로서비스'
  - ```XP```의 '지속적 통합' 프랙티스 : 품질이 보장된 소프트웨어를 반복적으로 개발할 수 있게 함
  - 스크럼 프로세스 : '스크럼 팀'이라는 조직과 '스프린트'라는 짧은 반복 주기를 통해 피드백과 개선 작업을 촉진함

> ```XP```나 스크럼을 살펴보면 개발 문화 및 관리 프로세스를 자세히 다루나, 설계 및 개발 공정에 대해 자세히 언급하지 않음
>
> - 에자일 자체가 성숙한 개발 문화에서 좋은 프랙티스을 가속화하고 기존 공정에서 낭비를 제거하는 방식으로 진행
>   - 개발 문화가 미성숙한 팀을 위해 기민한 반복 주기게 적합하며 핵심 활동에 집중할 수 있는 방법이 필요
>
> → ```DDD```를 중심으로 에자일 프로세스와 연계하여 마이크로서비스를 설계 및 개발하는 공정이 필요하다!

### 기민한 설계 및 개발을 위한 절차 → 스크럼 기반 마이크로서비스 개발 프로세스

- 스크럼 (```Scrum```) : 프로젝트 개발 및 관리를 위한 에자일 개발 방법론 중 하나
  1. 제품 백로그 (```Product Backlog```) : 개발할 제품에 대한 요구 사항 목록
  2. 스프린트 계획 회의 (```Sprint Planning Meeting```) : 스프린트 목표 및 스프린트 백로그를 계획하는 회의
  3. 스프린트 백로그 (```Sprint Backlog```) : 각 스프린트 목표에 도달하기 위해 필요한 작업 목록
  4. 스프린트 (```Sprint```) : 반복적인 개발 주기 (계획 회의부터 제품 리뷰가 진행되는 날짜까지의 기간 : 1~4주)
  5. 일일 스크럼 회의 (```Daily Scrum Meeting```) : 어제 한 일, 오늘 할 일, 장애 등을 공유하는 회의
  6. 시연 (```Testing```) : 초기에 정의한 백로그가 모두 구현되고 그 요건을 만족하는지 확인
  7. 회고 (```Review```) : 팀원들이 자기 스스로를 돌아보면서 개선점을 논의하여 다음 스프린트에 적용

#### 구현 스프린트를 진행하기 위한 준비 및 계획 → 아키텍처 정의 및 마이크로서비스 도출

- 아키텍처 정의 : 마이크로서비스 내부/외부 아키텍처를 정의하는 공정 → 아키텍처 구성도
  - 기존 워터풀 개발 방식과 달리, 기술 세부사항은 늦게 결정할 수 있어야 한다. (```Robert C. Martin```)
  - 그러나 최소한의 개발 및 테스팅 환경을 준비하는 게 바람직 : 스프린트에 실제 동작하는 어플리케이션 시연 가능
    - 도커나 쿠버네티스, 스프링부트 등을 미리 결정한다면, 빠르게 개발 환경을 구축해 개발 과정에 진입 가능
- 마이크로서비스 도출 : 스크럼 팀이 개발할 전체 마이크로서비스를 파악하는 작업 → 컨텍스트 맵
  - 모든 마이크로서비스를 하나의 스크럼 팀이 개발할 수 없음
  -  ```DDD```의 전략적 설계로 마이크로서비스를 도출하고, 그것들 간의 대략적인 매핑 관계를 정의해, 우선순위 산정

#### 백엔드와 프런트엔드 개발 공정의 접목 → ```API``` 명세 & 도메인 모델링

> 백엔드와 프런트엔드 영역 간 계악으로 해당 작업이 선행되고, 각각의 공정이 영역을 나누어서 진행

- ```API``` 명세 (```API Details```) : 각 백엔드 마이크로서비스가 프론트엔드에 제공할 서비스 명제들을 정리
- 도메인 모델링 (```Domain Modeling```) : 화이트보드, 포스트잇 등으로 도메인 설계 모델을 작성
  - ```OOAD``` 방식과 다른 점? : ```UML``` 등으로 정형화된 설계 모델을 작성해 소스 코드로 변환하지 않음
    - 단순한 도구들로 작성해 이를 공유하고 피드백을 받아 곧바로 소스 코드로 도메인을 개발
  - ```MDD```와 다른 점? : 추상적인 모델을 완벽히 만들고, 특정 기술이나 프레임워크를 통해 구체화하지 않음
    - 코드 자체가 모델의 기본 표현 형식을 그대로 반영하므로, 모델과 코드가 단절되지 않음
  - 핵심 도메인 모델을 이해시키기 위해 역공학 도구를 통해 ```UML``` 모델을 표현할 수 있음

#### ```UI``` 레이아웃 정의 및 백엔드 ```API``` 호출 → 프론트엔드 영역 설계 및 개발

- ```UI``` 흐름 정의 : 비즈니스 흐름에 따른 ```UI``` 흐름 정의 → ```UI``` 스토리보드
- ```UI``` 레이아수 정의 : 사용자 접점인 사용자 인터페이스 정의 → 발사믹 오븐, 카카오 오븐 등으로 산출
- ```UI``` 이벤트 및 액션 정의 : ```UI``` 레이아웃 내에서 특정 행위를 했을 때 발생하는 이벤트 및 액션 정의
- ```UI``` 개발 : ```UI``` 레아아웃 및 이벤트에 맞게 프론트엔드 어플리케이션 개발 → ```UI``` 프레임워크 등으로 산출

#### 어플리케이션을 지속적으로 빌드하고 자동으로 배포 → 빌드 및 배포 환경 자동화

- 소스 코드 리포지토리 구성 : 프론트엔드, 백엔드 코드를 위한 소스 코드 저장소 구성 (```Git```)
- 통합 빌드 잡 (```Build Job```) 구성 : 리포지토리에 존재하는 소스 코드를 통합해 컴파일 및 테스트 (```Jenkins```)
- 컨테이너 생성 파일 생성 : 컨테이너 배포 환경에서 운영 체제, ```WAS```, 어플리케이션을 묶어 이미지 생성 (```Dockerfile```)
- 배포 스크립트 : 자동으로 배포되는 스크립트 작성 (```Jenkins```, ```Github Actions```)

> Reference
>
> - <a href="https://www.aladin.co.kr/m/mproduct.aspx?ItemId=285280054">도메인 주도 설계로 시작하는 마이크로서비스 개발</a>