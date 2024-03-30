---
title: "[SpringBoot] 3. Spring Data"

tags:
    - SpringBoot

toc: true
toc_sticky: true

date: 2024-03-26
last_modified_at: 2024-03-30
---

## 스프링 데이터 (```Spring Data```) : 다양한 데이터 소스에 접근해 데이터를 활용

- 스프링 데이터는 여러 데이터 스토어를 지원하는 개별 프로젝트를 포함하는 상위 프로젝트
  - 여러 데이터 소스의 데이터를 다룰 때 일관성 있는 프로그래밍 모델 제공
  - 비즈니스 도메인 객체를 특정 데이터 스토어에 저장 가능
  - 관계형 데이터베이스와 스프링 데이터 ```JPA```를 사용해서 비즈니스 객체 관리 가능
- 스프링 템플릿 (```Spring Template```) : 특정 데이터베이스의 다양한 연산을 수행 가능한 클래스
  - 템플릿 클래스에서 저장소별 특화된 자원을 관리하고 예외를 변환할 수 있게 해주는 헬퍼 메서드가 포함

### 스프링 데이터 모듈 (```Spring Data Module```)

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/4fce3081-c961-42e5-b1ba-b07b8d7cb31d" width="80%">

- 스프링 데이터 커먼즈 : 데이터 스토어의 독립적인 기초 컴포넌트로 구성
  - 스프링 데이터 ```JPA```의 ```JpaRepository``` 인터페이스는 스프링 데이터 커먼즈 내 ```PagingAndSortingRepository```의 ```CRUD```, 페이징, 정렬 기능을 상속<br><img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/666ac803-a66b-4d03-b3ba-64d8caf9117f" width="80%">
- 스프링 데이터 서브 모듈 : 특정 데이터베이스에 특화된 기능을 포함

### 스프링부트 어플리케이션 데이터베이스 연동 설정

> 요구사항 : 스프링부트에 관계형 데이터베이스를 연동하기 위해선, 어플리케이션에 관련 설정 작업을 해야 한다.

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/2fe98ffc-7530-4a29-8c15-5b386a9cc01c" width="80%">

- ```application.properties```에 데이터베이스 연결 정보를 작성할 수 있음

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/125bd13f-b45c-45e7-8363-4936c6ae6b33" width="80%">

> 요구사항 : 어플리케이션을 시작할 때, 데이터베이스 내 스키마를 적절히 초기화해야 한다.

- ```src/main/resources/``` 폴더의 ```.sql``` 파일을 통해 스키마 정의 및 스크립트 실행이 가능

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/ed4f1d35-6e23-4695-8691-83b53e0d73cc" width="80%">

### ```CrudRepository```, ```PagingAndSortingRepository``` 인터페이스 이해

- ```Repository``` : 비즈니스 도메인 클래스와 그 식별자로 데이터 소스 접근을 추상화하는 인터페이스
  - 객체의 런타임 타입 정보만을 알려주는 마커 (```marker```) 인터페이스

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/21d76eb4-360c-4728-970e-8e89a694ec35" width="80%">

- ```CrudRepository``` : ```Repository```를 상속받아 ```CRUD``` 연산을 포함하는 하위 인터페이스

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/e9253a24-e0b4-41fa-bd24-ed593e818519" width="80%">

- ```PagingAndSortingRepository``` : 페이징 (```pagination```)과 정렬 (```sort```) 기능을 포함

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/974dcccb-9eec-4414-a7e7-e151658f5a3d" width="80%">

> 요구사항 : 스프링 데이터 ```JPA```를 사용해 도메인 객체를 관계형 데이터베이스에 저장하고 관리한다.

- 엔티티에 ```@Id```, ```@Column```, ```GeneratedValue``` 어노테이션 추가
  - ```@Transactional``` : 메소드 실행 중 발생하는 데이터 작업을 하나의 트랙잭션으로 처리

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/46bfc342-f746-46f2-932d-c54da6119e1c" width="80%">

- 엔티티를 관리하기 위한 레포지토리 인터페이스 작성

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/466f2dd2-eb57-4794-b63b-35018944d03e" width="80%">

### 쿼리 메소드, ```@NamedQuery```를 통한 스프링 데이터를 사용한 데이터 조회

- 쿼리 메소드 : 리포지토리 인터페이스에 정의하는 메소드 이름을 패턴에 맞춰 작성하면 이름을 파싱해 쿼리 생성

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/b7a77f68-f866-4070-9107-1861e56843c5" width="80%">

- ```@NamedQuery``` : 직접 쿼리문을 지정해 데이터를 조회 (2개 이상의 테이블을 조인해 데이터를 조회)
  - ```@@Modifying``` : ```@Query``` 에 정의된 쿼리가 조회가 아닌 수정 작업을 수행한다는 것을 명시

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/c3772e60-0728-4f77-90c9-5cc44552742a" width="80%">

### 타입 검사, 쿼리 정적 검사를 위한 ```Criteria API``` 사용

- ```Criteria API``` : 쿼리를 단순 문자열이 아닌 프로그램 코드로 작성해 타입 안정성 보장 가능

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/496e64e0-1202-45c5-94fa-bc15d25758cf" width="80%">

### 스프링 데이터 ```JPA```와 ```QueryDSL```

- ```QueryDSL``` : ```Criteria API```처럼 타입 안정성을 보장하고, 평문형 ```API```로 코드 작성량 을 줄임
  - 쿼리에 포함된 엔티티 타입이 실제로 존재하고, 해당 엔티티를 데이터베이스에 저장 가능
  - 쿼리에 포함된 모든 프로퍼티가 엔티티에 실제로 조직하고, 해당 프로퍼티를 데이터베이스에 저장 가능
  - 모든 ```SQL``` 연산자에는 적합한 타입이 사용되며, 최종 쿼리가 문법적으로 올바름

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/6e06e455-8a6a-4851-a84d-50e3490cea87" width="80%">

- ```querydsl-apt``` : 소스 파일의 어노테이션을 컴파일 단계 이전에 먼저 처리하는 어노테이션 처리 도구
  - 어플리케이션에 포함된 엔티티 클래스를 바탕으로 ```Q```-타입 클래스 생성
- ```querydsl-jpa``` : ```JPA```를 사용하는 어플리케이션에서 ```QueryDSL```을 사용할 수 있게 함
- ```apt-maven-gradle``` : 메이븐의 프로세스 골에서 ```Q```-타입 클래스가 생성되는 것을 보장
  - ```outputDirectory``` 프로퍼티로 ```Q```-타입 클래스 파일이 저장될 위치 지정

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/fb3eebf7-6845-4cbf-aafa-d43c23fb7867" width="80%">
