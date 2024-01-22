---
title: "[SpringBoot] 2. SpringBoot Common Task"

tags:
    - SpringBoot

toc: true
toc_sticky: true

date: 2024-01-22
last_modified_at: 2024-01-22
---

## 어플리케이션 설정 관리 : 여러 환경에 따른 설정 정보의 다중화

- 개발 환경의 다중화 → 개발 (```dev```), 테스트 (```test```), 스테이징 (```staging```), 배포 (```prod```)
  - 여러 환경에 배포할 때 설정 정보는 매번 변경되어야 하지만, 소스 코드는 변경되어선 안됨
  - 즉, 설정 정보를 외부화하여 관리할 필요성이 있음

> 어플리케이션 설정 관리 방법의 우선순위
>
> 1. 명령행 인자
> 2. 운영 체제의 환경 변수
> 3. 설정 정보 파일 (```application.properties``` 혹은 ```application.yml```)
> 4. ```@PropertySource```
> 5. ```SpringApplication```

### ```SpringApplication``` 클래스 사용

- 소스 코드로 정의하는 방식이므로 한 번 정의하면 나중에 바뀌지 않는 경우에 적합함
- ```java.util.Properties```나 ```java.util.Map<String, Object>```가 인자인 ```setDefaultProperties()``` 메소드 호출
  - ```Properties```나 ```Map<String, Object>```를 통해 설정 정보를 어플리케이션에 적용

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/41016cdc-001c-4c27-bc87-3d366061017f" width="80%">

- ```application.properties``` 파일은 다른 설정 파일들을 ```spring.config.import``` 프로퍼티를 통해 임포트해서 사용
  - ```spring.config.import=classpath:additional-application.properties```를 추가하면 스프링부트는 ```additional-application.properties``` 파일에 있는 설정 정보를 읽어 사용할 수 있음
    - 만약 클래스패스에 파일이 없으면, ```ConfigDataLocationNotFoundException``` 예외가 발생
    - ```spring.config.on-not-found```에 ```ignore```를 지정하면, 클래스파일에 설정 파일이 없을 때 예외 처리를 하고 종료하는 대신 어플리케이션 시동 작업을 계속 진행하게 할 수 있음

### ```@PropertySource``` 사용

- 설정 파일의 위치를 어노테이션을 사용해 지정 (자바 8 이후로는 동일한 어노테이션을 여러 번 사용할 수 있음)
  - ```src/main/resources/```의 파일은 ```JAR```로 패키징된 후 클래스패스에 위치하므로, 해당 디렉터리에 설정 파일 작성

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/080afe26-f960-4980-8551-1acc165c7d0e" width="80%">

- 스프링이 제공하는 ```Environment``` 인스턴스를 주입받으면, 설정 파일에 있는 정보를 읽을 수 있음

```
@SpringBootApplication
public class SpringBootApplication {
    public static final Logger log = Logger.getLogger(SpringBootApplication.class);

    public static void main(String[] args) {
        ConfigurableApplicationContext configurableApplicationContext
         = SpringApplication.run(SpringBootApplication.class, args);

        CustomConfiguration customConfiguration
         = applicationContext.getBean(CustomConfiguration.class);

        log.info(customConfiguration.toString());
    }
}
```

- ```@PropertySource```로는 ```.yml``` 파일 지정해서 사용할 수 없으므로, 추가적인 작업이 필요

### 환경 설정 파일 (```application.properties``` 또는 ```application.yml```)

- 환경 설정 파일에 명시된 설정 프로퍼티 정보는 스프리의 ```Environment``` 객체에 로딩
  - 어플리케이션 클래스에서 ```Environment``` 인스턴스나 ```@Value``` 어노테이션을 통해 설정 정보를 읽을 수 있음
  - ```spring.config.name``` 프로퍼티로 환경 설정 파일의 이름을 지정할 수 있음

> 스프링부트가 기본적으로 읽는 환경 설정 파일의 위치는,
>
> - 클래스패스 루트
> - 클래스패스 ```/config``` 패키지
> - 현재 디렉터리
> - 현재 디렉터리 ```/config``` 디렉터리
> - ```/config``` 디렉터리의 바로 하위에 위치한 디렉터리
>
> 추가로, ```spring.config.location``` 프로퍼티를 통해 상대 경로나 절대 경로의 환경 설정 파일을 읽을 수 있음<br>(```optional:``` 접두어를 통해 해당된 경로에 환경 설정 파일이 없더라도, 예외 처리 없이 스프링부트 기본 설정값으로 실행할 수 있음)
>
> ```
> java -jar target/config-data-file.jar --spring.config.location=optional:data/application.yml
> ```
>
>> ```spring.config.name```과 ```spring.config.properties```는 환경 설정 파일에 지정할 수 없음<br>→ ```SpringApplication.setDefaultProperties()``` 메소드나 환경 변수, 혹은 명령행 인자를 통해 지정

- ```application-{profile}.properties``` : 프로파일 (```profile```)별로 프로퍼티 파일 지정 가능
  - 환경 설정 파일의 ```spring.profile.active``` 프로퍼티를 통해 프로파일를 지정하면, 프로퍼티 파일의 내용이 로딩

```
@Configuration(proxyBeanMethods = false)
@Profile("production")
public class ProductionConfiguration {
    // ...
}
```

> 설정 파일의 로딩 순서
>
> 1. 어플리케이션 ```JAR``` 파일 안에 패키징되는 환경 설정 파일
> 2. 어플리케이션 ```JAR``` 파일 안에 패키징되는 ```profile```별 환경 설정 파일
> 3. 어플리케이션 ```JAR``` 파일 밖에서 패키징되는 환경 설정 파일
> 4. 어플리케이션 ```JAR``` 파일 안에 패키징되는 ```profile```별 환경 설정 파일

### 운영 체제의 환경 변수

- ```application.properties``` 파일에서 ```app.timeout``` 커스텀 프로퍼티를 활용

```
app.timeout=${APP_TIMEOUT}
```

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/c8c54862-d56a-43d8-b491-dc1251c7e0d1" width="80%">

1. ```ConfigurableApplicationContext``` 인스턴스에 접근
2. ```Environment``` 빈을 가져옴
3. 프로퍼티 값을 ```env.getProperty()``` 메소드로 읽어 콘솔 로그로 출력

## ```@ConfigurationProperties``` : 커스텀 프로퍼티 생성

> 스프링부트 빌트인 프로퍼티 전체 목록은 <a href="https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html">공식 래퍼런스 문서</a>에서 확인 가능

- 스프링 어플리케이션이 복잡해지고 기능이 많아질수록, 커스텀 프로퍼티의 필요성이 높아짐
  - 외부 ```REST``` 웹 서비스 ```URL```이나 특정 기능 활성화 여부를 지정할 ```boolean``` 플래그 등

### ```Environment``` 인스턴스 주입을 통한 프로퍼티 값 사용

- 스프링의 ```Environment``` 인스턴스에 프로퍼티가 바인딩 → ```Environment``` 인스턴스를 주입받아 프로퍼티 값 사용 가능
- 프로퍼티 값의 타입 안정성 (```Type-Safety```)이 보장되지 않아, 이로 인해 런타임 에러가 발생할 수 있음
  - ```URL```이나 이메일 주소를 프로퍼티로 사용할 때 유효성 검증 (```Vadlidation```)을 수행할 수 없음
- 프로퍼티 값을 일정한 단위로 묶어서 읽을 수 없음
  - ```@Value``` 어노테이션이나 스프링의 ```Environment``` 인스턴스를 사용해서 하나하나 개별적으로만 읽을 수 있음

### ```@ConfigurationProperties``` 어노테이션을 사용한 커스텀 프로퍼티 정의

> 요구 사항 : 커스텀 프로퍼티에 대한 타입 안정성을 보장하고, 값의 유효성을 검증해야 한다.

- 스프링부트 설정 처리기 (```Configuration Processor```)를 통해 ```@ConfigurationProperties```이 붙은 클래스에 대한 메타데이터 생성
  - ```spring-boot-configuration-processor``` 의존 관계를 추가해 스프링부트 설정 처리기를 활성화
  - 생성된 메타데이터는 환경 설정 파일에 기술된 프로퍼티에 대한 자동 완성이나 문서화 지원
- ```spring.config.import```와 ```@ConfigurationProperties```을 함께 사용해, 연관된 프로퍼티들을 그룹화한 프로퍼티 파일로 관리 가능
- ```@ConfigurationProperties``` 어노테이션을 클래스 안에서 빈을 생성하는 ```@Bean``` 메소드에도 붙일 수 있음
- 아래처럼 생성자를 사용해서 바인딩하는 방식이 아닌, ```setter``` 메소드를 통해 바인딩하는 방식 또한 가능

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/264e5990-ee36-44a5-bfe3-420b68fd02d2" width="80%">

- 커스텀 프로퍼티를 사용하려면 환경 설정 파일에 해당 프로퍼티에 대한 정보를 추가해야 함

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/8f9f02c6-0ce3-4bb0-b9c4-a5534462fbc3" width="80%">

- 프로퍼티를 정의하고 이를 담은 ```AppProperties``` 클래스를 통해 서비스 클래스에서 ```AppProperties``` 객체를 주입받을 수 있음

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/ac00105a-cd9c-4b8c-8dfa-14bf4d1c49ed" width="80%">

- 스프링부트 어플리케이션 클래스는 서비스 클래스를 사용해서 ```AppProperties``` 객체에 접근하여 프로퍼티 값을 사용
  - ```@EnableConfigurationProperties``` 어노테이션은 ```@ConfigurationProperties```이 붙은 클래스를 스프링 컨테이너에 등록
  - ```@ConfigurationPropertiesScan``` 어노테이션으로 기준 패키지을 지정하면, 지정 패키지 하위에 있는 ```@ConfigurationProperties```가 붙은 클래스를 모두 탐색해서 스프링 컨테이너에 등록
  - ```@ConfigurationProperties``` 어노테이션이 붙은 클래스를 자동 탐색해서 등록하는 것이 아니라 직접 명시해야 함

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/a1975bd6-5a08-44eb-914e-572a5d539585" width="80%">

- ```ConstructorBinding``` 어노테이션을 ```POJO``` 클래스에 사용하면, 생성자를 통해 프로퍼티 정보값이 설정
  - 생성자가 하나만 있으면 클래스에, 생성자가 여러 개라면 프로퍼티 정보값 설정에 사용할 생성자에 어노테이션을 붙이면 됨
  - 설정 정보 클래스의 불변성을 보장하기 위해선 세터 바인딩 대신 생성자 바인딩으로 프로퍼티 값을 설정해야 함

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/3ae42b22-9e2e-47cb-a8fb-3d2f25357007" width="80%">

