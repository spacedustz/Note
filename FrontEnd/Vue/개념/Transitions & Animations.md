Transition이나 Animation을 활용해 화면상 요소를 움직이면 사용자 인터페이스와 사용자 경험이 좋아집니다.

```html
<div class="video" :class="{animate: animatedBlock}" align="center">  
  <button @click="animateBlock">Animate</button>
```

<br>

```ts
const animateBlock = () => {  
  animatedBlock.value = true;  
}
```

<br>

```css
.video {  
  /*transition: transform 0.3s ease-out;*/  
}  
  
.animate {  
  /*transform: translateX(-50px);*/  
  animation: slide-fade 0.3s ease-out forwards;  
}  
  
@keyframes slide-fade {  
  0% { transform: translateX(0) scale(1); }  
  70% { transform: translateX(-120px) scale(1.1); }  
  100% { transform: translateX(-150px) scale(1); }  
}
```

---

## 팝업 Animation

팝업은 CSS 만으로 부족합니다.

```css
@keyframes slide-fade {  
	from {
		opacity: 0;
		transform: translateY(-50px) sclae(0.9);
	}
	
	to {
		opacity: 1;
		transform: translateY(0) scale(1);
	}
}
```