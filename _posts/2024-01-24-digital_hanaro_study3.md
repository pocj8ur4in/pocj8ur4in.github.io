---
title: "자바스크립트 프로토타입 (2024.01.24)"

tags:
    - Digital Hanaro Study

toc: true
toc_sticky: true

date: 2024-01-24
last_modified_at: 2024-01-25
---

> <a href="https://github.com/pocj8ur4in/finance-dev-study">디지털하나路 스터디</a> 3일차 내용을 정리한 글입니다.

## 공부하고자 한 이유

자바스크립트에서는 자바와 달리 클래스라는 개념이 없었고 대신 프로토타입을 통해 새로운 객체를 만드는 방식이라는 것을 알게 되었는데, 자바스크립트가 객체지향 프로그래밍을 하기 위해 어떻게 프로토타입이라는 개념을 사용하는지 궁금하였다.

## 공부한 내용

사전적인 의미의 프로토타입 (```Prototype```)이란, 원래의 형태 또는 전형적인 표준을 가리킨다. 소프트웨어 디자인 패턴에서는, 생성한 객체들의 타입을 프로토타입인 인스턴스로부터 결정되도록 하고, 인스턴스는 새 객체를 만들기 위해 자신을 복제하는 프로토타입 패턴 (```Prototype Pattern```)의 개념으로 확장하였다. 프로토타입 패턴을 구현하기 위해선 ```clone()``` 메소드를 선언하는 추상 베이스 클래스를 하나 만들고, 생성자가 필요한 클래스가 있으면 이 클래스를 상속하고 ```clone()``` 메소드 내의 코드를 구현한다.

- ```Prototype``` : 프로토타입을 만드려는 객체 클래스의 인터페이스
  - 인터페이스를 통해서 ```clone```을 상속받고, 프로토타입 객체들을 이 공통 타입으로 받음 (다형성 보장)

```
public interface Prototype {
    public Prototype clone();
}
```

- ```ConcretePrototype``` : 프로토타입의 인터페이스 구현
  - ```clone()``` : 생성자에 자신의 타입을 가진 객체를 넘기고, 초기화를 위해 패러미터로 받는 생성자를 생성함

```
public class Circle implements Prototype {
    private int x;
    private int y;

    public Circle(Circle prototype) {
        this.x = prototype.x;
        this.y = prototype.y;
    }

    public Circle(int x, int y) {
        this.x = x;
        this.y = y;
    }

    @Override
    public Prototype clone() {
        return new Circle(this);
    }
}
```

- ```Sub-Class``` : 상위 클래스에 값을 전달할 하위 클래스

```
public class RedCircle extends Circle {
    private String color;

    public RedCircle(RedCircle prototype) {
        super(prototype);
        this.color = prototype.color;
    }

    public RedCircle(Circle circle, String color) {
        super(circle);
        this.color = color;
    }

    public RedCircle(int x, int y, String color) {
        super(x, y);
        this.color = color;
    }

    public getColor() {
      return this.color;
    }

    public Prototype clone() {
        return new RedCircle(this);
    }
}
```

- 클라이언트 클래스 : 프로토타입 인터페이스를 통해 객체를 생성함

```
public class Client {
    Prototype circle = new Circle(3, 5);
    Prototype redCircle1 = new RedCircle(3, 5, "red");
    Prototype redCircle2 = new RedCircle((Circle) circle, "red");

    Prototype newCircle = circle.clone();
    Prototype newRedCircle = redCircle1.clone();

    newCircle.getColor(); // 에러
    newRedCircle.getColor();
}
```

위 예시는 자바에서 프로토타입 패턴을 적용한 사례이다. 프로토타입 패턴을 통해 객체를 복제하는 책임이 기존 클래스에서 복제하는 객체로 넘어가나, 이럴 경우에는 객체를 이용하려면 타입을 알아야 한다. 타입이 동적으로 변하는 자바스크립트의 경우에는 이 패턴을 객체를 생성하는 방식으로 활용한다. 자바스크립트는 기본 데이터 타입을 제외한 나머지는 모두 객체인데, 객체 안에 ```__proto__``` 속성이 존재한다. ```__proto__``` 속성은 객체가 만들어지기 위해 사용되는 원형인 프로토타입 객체를 숨은 경로로 참조하는 역할을 한다.

모든 객체는 프로토타입 객체에 접근할 수 있으며, 프로토타입 객체 역시 동적으로 런타임에 멤버를 추가할 수 있다. 또한 같은 원형을 복사로 생성된 모든 객체는 추가된 멤버를 사용할 수 있다. 코드 재사용의 대표적인 방식인 상속을 예시로 들어보자. 자바스크립트의 상속을 ```classical```이 아닌 ```prototypal``` 방식으로 생성한다면, 리터럴 혹은 ```Object.create()```를 이용해 객체를 생성하고 확장한다.

```
var person = {
  type: 'person',
  getType: function() { return this.type; },
  getValue: function () { return this.value; };
}

var pocj8ur4in = Object.create(person);
pocj8ur4in.type = "developer";
```