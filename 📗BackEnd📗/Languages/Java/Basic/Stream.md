## **💡 Stream**

많은 수의 데이터를 다룰 때 컬렉션이나 배열에 데이터를 담고 원하는 결고를 얻기 위해 for문이나 iterator를 사용해서 코드를 작성해왔다.

그러나 이런 방식으로 작성된 코드는 너무 길고 가독성과 재사용성이 떨어진다.

또 다른 문제는 데이터 소스마다 다른 방식으로 다뤄야 한다는 단점이 있다.

<br>

예를 들면 List를 정렬할 때는 Collections.sort()를 사용하고,
배열을 정렬할 때는 Arrays.sort()를 사용해야 한다.

이러한 문제를 해결하기 위해 만든것이 Stream이다.

스트림은 데이터 소스를 추상화하고 데이터를 다루는데 자주 사용되는 메서드들을 정의 해놓았다.

<br>

**스트림의 특징**

- 데이터 소스(원본)을 변경하지 않는다.
- Iterator처럼 일회용이다.
- 작업을 내부 반복으로 처리한다.

예를 들어, 문자열 배열과 같은 내용의 문자열을 저장하는 List가 있을 때

```java
String[] strArr = { "aaa","ccc","bbb" };
List<String> strList = Arrays.asList(sttArr);
```

이 두 데이터 소스르 기반으로 스트림 생성

```java
Stream<String> stream1 = Arrays.stream(strArr);
Stream<String> stream2 = strList.stream();
```

두 스트림으로 데이터 소스의 데이터를 읽어서 정렬하고 화면에 출력, 소스 원본이 정렬되는 것은 아님

```java
    Stream<String> stream1 = Arrays.stream(strArr)
            .sorted()
            .forEach(System.out::println);

    Stream<String> stream2 = strList.stream()
            .sorted()
            .forEach(System.out::println);
```

------

## **💡 스트림의 연산**

스트림이 제공하는 다양한 연산을 이용해 복잡한 작업을 단순화 할 수 있다.

<br>

예시

```java
stream.distinct().limit(5).sorted().forEach(System.out::println)
```



**중간연산**

연산결과를 스트림으로 반환하기 때문에 중간연산을 연속해서 연결할 수 있다.

- distinct()
- limit()
- sorted()

<br>

**최종연산**

스트림의 요소를 소모하면서 연산을 수행하므로 단 한번만 연산한다.

- forEach()

<br>

### **중간 연산 목록**

중복 제거

- Stream distinct()

조건에 안맞는 요소 제외

- Stream filter(Predicate predicate)

요소의 일부를 잘라냄

- Stream limit(long maxSize)

일부를 건너뜀

- Stream skip(long n)

요소에 작업 수행

- Stream peek(Consumer action)

요소 정렬

- Stream sorted() & sorted(Comparator comparator)

요소 변환

- Stream map(Function<T,R> mapper)
- DoubleStream mapToDouble()
- IntStream mapToInt()
- LongStream mapToLong()

- Stream flatMap(Function<T,R> mapper)
- DoubleStream flatMapToDouble()
- IntStream flatMapToInt()
- LongStream flatMapToLong()

<br>

### **최종 연산 목록**

각 요소에 지정된 작업 수행

- void forEach(Consumer<? super T> action)
- void forEachOrdered<Consumer<? super T> action)

요소의 개수 반환

- long count()

최대값 & 최소값 반환

- Optional max(Comparator<? super T> comparator)
- Optional min(Comparator<? super T> comparator)

요소 하나를 반환

- Optional findAny() - 아무거나 하나
- Optional findFirst() - 첫번째 요소

주어진 조건을 모든 요소가 만족시키는지 아닌지 확인

- boolean allMatch(Predicate p) - 모두 만족 하는지
- boolean anyMatch(Predicate p) - 하나라도 만족 하는지
- boolean noneMatch(Predicate p) - 모두 만족하지 않는지

모든 요소를 배열로 반환

- Object[] toArray()
- A[] toArray(IntFunction<A[]> generator)

요소를 하나씩 줄여가면서(Reducing) 계산

- Optional reduce(BinaryOperator accumulator)
- T reduce(T identity, BinaryOperator accumulator)
- U reduce(U identity, BiFunction<U,T,U> accumulator, BinaryOperator combiner)

요소를 수집, 주로 요소의 그룹화하거나 분할한 결과를 컬렉션에 담아 반환하는데 사용

- R collect(Collector<T,A,R> collector)
- R collect(Supplier supplier, BiConsumer<R,T> accumulator, BiConsumer<R,R> combiner)

<br>

### **지연된 연산**

스트림의 연산에서 한가지 중요한 점은 최종 연산이 수행되기 전까지는 중간연산이 수행되지 않는다.

스트림에 대해 distinct()나 sort()같은 중간 연산을 호출해도 즉각적인 연산이 수행되는 것이 아니다.

최종 연산이 수행되어야 비로소 스트림의 요소들이 중간 연산을 거쳐 최종 연산에서 소모된다.

<br>

### **Stream와 IntStream**

요소의 타입이 T인 스트림은 기본적으로 Stream이지만, 오토박싱 & 언박싱으로 인한 비효율을 줄이기 위해 데이터 소스의 요소를 기본형으로 다루는 스트림, IntStream, LongStream, DoubleStream이 제공된다.

일반적으로 Stream 대신 IntStream을 사용하는 것이 더 효율적이고,
int 타입의 값으로 작업하는데 유용한 메서드들이 포함되어 있다.

------

## **💡 병렬 스트림**

스트림으로 데이터를 다룰때 장점 중 하나가 병렬 처리가 쉽다는 것이다.

내부적으로 fork & join 프레임워크를 이용해서 자동적으로 연산을 병렬로 수행한다.

우리가 할일은 그저 스트림에 parallel()이라는 메서드를 호출해 병렬로 연산을 수행하도록 지시하는 것이다.

반대로 병렬로 처리되지 않게 하려면 sequential()을 호출하면 된다.

모든 스트림은 기본적으로 병렬 스트림이 아니므로 sequential()을 호출할 필요가 없다.

이 메서드는 parallel()을 호출한 것을 취소할 때만 사용한다.

```java
// strStream()을 병렬 스트림으로 전환
int sum = strStream.parallel()
    .mapToInt(s -> s.length())
    .sum();
```

병렬처리가 항상 더 빠른 결과를 얻게 해주는 것은 아니다.

---

## **💡 스트림 생성**

스트림의 소스가 될 수 있는 대상은 배열, 컬렉션, 임의의 수 등 다양하다.

<br>

### **컬렉션**

컬렉션의 최상위 인터페이스인 Collection에 stream()이 정의되어 있다.

그래서 Collection의 하위 인터페이스인 List와 Set을 구현한 클래스들은 모두 이 메서드로 생성 가능하다.

```java
Stream<T> Collection.stream()
```

<br>

List로부터 스트림을 생성하는 코드의 예시

```java
List<Integer> list = Arrays.asList(1,2,3,4,5); // 가변인자
Stream<Integer> intStream = list.stream(); // list를 소스로 컬렉션 생성
```

<br>

forEach()는 지정된 작업을 스트림의 모든 요소에 대해 수행한다.

주의할 점은 forEach()가 모든 요소를 소모해 작업 수행 후 같은 스트림에 두번 호출 풀가능하다.

소스의 원본이 소모되는 것이 아닌 생성한 스트림의 요소를 소모한다는 것을 기억하자.

```java
intStream.forEach(System.out::println); // 스트림의 모든 요소 출력
intStream.forEach(System.out::println); // 에러, 스트림이 이미 닫혔다
```

------

### **배열**

배열을 소스로 하는 스트림을 생성하는 메서드는 Stream과 Arrays에 static 메서드로 정의되어 있다.

```java
Stream<T> Stream.of(T... values) // 가변인자
Stream<T> Stream.of(T[])
Stream<T> Arrays.stream(T[])
Stream<T> Arrays.stream(T[] array, int startInclusive, int endExclusive)
```

<br>

문자열 배열을 소스로 하는 스트림 생성

```java
Stream<String> strStream = Stream.of("a","b","c"); // 가변인자
Stream<String> strStream = Stream.of(new String[] {"a","b","c"});
Stream<String> strStream = Arrays.stream(new String[] {"a","b","c"});
Stream<String> strStream = Arrays.stream(new String[] {"a","b","c"}, 0, 3);
```

<br>

기본형 배열을 소스로 하는 스트림 생성

```java
IntStream IntStream.of(int... values) // Stream이 아닌 IntStream
IntStream IntStream.of(int[])
IntStream Arrays.stream(int[])
IntStream Arrays.stream(int[] array, int startInclusive, int endExclusive)
```

------

### **특정 범위의 정수**

IntStream과 LongStream은 지정된 범위의 연속된 정수를 스트림으로 생성해서 반환하는 range()와 rangeClosed() 메서드를 가지고 있다.

```java
IntStream IntStream.range(int begin, int end)
IntStream IntStream.rangeClosed(int begin, int end)
```

<br>

range()의 경우 경계의 끝인 end가 범위에 포함되지 않고 rangeClosed()의 경우는 포함된다.

```java
IntStream intStream = IntStream.range(1, 5); // 1,2,3,4
IntStream intStream = IntStream.rangeClosed(1, 5) // 1,2,3,4,5
```

------

### **임의의 수**

난수를 생성하는데 사용하는 Random 클래스에는 아래와 같은 인스턴스 메서드들이 포함된다.

이 메서드들은 해당 타입의 난수들로 이루어진 스트림을 반환한다.

아래 메서드들이 반환하는 스트림은 크기가 정해져있지 않은 ''무한 스트림'' 이므로 limit()을 같이 사용해 스트림의 크기를 제한 해주어야 한다.

```java
IntStream ints()
LongStream longs()
DoubleStream doubles()

IntStream intStream = new Random().ints() // 무한 스트림
intStream.limit(5).forEach(System.out::println); // 5개의 요소만 출력

// 생성할때 유한 스트림으로 만들어주면 limit()을 사용하지 않아도 된다
IntStream intStream = new Random.ints(5); // 크기가 5인 난수 스트림을 반환
```

<br>

위 메서드들에 의해 생성된 스트림의 난수는 아래의 범위를 갖는다.

```java
Integer.MIN_VALUE <= ints() <= Integer.MAX_VALUE
Long.MIN_VALUE <= longs() <= Long.MAX_VALUE
0.0 <= doubles() < 1.0
```

<br>

지정된 범위(begin~end)의 난수를 발생시키는 스트림을 얻는 메서드. 단, end는 범위에 포함 X

```java
IntStream ints(int begin, int end)
LongStream longs(long begin, long end)
DoubleStream doubles(double begin, double end)

IntStream ints(long streamSize, int begin, int end)
LongStream longs(long streamSize, long begin, long end)
DoubleStream doubles(long streamSize, double begin, double end)
```

------

## **💡 iterate() & generate()**

람다식을 파라미터로 받아 이 람다식에 의해 계산되는 값들을 요소로 무한 스트림 생성

```java
static <T> Stream<T> iterate(T seed, UnaryOperator<T> f)
static <T> Stream<T> generate(Supplier<T> s)
```

<br>

### **iterate()**

iterate()는 씨앗값(seed)로 지정된 값부터 시작해, 람다식 f에 의해 계산된 결과를 다시 seed값으로 해서 계산 반복

아래 스트림은 0부터 시작해서 값이 2씩 계속 증가하는 무한스트림이다.

```java
// 아래 스트림은 0부터 시작해서 값이 2씩 계속 증가하는 무한스트림이다.
Stream<Integer> evenStream = Stream.iterate(0, n->n+2); // 0, 2, 4, 6 ...

evenStream.limit(5).forEach(System.out::println);
System.out.println("-- even 끝 --");

// 결과값
0
2
4
6
8
-- even 끝 --
```

<br>

### **Generate()**

람다식에 의해 계산되는 값을 요소로 하는 무한스트림이지만
iterate()와 달리, 이전 결과를 이용해서 다음 요소를 계산하지 않는다.

```java
// iterate()와 달리, 이전 결과를 이용해서 다음 요소를 계산하지 않는다.
Stream<Double> randomStream = Stream.generate(Math::random);
Stream<Integer> oneStream = Stream.generate(()->1);

randomStream.limit(5).forEach(System.out::println);
System.out.println("-- random 끝 --");

oneStream.limit(5).forEach(System.out::println);
System.out.println("-- one 끝 --");

// 결과값
0.4443310896148389
0.3061832897820761
0.7940177405257327
0.8880947694789408
0.6062985277800407
-- random 끝 --
1
1
1
1
1
-- one 끝 --

Process finished with exit code 0
```

주의할 점은 generate()의 파라미터 타입은 Supplier이므로 파라미터가 없는 람다식만 허용한다.

<br>

### **공통점**

iterate()와 generate()에 의해 생성된 스트림을 아래와 같이 기본형 스트링 타입의 참조변수로 다룰 수 없다.

```java
IntStream evenStream = Stream.iterate(0, n->n+2); // 에러
DoubleStream randomStream = Stream.generate(Math::random); // 에러
```

굳이 필요하다면 아래와 같이 mapToInt()와 같은 메서드로 변환을 해야 한다.

```java
IntStream evenStream = Stream.iterate(0, n->n+2).mapToInt(Integer::valueOf);
Stream<Integer> stream = evenStream.boxed(); // IntStream -> Stream<Integer> 변환
```

------

## **💡 파일**

java.nio.file.Files는 파일을 다루는데 필요한 유용한 메서드들을 제공한다.

list()는 지정된 디렉터리에 있는 파일의 목록을 소스로 하는 스트림을 생성해서 반환한다.

<br>

**기본 형식**

Path는 하나의 파일 또는 경로를 의미한다.

```java
Stream<Path> Files.list(Path dir);
```

<br>

파일의 한 Line을 요소로 하는 스트림도 있다.

아래의 메서드는 BufferedReader 클래스에 속한 메서드로 파일 뿐 아니라,

다른 입력대상으로부터 데이터를 행 단위로 읽을 수 있다.

```java
Stream<String> lines()
```

------

## **💡 Empty Stream**

요소가 없는 빈 스트림을 생성한다.

스트림 연산 수행 결과가 하나도 없을때 null 대신 빈 스트림을 반환하게 해준다.

```java
Stream emptyStream = Stream.empty(); // 빈 스트림 생성
long count = emptyStream.count(); // count 값은 0 이다.
```

------

## **💡 concat()**

두 스트림을 연결하는 메서드이며, 연결하려는 스트림의 요소 간 타입이 일치해야 한다.

```java
String[] str1 = {"123", "456", "789"};
String[] str2 = {"ABC", "DEF", "GHI"};

Stream<String> strs1 = Stream.of(str1);
Stream<String> strs2 = Stream.of(str2);

Stream<String> reslutStream = Stream.concat(strs1, strs2); // 두 스트림 연결
```