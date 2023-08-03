## Vue Component Custom Event (Parent -> Child)

저번에 봤던 Props는 부모 App 에서 컴포넌트로 전달했지만 

이번엔  **컴포넌트에서 부모 App으로 데이터를 전달합니다, props와는 반대 방향이죠**

버튼을 클릭했을떄 이벤트가 발생하듯이 Vue의 컴포넌트도 마찬가지입니다.

컴포넌트가 부모 App에게 무언가 알리고자 한다면 컴포넌트는 부모가 수신할 이벤트를 발생시켜야 합니다.

```javascript
methods: {
	toogleFavorite() {
		this.friendIsFavorite = !this.friendIsFavorite;
	}
};

// -----------------------

methods: {
	toogleFavorite() {
		this.$emit();
	}
}
```

<br>

위에서 나온 `$emit()`은 this 키워드로 호출할 수 있는 내장 메서드입니다.

이 `$emit()`은 부모 App이 수신할 Custom Event를 발생시킵니다.

<br>

emit의 첫번쨰 파라미터엔 Custom Event의 이름을 지정할 수 있는데 **케밥케이스를 기반으로**임의로 작성합니다. (이벤트 이름은 전부 케밥 케이스)

그리고 HTML에서 emit을 사용한 함수를 바인딩하고  값으로는 -> 부모 App의 Method에 함수를 만들어서 지정해줍니다.

```javascript
@toogle-favorite="toogleFavoriteStatus"
```

<br>

`$emit`의 2번쨰 파라미터부터 이벤트로