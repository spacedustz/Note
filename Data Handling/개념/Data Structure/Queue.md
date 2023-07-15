## 💡 큐

- 데이터를 순서대로 쌓는 자료구조
- 먼저 들어간 데이터는 제일 처음에 나오는 FIFO 구조
- 데이터 삽입은 Add, 데이터 추출은 Poll이다.
- 데이터를 하나씩 넣고 뺄수 있다.
- 입출력 방향이 두 곳이며 방향이 다르다.

<br>

### 우선순위 큐 (Priority Queue)

들어간 순서와 상관엇이 우선순위가 높은 데이터가 먼저 나오는 자료구조이다.

큐 설정에 따라 front에 항상 최대값 or 최소값이 위치한다.

일반적으로 Heap을 이용해 구현하는데 Heap은 트리 종류 중 하나이다.

<br>

### **구현**

- add(): 큐에 데이터를 추가할 수 있어야 합니다.
- poll(): 가장 먼저 추가된 데이터를 큐에서 삭제하고 삭제한 데이터를 리턴해야 합니다.
- size(): 큐에 추가된 데이터의 크기를 리턴해야 합니다.
- peek(): 큐에 가장 먼저 추가된 데이터를 리턴해야 합니다.
- show(): 큐에 들어있는 모든 데이터를 String 타입으로 변환하여 리턴합니다.
- clear(): 큐에 들어있는 모든 데이터를 삭제합니다.

```java
Queue<Integer> queue = new LinkedList<>();

queue.add(1);
queue.add(2);
queue.add(3);
queue.add(4);

queue.poll();
queue.poll();
queue.poll();
queue.poll();

// 1, 2, 3, 4 순으로 데이터가 빠져나감
```

<br>

**프린터를 예시로 들어보자**

컴퓨터 장치들 사이에서 데이터를 주고받을 때, 각 장치 사이에 존재하는 속도차이나 시간차이를
극복하기 위해 임시 기억 장치의 자료구조로 Queue를 사용한다.

이것을 통틀어 Buffer라고 한다.

대부분의 컴퓨터 장치에서 발생하는 이벤트는 파동 그래프와 같이 불규칙적으로 발생한. 

이에 비해 CPU와 같이 발생한 이벤트를 처리하는 장치는 일정한 처리 속도를 갖는다. 

불규칙적으로 발생한 이벤트를 규칙적으로 처리하기 위해 버퍼(buffer)를 사용한다.

- 일반적으로 프린터는 속도가 느리다.
- CPU는 프린터와 비교하여, 데이터를 처리하는 속도가 빠르다.
- 따라서, CPU는 **빠른 속도로 인쇄에 필요한 데이터(data)를 만든 다음, **
  **인쇄 작업 Queue에 저장하고 다른 작업을 수행**한다.
- **프린터는 인쇄 작업 Queue에서 데이터(data)를 받아 일정한 속도로 인쇄**한다.

---

### ArrayList를 Queue로 구현

```java
    private ArrayList<Integer> listQueue = new ArrayList<>();

    public void add(Integer data) {
        listQueue.add(data);
    }

    public Integer poll() {
        if (listQueue.size() == 0) {
            return null;
        } else {
            return listQueue.remove(0);
        }
    }

    public int size() {
        return listQueue.size();
    }

    public Integer peek() {
        if (listQueue.size() == 0) {
            return null;
        } else {
            return listQueue.get(0);
        }
    }

    public String show() {
        return listQueue.toString();
    }

    public void clear() {
        listQueue.clear();
    }
```

---

**스택 & 큐 를 배열로 구현했을 때**

배열은 순서가 있고 첫 부분을 제거하거나 추가하려면 요소들을 하나씩 뒤로 옮겨야 하며 시간복잡도는 O(n) 임
스택과 큐의 과정이 비효율적이기 때문에 스택과 큐에서는 **기본적인 배열**을 사용하지 않음

그래서 첫 부분을 제거하거나 추가하는 과정의 시간복잡도가 상수인 연결 리스트를 스택 & 큐에 적용하는게 좋음

<br>

### **배열로 큐 구현**

- addLast, removeLast -> O(1)의 시간복잡도
- addFirst, removeFirst -> O(n)의 시간복잡도
- First In First Out (FIFO, 선입선출, 먼저 들어온 원소가 먼저 나간다.)
- 삽입은 rear에서 삭제는 front에서 일어나므로 삽입은 O(1), 삭제는 O(n)의 시간복잡도
- front에서 배열 원소를 삭제할 때도 상수 시간을 보장하려면? 원형 배열
  (head와 tail의 위치가 고정적이지 않고, 배열의 시작과 끝이 연결되어 있는 구조)