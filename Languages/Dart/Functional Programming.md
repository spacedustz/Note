**Java & Kotlin과 동일한 내용은 안쓰고 새로운 내용만 작성**

---

## Type Conversion

- List -> Map = asMap()을 사용한다. 반환값은 int : Value의 형태로 출력된다.
- List -> Set는 toSet(), Set.from() 둘 다 가능하다.
- Map -> List, Set -> List도 toList()로 가능

```dart
void main() {
    List<String> group = ['사람', '사람2', '사람3'];
    print(group);
    
    // Type Conversion to Map -> 반환값 : { 0: 사람, 1: 사람2, 2: 사람2 }
    print(group.asMap());
    
    // Type Conversion to Set -> 반환값 : { 사람, 사람2, 사람3 }
    print(group.toSet());
    
    // ------- Map --------
    Map maps = group.asMap();
    print(maps.keys.toList());
    print(maps.values.toList());
    
    // ------- Set --------
    Set sets = Set.from(group);
    print(sets.toList());
}
```

---

## Mapping

- map도 다른 프로그래밍 언어와 비슷하게 원본 리스트의 변경이 아닌 **Iterator를 반환한다**.
- 반환받은 Iterator를 `toList()`를 써서 리스트로 변환만 해주면 된다.
- Arrow Function을 이용하면 더 간결하게 가능하며 자바의 람다와 비슷하다.

```dart
void main() {
    List<String> list = ['a', 'b', 'c'];
    
    final newList = list.map((x) {
        return '소문자 $x';
    });
    
    print(list);
    print(newList.toList());
    
    final newList2 = list.map((x) => '소문자 $x');
}
```

다른 예시로 String 값으로 13579를 받고 1.jpg, 3.jpg 형태로 반환받고 싶을때의 예시.

```dart
String number = '13579';
final parsed = number.split('').map((x) => '$x.jpg').toList();
print(parsed);
```

<br>

이번엔 Map을 Mapping 하는 예시이다.

- Map은 키 & 값 모두를 매핑해줘야 하므로 key, value를 함수 내 파라미터로 받는다.
- Set도 마찬가지로 하면 된다.

```dart
void main() {
    Map<String, String> book = {
        '해리포터' : 'Harry Potter',
        '책' : 'Book'
    };
    
    final result = book.map((key, value) => MapEntry('키 - $key', '값 - $value'));
    
    print(result);
    // 결과값 : 키 - 해리포터 : 값 - Harry Potter, 키 - 책 : 값 - Book
}
```

---

## Where

- where 함수는 조건을 필터링하는 함수이며 Boolean 값을 반환한다.
- Java, Kotlin의 filter와 비슷한 기능을 한다.
- 새 반환 리스트에서 조건에 부합하지 않을 경우(False일 경우)요소를 삭제한다. 
  **(원본 요소를 삭제한다는게 아니라 새로운 반환 값에서 삭제)**

```dart
void main() {
    List<Map<String, String>> people = [
        {
            'name': '이름',
            'group': '그룹'
        },
        {
            'name': '이름2',
            'group': '그룹2'
        },
        {
            'name': '이름3',
            'group': '그룹3'
        }
    ];
    
    people.where((x) => x['group'] == '그룹').toList();
}
```

---

## Reduce

- 원본 컬렉션의 포인터를 파라미터로 받아 매핑을 수행하는 함수이다.
- reduce를 수행할 매개의 타입과 동일한 타입을 반환해야 한다.

리스트의 숫자를 다 더하고 반환하는 예시

```dart
void main() {
    List<int> numbers = [1, 3, 5, 7, 9];
    
    final result = numbers.reduce((prev, next){
        print('---');
        print('prev : $prev');
        print('next : $next');
        print('total : ${prev + next}');
        
        return prev + next;
    });
    
    // 1줄로 변경
    final result = numbers.reduce((prev, next) => prev + next);
}
```

---

## Fold

- 위의 reduce는 타입을 무조건 동일하게 반환해야 했다.
- **Fold는 reduce의 단점인 타입을 자유롭게 반환할 수 있게 사용시 Generic을 이용한다.**
- 2개의 파라미터를 받으며, 첫번째 파라미터는 시작값, 두번째 파라미터는

```dart
void main() {
    List<int> numbers = [1, 3, 5, 7, 9];
    
    final sum = numbers.fold<int>(0, (prev, next) => prev + next);
    
    print(sum);
}
```

---

## Cascading Operator

- 여러개의 리스트를 하나로 합칠 때 사용한다.
- `...`을 사용해 리스트들의 요소를 펼친다.
- Cascading Operator로 생성된 리스트도 새로운 리스트를 반환한다.

```dart
void main() {
    List<int> even = [2, 4, 6 ,8];
    List<int> odd = [1, 3, 5, 7];
    
    // Cascading Operator
     print([...even, ...odd]);
    
    // 결과값 : [2, 4, 6, 8, 1, 3, 5, 7]
}
```

- 실무 사용 예시
- Json 데이터를 받아서 Person Class로 구조화를 하는 예시이다.
- **Mapping 시 `!`를 붙여주는 이유는 맵의 Key & Value가 어떤값인지 확실히 알 수 없기 때문에, Non-Nullable을 선언해줘야 한다.**
- Person Class에 toString()을 구현하지 않는다면 Instance of Person 으로만 값이 나올것이다.

```dart
void main() {
        List<Map<String, String>> people = [
        {
            'name': '이름',
            'group': '그룹'
        },
        {
            'name': '이름2',
            'group': '그룹2'
        },
        {
            'name': '이름3',
            'group': '그룹3'
        }
    ];
    
    // Cascading Operator
    final result = people
        .map((x) => Person(
            name: x['name']!,
            group: x['group']!
        )
    )
        .where((x) => x.group == '그룹')
        .fold<Int>(0, (prev, next) => prev + next.name.length);
    
    print(result);
}

class Persoon {
    final String name;
    final String group;
    
    Person({required this.name, required this.group});
    
    @override
    String toString() {
        return 'Person(name:$name, group:$group)';
    }
}
```

