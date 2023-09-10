## **💡** **CSS** 

https://codesandbox.io/s/html-cssgico-rur0eq

<br>

### **CSS Box Model**

border(테두리)를 기준으로 padding(안쪽 여백)과 margin(바깥 여백)이 있음

<br>

CSS Box Model

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css88.png) 

<br>

이해가 잘되는 사진

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css2.png) 

<br>

**border (테두리) 노란색**

p 태그에 1px의 빨간 실선 추가

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css3.png) 

border 속성에 적용된 각각의 값은 두께(border-width),스타일(border-style),색상(border-color)임

이외의 border-style mdn과 같이 구글검색을 통해 테두리 스타일에 대한 다양한 세부 속성 확인 가능

<br>

### 질문

- 테두리를 점선으로 만들고 싶으면 어떻게 해야 할까요?
  - border-style의 값 중 하나를 바꿔보세요.
- 테두리를 둥근 모서리로 만들 수도 있습니다. 어떤 속성을 사용하면 되나요?
  - 참고로, border 속성만으로는 둥근 모서리를 만들 수 없습니다.
- 박스 바깥쪽에 그림자를 넣을 수도 있습니다. 어떤 속성을 사용하면 되나요? 참고로, 그림자를 명확하게 보기 위해서는 background 속성이 불투명해야 합니다.

<br>

### margin (바깥 여백) 주황색

각각의 값은 top,right,bottom,left 로 시계방향임, p 태그의 상하좌우에 여백 추가

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css4.png) 

<br>

값을 2개만 넣으면 top,bottom이 10px / right,left가 20px

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css5.png) 

<br>

값을 1개만 넣으면 모든 방향에 10px의 여백 추가

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css6.png) 

<br>

margin의 특정위치를 지정해 여백 추가 가능

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css7.png) 

<br>

음수값도 지정 가능(다른 요소와의 간격 좁힘)

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css8.png) 

------

### **padding (안쪽 여백) 초록색**

위의 margin 규칙처럼 padding도 동일하게 적용

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css9.png) 

<br>

padding에 border이나 background-color를 적용하면 더 선명하게 확인가능

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css10.png) 

<br>

### **박스 측정 기준**

박스보다 큰 컨텐츠가 있으면 overflow 속성을 지정해 스크롤 표시

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css11.png) 

<br>

### **박스 측정 예시**

HTML 코드 예시

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css12.png) 

<br>

CSS 코드 예시

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css13.png) 

<br>

결과값

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css14.png) 

id가 container인 박스의 width 속성에 300px을 지정했습니다.
그러나 개발자 도구로 확인한 해당 요소의 width 값은 324px 입니다.
CSS에서 지정한 두 요소에 대해 아래와 같이 확인할 수 있습니다.

<br>

#container의 너비는 300px이 아니라, 324px입니다. 브라우저는 다음과 같은 계산을 실행합니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css15.png) 

<br>
\#inner의 100%는 300px이 아니라, 364px입니다. 브라우저는 다음과 같은 계산을 실행합니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css16.png) 

<br>

**해결법은?**

모든 요소에 box-sizing: border-box 를 추가해 모든박스의 여백+테두리 포함한 크기로 계산됨
<br>

이렇게 모든 요소에 box-sizing: border-box를 적용하면, 
모든 박스에서 여백과 테두리를 포함한 크기로 계산됩니다.<br>

일반적으로 box-sizing은 HTML 문서 전체에 적용합니다.<br>
box-sizing을 일부 요소에만 적용하는 경우, 혼란을 가중시킬 수 있습니다.

앞으로 레이아웃과 관련된 이야기를 할 때에는 border-box 계산법을 기준으로 이야기합니다.

<br>

**박스 크기 측정 기준 두 가지를 항상 기억해 주세요.**

- content-box는 박스의 크기를 측정하는 기본값입니다. 그러나 대부분의 레이아웃 디자인에서 여백과 테두리를 포함하는 박스 크기 계산법인 border-box를 권장합니다.
- border-box인 경우 box의 높이: height + padding-top + padding-bottom + border-top + border-bottom
- content-box인 경우 box의 높이: height

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css18.png) 

 

------

## **💡** CSS 작성 기본 구조



### **선택자(Selector)**

{속성:속성값; 속성:속성값;}

```css
p {
text-align:center; color:red;
}
```

<br>

### Selector

\+ = 인접한 형제 엘리먼트 선택
\> = ~의 자식 엘리먼트 선택

~ = ~과 인접한 형제 엘리먼트 선택

<br>

**a태그 style 옵션
**a:link 

- 방문 전 링크 상태

a:visited 

- 방문 후 링크 상태

a:hover

- 마우스 오버했을때 링크 상태

a:active

- 클릭했을때 링크 상태

id

- 스타일을 지정할 때 한가지만 지정해서 쓰는 이름(표기방식 = #이름) 
- id는 문서내에 고유한 이름이어야 함.

<br>

**ex)** html 문서내에 h4가 여러개 있다고 가정하고 가운데 있는 h4인 test-title 부분만 변경을 하려면

[HTML 문서의 중간 h4]
<h4 id="test-title">test-title</h4> 라고 임의의 id인 "test-title"을 지정해주고 css 파일에 가서

[CSS 파일]

```css
\#test-title {
 color: red;
}
```

로 html문서에서 지정한 id인 test-title의 색상을 지정해주면 가운데 h4인 test-title의 색상만 변경이 된다.

<br>

**class = 그룹으로 묶어서 스타일을 지정할 때 쓰는 이름(표기방식 = .이름)**
ex) html 문서내에 다수의 동일한 요소(li 태그) 들을 지정하여 텍스트에 밑줄을 긋고 싶을때

<br>

**HTML 문서**

동일한 요소들에 전부 class를 지정해준다

```html
<ul>
 <li class="skw">Home</li>
 <li class="skw">Mac</li>
 <li class="skw">iPhone</li>
</ul>
```

<br>

**CSS 파일**

class는 # 이 아닌 . 을 이용해 선택

```css
.skw {
 text-decoration: underline
}
```

<br>

### **Element**

여러 class를 하나의 요소에 적용하기

여러 class를 하나의 요소에 적용하려면, 띄어쓰기로 적용하려는 class들의 이름을 구분
ex) 요소를 만들거나, 요소에 스타일링을 적용할때 목적과 이름이 일치하는지 항상 확인

<br>

**HTML**

하나의 요소(li)에 2개의 class (skw , lkb) 적용

```css
<li class="skw lkb>Name</li>
```

<br>
**CSS**

특정 클래스를 통해 요소 스타일링

```css
.lkb {
  font-weight: bold;
  color: #009999;
}
```

------

### **그 외 Selector** 

- 셀렉터 

  - h1 { } div { } 

- 전체 셀렉터 

  -  \* { } 

- Tag 셀렉터 

  - section, h1 { } 

- ID 셀렉터 

  - \#only { } 

- class 셀렉터 

  - .widget { } .center { } 

- attribute 셀렉터 

  - a[href] { } p[id="only"] { } p[class~="out"] { } p[class|="out"] { } section[id^="sect"] { } div[class$="2"] { } div[class*="w"] { } 

- 후손 셀렉터

  ```css
  header h1 {}
  ```

- 자식 셀렉터

  ```css
  header > p { }
  ```

- 인접 형제 셀렉터

  ```css
  section + p { }
  ```

- 형제 셀렉터

  ```css
  section ~ p { }
  ```

- 가상 클래스

  ```css
  a:link { }
  a:visited { }
  a:hover { }
  a:active { }
  a:focus { }
  ```

- 요소 상태 셀렉터

  ```css
  input:checked + span { }
  input:enabled + span { }
  input:disabled + span { }
  ```

- 구조 가상 클래스 셀렉터

  ```css
  p:first-child { }
  ul > li:last-child { }
  ul > li:nth-child(2n) { }
  section > p:nth-child(2n+1) { }
  ul > li:first-child { }
  li:last-child { }
  div > div:nth-child(4) { }
  div:nth-last-child(2) { }
  section > p:nth-last-child(2n + 1) { }
  p:first-of-type { }
  div:last-of-type { }
  ul:nth-of-type(2) { }
  p:nth-last-of-type(1) { }
  ```

- 부정 셀렉터

  ```css
  input:not([type="password"]) { }
  div:not(:nth-of-type(2)) { }
  ```

- 정합성 확인 셀렉터

  ```css
  input[type="text"]:valid { }
  input[type="text"]:invalid { }
  ```

<br>

**속성**

color = 글자색
background-color = 배경색
background = 테두리색
text-align = 단락 가운데 정렬
font-size = 글자 크기 px 단위
font-family = 글꼴

- 절대 단위: px, pt 등
- 상대 단위: %, em, rem, ch, vw, vh 등

<br>

**1. 기기나 브라우저 사이즈 등의 환경에 영향을 받지 않는 절대적인 크기로 정하는 경우** px(픽셀)을 사용합니다.

<br>

px은 **글꼴의 크기를 고정하는 단위**이기 때문에 사용자 접근성이 불리합니다.

작은 글씨를 보기 힘든 사용자가 브라우저의 기본 글꼴 크기를 더 크게 설정하더라도 크기가 고정됩니다.

<br>

개발자가 제목(heading)을 강조하기 위해 픽셀을 이용해 글꼴의 크기를 지정했으나

사용자의 환경에 따라 일반 텍스트보다 작게 보이는 결과를 초래할 수 있습니다.

<br>

그리고 픽셀은 모바일 기기처럼 작은 화면이면서, 동시에 고해상도인 경우에도 적합하지 않습니다.

<br>

기본적으로 고해상도에서는 1px이 모니터의 한 점보다 크게 업스케일(upscale)되기 때문에,

뚜렷하지 못한 형태로 출력되는 경우도 있습니다. 픽셀은 인쇄와 같이 화면의 사이즈가 정해진 경우에 유리합니다.

<br>

**2. 일반적인 경우** 

상대 단위인 rem을 추천합니다.

<br>

root의 글자 크기, 즉 브라우저의 기본 글자 크기가 1rem이며, 두 배로 크게 하고 싶다면 2rem,

작게 하려면 0.8rem 등으로 조절해서 사용할 수 있습니다.

<br>

이는 사용자가 설정한 기본 글꼴 크기를 따르므로, 접근성에 유리합니다.

<br>

em은 부모 엘리먼트에 따라 상대적으로 크기가 변경되므로 계산이 어렵습니다.

이에 비해 rem은 root의 글자 크기에 따라서만 상대적으로 변합니다.

<br>

**기타 스타일링**

- 굵기: font-weight
- 밑줄, 가로줄: text-decoration
- 자간: letter-spacing
- 행간: line-height

가로로 정렬할 경우 text-align을 사용합니다. 

유효한 값으로는 left, right, center, justify(양쪽 정렬)가 있습니다.

<br>

세로로 정렬할 경우에는 문제가 조금 복잡합니다. 

vertical-align 속성을 쉽게 떠올릴 수 있지만, 
이 속성은 부모 요소의 display 속성이 반드시 table-cell이어야 합니다. 

<br>

세로 정렬이란, 정렬하고자 하는 글자를 둘러싸고 있는 박스의 높이가, 글자 높이보다 큰 경우에만 적용할 수 있는데, 이 부분은 이후 학습할 박스 모델 및 레이아웃에서 좀 더 살펴보겠습니다.

<br>

**사용 점유율**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css19.png)

------

### CSS 우선순위 규칙

어느게 우선순위가 제일 높을까

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css20.png)

<br>

우선순위 규칙에 따라 id가 우선순위가 제일 높다

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/css21.png) 