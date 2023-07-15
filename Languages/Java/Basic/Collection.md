## **💡 Collection FrameWork**  

- 여러 데이터들의 집합,메소드들을 미리 정의해놓은 것
- 특정 자료구조에 데이터를 추가&삭제&수정&검색 등의 동작을 수행하는 메소드 제공

<br>

컬렉션 프레임워크의 구조

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java56.png)

------

### **컬렉션의 주요 인터페이스 3가지**

<br>

list와 set은 공통점이 많아 공통점을 추출하여 추상화한것이 Collection 이라는 인터페이스임

<br>

**List**

- List는 **데이터의 순서가 유지되며, 중복 저장이 가능**한 컬렉션을 구현하는 데에 사용됩니다.
- ArrayList, Vector, Stack, LinkedList 등이 List 인터페이스를 구현합니다.

**Set**

- Set은 **데이터의 순서가 유지되지 않으며, 중복 저장이 불가능**한 컬렉션을 구현하는 데에 사용됩니다.
- HashSet, TreeSet 등이 Set 인터페이스를 구현합니다.

**Map**

- Map은 **키(key)와 값(value)의 쌍으로 데이터를 저장**하는 컬렉션을 구현하는 데에 사용됩니다.
- **데이터의 순서가 유지되지 않으며, 키는 값을 식별하기 위해 사용되므로 중복 저장이 불가능하지만, 값은 중복 저장이 가능합니다.**
- HashMap, HashTable, TreeMap, Properties 등

<br>

#### **Collection Interface**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java57.png) 

<br>

#### **List Interface**

- 객체를 배열과 같이 자동으로 인덱스가 부여되며, 인덱스로 객체를 검색,추가,삭제 등 여러 기능 제공
- Collection Interface의 Method를 상속받아 사용 가능

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java58.png) 

<br>

#### **ArrayList (객체의 배열화)**

- list 인터페이스를 구현한 클래스로, 컬렉션에서 가장많이 사용됨
- 기능적으로는 Vector와 동일하지만 그걸 개선한것이므로 Vector보다 ArrayList를 사용함
- Arraylistdp 객체를 추가하면 인덱스 0부터 차례로 저장

```java
ArrayList<타입 매개변수> 객체명 = new ArrayList<타입 매개변수>(초기 저장 용량);

ArrayList<String> container1 = new ArrayList<String>();
// String 타입의 객체를 저장하는 ArrayList 생성
// 초기 용량이 인자로 전달되지 않으면 기본적으로 10으로 지정됩니다. 

ArrayList<String> container2 = new ArrayList<String>(30);
// String 타입의 객체를 저장하는 ArrayList 생성
// 초기 용량을 30으로 지정하였습니다. 
public class ArrayListExample {
	public static void main(String[] args) {

		// ArrayList를 생성하여 list에 할당
		ArrayList<String> list = new ArrayList<String>();

		// String 타입의 데이터를 ArrayList에 추가
		list.add("Java");
		list.add("egg");
		list.add("tree");

		// 저장된 총 객체 수 얻기
		int size = list.size(); 

		// 0번 인덱스의 객체 얻기
		String skill = list.get(0);

		// 저장된 총 객체 수 만큼 조회
		for(int i = 0; i < list.size(); i++){
			String str = list.get(i);
			System.out.println(i + ":" + str);
		}

		// for-each문으로 순회 
		for (String str: list) {
			System.out.println(str);
		}		

		// 0번 인덱스 객체 삭제
		list.remove(0);
	}
}
```

<br>

#### **LinkedList**

- 데이터를 효율적으로 추가,삭제,변경을 위해 사용

<br>

각 요소들은 자신과 연결된 이전요소 및 다음요소의 주소값과 데이터로 구성

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java59.png) 

```java
public class LinkedListExample {
	public static void main(String[] args) {
		
		// Linked List를 생성하여 list에 할당
		ArrayList<String> list = new LinkedList<>();

		// String 타입의 데이터를 LinkedList에 추가
		list.add("Java");
		list.add("egg");
		list.add("tree");

		// 저장된 총 객체 수 얻기
		int size = list.size(); 

		// 0번 인덱스의 객체 얻기
		String skill = list.get(0);

		// 저장된 총 객체 수 만큼 조회
		for(int i = 0; i < list.size(); i++){
			String str = list.get(i);
			System.out.println(i + ":" + str);
		}

		// for-each문으로 순회
		for (String str: list) {
			System.out.println(str);
		}		

		// 0번 인덱스 객체 삭제
		list.remove(0);
	}
}
```

<br>

### **ArrayList 와 LinkedList의 차이점**

<br>

**ArrayList의 장점**

- **데이터를 순차적으로 추가하거나 삭제하는 경우**
  - 순차적으로 추가한다는 것은 0번 인덱스에서부터 데이터를 추가하는 것을 의미.
  - 순차적으로 삭제한다는 것은 마지막 인덱스에서부터 데이터를 삭제하는 것을 의미.
- **데이터를 읽어들이는 경우**
  - 인덱스를 통해 바로 데이터에 접근할 수 있으므로 검색이 빠름.

<br>

**ArrayList의 단점**

- **중간에 데이터를 추가하거나, 중간에 위치하는 데이터를 삭제하는 경우**
  - 추가 또는 삭제 시, 해당 데이터의 뒤에 위치한 값들을 뒤로 밀어주거나 앞으로 당겨주어야 함.

<br>

**LinkedList의 장점**

- **중간에 위치하는 데이터를 추가하거나 삭제하는 경우**
  - 데이터를 중간에 추가하는 경우, Prev와 Next의 주소값만 변경하면 되므로, 다른 요소들을 이동시킬 필요가 없음.

<br>

**결론**

데이터의 잦은 변경이 예상된다면 LinkedList를, 데이터의 개수가 변하지 않는다면 ArrayList를 사용하는 것이 좋음.

------

## **💡 Iterator (반복자)**  

- 컬렉션에 저장된 요소들은 순차적으로 읽어옴 (컬렉션 순회 기능)- 컬렉션에는
  Iterator 인터페이스를 구현한 클래스의 인스턴스를 반환하는 메소드인 iterator()가 정의되어져있음
- 즉, iterator()를 호출하면, Iterator 타입의 인스턴스가 반환됨

<br>

iterator() 를 통해 만들어진 인스턴스는 이 사진의 메소드를 사용 가능

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java60.png)  

```java
ArrayList<String> list = ...;
Iterator<String> iterator = list.iterator();

while(iterator.hasNext()) {     // 읽어올 다음 객체가 있다면 
	String str = iterator.next(); // next()를 통해 다음 객체를 읽어옵니다. 
	...
}
```

<br>

Iterator를 사용하지 않더라도, for-each문을 이용해서 전체 객체를 대상으로 반복할 수 있다

```java
ArrayList<String> list = ...;
for(String str : list) {
	...
}
```

next() 메서드로 가져온 객체를 컬렉션에서 제거하고 싶다면 remove() 메서드를 호출한다

next() 메서드는 컬렉션의 객체를 그저 읽어오는 메서드로, 실제 컬렉션에서 객체를 빼내는 것은 아님

<br>

하지만, remove() 메서드는 컬렉션에서 실제로 객체를 삭제한다

```java
ArrayList<String> list = ...;
Iterator<String> iterator = list.iterator();

while(iterator.hasNext()){        // 다음 객체가 있다면
	String str = iterator.next();   // 객체를 읽어오고,
	if(str.equals("str과 같은 단어")){ // 조건에 부합한다면
		iterator.remove();            // 해당 객체를 컬렉션에서 제거합니다. 
	}
}
```

------

## **💡 Set**

- 요소 중복을 허용하지않고, 저장순서를 유지하지 않음
- 대표적인 Set을 구현한 클래스로 HashSet , TreeSet이 있음

<br>

Set 인터페이스의 메소드

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java61.png) 

<br>

### **HashSet**

- Set 인터페이스를 구현한 가장 대표적인 컬렉션 클래스
- 따라서 Set 인터페이스의 특성을 그대로 상속받기 때문에 중복값허용 X / 저장순서 유지 X

<br>

### **HashSet에 값을 추가할 때, 값이 중복인지 판단 여부**

1. add(Object o)를 통해 객체를 저장하고자 합니다.
2. 이 때, 저장하고자 하는 객체의 해시코드를 hashCode() 메서드를 통해 얻어냅니다.
3. Set이 저장하고 있는 모든 객체들의 해시코드를 hashCode() 메서드로 얻어냅니다.
4. 저장하고자 하는 객체의 해시코드와, Set에 이미 저장되어져 있던 객체들의 해시코드를 비교하여, 같은 해시코드가 있는지 검사합니다.
   1. 이 때, 만약 같은 해시코드를 가진 객체가 존재한다면 아래의 5번으로 넘어갑니다.
   2. 같은 해시코드를 가진 객체가 존재하지 않는다면, Set에 객체가 추가되며 add(Object o) 메서드가 true를 리턴합니다.
5. equals() 메서드를 통해 객체를 비교합니다.
   1. true가 리턴된다면 중복 객체로 간주되어 Set에 추가되지 않으며, add(Object o)가 false를 리턴합니다.
   2. false가 리턴된다면 Set에 객체가 추가되며, add(Object o) 메서드가 true를 리턴합니다.

<br>

```java
import java.util.*;

public class Main {
    public static void main(String[] args) {

				// HashSet 생성
        HashSet<String > languages = new HashSet<String>();

				// HashSet에 객체 추가
        languages.add("Java"); 
        languages.add("Python");
        languages.add("Javascript");
        languages.add("C++");
        languages.add("Kotlin");
        languages.add("Ruby");
        languages.add("Java"); // 중복

				// 반복자 생성하여 it에 할당
        Iterator it = languages.iterator();

				// 반복자를 통해 HashSet을 순회하며 각 요소들을 출력
        while(it.hasNext()) {
            System.out.println(it.next());
        }
    }
}
```

<br>

### **TreeSet**

- 이진 탐색 트리 형태로 데이터 저장
- Set인터페이스의 특성인 데이터의 중복저장 허용X, 저장순서 유지X 적용

*** 이진탐색트리?** = 하나의 부모노드가 최대 두개의 자식노드와 연결되는 이진트리의 일종,정렬과 검색에 특화된 자료구조

**모든 왼쪽 자식의 값이 루트나 부모보다 작고, 모든 오른쪽 자식의 값이 루트나 부모보다 큰 값을 가지는 특징**이 있다.

<br>

모든 왼쪽값은 루트노드나 부모노드보다 작고 오른쪽값은 항상 크다

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java62.png) 

<br>

위와 같은 자료구조를 구현한 의사코드 작성 예시

```java
class Node {
	Object element; // 객체의 주소값을 저장하는 참조변수 입니다. 
	Node left;      // 왼쪽 자식 노드의 주소값을 저장하는 참조변수입니다.
	Node right;     // 오른쪽 자식 노드의 주소값을 저장하는 참조변수입니다. 
}
import java.util.TreeSet;

public class TreeSetExample {
    public static void main(String[] args) {

				// TreeSet 생성
        TreeSet<String> workers = new TreeSet<>();

				// TreeSet에 요소 추가
        workers.add("Lee Java");
        workers.add("Park Hacker");
        workers.add("Kim Coding");

        System.out.println(workers);
        System.out.println(workers.first());
        System.out.println(workers.last());
        System.out.println(workers.higher("Lee"));
        System.out.println(workers.subSet("Kim", "Park"));
    }
}
```

출력값을 보면 요소를 추가하기만 했는데 자동으로 사전편찬순으로 오름차순 정렬이 됨

------

## **💡 Map <K, V>**  

- 키(key), 값(value)으로 구성된 객체를 저장하는 구조
- 이 객체를 Entry객체라고하는데, 이 Entry객체는 키와 값을 각각의 객체로 저장함
- 키는 중복저장X 값은 중복저장O 이며, 둘다 기본타입일 수 없음
- Map 인터페이스를 구현한 클래스는 HashMap, Hashtable, TreeMap, SortedMap 등이 있다

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java63.png) 

<br>

Map 인터페이스를 구현한 클래스에서 공통사용이 가능한 메소드

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java64.png)  

<br>

### **HashMap**

- 해시함수를 통해 키와 값이 저장되는 위치결정, 삽입되는 순서위 위치 또한 관계 없음
- 많은 양의 데이터를 검색하는데 뛰어난 성능

<br>

Entry는 Map의 내부인터페이스인 Entry를 구현하며, Map.Entry 인터페이스에는 이런 메소드가 정의됨

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java65.png) 

<br>

### **HashMap 사용법**

키와 값의 타입을 따로 지정해야함

```java
HashMap<String, Integer> hashmap = new HashMap<>();
```

<br>

**예시**

```java
import java.util.*;

public class HashMapExample {
    public static void main(String[] args) {

	    // HashMap 생성
        HashMap<String, Integer> map = new HashMap<>();

        // Entry 객체 저장
        map.put("피카츄", 85);
        map.put("꼬부기", 95);
        map.put("야도란", 75);
        map.put("파이리", 65);
        map.put("피존투", 15);

        // 저장된 총 Entry 수 얻기
        System.out.println("총 entry 수: " + map.size());

        // 객체 찾기
        System.out.println("파이리 : " + map.get("파이리"));
				
        // key를 요소로 가지는 Set을 생성 -> 아래에서 순회하기 위해 필요합니다. 
        Set<String> keySet = map.keySet();

        // keySet을 순회하면서 value를 읽어옵니다. 
        Iterator<String> keyIterator = keySet.iterator();
        while(keyIterator.hasNext()) {
            String key = keyIterator.next();
            Integer value = map.get(key);
            System.out.println(key + " : " + value);
        }

        // 객체 삭제
        map.remove("피존투");

        System.out.println("총 entry 수: " + map.size());

        // Entry 객체를 요소로 가지는 Set을 생성 -> 아래에서 순회하기 위해 필요합니다. 
        Set<Map.Entry<String, Integer>> entrySet = map.entrySet();

        // entrySet을 순회하면서 value를 읽어옵니다. 
        Iterator<Map.Entry<String, Integer>> entryIterator = entrySet.iterator();
        while(entryIterator.hasNext()) {
            Map.Entry<String, Integer> entry = entryIterator.next();
            String key = entry.getKey(); // Map.Entry 인터페이스의 메서드
            Integer value = entry.getValue(); // Map.Entry 인터페이스의 메서드
            System.out.println(key + " : " + value);
        }

        // 객체 전체 삭제
        map.clear();
    }
}
```

Map은 키와 값을 쌍으로 저장하기 때문에 iterator()를 직접 호출할 수 없음.

그 대신 keySet() 이나 entrySet() 메서드를 이용해 Set 형태로 반환된 컬렉션에
iterator()를 호출하여 반복자를 만든 후, 반복자를 통해 순회할 수 있음.

<br>

### **HashTable**

- HashMap과 내부구조가 동일하여 사용방법이 유사함
- HashMap의 새로운 버전이라고 보면 됨

```java
import java.util.*;

public class HashTableExample {
    public static void main(String[] args){

        HashTable<String, String> map = new Hashtable<String, String>();

        map.put("Spring", "345");
        map.put("Summer", "678");
        map.put("Fall", "91011");
        map.put("Winter", "1212");

        System.out.println(map);

        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("아이디와 비밀번호를 입력해 주세요");
            System.out.println("아이디");
            String id = scanner.nextLine();

            System.out.println("비밀번호");
            String password = scanner.nextLine();

            if (map.containsKey(id)) {
                if (map.get(id).equals(password)) {
                    System.out.println("로그인 되었습니다.");
                    break;
                } 
                else System.out.println("비밀번호가 일치하지 않습니다. ");
            } 
            else System.out.println("입력하신 아이디가 존재하지 않습니다.");
        }
    }
}
```

------

## **💡 컬렉션 정리**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java66.png) 

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/java67.png) 