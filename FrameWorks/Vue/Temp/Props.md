## Vue Props

같은 컴포넌트를 사용할 때 서로 다른 데이터를 출력하기 위한 개념이자 일종의 Custom HTML 속성이다.

Vue App에 Props를 정의할 때는 카멜케이스, HTML내 Custom Tag에 Props를 정의할떈 케밥케이스 (- 를 이용함)를 사용한다.

Props는 Data 프로퍼티와 동일하게 취급되며 배열을 값으로 가질수도 있고, 객체를 가질수도 있다.

팀으로 협업을 한다면 왠만하면 객체를 값으로 가지는게 좋다.

```javascript
props: [
	'name',
	'phoneNumber',
	'emailAddress'
]
```

<br>

```html
<friend-contact name="a" phone-number="1" email-address="a@a.com"></friend-contact>
<friend-contact name="b" phone-number="2" email-address="b@b.com"></friend-contact>
```

<br>

또, Props는 Immutable하기 때문에 단방향 데이터 플로우에 위반하면 Vue App이 실행되지 않습니다.

즉, Custom HTML Tag에서 데이터를 변경하면 안되고 부모인 Vue App에서 변경 후 Custom HTML 로 반영해야 합니다.

그러기 위해선 Data 프로퍼티를 만들어서 초기값을 Props의 프로퍼티로 지정 후 해당 데이터 프로퍼티를 출력하면 됩니다.

이 방법은 원본 데이터를 그대로 변경하는게 아니라 내부값을 통하고 원본값 변경은 나중에 다뤄보겠습니다.

<br>

> 지원되는 프로퍼티 값

일반적으로 다음 공식 문서에서 프로퍼티 유효성 검사에 대한 모든 것을 배울 수 있습니다. [https://v3.vuejs.org/guide/component-props.html](https://v3.vuejs.org/guide/component-props.html)

<br>

특히 다음 값 타입(`type`  프로퍼티)이 지원됩니다.

- 문자열(String)
    
- 숫자(Number)
    
- 불리언(Boolean)
    
- 배열(Array)
    
- 객체(Object)
    
- 날짜(Date)
    
- 함수(Function)
    
- 심볼(Symbol)

<br>

생성자 함수(`Date`와 같은 내장된 함수 또는 커스텀 함수)도 타입이 될 수 있습니다.

```javascript
props: {
	name: {
		type: String,
		required: true
	},

	phoneNumber: {
		type: String,
		required: false
		validator: function(value) {
			return value === '1' || value === '0';
		}
	}
}
```

<br>

**Main Vue App**

```javascript
<template>  
  <section>  
    <header>  
      <h1>My Friends</h1>  
    </header>  
    <ul>  
      <friend-contact  
          v-for="friend in friends"  
          key="friend.id"  
          :name="friend.name"  
          :phone-number="friend.phone"  
          :email-address="friend.email"  
          :is-favorite="true">  
      </friend-contact>  
    </ul>  
  </section>  
</template>  
  
<script>  
export default {  
  data() {  
    return {  
      friends: [  
        {  
          id: "manuel",  
          name: "Manuel Lorenz",  
          phone: "0123 45678 90",  
          email: "manuel@localhost.com",  
        },  
        {  
          id: "julie",  
          name: "Julie Jones",  
          phone: "0987 654421 21",  
          email: "julie@localhost.com",  
        },  
      ],  
    };  
  },  
};  
</script>  
  
<style>  
* {  
  box-sizing: border-box;  
}  
  
html {  
  font-family: "Jost", sans-serif;  
}  
  
body {  
  margin: 0;  
}  
  
header {  
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.26);  
  margin: 3rem auto;  
  border-radius: 10px;  
  padding: 1rem;  
  background-color: #58004d;  
  color: white;  
  text-align: center;  
  width: 90%;  
  max-width: 40rem;  
}  
  
#app ul {  
  margin: 0;  
  padding: 0;  
  list-style: none;  
}  
  
#app li {  
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.26);  
  margin: 1rem auto;  
  border-radius: 10px;  
  padding: 1rem;  
  text-align: center;  
  width: 90%;  
  max-width: 40rem;  
}  
  
#app h2 {  
  font-size: 2rem;  
  border-bottom: 4px solid #ccc;  
  color: #58004d;  
  margin: 0 0 1rem 0;  
}  
  
#app button {  
  font: inherit;  
  cursor: pointer;  
  border: 1px solid #ff0077;  
  background-color: #ff0077;  
  color: white;  
  padding: 0.05rem 1rem;  
  box-shadow: 1px 1px 2px rgba(0, 0, 0, 0.26);  
}  
  
#app button:hover,  
#app button:active {  
  background-color: #ec3169;  
  border-color: #ec3169;  
  box-shadow: 1px 1px 4px rgba(0, 0, 0, 0.26);  
}  
</style>
```

<br>

**Friend Component**

```javascript
<template>  
  <li>  
    <h2>{{ name }} {{ friendIsFavorite ? '(Favorite)' : '' }}</h2>  
    <button @click="toggleDetails">{{ detailsAreVisible ? 'Hide' : 'Show' }} Details</button>  
    <button @click="toggleFavorite">Details</button>  
  
    <ul v-if="detailsAreVisible">  
      <li>  
        <strong>Phone:</strong>  
        {{ phoneNumber }}  
      </li>  
      <li>  
        <strong>Email:</strong>  
        {{ emailAddress }}  
      </li>  
    </ul>  
  </li>  
</template>  
  
<script>  
export default {  
  // props: ["name", "phoneNumber", "emailAddress", "isFavorite"],  
  props: {  
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
      //   return value === '1' || value === '0';      // }    }  
  },  
  data() {  
    return {  
      detailsAreVisible: false,  
      friendIsFavorite: this.isFavorite,  
    };  
  },  
  methods: {  
    toggleDetails() {  
      this.detailsAreVisible = !this.detailsAreVisible;  
    },  
    toggleFavorite() {  
      this.friendIsFavorite = !this.friendIsFavorite;  
    }  
  }  
};  
</script>
```