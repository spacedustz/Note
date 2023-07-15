## AssertThat

`assertThat()` 메서드는 테스트 코드에서 특정 값을 검증하기 위해 사용되는 AssertJ 라이브러리의 메서드입니다. `extracting()`과 `containsExactly()`는 `assertThat()` 메서드와 함께 사용되는 메서드입니다.

`extracting()` 메서드는 특정 객체나 속성에서 값을 추출하여 검증할 수 있도록 도와줍니다. 일반적으로 컬렉션의 요소나 객체의 속성을 추출하여 테스트하고자 할 때 사용됩니다. 예를 들어, 다음은 `List` 객체의 `name` 속성에서 값을 추출하여 검증하는 예입니다:

```kotlin
data class Person(val name: String, val age: Int) { 
		val people = listOf(Person("John", 25), Person("Jane", 30))  
		
		assertThat(people)     
				.extracting("name")     
				.containsExactly("John", "Jane")
}
```

위의 예제에서는 `people` 리스트의 각 요소에서 `name` 속성 값을 추출하여, `containsExactly()` 메서드를 사용하여 "John"과 "Jane"이 순서대로 포함되어 있는지 검증합니다.

<br>

`containsExactly()` 메서드는 여러 값들이 주어진 순서대로 컬렉션에 포함되어 있는지 검증합니다. 

순서가 중요하며, 컬렉션에 있는 값들과 정확하게 일치해야 합니다. 

다른 순서나 추가적인 값이 포함되어 있으면 검증이 실패합니다.

---

### 또 다른 예시

다음은 `Map` 객체에서 특정 키-값 쌍들이 포함되어 있는지 검증하는 예입니다:


```kotlin
val map = mapOf("key1" to "value1", "key2" to "value2", "key3" to "value3")  

assertThat(map)     
		.extracting("key1", "key2", "key3")     
		.containsExactly("value1", "value2", "value3")
```

위의 예제에서는 `map` 객체에서 "key1", "key2", "key3" 키에 해당하는 값들을 추출하여, `containsExactly()` 메서드를 사용하여 "value1", "value2", "value3"이 순서대로 포함되어 있는지 검증합니다.

<br>

`assertThat()` 메서드와 함께 `extracting()`과 `containsExactly()`를 사용하여 값을 검증하면, 테스트 코드를 더 읽기 쉽고 명확하게 만들 수 있습니다.