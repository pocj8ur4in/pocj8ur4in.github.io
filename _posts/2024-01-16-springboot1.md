---
title: "[SpringBoot] 1. SpringBoot"

tags:
    - SpringBoot

toc: true
toc_sticky: true

date: 2024-01-16
last_modified_at: 2024-01-16
---

## 객체지향 프로그래밍 (```OOP```) :  프로그램을 일련의 독립된 객체들로 이해하는 프로그래밍 방법론

- 캡슐화 (```Encapsulation```) : 변수와 함수를 하나의 단위로 묶는 것
- 정보 은닉 (```Information Hiding```) : 프로그램의 구현을 외부로 드러나지 않게 내부로 감추는 것
- 상속 (```Inheritance```) : 자식 클래스가 부모 클래스의 특성과 기능을 그대로 물려받는 것
- 다형성 (```Polymorphism```) : 하나의 변수, 또는 함수가 상황에 따라 다른 의미로 해석되는 것

### 객체지향 5원칙 (```SOLID```) : 객체자향을 올바르게 설계할 수 있도록 도와주는 원칙

1. ```SRP``` (```Single Responsibility Principle```) : 객체는 오직 하나의 책임을 가져야 한다.
  - 클래스를 설계할 때 어플리케이션의 경계를 정하고, 추상화로 어플리케이션 내의 속성과 메소드를 설계해야 한다.
2. ```OCP``` (```Open Closed Principle```) : 객체는 확장에 대해 개방적이고 수정에 대해 폐쇄적이어야 한다.
  - 클래스, 모듈, 함수와 연동할 때는 상위 클래스나 인터페이스를 중간에 두어 직접적인 연동을 피해야 한다.
3. ```LSP``` (```Liskov Substitution Principle```) : 자식 클래스는 항상 자신의 부모 클래스를 대체할 수 있다.
  - 자식 클래스의 인스턴스는 부모 클래스의 인스턴스 역할을 대신할 때에도 논리적으로 문제가 없어야 한다.
4. ```ISP``` (```Interface Segregation Principle```) : 클라이언트에서 사용하지 않는 메서드는 사용해선 안 된다.
  - 각 상황에 맞는 메소드만 클래스에게 제공하도록 인터페이스를 작게 나누어 설계해야 한다.
5. ```DIP``` (```Dependency Inversion Principle```) : 자신보다 변하기 쉬운 것에 의존해선 안된다.
  - 추상성이 높고 고수준의 클래스는 구체적이고 저수준의 클래스에 의존하지 않도록 설계해야 한다.

### 자바 빈 (```Java Bean```) : 자바 객체를 재사용 가능하도록 컴포넌트화한 클래스

- 클래스는 반드시 패키지화되어야 한다.
- 멤버변수는 프로퍼티 (```Property```) 라고 부른다.
- 프로퍼티의 접근 제어자는 ```private```이다.
- 데이터를 저장하는 필드와 그 데이터를 조작하기 위한 외부에서의 접근은 ```getter```와 ```setter``` 메소드로 한다.
- 프로퍼티가 ```boolean```이면, ```get```가 아닌 ```is```를 사용해도 된다.

```
public class MemberInfo {
  private int id;
  private String Name;
  private String pw;
  
  public int getId() { return id; }
  public void setId(int id) { this.id = id; }
  public String getName() { return Name; }
  public void setName(String name) { this.Name = name; }
  public String getPw() { return pw; }
  public void setPw(String pw) { this.pw = pw; }
}
```

> ... 서버 사이드에서 어플리케이선을 개발할 때 자바 빈만으로 해결하지 못하는 문제가 발생한다.
>
> - 기존 어플리케이션에 필요한 비즈니스 로직만이 아닌, ```DB```와 트랜젝션 처리를 위한 프로그램이 추가로 필요하다.
> - 각각의 어플리케이션 서버에는 독자적인 ```API```이 제공되기에 어플리케이션의 컴포넌트화가 어렵다.

### ```EJB```, ```J2EE``` : 비즈니스 로직과 시스템 서비스 로직을 분산하고, 로직 간의 규약을 규정

- 비즈니스 로직을 탑재한 부품을 ```Enterprise Bean```이라 부른다.
- ```DB```와 트랙젝션 처리 등의 시스템 서비스를 이용하는 부품을 컨테이너 (```Container```)라 부른다.
- 비즈니스 객체들을 관리하는 ```EJB``` 컨테이너에서 필요할 때마다 객체를 꺼내는 방식으로 객체들 간의 의존성을 해결한다.

```
@Stateless
public class Service {

  @PersistenceContext
  private Manager Manager;

  public void addCustomer(Customer customer) {
    Manager.persist(customer);
  }
}
```

> ... ```EJB```는 비즈니스 로직이 특정 ```EJB``` 컨테이너에 종속되는 문제가 발생한다. (→ 기술 침투)
>
> - ```EJB``` 컨테이너를 사용하기 위한 코드 (상속 & 구현)들이 많고, ```EJB``` 컨테이너가 없으면 불필요한 코드가 된다.
> - 회사마다 ```EJB``` 컨테이너를 구현한 내용이 달라 다른 회사의 ```EJB``` 컨테이너로의 변경이 어렵다.
>
> → 회사마다 다르고 복잡한 자바 엔터프라이즈 어플리케이션의 개발을 하나로 단순화하자!

### 스프링 (```Spring```) : 자바 (```JAVA```) 기반의 웹 프레임워크 (```Web Framework```)

- 순수 자바 객체 (```Plain Old Java Object```) 방식 : ```POLO```
  - 인터페이스를 직접 구현하거나 상속받지 않아 기존 라이브러리 지원에 용이하고, 코드가 간결하며 객체가 가벼움
- 관점지향 프로그래밍 (```Aspect Oriented Programming```) : ```AOP```
  - 로깅, 트랜잭션, 보안 등 여러 모듈에서 공통적으로 사용하는 기능을 분리하여 관리할 수 있음
- 의존성 주입 (```Dependency Injection```) : ```DI```
  - 프로그래밍 구성 요소 간 의존 관계를 코드 밖에서 설정을 통해 정의해, 재사용률을 높이고 모듈 간 결합도를 낮춤
- 제어의 역전 (```Inversion of Control```) : ```IoC```
  - 객체의 생성부터 소멸까지의 제어권이 프레임워크에게 있어, 외부 라이브러리 코드가 개발자의 코드를 호출
- 모델-뷰-컨트롤러 (```Model-View-Controller```) : ```MVC``` 패턴
  - 사용자 인터페이스, 데이터 및 논리 제어의 구현에 사용되는 소프트웨어 디자인 패턴
- 모듈화 디자인 (```Modulation```) : 한 프레임워크을 여러 기능적 구성요소 (```Module```)로 조합해 완성
  - ```Core``` : 제어의 역전 (```IOC```)과 의존성 주입 (```DI```) 기능 제공
  - ```DAO``` : 자바 데이터베이스 커넥터 (```JDBC```) 추상 계층 제공 (```VO``` 클래스로 접근)
  - ```ORM``` : ```ORM```이나 데이터베이스 ```API```와의 통합 기능 제공
  - ```Web``` : 웹 어플리케이션 구현과 관련된 기능 제공
  - ```JEE``` : 엔터프라이즈 ```J2EE``` 스펙과 관한 기능 제공

> ... 스프링 프레임워크가 나왔지만 여전히 개발자가 신경써야 할 일이 많다.
>
> - 서블릿 (```Servlet```)에 대한 이해와 서블릿의 배포를 위해 필요한 ```web.xml```에 대한 이해
> - 어플리케이션 컴포넌트를 패키징한 ```WAR```, ```EAR``` 디렉터리 구조에 대한 지식
> - 도메인, 포트, 스레드, 데이터 소스 등 어플리케이션을 배포할 때에 필요한 서버 지식
> - 복잡한 클래스 로딩 전략, 어플리케이션 모니터링, 유지 관리, 로깅 처리
>
> → 어플리케이션에 비즈니스 로직을 작성하고, 실행 가능한 파일로 만들어 커맨드라인으로 바로 실행하자!

## 스프링부트 (```SpringBoot```) : 스프링 프레임워크 기술을 편리하게 사용할 수 있도록 지원

- 빠른 구동 (```Quick Run```) : 어플리케이션에 필요한 의존 관계만 명시하면, 어플리케이션을 빠르게 실행할 수 있음
  - 스프링 ```MVC``` 의존 관계를 추가하고 메이븐 혹은 그레이들 프로젝트 설정
  - 스프링 ```MVC```의 ```DispatcherServlet```의 설정
  - 어플리케이션 컴포넌트를 ```WAR``` 파일로 패키징
  - ```WAR``` 파일을 아파치 톰캣 (```Apache Tomcat```) 같은 서블릿 컨테이너에 배포
- 자동 구성 (```Auto Configuration```) : 어플리케이션에 필요한 최소한의 컴포넌트를 대신해서 설정
  - 클래스패스에 있는 ```JAR``` 파일이나 여러 설정 파일에 지정된 프로퍼티 정보를 바탕으로 구성
  - ```XML``` 파일을 자체적으로 빌드하여 스프링 프로젝트 내 객체 의존성 관리를 자동화
  - 스프링 외부에 존재하는 라이브러리 또한 가져와 자동으로 구성
- 미리 정의된 방식 (```Opinionated```) : 어플리케이션 실행에 필요한 컴포넌트들을 ```starter``` 의존 관계를 기준으로 구성
   - ```spring-boot-starter-web```만 추가하면, 웹 어플리케이션 개발에 필요한 의존 관계를 클래스패스에 모두 넣어줌
- 독립 실행형 (```Standalone```) : 어플리케이션에 웹 서버를 내장하여 독립적으로 실행 가능 
  - 실행 가능한 ```JAR``` 파일로 패키징 → ```java -jar``` 명령어로 실행 가능
  - 어플리케이션이 쉽게 컨테이너화될 수 있어 클라우드 네이티브 (```Cloud Native```)에도 적합
- 실제 서비스 환경에 사용 가능 (```Production-Ready```)
  - 헬스 체크 (```Health Check```)나 스레드 덤프 (```Thread```) 분석을 통한 어플리케이션 모니터링 기능 제공
  - 매트릭 (```Metric```), 상태 확인, 외부 구성과 같은 프로덕션 준비 기능 제공

### 스프링부트 컴포넌트 (```SpringBoot Components```) : 어플리케이션 개발의 특정 영역에 특화된 요소

- ```spring-boot``` : 스프링부트의 기본 컴포넌트로서, 다른 컴포넌트를 사용할 수 있도록 지원
  - 톰캣 (```Tomcat```)과 같은 내장 웝 서버 기능
  - 데이터베이스 연결 정보와 같은 어플리케이션 설정 정보를 외부화하는 기능
- ```spring-boot-autoconfigure``` : 어플리케이션에 필요한 의존 관계의 자동 구성을 담당
  - 클래스패스와 설정 파일의 포로퍼티에 저장된 의존 관계를 바탕으로 스프링 빈 (```Spring Boot```)을 추론해 생성
- ```spring-boot-starters``` : 개발의 편의를 위해 제공하는 미리 패키징된 의존 관셰 기술서의 모음
- ```spring-boot-CLI``` : 그루브 코드를 컴파일하고 실행할 수 있는, 관리자 친화적 명령행 도구
  - 어플리케이션에 수정 사항이 발생할 때마다 파일 내용의 변경 감지
  - 의존 관계 관리나 빌드 관련 문제에 대한 걱정 없이 프로트타입 어플리케이션을 빠르게 만들 수 있게 해줌
- ```spring-boot-actuator``` : 어플리케이션을 모니터링하고 검사 가능한 엑추에이터 엔드포인트 제공
  - ```JMX```나 ```HTTP``` 엔드포인트로 관리할 수 있음
  - 어플리케이션의 여러 측면의 상태를 감지할 수 있도록 미리 정의된 형태의 다양한 엑추에이터 엔드포인드들을 제공
  - 커스텀 엑추에이터 엔드포인트를 추가하거나, 엑추에이터 엔드포인트의 활성화 여부를 설정할 수 있음
  - 인가되지 않은 접근으로부터 엔드포인트를 보호할 수도 있음
- ```spring-boot-actuator-autoconfigure``` : 클래스패스에 있는 클래스를 기반으로 엑추에이터 엔드포인트를 자동 구성
  - 의존 관계가 클래스패스에 있으면, 이에 해당되는 것을 엑추에이터 엔드포인트로 추가
- ```spring-boot-test``` : 테스트 케이스의 작성에 필요한 에너테이션 (```annotation```) 및 메소드 포함
- ```spring-boot-test-autoconfigure``` : 어플리케이션의 테스트 케이스에 필요한 의존 관계를 자동 구성
- ```spring-boot-loader``` : 어플리케이션을 ```JAR``` 파일로 패키징하기 위해 필요한 모든 의존 관계와 내장 웹 서버를 포함
  - 독립적으로 사용되지 않고 메이븐이나 그레이들 플러그인과 함께 사용
- ```spring-boot-devtools``` : 어플리케이션 개발을 돕는 여러 개발자 도구들

### 스프링부트 프로젝트 구조 : 스프링 이니셜라이저 (```Spring Initializr```)로 자동 생성

- ```pom.xml / build.gradle``` : 스프링 이니셜라이저에서 스프링부트 프로젝트를 생성할 때 지정한 의존 관계가 들어 있음
  - 메이븐 (```Maven```) 혹은 그레이들 (```Gradle```)과 같은 빌드 도구를 통해 빌드 가능

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>  <!-- spring-boot-starter-parent : 스타터 의존 관계나 플러그인에 대한 기본 설정 제공 및 관리 -->
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.1</version>
        <relativePath/> <!-- 메이븐 리포지토리에서 parent를 가져옴 -->
    </parent>
    <groupId>pocj8ur4in</groupId>  <!-- 프로젝트 아티펙트 정보 -->
    <artifactId>test</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>pocj8ur4inTest</name>
    <description>pocj8ur4inTest</description>
    <properties>
        <java.version>21</java.version>
    </properties>
    <dependencies>  <!-- dependencies : 스타터 의존 관계들을 선언 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <dependency>  <!-- JUnit, Mockito 등으올 스프링부트 어플리케이션 테스트를 지원 -->
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    <build>
        <plugins>  <!-- plugins : 플러그인들을 선언 -->
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

> 빌드 플러그인을 통한 스프링부트 어플리케이션의 실행 흐름
>
> 1. ```resource-plugin```의 호출 : ```src/main/java```의 소스 파일들을 빌드 결과가 저장될 디렉터리에 복사
> 2. ```compiler-plugin```의 호출 : 어플리케이션을 시작하기 전에 소스 코드를 컴파일
>
> → 빌드 플러그인은 저수준의 세부 작업을 모두 추상화하여 개발자가 쉽게 사용할 수 있게끔 해줌

- 래퍼 (```wrapper```) 파일 : 빌드 도구를 로컬에 설치하지 않고 프로젝트를 빌드할 수 있게 해줌
- 패키지 (```Packages```) 구조 : 자바 클래스를 포함하는 소스 패키지와 테스트 클래스를 포함하는 테스트 패키지로 분리
- ```application.properties``` 파일이 존재하는 리소스 (```resource```) 폴더 : 프로젝트를 진행하면서 사용할 파일들

#### 스프링부트 메인 클래스 (```Main Class```) : 패키지 내에서 어플리케이션 실행을 담당

```
package pocj8ur4in.vocawik;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class VocawikApplication {
    public static void main(String[] args) {
        SpringApplication.run(VocawikApplication.class, args);
    }
}
```

1. ```main()``` 메소드 : 웹 어플리케이션을 실행하는 메소드
  - 어플리케이션 컴포넌트를 빌드 및 패키징한 ```WAR / EAR``` 파일을 만들어 웹 서버에 배포할 필요가 없음
  - 전통적인 자바 어플리케이션을 실행하는 것처럼 웹 어플리케이션을 실행할 수 있음
    - 별도의 서블릿 컨테이너를 실행하지 않고, 스프링부트 어플리케이션이 내장된 서블릿 컨테이너 안에서 실행됨
      - ```spring-boot-starter-web```이 ```spring-boot-starter-tomcat``` 모듈에 대한 의존 관계를 포함

2. ```@SpringBootApplication``` 어노테이션 : 루트 패키지부터 스프링 어노테이션이 붙은 컴포넌트를 탐색해 관리
   - ```@EnableAutoConfiguration``` : 어플리케이션 클래스패스의 ```JAR``` 파일을 바탕으로 어플리케이션을 자동 구성
   - ```@ComponentScan``` : 어플리케이션에 존재하는 스프링 컴포넌트를 탐색
     - ```@Component```, ```@Bean``` 등이 붙은 자바 빈을 스프링에서 관리하기 위해 루트에서부터 탐색
     - ```@ComponentScan(basePackage = {})```로 탐색 범위를 직접 지정할 수 있음
  - ```@SpringBootConfiguration``` : 스프링부트 어플리케이션 설정을 담당
    - ```@Configuration```를 내부적으로 포함하여, 컴포넌트 탐색을 통해 어플리케이션 설정 과정에 참여

3. ```SpringApplication()``` 클래스 : ```run()``` 정적 메소드를 통해 스프링부트 어플리케이션을 편리하게 실행

> ```run()``` 메소드가 실행될 때 수행하는 적업의 흐름
> 
> 1. 클래스패스에 있는 라이브러리를 기준으로 ```SpringApplication``` 클래스의 인스턴스 생성
> 2. ```CommandLinePropertySource```를 등록해서 명령행 인자를 스프링 프로퍼티로 읽음
> 3. 1단계에서 생성한 ```ApplicationContext```를 통해 싱글톤 빈 로딩
> 4. 어플리케이션에 설정된 ```ApplicationRunner```와 ```CommandRunner``` 실행

- ```SpringApplication``` 클래스는 클래스패스에 있는 ```JAR```의 의존 관계를 바탕으로 ```ApplicationContext``` 인스턴스 생성
  - ```ApplicationContext```는 빈을 생성할 때 필요한 의존 관계 주입을 실행할 스프링 ```IoC``` 컨테이너의 역할을 담당
  - 클래스패스에 있는 클래스로 어플리케이션 타입이 서블릿 (```Servlet```) 혹은 리액티브 (```Reactive```)인지 유추

> 스프링부트가 ```ApplicationContext```를 로딩할 때의 전략
>
> 1. 서블릿 기반 : ```AnnotationConfigServletWebSErverApplicationContext``` 클래스 인스턴스 생성
> 2. 리액티브 기반 : ```AnnotationConfigReactiveWebServletApplicationContext``` 클래스 인스턴스 생성
> 3. 둘다 아닐 경우 : ```AnnotationConfigApplicationContext``` 클래스 인스턴스 생성

- 필요한 경우에 ```SpringApplication``` 클래스의 인스턴스를 직접 생성해 어플리케이션 시동 모드를 변경 가능
- 스프링 프로파일 지정, 어플리케이션 리소스 리소스 로더 지정과 같은 기능을 ```Setter``` 메소드로 제공

#### ```application.properties``` 또는 ```application.yml``` : 어플리케이션의 설정 정보 관리

- ```src/main/resources/``` 디렉토리에 자동으로 생성 (기본값은 ```.properties```)
- 서버 접속 정보, 데이터베이스 접속 정보와 같은 어플리케이션 설정 정보를 소스 코드에서 분리해서 외부화
- 멀티 모듈을 구성하거나 배포 환경가 다중화된 경우에, 파일을 여러 개로 나누어 설정을 다르게 관리할 수 있음

### ```JAR``` 파일 : 스프링부트 프로젝트로부터 생성된 실행 가능한 파일

- 설정한 패키징 방식에 따라 프로젝트의 ```target``` 디렉터리에 ```.JAR``` 파일 생성
  - 메이븐은 ```spring-boot-maven-plugin``` 플러그인의 ```repackage``` 골 (```goal```)이 메이븐 ```package``` 라이프사이클과 연동되어, 컴파일된 클래스 파일 (```.class```)를 리패키징
  - 그레이들은 스프링부트 프로젝트를 빌드할 때 ```org.springframework.boot``` 플러그인이 생성한 ```bootJar``` 테스크가 그레이들 ```build``` 라이프사이클에 편입되어 패키징
- ```java -jar``` 명령의 인자로 지정하면 어플리케이션을 실행할 수 있음
- ```ctrl+c``` 등을 통해 자바 프로세스를 종료하면, 스프링부트 어플리케이션 또한 종료

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/ef10695d-0893-4d9a-aadc-cc63f96841fb" width="80%">

- ```META-INF``` : 실행할 ```JAR``` 파일의 핵심 정보를 담고 있는 ```MANIFEST.MF``` 파일
  - ```Start-Class``` 패러미터 : 어플리케이션을 시작할 클래스를 지정
  - ```Main-Class``` 패러미터 :  ```Start-Class```를 사용해서 어플리케이션을 시작하는 ```Launcher``` 클래스를 지정
- 스프링부트 로더 컴포넌트 : ```JAR/WAR``` 파일을 로딩하는 ```JarLauncher/WarLauncher``` 클래스
  - ```loader.*``` 프로퍼티에 값을 지정하면, ```PropertiesLauncher``` 클래스로 클래스 로딩 과정 커스텀마이징 가능
- ```BOOT-INF/classes``` : 컴파일된 모든 어플리케이션 클래스가 위치한 디렉터리
- ```BOOT-INF/lib```  : 의존 관계로 지정한 라이브러리가 들어있는 디렉터리
- ```classpath.idx``` : 클래스로더가 로딩해야 하는 순서대로 정렬된 의존 관계 목록이 들어있음
- ```layer.idx``` : 도커 이미지를 생성할 때 논리적 계층으로 ```JAR```를 분할할 때 사용

> 안전 종료 (```Graceful shutdown```) : 처리 중인 요청이 완료될 때까지 기다릴 타임아웃 설정  
> 
> - 어플리케이션을 종료할 때, 처리 중인 요청의 처리가 보장되지 않음
> - 종료 명령어 실행되면 더 이상의 요청을 받지 않되, 이미 처리 중인 요청은 완료를 보장해야 함
> - 스프링부트 ```2.3.0```부터 도입되어, 그 이전 버전에서는 동작하지 않음
>
> ```
> server.shutdown=graceful # 기본값: immediate
> spring.lifecycle.timeout-per-shutdown-phase=1m # 기본값: 30s
> ```

### 스프링부트 스타트업 이벤트 : 스프링 어플리케이션 시작 및 초기화 과정에서 사용 가능한 빌트인 이벤트

- ```ApplicationStartingEvent``` : 어플리케이션이 시작되어 리스너 (```Listener```가 등록될 때 발행
  - 스프링부트의 ```LoggingSystem```이 해당 이벤트를 통해 어플리케이션 초기화 단계 이전에 필요한 작업 수행
- ```ApplicationEnvironmentPreparedEvent``` : 어플리케이션이 시작되고 ```Environment```가 준비될 때 발행
  - ```MessageConverter```, ```ConversionService```, ```Jackson``` 초기화 등 사전 초기화 (```PreInitialize```) 작업 수행
- ```ApplicationContextInitializedEvent``` : ```ApplicationContext```가 준비되고 ```ApplicationContextInitializer```가 실행되면 발행
  - 빈이 스프링 컨테이너에 로디오디어 초기화되기 전에 이루어질 작업이 필요할 때 이 이벤트를 사용
- ```ApplicationPreparedEvent``` : ```ApplicationContext```가 준비되고 ```ApplicationContext```가 초기화되기 전에 발행
  - 이 이벤트가 발행된 이후에 ```Environment```를 사용할 수 있음
- ```ContextRefreshedEvent``` : ```ApplicationContext```가 초기화된 이후에 발행
  - 스프링부트가 아닌 스프링이 발행한 이벤트로, ```SpringApplicationEvent```를 상속하지 않음
  - 스프링부트의 ```ConditionEvaluationLoggingListener```가 이 이벤트가 발행되면 자동 구성 보고서를 출력
- ```WebServerInitializedEvent``` : 웹 서버가 준비되면 발행
  - 스프링부트가 아닌 스프링이 발행한 이벤트로, ```SpringApplicationEvent```를 상속하지 않음
  - 어플리케이션 타입에 따른 하위 이벤트가 존재 (```ServletServerInitializedEvent```, ```ReactiveServerInitializedEvent```)
- ```ApplicationStartedEvent``` : ```ApplicationContext```가 초기화되고 ```ApplicationRunner```, ```CommandLineRunner```가 호출되기 전에 발행
- ```ApplicationReadyEvent``` : 어플리케이션 요청 처리가 준비되었을 때 ```SpringApplication```에 의해 발행
  - 모든 어플리케이션 초기화가 완료된 이후에 발행 : 이후에 어플리케이션 내부 상태를 변경하는 것은 권장되지 않음
- ```ApplicationFailedEvent``` : 어플리케이션 시작 과정에서 예외가 발생하면 발행
  - 예외 발생 시 스크립트를 실행하거나, 스타트업 실패를 알릴 때 사용

### 스프링부트 어플리케이션 이벤트 감지 : 스타트업 이벤트가 제공하는 정보들을 활용하기 위한 이벤트 구독

- ```@EventListener``` 어노테이션 : 스프링 프레임워크에서 제공하는 이벤트를 구독하는 어노테이션
  - 어플리케이션 스타트업 극초기에 발행되는 이벤트는 감지하지 못함

```
# @EventListener를 사용해서 ApplicationReadyEvent를 구독
@EventListener(ApplicationReadyEvent.class)
public void funcForApplicationReadyEvent(ApplicationReadyEvent applicationReadyEvent) {
  System.out.println("ApplicationReadyEvent generated at "
  + new Date(funcForApplicationReadyEvent.getTimestamp()));
}
```

- ```SpringApplication``` 클래스 : 어플리케이션 스타트업을 커스텀마이징할 수 있는 ```setter``` 메소드를 통해 리스너 등록
  - ```ApplicationListener``` 인터페이스의 ```onApplicationEvent``` 메소드를 구현해 ```SpringApplication```에 추가
  - ```SpringApplication```에 리스너를 등록하거나 수정하는 것은 클래스 코드의 변경을 유발

```
# 커스텀 ApplicationListener 구현체 작성
public class ApplicationStartEventListener
 implements ApplicationListener<ApplicationStartingEvent> {
  @Override
  public void onApplicationEvent(ApplicationStartingEvent applicationStartingEvent) {
    System.out.println("Application Starting Event logged at "
    + new Date(applicationStartingEvent.getTimestamp()));
  }
}
```

```
# SpringApplication에 어플리케이션 이벤트 리스너 추가
@SpringBootApplication
public class SpringBootEventApplication {
  public static void main(String[] args) {
    SpringApplication springApplication
     = new SpringApplication(SpringBootEventApplication.class);
  }
}
```

- ```spring.factories``` 파일 : 어플리케이션 기능 설정 및 커스터마이징을 가능하도록 스프링부트가 제공
  - <del>스프링부트 이전부터 스프링 프레임워크에서 제공 (```spring-beans.jar```에서 확인 가능)</del><br>→ 스프링부트 ```2.7.0```부터 ```deprecated```

> Reference
>
> - <a href="https://www.aladin.co.kr/m/mproduct.aspx?ItemId=330484424">실전 스프링부트</a>