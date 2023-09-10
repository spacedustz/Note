## 💡 Like & Contains

일하다가 어드민 기능중 유저를 여러 조건으로 검색하는 기능을 개발하는 도중

QueryDsl의 Like, Contains가 비슷하게 동작하는거 같아 알아보고 글을 쓴다.

like는 컬럼의 모든 텍스트가 일치해야하고 contains는 like를 `%text%` 이렇게 쓴것과 같았다.

둘다 StringExpression 타입이다.

<br>

둘다 내부적으로 Like 연산이 수행되므로 escape 처리를 해줘야 한다.

```kotlin
val builder = BooleanBuilder()

// escape 처리
builder.or(test.type.like("%$text%", '!'))

builder.and(test.type.contains(text..replace("!", "!!").replace("%", "!%").replace("_", "!_")))
```

like 메서드는 excape 파라미터를 1개 밖에 허용하지 않기 때문에 replace를 활용하여,
like 메서드 안에 여러개의 escape를 할 수 있다.

```kotlin
userBuilder.or(user.geometry.sigungu.like("%$sigungu%".replace("!", "!!").replace("%", "!%").replace("_", "!_"), '!'))  

animalBuilder.or(user.geometry.sigungu.like("%$sigungu%".replace("!", "!!").replace("%", "!%").replace("_", "!_"), '!'))
```