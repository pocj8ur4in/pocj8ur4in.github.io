---
title: "[MicroService] 5. MicroService Design"

tags:
    - MicroService

toc: true
toc_sticky: true

date: 2024-01-16
last_modified_at: 2024-01-16
---

## 마이크로서비스 설계 : 응집성 높게 (```High Cohesion```), 의존도 낮게 (```Low Coupling```)

- 마이크로서비스의 내부 구조를 구성하는 각 요소들은 역할별로 모듈화 (```Modulation```)되어야 함
  1. 자체적인 응집도가 높고, 서로 간의 의존성이 낮은 모듈들이 모여 하나의 마이크로서비스를 이룸
  2. 하나의 마이크로서비스는 다른 마이크로서비스와 의존성이 낮아야 함

→ 마이크로서비스를 구성하는 각각의 요소들을 모두 유연해야 한다.

### 마이크로서비스를 도출하는 방법

- 

> Reference
>
> - <a href="https://www.aladin.co.kr/m/mproduct.aspx?ItemId=285280054">도메인 주도 설계로 시작하는 마이크로서비스 개발</a>