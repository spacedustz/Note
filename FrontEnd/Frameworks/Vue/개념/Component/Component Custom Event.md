## Vue Component Custom Event (Parent -> Child)

저번에 봤던 Props는 App.vue App 에서 컴포넌트로 전달했지만 

이번엔  **컴포넌트에서 App.vue App으로 데이터를 전달합니다, props와는 반대 방향이죠.**

<br>

버튼을 클릭했을떄 이벤트가 발생하듯이 Vue의 컴포넌트도 마찬가지입니다.

컴포넌트가 App.vue App에게 무언가 알리고자 한다면 컴포넌트는 App.vue가 수신할 이벤트를 발생시켜야 합니다.

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

이 `$emit()`은 App.vue App이 수신할 Custom Event를 발생시킵니다.

<br>

emit의 첫번쨰 파라미터엔 Custom Event의 이름을 지정할 수 있는데 **케밥케이스를 기반으로** 임의의 이름을 작성합니다.

**(케밥케이스는 props의 데이터를 전달할때, 이벤트 이름을 지정할때 등에 사용합니다.)**

<br>

그리고 App.vue App에서 emit을 사용한 함수를 `v-on의 축약어인 @`를 사용해 바인딩하고,  

값으로는 -> App.vue App의 Method에 함수를 만들어서 지정해줍니다. (여기선 toogleFavoriteStatus 함수를 만듬)

```html
<friend-contact  
    v-for="friend in friends"  
    key="friend.id"  
    :name="friend.name"  
    :phone-number="friend.phone"  
    :email-address="friend.email"  
    :is-favorite="true">  
    @toggle-favorite="toggleFavoriteStatus"  
</friend-contact>

// ------

methods: {
	toggleFavoriteStatus() {}
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

그리고 App.vue App은 이미 id가 있으니 이제 간단하게 전달할 수 있습니다.

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

이제 Component의 id 프로퍼티에 제공된 id를 가지고 Custom Event를 발생시킬 수 있습니다.

이제 toggleFavorite 이벤트가 발생하면 추가 데이터로 id값도 같이 넘어가게 됩니다.

그럼 아까 App.vue App에서 만든 toggleFavoriteStatus 함수에 이벤트로 넘어온 id 값을 파라미터로 받을 수 있습니다.

```javascript
methods: {
	toggleFavoriteStatus(friendId) {
		const identifiedFriend = this.friends.find(friend => friend.id === friendId);  
		identifiedFriend.isFavorite = !identifiedFriend.isFavorite;
	}
}
```

<br>

이렇게 작성하면 Component가 아닌 App.vue App에서 즐겨찾기의 상태를 변경할 수 있습니다.

마지막으로 Component에 추가했었던 friendIsFavorite 데이터 프로퍼티는 이제 삭제해도 됩니다.

---

## 정리

이렇게 단방향 데이터 플로우를 양방향 데이터 플로우로 만들었습니다.

컴포넌트의 props 데이터를 App.vue에서 컴포넌트로 전달하는데 썼고, `$emit()`으로 컴포넌트 내부에서 Custom Event를 발생시키면서,

반대 방향으로 전달하는데도 썼습니다.

<br>

그리고 App.vue에서 Custom Event를 수신해서 Main App의 데이터 프로퍼티가 저장된 App.vue의 데이터를 변경했습니다.

그다음 업데이트된 데이터를 컴포넌트로 다시 돌려보내서 Vue가 변경사항을 감지하고 UI를 업데이트 하게 했습니다.

<br>

1. Component의 props 프로퍼티들을 App.vue에서 바인딩해서 값을 넣고 다시 되돌려줌
2. Component에서 `$emit`을 이용해 컴포넌트 내부에서 Custom Event를 발생시킴
3. 이벤트가 발생함으로써 `$emit`의 2번째 파라미터부터 들어오는 데이터들을 다시 전달
4. App.vue에서 Custom Event를 수신해서 App.vue의 Data 프로퍼티 값 데이터를 변경
5. 업데이트된 App.vue의 Data 프로퍼티를 다시 컴포넌트로 전달
6. Vue가 데이터의 변경을 감지하고 UI를 업데이트

---
