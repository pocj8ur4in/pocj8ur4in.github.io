---
title: "실행 컨텍스트 실습 (2024.01.28)"

tags:
    - Digital Hanaro Study

toc: true
toc_sticky: true

date: 2024-01-28
last_modified_at: 2024-01-29
---

> <a href="https://github.com/pocj8ur4in/finance-dev-study">디지털하나路 스터디</a> 4일차 내용을 정리한 글입니다.


## 공부하고자 한 이유

실행 컨텍스트 (```Execution Context```)는 실행할 코드에 제공할 환경 정보들을 모아놓은 객체를 의미한다. 자바스크립트에서 가장 중요한 개념 중 하나가 바로 실행 컨텍스트라고 알고 있어, 강사님이 강의하시면서 사용한 함수의 실행 컨텍스트를 단계별로 나누어보면서 정리하여 이해하고자 하였다.

## 공부한 내용

```
var gg = 1;  let bb = 2;

function f1(x, y) {
  var gg = 11;   let bb = 22;
  console.log('f1>', gg, bb, zz, f2, f2.length);
  f2('first');
  { 
    const xx = 99;
    let lll = 0;
    f2('nest-first');
    var zz = 88;
    function f2(t) { console.log(t, 'nested', xx, zz, lll); }
  }
  function f2(t, u) { console.log(t, 'inner', xx, zz); }
  function f2(t, u, v) { console.log(t, 'inner2', xx, zz); }
  var zz = 800;
  f2('second');
}

function f2(g) {
  console.log(g, 'global f2>', gg, bb, xx, kk);
}

let xx = 9;
if (gg > 0) { var kk = 33; var yy = 9; }

f1(1,2);   console.log(kk, yy);

f2('third');
```

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/40dca0b0-9e4b-44d6-a36c-83aee24fc2e3">

```(1)``` 전역 코드 평가 단계

```
var gg;  let bb;
function f1(x, y) { ... } // Function Object
function f2(g) { ... }    // Function Object
let xx;
var kk;
```

```(2)``` 전역 코드 실행 단계

```
var gg = 1;  let bb = 2;
let xx = 9;
if (gg > 0) { ... }
f1(1,2);   console.log(kk, yy);
f2('third');
```

```(3)``` 전역 코드 실행 단계 (```if```문 코드 블록 실행 및 종료)

```
if (gg > 0) { // var gg = 1;
  var kk = 33; var yy = 9;
}
```

```(4)``` 함수 코드 평가 단계 : ```f1(1,2)``` 호출

```
f1(1,2);

function f1(x, y) {
  var gg;   let bb;
  { ... }
  // function f2(t, u) { ... } // Function Object
  function f2(t, u, v) { ... } // Function Object
  var zz;
}
```

```(5)``` 함수 코드 평가 단계 내부의 블록 코드 평가 단계 : ```{ ... }```

```
  { 
    const xx;
    let lll;
    var zz;
    function f2(t) { ... } // Function Object
  }
```

```(6)``` 함수 코드 실행 단계 : ```f1(1,2)``` 실행

```
f1(1,2);

function f1(x, y) {
  gg = 11;   bb = 22;
  console.log('f1>', gg, bb, zz, f2, f2.length); // f1> 11, 22, undefined, f2, 3
  f2('first');
  { ... }
  zz = 800;
  f2('second');
}
```

```(7)``` 함수 코드 실행 단계 : ```f1(1,2)``` 실행 → 함수 코드 평가 단계 : ```f2('first')``` 호출 

```
f1(1,2);

function f1(x, y) {
  f2('first');

  function f2(t, u, v) { console.log(t, 'inner2', xx, zz); };
}
```

```(8)``` 함수 코드 실행 단계 : ```f1(1,2)``` 실행 → 함수 코드 실행 단계 : ```f2('first')``` 실행 

```
f1(1,2);

function f1(x, y) {
  gg = 11;   bb = 22;
  f2('first'); // first inner2 9 undefined

  function f2(t, u, v) { console.log(t, 'inner2', xx, zz); };
}
```

```(9)``` 함수 코드 실행 단계 : ```f1(1,2)``` 실행 → 함수 코드 평가 단계 : ```f2('nest-first')``` 호출

```
function f1(x, y) {
  gg = 11; bb = 22;
  { 
    xx = 99;
    lll = 0;
    f2('nest-first');
    function f2(t) { console.log(t, 'nested', xx, zz, lll); }
  }
...
}
```

```(10)``` 함수 코드 실행 단계 : ```f1(1,2)``` 실행 → 함수 코드 실행 단계 : ```f2('nest-first')``` 실행

```
function f1(x, y) {
  gg = 11; bb = 22;

  { 
    xx = 99;
    lll = 0;
    f2('nest-first'); // nest-first nested 99 undefined 0
    function f2(t) { console.log(t, 'nested', xx, zz, lll); }
  }
...
}
```

```(11)``` 함수 코드 실행 단계 : ```f1(1,2)``` 실행 → 함수 코드 평가 단계 : ```f2('second')``` 호출

```
function f1(x, y) {
  gg = 11; bb = 22;
  
  {
    const xx = 99;
    lll = 0;
    zz = 88;
    function f2(t) { console.log(t, 'nested', xx, zz, lll); }
  }

  f2('second');
}
```

```(12)``` 함수 코드 실행 단계 : ```f1(1,2)``` 실행 → 함수 코드 실행 단계 : ```f2('second')``` 실행

```
function f1(x, y) {
  gg = 11; bb = 22;
  
  {
    const xx = 99;
    lll = 0;
    zz = 88;
    function f2(t) { console.log(t, 'nested', xx, zz, lll); }
  }
  f2('second'); // second nested 99 800 0
}
```

```(13)``` 전역 코드 실행 단계 (```console.log``` 문 실행 및 종료)

```
gg = 1;  bb = 2;

console.log(kk, yy); // 33 9
```

```(14)``` 전역 코드 실행 단계 → 함수 코드 평가 단계 : ```f2('third')``` 평가

```
gg = 1; bb = 2;

function f2(g) {
  console.log(g, 'global f2>', gg, bb, xx, kk);
}

let xx = 9;
if (gg > 0) { var kk = 33; var yy = 9; }

f2('third');
```

```(15)``` 전역 코드 실행 단계 → 함수 코드 평가 단계 : ```f2('third')``` 실행

```
gg = 1; bb = 2;

function f2(g) {
  console.log(g, 'global f2>', gg, bb, xx, kk);
}

let xx = 9;
if (gg > 0) { var kk = 33; var yy = 9; }

f2('third'); // third global f2> 1 2 9 33
```