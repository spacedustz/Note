## **💡 Iterator**  

**자바의 컬렉션 프레임워크에서 컬렉션의 요소들을 읽어오는 방법을 표준화 하였는데 그 중 하나가 Iterator 이다.**

Iterator와 Iterable은 Collection의 상위 인터페이스이다.
상향된 for문을 쓰기위한 인터페이스 구현

<br>

**Iterator의 구현 메서드**

- boolean hasNext() -> 다음 요소가 있다면 true 반환
- E next() -> 포인터
- void remove()
- void forEachRemaning(Consumer actions)

<br>

**Iterable의 구현 메서드**

- Iterator<E> iterator()
- void forEach(Consumer actions)
- Spliterator spliterator()

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DataStructure_Iterator.png)  

<br>

### **Iterator 인터페이스**

- hasNext()
  - 임시포인터를 만들어 포인터가 null을 가리키는지 여부만 확인하는 로직만 쓰면 됨
- next()
  - hasNext()가 true이면 현재 포인터가 가리키는 데이터를 반환하고 다음 요소로 포인터를 옮긴다
- remove()
  - 원래는 UnsupportedOperationException을 던지면 됬었지만
  - 자바 1.8 이후로 이 메서드를 쓸 필요가 없음
- forEachRemaining()
  - 마찬가지로 자바 1.8 이후로 쓸 필요가 없다

<br>

### **Iterable 인터페이스**

- iterator() 메서드를 상속한 하위 클래스에서 생성을 강제하는 역할
- iterator의 hasNext(), next() 등을 활용할 수 있다
- 이 인터페이스를 구현한 객체를 for-each loop를 사용할 수 있게 된다

------

## **구현**

- 전 포스팅에서 구현한 LinkedList 클래스의 내부 클래스로 넣어줌
- 이 클래스를 구현함으로써 상향된 for문을 쓸 수가 있다

```java
    /* ----------------- Iterator ----------------- */
    class IteratorHelper implements Iterator {

        Node<E> index;

        public IteratorHelper() {
            index = head;
        }

        // index가 null 이면 반환할게 없다 (비어있거나, 요소의 끝에 왔을때)
        @Override
        public boolean hasNext() {
            return (index != null);
        }

        /**
         * hasNext가 false면 Exception을 던지고
         * 요소가 있으면 임의의 변수인 val에 현재 포인터가 가리키는 데이터를 반환하고
         * 포인터를 다음 요소로 옮긴다
         */
        @Override
        public Object next() {
            if (!hasNext()) {
                throw new NoSuchElementException();
            }

            E val = index.data;
            index = index.next;
            return val;
        }
    }
```