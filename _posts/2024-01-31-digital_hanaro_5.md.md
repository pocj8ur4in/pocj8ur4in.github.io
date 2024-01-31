---
title: "고차 함수, 콜백 함수 (2024.01.31)"

tags:
    - Digital Hanaro Study

toc: true
toc_sticky: true

date: 2024-01-31
last_modified_at: 2024-01-31
---

> <a href="https://github.com/pocj8ur4in/finance-dev-study">디지털하나路 스터디</a> 5일차 내용을 정리한 글입니다.

## 공부한 내용

고차함수, 콜백함수의 개념을 정리해보고 이 둘의 차이점에 대해 짚어보고자 하였다.

### 고차 함수 (```Higher-Order Function```) : 다른 함수를 인자로 받거나 함수를 반환하는 함수

> 자바스크립트에서의 함수는 일급 객체 (```First-Class Citizen```)
>
> 1. 변수에 할당 (```Assignment```)할 수 있다.
> 2. 다른 변수의 인자 (```Argument```)로 전달될 수 있다.
> 3. 다른 함수의 결과로 반환 (```Return```)될 수 있다.
>
> → 함수가 일급 객체이므로, 함수를 데이터와 유사하게 다룰 수 있어 '고차 함수'로서 활용될 수 있다.

- 함수의 형태로 반환되는 함수를 모두 고차 함수라 정의
  - 함수는 일급 객체 → 일급 객체로서의 함수는 고차 함수로 활용 가능

```
const double = (n) => { return n * 2; };
console.log(double(4)); // 4 * 2 = 8
```
```
const adder = added => num => num + added;
console.log(adder(5)(3)); // 5 + 3 = 8
```

> 함수를 리턴하는 함수를 커리 함수 (```Curry Function```)라고 부르던데...?
>
> - 커리 함수라는 용어로, 고차 함수를 '함수를 인자로 받는 함수'에만 한정해 사용할 수 있음
>   - 엄밀히 말하면, 고차 함수가 커리 함수를 포함하는 개념

#### ```Array.map()``` 함수 : 배열의 각 요소에 대해 주어진 함수를 호출한 다음, 그 결과를 새로운 배열로 반환

```
console.log([1, 2, 3, 4, 5].map((num) => { return num * num; })); // [ 1, 4, 9, 16, 25 ]
```

#### ```Array.filter()``` 함수 : 배열의 요소 중에 주어진 조건을 만족하는 요소만을 추출하여 새로운 배열로 반환

```
console.log([1, 2, 3, 4, 5].filter((num) => { return num % 2 === 0 })); // [ 2, 4 ]
```

#### ```Array.reduce()``` 함수 : 배열의 각 요소에 대해 주어진 함수를 실행하고, 그 결과를 누적하여 하나의 값으로 반환

```
console.log([1, 2, 3, 4, 5].reduce((accumulator, currentValue) => { return accumulator + currentValue;}, 0)); // 15
```

#### ```Array.forEach()``` 함수 : 배열의 각 요소에 대해 주어진 함수를 실행 (반환값이 존재하지 않음)

```
[1, 2, 3, 4, 5].forEach((num) => { console.log(num); }); // 1부터 5까지 순서대로 출력
```

### 콜백 함수 (```Callback Function```) : 매개변수를 통해 다른 함수의 내부로 전달되는 함수

- 고차 함수의 인자로 전달되어, 특정 동작을 수행하거나 완료 시에 호출
  - 콜백 함수를 전달받은 고차 함수는 함수 내부에서 이 콜백 함수르 호출 (```Invoke```)할 수 잇음
  - 부르는 조건에 따라서 콜백 함수의 실행 조건을 결정할 수 있음

```
setTimeout(() => { console.log(`출력`); }, 1);
```

- 매개변수를 통해 다른 함수의 내부로 전달되는 함수는 콜백 함수, 매개변수를 통해 콜백 함수를 전달받는 함수는 고차 함수

```
// printString : 두개의 함수와 하나의 문장을 매개변수로 사용하는 고차함수
const printString = (callbackHof, callback_only, str) => {
    str +=' 반이고';
    callbackHof( callback_only, str );
}

// concatFirst : printString의 매개변수로 활용되는 콜백함수이면서, 하나의 함수와 하나의 문장을 매개변수로 사용하는 고차함수
const concatFirst = (callback_only, str) => {
  callback_only(str);
}

// concatAgain : concatFirst의 매개변수로 활용되는 콜백함수
const concatAgain = (str) => {
  str += ' 가만히 있으면 반이라도 간다';
  console.log(str);
}

printString(concatFirst, concatAgain, '시작은'); // 시작은 반이고 가만히 있으면 반이라도 간다
```

> 콜백 함수를 언제 호출하는지에 따라, 자바스크립트 엔진이 콜백 함수의 호출 시점을 결정할 수 있다!
>
> - 함수가 실행되면, 콜 스택 (```Call Stack```)에 함수를 넣었다가 함수에서 반환이 일어날 때 가장 위쪽에서 해당 함수를 꺼낸다.
> - 이벤트 루프 (```Event Loop```)는 콜 스택과 테스크 큐 (```Task Queue```)를 주시하고 있다가, 스택이 비어 있으면 큐의 첫번째 콜백을 스택에 쌓아 실행한다.


> 참고
> 
> - <a href="https://www.datoybi.com/callback-promise-async-await/">Steady-Dev, 'Callback & Promise & async/await 톺아보기'</a>
> - <a href="https://soldonii.tistory.com/119">soldonii, '200106(월) : 비동기, 고차함수, 일급객체, V8 엔진 등'</a>