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
	toggleFavorite() {  
	  this.$emit('toggle-favorite');  
	}
}
```

<br>

위에서 나온 `$emit()`은 this 키워드로 호출할 수 있는 내장 메서드입니다.

이 `$emit()`은 부모 App이 수신할 Custom Event를 발생시킵니다.

<br>

emit의 첫번쨰 파라미터엔 Custom Event의 이름을 지정할 수 있는데 **케밥케이스를 기반으로** 임의의 이름을 작성합니다.

**(케밥케이스는 props의 데이터를 전달할때, 이벤트 이름을 지정할때 등에 사용합니다.)**

<br>

그리고 부모 App에서 emit을 사용한 함수를 `v-on의 축약어인 @`를 사용해 바인딩하고,  

값으로는 -> 부모 App의 Method에 함수를 만들어서 지정해줍니다. (여기선 toogleFavoriteStatus 함수를 만듬)

```html
<friend-contact  
    v-for="friend in friends"  
    key="friend.id"  
    :name="friend.name"  
    :phone-number="friend.phone"  
    :email-address="friend.email"  
    :is-favorite="true">  
    @toggle-favorite=""  
</friend-contact>

// ------

methods: {
	toggle
}
```

<br>

이렇게 하면 Component -> Parent App으로 이벤트는 발생시키지만 데이터는 전달하는건 아직 구현하지 않았습니다.

`$emit`의 2번쨰 파라미터부터 들어올 값은 전부 이벤트와 함께 전달될 데이터입니다.

<br>

예를들어 Component의 props에 id를 추가한다고 가정해보겠습니다.

```javascript
props: {  
  id: {  
    type: String,  
    required: true  
  },  
  name: {  
    type: String,  
    required: true  
  },  
  phoneNumber: {  
    type: String,  
    required: true  
  },  
  emailAddress: {  
    type: String,  
    required: true  
  },  
  isFavorite: {  
    type: Boolean,  
    required: false,  
    default: false,  
    // validator: function(value) {  
    //   return value === '1' || value === '0';    // }  }
```

<br>

그리고 Component의 methods의 toggleFavorite 함수에서 `$emit`의 데이터로 this.id 를 줄 수 있겠죠.

```javascript
methods: {  
  toggleDetails() {  
    this.detailsAreVisible = !this.detailsAreVisible;  
  },  
  toggleFavorite() {  
    this.$emit('toggle-favorite', this.id);  
  }  
}
```

<br>

그리고 부모 App은 이미 id가 있으니 이제 간단하게 전달할 수 있습니다.

```html
<friend-contact  
    v-for="friend in friends"  
    :key="friend.id"  
    :id="friend.id"  
    :name="friend.name"  
    :phone-number="friend.phone"  
    :email-address="friend.email"  
    :is-favorite="true">  
    @toggle-favorite="toggleFavoriteStatus"  
</friend-contact>
```

<br>

이제 Component