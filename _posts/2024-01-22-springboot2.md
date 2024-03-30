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

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/cd0898ec-e803-4c63-8a39-0c265c5a2dd5" width="80%">

- ```application.properties``` 파일은 다른 설정 파일들을 ```spring.config.import``` 프로퍼티를 통해 임포트해서 사용
  - ```spring.config.import=classpath:additional-application.properties```를 추가하면 스프링부트는 ```additional-application.properties``` 파일에 있는 설정 정보를 읽어 사용할 수 있음
    - 만약 클래스패스에 파일이 없으면, ```ConfigDataLocationNotFoundException``` 예외가 발생
    - ```spring.config.on-not-found```에 ```ignore```를 지정하면, 클래스파일에 설정 파일이 없을 때 예외 처리를 하고 종료하는 대신 어플리케이션 시동 작업을 계속 진행하게 할 수 있음

### ```@PropertySource``` 사용

- 설정 파일의 위치를 어노테이션을 사용해 지정 (자바 8 이후로는 동일한 어노테이션을 여러 번 사용할 수 있음)
  - ```src/main/resources/```의 파일은 ```JAR```로 패키징된 후 클래스패스에 위치하므로, 해당 디렉터리에 설정 파일 작성

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/a1858e95-9784-4d5b-8cd2-94cac3930019" width="80%">

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
> 추가로, ```spring.config.location``` 프로퍼티를 통해 상대 경로나 절대 경로의 환경 설정 파일을 읽을 수 있음<br>(```optional:``` 접두어로 해당 경로에 환경 설정 파일이 없더라도, 예외 처리 없이 스프링부트 기본 설정값으로 실행 가능)
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

- ```application.properties``` 파일에서 ```app.timeout``` 커스텀 프로퍼티 활용

```
app.timeout=${APP_TIMEOUT}
```

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/9b5cbce3-6baf-40f4-9a68-9340ff726cc6" width="80%">

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
  - ```URL```이나 이메일 주소를 프로퍼티로 사용할 때 유효성 검증 (```Validation```)을 수행할 수 없음
- 프로퍼티 값을 일정한 단위로 묶어서 읽을 수 없음
  - ```@Value```나 스프링의 ```Environment``` 인스턴스를 사용해서 하나하나 개별적으로만 읽을 수 있음

### ```@ConfigurationProperties``` 어노테이션을 사용한 커스텀 프로퍼티 정의

> 요구사항 : 커스텀 프로퍼티에 대한 타입 안정성을 보장하고, 값의 유효성을 검증해야 한다.

- 설정 처리기 (```Configuration Processor``` )로 ```@ConfigurationProperties```가 붙은 클래스 메타데이터 생성
  - ```spring-boot-configuration-processor``` 의존 관계를 추가해 스프링부트 설정 처리기를 활성화
  - 생성된 메타데이터는 환경 설정 파일에 기술된 프로퍼티에 대한 자동 완성이나 문서화 지원
- ```spring.config.import```, ```@ConfigurationProperties```으로 연관 프로퍼티들을 그룹화한 프로퍼티 파일로 관리
- ```@ConfigurationProperties```을 클래스 안에서 빈을 생성하는 ```@Bean``` 메소드에도 붙일 수 있음
- 아래처럼 생성자를 사용해서 바인딩하는 방식이 아닌, ```setter``` 메소드를 통해 바인딩하는 방식 또한 가능

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/705c02ca-509a-4033-a637-e50f572008c4" width="80%">

- 커스텀 프로퍼티를 사용하려면 환경 설정 파일에 해당 프로퍼티에 대한 정보를 추가해야 함

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/526d0d97-abf3-4e3c-a81c-991315ba2efb" width="80%">

- 프로퍼티 정의를 담은 ```AppProperties``` 클래스로 서비스 클래스에서 ```AppProperties``` 객체를 주입받을 수 있음

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/f0f3bd4a-c9a8-4792-9f27-d978a19a2b71" width="80%">

- 스프링부트 어플리케이션 클래스는 서비스 클래스를 사용해서 ```AppProperties``` 객체에 접근하여 프로퍼티 값 사용
  - ```@EnableConfigurationProperties```는 ```@ConfigurationProperties```가 붙은 클래스를 스프링 컨테이너에 등록
  - ```@ConfigurationPropertiesScan```으로 기준 패키지을 지정하면, 지정 패키지 하위에 있는 ```@ConfigurationProperties```가 붙은 클래스를 모두 탐색해서 스프링 컨테이너에 등록
  - ```@ConfigurationProperties```가 붙은 클래스를 자동 탐색해서 등록하는 것이 아니라 직접 명시해야 함

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/fe5576ec-9f14-4a9d-89f0-7182f4dc067a" width="80%">

- ```ConstructorBinding```을 ```POJO``` 클래스에 사용하면, 생성자를 통해 프로퍼티 정보값이 설정
  - 생성자가 하나면 클래스에, 생성자가 여러 개라면 프로퍼티 정보값 설정에 사용할 생성자에 어노테이션을 붙이면 됨
  - 설정 정보 클래스의 불변성을 보장하기 위해선 세터 바인딩 대신 생성자 바인딩으로 프로퍼티 값을 설정해야 함
- 생성자 바인딩 대신 세터 메소드를 사용하는 세터 바인딩 방식으로 프로퍼티 값을 설정할 수도 있음
  - 설정 정보의 불변성을 보장하기 위해 세터 메소드 대신 ```@ConstructorBinding```을 사용해야 함
  - ```@DefaultValue```로 프로퍼티 기본값 지정 가능

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/53942f92-5382-4d51-b658-45ed3ff238e5" width="80%">

### ```CommandRunner```, ```ApplicationRunner```로 스프링부트 어플리케이션 시작 시 코드 실행

> 요구사항 : 어플리케이션 초기화 이전에 ```DB``` 초기화 스크립트를 실행하거나, 외부 ```REST``` 서비스를 호출해서 데이터를 가져오는 상황이 있을 수 있다.

- 스프링부트 메인 클래스가 ```CommandRunner``` 인터페이스를 구현

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/fdb7007e-130e-41e6-b58d-c4a404828f77" width="80%">

- ```CommandRunner``` 구현체에 ```@Bean```을 붙어 스프링 빈으로 정의
  - ```CommandRunner```는 ```run(String... args)``` 메소드 하나만 가진 함수형 인터페이스<br>→ 람다식을 사용해서 ```CommandRunner``` 구현체를 작성할 수 있음

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/1cc72f8d-ee00-4173-8401-2969018435d6" width="80%">

- ```CommandRunner``` 구현체에 ```@Component```를 붙어서 스프링 컴포넌트로 정의
  - 어플리케이션을 실행하면 스프링부트 컴포넌트 스캔을  통해 컴포넌트의 인스턴스가 생성되고 빈으로 등록

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/0eb370aa-171e-4a70-b11d-f7d100b6c856" width="80%">

> ```@Bean vs @Component```? : 모두 스프링에 의해 빈으로 등록된다는 공통점
>
> - 빈으로 등록할 클래스의 코드에 직접 접근할 수 없으면, 클래스의 인스턴스를 반환하는 메소드에 ```@Bean```
> - 빈으로 등록할 클래스의 코드에 직접 접근할 수 있으면, 클래스의 인스턴스를 반환하는 메소드에 ```@Component```

- ```CommandRunner``` 안에서 스프링 의존 관계 주입으로 빈을 주입받아 사용 가능
  - ```CommandRunner``` 구현체는 빈 등록을 포함한 초기화를 거의 마친 뒤 실행되므로, 어떤 빈이든 주입받아 사용 가능

### 스프링부트 어플리케이션 로깅 커스터마이징

- 로거 (```Logger```) : 한 개 이상의 어펜더를 사용해 로그 메시지 표시를 담당하는 로깅 프레임워크 컴포넌트
  - 어펜더 (```Appender```) : 로그가 출력되는 대상과 로깅 포맷 지정 가능
    - ```ConsoleAppender``` : 어플리케이션의 콘솔에 로그 출력
    - ```FileAppender``` : 하나의 파일에 로그 출력
    - ```RollingFileAppender``` : 시간과 날짜 기반으로 별도의 파일에 로그 출력
    - ```SmtpAppender``` : 정해진 이메일 주소로 로그 출력

> 요구사항 : 어플리케이션에 발생하는 중요 이벤트와 어플리케이션 동작에 대한 로그를 출력하는 로깅은 필수적이다.

- 스프링부트 어플리케이션의 콘솔 로그는 기본으로 제공 : ```Apache Commons``` 로깅 프레임워크 사용
  - ```Logback```, ```Log4j2``` 등 로깅 프레임워크, 자바에서 제공하는 ```java.util.logging``` 또한 지원
- 로그 출력 패턴 : 로그를 구성하는 여러 요소들을 출력하는 형태 및 ```ANSI``` 색상을 지정할 수 있음
- 로그 롤링 (```Log Rolling```) : 나중에 확인할 수 있도록 로그의 양, 기간에 따라 별도의 파일에 나누어 저장

> 로그를 구성하는 여러 요소?
> 
> - 일시 : 로그가 출력되는 날짜와 시간
> - 로그 레벨 : 로그의 중요도에 따라 ```FATAL```, ```ERROR```, ```WARN```, ```INFO```, ```DEBUG```, ```TRACE```로 구분
> - 구분자 : 실제 로그 메시지의 시작 부분
> - 스레드 이름 : 현재 로그를 출력한 스레드 이름<br>(```TaskExecutor```로 생성할 때 지정된 스레드풀에서 사용할 이름)
> - 로거 이름 : 축약된 클래스 이름
> - 메시지 : 실제 로그 메시지
 
### 스프링부트 어플리케이션에 ```Log4j2``` 사용

- 기본으로 내장된 ```logback``` 의존 관계를 제거하고, ```Log4j2``` 의존 관계를 추가

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/8bc291f1-929b-4491-864c-5d8220a01dcc" width="80%">

- ```XML```, ```JSON```, ```YAML``` 형식 중 하나로 ```Log4j2``` 설정 파일 작성

```
Configuration: # 로그 설정
  name: DEFAULT # 설정 이름
  status: "${env:LOGGING_LEVEL}" # 설정 상태

  Appenders: # 설정 Appender
    Console:
      name: Console_Appender
      target: SYSTEM_OUT # 출력 대상 (SYSTEM_OUT, SYSTEM_ERR)
      PatternLayout: # 출력 패턴
        charset: "${env:LOGGING_CHARSET}"
        pattern: "${env:LOGGING_PATTERN}"
        disableAnsi: false # ANSI 색상 미사용 여부
    RollingFile:
      name: RollingFile_Appender
      fileName: "${env:LOGGING_FILENAME}" # 파일명
      filePattern: "${env:LOGGING_FILE_PATTERN}" # 파일 패턴
      PatternLayout:
        charset: "${env:LOGGING_CHARSET}"
        pattern: "${env:LOGGING_PATTERN}"
      Policies:
        SizeBasedTriggeringPolicy:
          size: "${env:LOGGING_FILE_SIZE}" # 파일 크기
        TimeBasedTriggeringPolicy:
          interval: "${env:LOGGING_FILE_INTERVAL}" # 시간 간격
  Loggers:
    Root:
      level: "${env:LOGGING_LEVEL}" # 루트 로거 레벨
      AppenderRef:
        - ref: Console_Appender # 루트 로거 출력 대상
        - ref: RollingFile_Appender # 루트 로거 출력 대상
    Logger:
      name: vw.temp # 로거 이름
      additivity: false # 상위 로거 출력 여부
      level: "${env:LOGGING_LEVEL}" # 로거 레벨
      AppenderRef:
        - ref: Console_Appender
        - ref: RollingFile_Appender
```

- ```LoggerFactory``` 클래스의 ```getLogger``` 메소드로 로거 인스턴스 생성
  - ```SLF4j``` : 로깅 프레임워크를 빌드 타임에 플러그인 방식으로 사용할 수 있게 해주는 추상화 라이브러리

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/1e88dc92-a58e-498e-9eed-a4e79e238b54" width="80%">

### ```Bean Validation```으로 사용자 입력 데이터 유효성 검증

> 요구사항 : 사용자 입력 데이터가 비즈니스 요구 사항에 적합한지 검증해야 한다.

- ```Bean Validation``` : 유효성 검사를 간단한 어노테이션으로 쉽게 구현 가능 + 커스텀 벨리데이터 생성 가능

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/d8aaac7b-75a7-4747-87b5-59fa9f86824a" width="80%">

- 유효성 검사를 할 필드에 어노테이션을 붙어 비즈니스 제약 사항을 수행하는지 확인
  - 제약 사항이 충족되지 않으면, 어노테이션에서 지정한 에러 메시지 표시

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/a43c1b0d-fff9-4026-8da6-c8f8ebbd1f2c" width="80%">

- ```Hibernate Validation``` : ```Bean Validation``` 스펙을 참조하는 구현체

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/fe447231-87ac-45b3-a139-cb7f234c7f73" width="80%">

### 커스텀 ```Bean Validation``` 어노테이션을 사용한 ```POJO``` 빈 유효성 검증

> 요구사항 : 사용자 입력 데이터가 비즈니스 요구 사항에 적합한지 검증할 때, 유효성 검사 커스텀마이징이 필요하다.

- ```passay``` 라이브러리 : 비밀번호 규칙을 강제

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/3e6b49cc-b8b5-40e8-895d-d1a528fc384d" width="80%">

- ```ConstraintValidator``` : 커스텀 어노테이션을 정의할 때, 제약 사항 준수를 위해 호출되는 인터페이스
  - ```isValid``` 메소드는 비밀번호 유효성 검증에 사용하는 커스텀 로직이 정의 → ```true/false``` 반환
  - 첫번째 인자 ```Password```는 커스텀 벨리데이터 로직을 적용하는 어노테이션 → ```@String```
  - 두번째 인자 ```String```은 커스텀 어노테이션을 적용해야 하는 데이터 타입

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/c096eb4f-e20a-4a0d-9b28-85c8c52ea0a3" width="80%">

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/89949354-15ea-4159-bccb-fb5143d23393" width="80%">

