---
title: "자바스크립트 프록시 (2024.02.04)"

tags:
    - Digital Hanaro Study

toc: true
toc_sticky: true

date: 2024-02-04
last_modified_at: 2024-02-05
---

> <a href="https://github.com/pocj8ur4in/finance-dev-study">디지털하나路 스터디</a> 6일차 내용을 정리한 글입니다.

## 공부한 이유

프록시 (```Proxy```)를 번역하면 어떤 일을 대신 수행하는 대리자, 대변인의 의미를 갖고 있다. 디자인패턴에서도 어떤 객체를 사용하고자 할 때, 객체를 직접 참조하는 것이 아니라 해댱 객체를 대행할 수 있는 프록시 객체를 통해 대상하고자 하는 객체에 접근하는 방식을 프록시 패턴 (```Proxy Pattern```)이라고 부른다. 자바스크립트에서도 프록시 객체가 있다는 것을 이번 수업을 통해 알게 되어 이에 대해 정리하고자 하였다.

## 공부한 내용

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/9a0c5c88-3e49-43f9-a2e1-55ae60429d27" width="60%">

- 프록시 객체 (```Proxy Object```) : 원본 객체의 어떤 작업을 가로채 대신 처리하는 객체
  - 타겟 (```target```) : 프록시 객체가 감쌀 (```wrapping```) 원본 객체
  - 핸들러 (```handler```) : 동작을 가로채는 '트랩 (```trap```)'이 담겨 타겟의 동작을 제어하는 메소드를 정의한 객체

```
let target = {};
let proxy = new Proxy(target, handler)

proxy.test = 5;
alert(proxy.test); // 5
```

> 특정 객체를 감싸 해당 객체에 작업이 가해지고, 핸들러에 상응하는 트랩이 있다면 중간에서 작업을 트랩

- 프록시는 일반 객체와 달리 프로퍼티가 없는 '특수 객체'
  - 핸들러가 비어 있으면 프록시에 가해지는 작업은 원본 객체인 타겟으로 바로 전달
- 프록시의 트랩은 원본 객체에 수행하는 동작을 수행하는 내부 메소드의 호출을 가로챔

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/4c6317c5-a2b0-4643-994f-ba45f073239b">

```
let numbers = [0, 1, 2];

numbers = new Proxy(numbers, {
  get(target, prop) {
    if (prop in target) return target[prop];
    return 0;
  }
});

alert( numbers[1] ); // 1
alert( numbers[123] ); // 0
```

> 프록시가 ```Reflect```와 다른 점?
>
> - ```Reflect```는 타겟 객체의 상태를 ```Boolean```으로 반환하는 여러 메소드를 가진 자바스크립트 기본 객체
>   - ```Reflect```의 메소드가 프록시와 연동하여, ```Reflect```의 메소드를 통해 검증하는 값을 프록시에도 핸들러에 할당해 처리 가능

- 프록시 응용 ```#1```. 프록시는 비싼 함수 호출을 캐싱 (```Caching```)할 수 있음

```
function calculateCost(price, taxRate) {
  console.log('계산 : ');
  return price * (1 + taxRate);
}

const cache = new Map();

const proxy = new Proxy(calculateCost, {
  apply(target, thisArg, args) {
    const key = args.join('-');
    if (cache.has(key)) {
      console.log('캐시된 결과 반환 : ');
      return cache.get(key);
    } else {
      const result = Reflect.apply(target, thisArg, args);
      cache.set(key, result);
      return result;
    }
  },
});

console.log(proxy(10, 0.2)); // 계산 : 12
console.log(proxy(10, 0.2)); // 캐시된 결과 반환 : 12
console.log(proxy(20, 0.2)); // 계산 : 24
console.log(proxy(20, 0.3)); // 계산 : 26
console.log(proxy(20, 0.3)); // 캐시된 결과 반환 : 26
```

- 프록시 응용 ```#2```. 프록시는 데이터 검증에 활용하는 유효성 검사기 (```Validator```)로 활용될 수 있음

```
const user = {
  name: 'John',
  password: '',
};

const proxy = new Proxy(user, {
  set(target, prop, value) {
    if (prop === 'password' && value.length < 8) {
      throw new Error('Password must be at least 8 characters long');
    }
    target[prop] = value;
    return true;
  },
});

console.log(proxy.name); // John
console.log(proxy.password); // 

proxy.password = '12345678';
console.log(proxy.password); // 12345678

proxy.password = '123'; // 'Password must be at least 8 characters long' 에러 반환
```

- 프록시 응용 ```#3```. 프록시는 데이터 변화를 감지하는 로거 (```logger```)로 활용될 수 있음

```
const user = {
  name: 'John',
  email: 'john@example.com',
};

const proxy = new Proxy(user, {
  get(target, prop) {
    console.log(`Getting ${prop} property`);
    return target[prop];
  },
  set(target, prop, value) {
    console.log(`Setting ${prop} property to ${value}`);
    target[prop] = value;
    return true;
  },
});

console.log(proxy.name); // Getting name property -> John
proxy.email = 'bob@example.com'; // Setting email property to bob@example.com
console.log(proxy.email); // Getting email property -> bob@example.com
```
