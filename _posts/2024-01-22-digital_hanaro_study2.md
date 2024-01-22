---
title: "TailwindCSS란? (2024.01.22)"

tags:
    - Digital Hanaro Study

toc: true
toc_sticky: true

date: 2024-01-22
last_modified_at: 2024-01-22
---

> <a href="https://github.com/pocj8ur4in/finance-dev-study">디지털하나路 스터디</a> 2일차 내용을 정리한 글입니다.

## 공부하고자 한 이유

토이 프로젝트를 만들 때 부트스트랩 (```Bootstrap```)을 많이 활용하여 화면을 구성하곤 하였는데, 오늘 강사님께서 ```TailwindCSS```라는 새로운 프론트엔드 프레임워크 기술에 대해 말씀해주시면서, 현재는 부트스트랩보다 ```TailwindCSS```를 사용한 사이트가 훨씬 다수임을 알려주셨다. 그래서 향후 토이 프로젝트에 ```TailwindCSS```를 적용할 수 있도록 부트스트랩과 차이점을 비교해보면서 ```TailwindCSS```에 대해 공부해보고자 한다.

## 공부한 내용

부트스트랩 (```BootStrap```)은 2011년에 트위터에서 시작된 오픈 소스 프론트엔드 프레임워크이다. 글자, 인용문, 목록, 표 등 자잘한 요소부터 메뉴, 바, 버튼 등까지 웹 페이지에서 자주 쓰이는 요소들을 모두 내장하고 있어, 부트스트랩의 ```CSS```와 ```JS```를 사이트에 반영만 하면 일정한 디자인을 빠른 시간 내에 제작할 수 있다. 그리고 데스크탑만이 아니라 모바일 화면 또한 비율에 맞게 반응형으로 지원하여 크로스 브라우저 (```Cross-Browser```) 환경에도 적합하다. 또한 해상도 크기에 맞게 자동으로 정렬되고 크기 조절이 가능한 그리드 시스템 (```Grid System```)이 내장되어 있어 화면에 특정한 요소를 배치하는 것에 대한 커스텀마이징 또한 매우 간단한 편이다. <a href="https://getbootstrap.com">부트스트랩 공식 웹 사이트</a>에서 여러 예시 화면들을 볼 수도 있다.

나 같은 경우에는 전문적인 프론트엔드 개발자가 아니라서, 부트스트랩을 처음 접했을 때에는 블로그를 운영하는 과정에서 배운 ```HTML/CSS/JS```에 대한 지식들만 있는 상태였다. 그러나 예시 화면들의 각 요소들을 직접 뜯어보고 수정하는 과정에서 사용해본 내부 클래스들로만으로도 내가 필요로 한 화면들을 금방금방 구성해낼 수 있었다. 아래의 화면은 내가 기획하였던 사이트의 노래 검색 화면으로, 화면 구상에서 실제 구현까지 2~3일 정도 걸린 것으로 기억한다. ```Header```와 ```Footer``` 부분은 템플릿 엔진을 통해 이전에 만든 요소를 그대로 사용하였고, 상세 검색 화면은 그리드 시스템과 내장된 글자 및 버튼 속성을 적절히 적용하여 구현하였다. 그리고 버튼을 눌렀을 때 나올 수 있는 동작들, 예를 들어 마우스 포커싱 기능들도 ```CSS```로 구현되어 있어 따로 만들 필요가 없었다. 그리고 작년에 ```7``` 버전이 출시될 만큼 꾸준한 개발 및 지원이 이루어지고 있고, 또 부트스트랩을 사용하는 웹 사이트 및 래퍼런스들도 여전히 많이 존재한다. 

<img src="https://github.com/pocj8ur4in/pocj8ur4in.github.io/assets/105341168/625ec1e6-55ec-48a3-9ae8-5b415405f4b1">

그럼 부트스트랩 대신에 ```TailwindCSS```가 대세가 된 이유는 무엇일까? 내가 처음 떠올린 이유는 부트스트랩만으로는 생각보다 직접 커스텀마이징을 하는 데에 한계가 있다는 것이다. 물론 오픈 소스이므로 래퍼런스가 정말 많고, 원하는 페이지를 만드는 것도 얼마든지 가능한 것 또한 사실이다. 그런데 사실 이건 ```HTML/CSS/JS```을 다룰 수 있으면 얼마든지 가능한 부분이고, 이젠 피그마 등을 활용해 원하는 화면을 빠르게 배치해 만드는 것도 가능하다. 오히려 부트스트랩 기반으로 한, 비슷한 디자인의 사이트들이 많아져서 타 사이트와의 차별성을 두기 어려운 부분 또한 맞는 말이라고 생각한다. 부트스트랩의 취지는 ```HTML/CSS/JS```들을 미리 만들어 개발자가 사용할 수 있는 것인데, 내가 구현하지 않는 부분까지 빌트인 (```built-in```)되어 있다보니, 부트스트랩 자제 문법을 공부하는 데에도 시간이 꽤 걸린다.

그러면 ```TailwindCSS```에 대해 알아보자. ```TailwindCSS```는 2017년에 ```Tailwind Labs```에서 개발한 ```CSS``` 프레임워크이다. ```TailwindCSS```는 ```CSS```를 작성하지 않고 클래스 이름을 제공하여 ```HTML```에 필요한 ```CSS``` 유틸리티만 입혀도 스타일이 완성되는 '유틸리티 우선 ```CSS```'를 지향한다. <a href="https://tailwindcss.com">```TailwindCSS``` 공식 사이트</a>를 보면, 클래스 이름만 적어도 ```CSS```가 적용되는 여러 예시들을 볼 수 있다.

```
<div>
    <style>
    .rainbow-block {
      display: inline-block;
      width: 100%;
      height: 150px;
      background: linear-gradient(to right, violet, indigo, blue, green, yellow, orange, red);
    }
  </style>
  <div class="rainbow-block"></div>
</div>
```

<div>
    <style>
    .rainbow-block {
      display: inline-block;
      width: 100%;
      height: 150px;
      background: linear-gradient(to right, violet, indigo, blue, green, yellow, orange, red);
    }
  </style>
  <div class="rainbow-block"></div>
</div>

무지개색 블록을 만들고자 할 때, 순수 ```CSS```는 위의 스타일 코드를 적어야 한다. 반면 ```TailwindCSS```는 아래의 예시처럼 미리 정의된 유틸리티 클래스들을 활용하여 클래스 이름만으로 스타일을 적용할 수 있다.

```
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

.rainbow-block {
  @apply inline-block w-32 h-32 bg-gradient-to-r from-violet to-red;
}
```

사실 이게 왜 장점이지? 할 수도 있다. 어쨌든 ```HTML/CSS``` 또한 기능 자체를 제공하기는 한다! 하지만 ```TailwindCSS```가 제공하는 유틸리티 클래스는 부트스트랩의 장점인 일관성 있는 디자인을 가지면서, 기본 스타일 값을 직접 커스텀마이징할 수 있는 ```key-value```를 제공한다. 그리고 로우 레벨의 스타일 또한 제공하므로, 미리보기, 자동완성, 신택스 하이라이팅 및 린팅을 지원하는 ```IntelliSense``` 플러그인을 활용하여 필요한 디자인을 세밀하게 구현할 수 있다. 무엇보다 프론트엔드 개발자가 가장 장점으로 꼽는 부분은 <b>클래스 이름을 고민하지 않아도 된다는 점</b>인데, 이건 함수의 이름을 잘 짓기 위해 프로젝트 시작 전에 매번 고민하는 시간을 갖는 나에게도 와닿는 문제라 공감이 가는 부분이 많다.
