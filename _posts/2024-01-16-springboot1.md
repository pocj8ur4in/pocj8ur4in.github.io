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
  - 스프링 ```MVC``` 의존 관계의 추가
  - 메이븐 혹은 그레이들 프로젝의트 설정
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

#### 스프링부트 메인 클래스 : 패키지 내에서 어플리케이션 실행을 담당하는 클래스

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

2. ```@SpringBootApplication``` 에너테이션

3. ```SpringApplication()``` 클래스


> Reference
>
> - <a href="https://www.aladin.co.kr/m/mproduct.aspx?ItemId=330484424">실전 스프링부트</a>