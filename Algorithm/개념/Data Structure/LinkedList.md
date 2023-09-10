## 💡 LinkedList

포인터를 사용하여 여러 개의 노드를 연결하는 자료 구조

자료구조를 사용할때 항상 경계 조건을 생각하기

<br>

배열과의 차이점
배열도 순서대로 여러 데이터를 저장할때 사용한다는 공통점이 있지만 크기 조정이 어렵지만,
LinkedList는 항상 맞는 크기로 만들어지도록 설계되어 많은양의 데이터나 순차적 데이터를 사용할때 적합함

 <br>

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DataStructure_LinkedList_Node.png)

---

### LinkedList의 기본 구조

- 연결 리스트의 기본구조에는 노드가 있다
- 노드에는 두가지 정보가 들어있다
  - next - 다음 노드를 가리키는 포인터
  - data - 노드에 넣는 데이터를 가리키는 포인터

---

### 노드를 정의하는 법

```java
public class LinkedList<E> {

    private Node<E> head;
    private int currentSize;

    /** currentSize 변수 설명
     * 시간복잡도 효율을 높이기 위한 포인터 변수, 리스트에 요소 추가시 + 1
     * O(n) -> O(1)로 효율성 증대
     */
    public LinkedList() {
        head = null; // 노드의 시작 포인터
        currentSize = 0;
    }

    // 노드 객체. next가 static이 아닌 내부 클래스에 있지 않으면, 외부에서 next의 값을 변경할 수 있다.
    class Node<E> {
        E data; // E타입의 객체
        Node<E> next; // 다른 노드를 가리키는 포인터

        public Node(E obj) {
            data = obj;
            next = null;
        }
    }
```

---

### addFirst() - 새로운 Node를 연결리스트의 맨 앞 부분에 추가

- 새 Node 생성
- 새 Node의 next 포인터를 현재 head를 가리키도록 한다.
- head 포인터를 다시 새로운 노드의 next를 가리키도록 한다

 <br>

- **※** 리스트의 앞부분에 데이터를 추가하는 작업의 시간복잡도는 O(1)이다  
- **※** 새로운 요소를 추가하기 위해 뒷부분을 살펴볼 필요가 없기 때문
- **※** 만약 새 노드를 추가하지않고 바로 head의 포인터 방향을 바꾸면 가비지 컬렉션 발생

```java
    /* ----------------- Add First ----------------- */
    // 새로운 요소를 리스트의 맨 앞에 위치시킬때
    public void addFirst1(E obj){
        Node<E> node = new Node<E>(obj); // 1
        node.next = head; // 2
        head = node; // 3
        currentSize++;
    }

    // 비어있는 리스트에 첫 요소를 추가할때
    public void addFirst2(E obj){
        Node<E> node = new Node<E>(obj); // 1
        node.next = null; // 2
        head = node; // 3
        currentSize++;
    }
```

---

### addLast() - 새로운 Node를 연결리스트의 맨 뒷 부분에 추가

- **연결리스트의 마지막**을 가리키는 **임시포인터** 사용
- 리스트의 요소를 확인하려면 무조건 head에서 시작해야 하는데, 그럼 next를 너무 많이 사용하기 때문이다.
- 임시 노드를 만들어서 head를 가리키게 하고 next가 null일 때까지 반복을 돌며 null일때 새 노드의 next를 가리키면 됨

 <br>

- currentSize 대신 tail 포인터를 사용하는 이유
- 가장 큰 currentSize를 찾기위한 비교 과정을 거쳐야하고 그럴때 시간복잡도는 O(n)으로 효율이 좋지 않다
- tail 포인터가 추가됐을때 복잡도는 증가하지만 효율성은 좋아진다 O(n) -> O(1)

```java
    /* ----------------- Add Last ----------------- */
    // tail 변수가 없을때 시간복잡도는 O(N)
    public void addLast1(E obj){
        // 임시 포인터 tmp와 마지막에 추가할 요소인 node 생성
        Node<E> tmp = head;
        Node<E> node = new Node<E>(obj);

        // head가 null일 때 (리스트가 비어있을때) head를 새로만든 node를 가리키게한다
        if (head == null) {
            head = node;
            currentSize++;
            return;
        }

        /** 리스트가 비어있지 않을 때
         *  계속 .next를 타다가 next가 null일 경우 (리스트의 끝에 도달했을 경우)
         *  while문을 빠져나와서 tmp.next에 새로만든 node를 가리키게 한다
         */
        while(tmp.next != null) {
            tmp = tmp.next;
        }
        tmp.next=node;
        currentSize++;
    }

    // ---------------------------------------------------------------
    
    /** tail 포인터가 추가됐을때 시간복잡도는 O(1)
     *  tail 포인터를 사용하는 이유
     *  리스트의 맨 마지막을 가리키는 임시 포인터를 두어 사용하면 시간복잡도를 O(1)로 줄일 수 있다
     */
    public void addLast2(E obj) {
        // 마지막에 추가할 요소인 node 생성
        Node<E> node = new Node<E>(obj);

        /** head가 null일 때 (리스트가 비어있을때)
         *  head와 tail이 node를 가리키게 한다
         *  head를 바꿀때 tail도 같이 바꿔주지 않으면 NullPointerException 발생
         */
        if (head == null) {
            head = tail = node;
            currentSize++;
            return;
        }

        tail.next = node;
        tail = node;
        currentSize++;
        return;
    }
```

---

### removeFirst() - 연결리스트의 첫 node를 제거

- 첫번쨰 노드를 가리키는 포인터를 없애고 노드의 data 객체를 반환해야함
- tail 포인터의 단점은?
  - 리스트에 single element가 있는 경우, head와 tail 둘다 그 요소를 가르키고 있다. 이런경우 head와 tail 둘다 null을 가르키도록 바꿔야하고 그렇게 해야지 garbage collection이 일어나면서 요소가 없어진다

```java
    /* ----------------- Remove First ----------------- */
    public E removeFirst() {

        if (head == null) {
            return null;
        }

        // 삭제할 첫번째 요소의 데이터
        E tmp = head.data;

        // head와 tail이 같을때 (요소가 1개일때) head 와 tail을 둘 다 바꿔줌
        if (head == tail) {
            head = tail = null;
        } else {
            head = head.next; // head가 2번쨰 노드를 가리키게 함
        }
        currentSize--;

        return tmp;
    }
```

---

### removeLast() - 연결리스트의 마지막 node를 제거

- 마지막 노드를 마지막에서 2번쨰 노드로 옮겨 마지막 노드 제거
- 단일 연결 리스트이기 떄문에 head부터 시작해야하지만,
- 임시포인터 current, previous를 활용하여 마지막에서 2번쨰 노드를 찾을 수 있다.
- current는

```java
    /* ----------------- Remove Last ----------------- */
    public E removeLast() {
        // 비어있을때
        if (head == null) {
            return null;
        }

        // 하나의 요소만 있을때
        if (head == tail) {
            return removeFirst();
        }

        // 그 외, 임시포인터 current, privious를 활용하여 마지막 노드 제거
        Node<E> current = head;
        Node<E> previous = null;

        // 리스트의 끝에 도착 할때까지 요소들을 하나씩 살펴보기
        while (current != tail) {
            previous = current; // 순서 중요 previous가 먼저 head를 가리켜야함
            current = current.next;
        }

        // 리스트의 끝에 도달 했을 시
        previous.next = null;
        tail = previous;
        currentSize--;
        return current.data;
    }
```

---

### find(), remove() - 임의의 위치의 노드 제거와 노드 검색

- Comparable 인터페이스를 이용해 제거하고 싶은 요소의 위치 찾기
- 바로 앞 노드의 next를 다음노드를 가리키게 만들어 가운데 노드 제거
  previous, current 2개를 이용하여 각각 바로 앞 노드와 제거하고자 하는 노드를 가리키게 함

```java
    /* ----------------- Remove ----------------- */
    public E remove(E obj) {

        Node<E> current = head, previous = null;

        // current가 마지막 요소 까지 갈동안 필터링
        // current가 아닌 current.next를 while 조건 안에 두면 마지막 요소는 확인을 못한다
        while (current != null) {

            // current.data가 지우고자 하는 데이터와 같으면 (compareTo == 0)
            if (((Comparable<E>) obj).compareTo(current.data) == 0) {

                // 첫 요소 & 마지막 요소인지 필터링
                if (current == head) {
                    return removeFirst();
                }
                if (current == tail) {
                    return removeLast();
                }

                // 지우고자 하는 요소를 찾았을때 지울 노드의 data 리턴
                // previous에서 current를 가리키던 포인트를 삭제 해야 하므로 그 다음으로 건너뛰어서 가리킴
                currentSize--;
                previous.next = current.next;
                return current.data;
            }
            // 찾고자 하는 요소가 아닐 때 current가 끝까지 도달할때 까지 다시 이동
            previous = current;
            current = current.next;
        }

        return null;
    }

    /* ----------------- Find ----------------- */
    public boolean contains(E obj) {
        Node<E> current = null;

        while (current != null) {
            if (((Comparable<E>) obj).compareTo(current.data) == 0) {
                return true;
            }
            current = current.next;
        }
        return false;
    }
```

---

### peek() - 단순히 찾고자 하는 요소의 데이터 리턴

```java
    /* ----------------- Peek ----------------- */
    public E peekFirst() {
        if (head == null) {
            return null;
        }
        return head.data;
    }

    public E peekLastt() {
        if (tail == null) {
            return null;
        }
        return tail.data;
    }
```

---

## 연결리스트 테스트

- LinkedList 클래스를 테스트하는 클래스를 생성하여 메서드들을 테스트

```java
public class LinkedListTest {
    public static void main(String[] args) {

        LinkedList<Integer> list = new LinkedList<Integer>();
        int n = 10;

        // 연결 리스트 생성
        for (int i=0; i<n; i++) {
            list.addFirst1(i);
            System.out.println(i);
        }

//        // 연결 리스트 생성
//        for (int i=0; i<n; i++) {
//            list.addLast1(i);
//        }

        // 연결 리스트 삭제
        for (int i=n-1; i>=0; i++) {
            int x = list.removeFirst();
            System.out.println(x);
        }

//        // 연결 리스트 삭제
//        for (int i=0; i<n; i++) {
//            int x = list.removeLast();
//        }

    }
}
```