## **💡 ArrayList로 스택 구현**

```java
public class Implementation_Stack {
    private ArrayList<Integer> listStack = new ArrayList<Integer>();

    public void push(Integer data) {
        listStack.add(data);
    }

    public Integer pop() {
        if (listStack.size() == 0) {
            return null;
        } else {
            return listStack.remove(listStack.size()-1);
        }
    }

    public int size() {
        return listStack.size();
    }

    public Integer peek() {
        if (listStack.size() == 0) {
            return null;
        } else {
            return listStack.get(listStack.size()-1);
        }
    }

    public String show() {
        return listStack.toString();
    }

    public void clear() {
        listStack.clear();
    }
}
```

------

### **스택을 배열로 구현**

배열은 순서가 있고 첫 부분을 제거하거나 추가하려면 요소들을 하나씩 뒤로 옮겨야 하며 시간복잡도는 O(n) 임
스택과 큐의 과정이 비효율적이기 때문에 스택과 큐에서는 **기본적인 배열**을 사용하지 않음

그래서 첫 부분을 제거하거나 추가하는 과정의 시간복잡도가 상수인 연결 리스트를 스택 & 큐에 적용하는게 좋음

<br>

### **배열로 스택 구현**

- addLast, removeLast -> O(1)의 시간복잡도
- addFirst, removeFirst -> 배열의 원소들은 메모리 상에서 순차적으로 저장되기 때문에 맨 앞에서 삽입/삭제 연산이 일어나면 뒤로 한칸씩 미루거나 앞으로 한칸씩 당겨야 하므로 O(n)의 시간복잡도
- Last In First Out (LIFO, 후입선출, 나중에 들어온 원소가 제일 먼저 나간다.)
- top에서만 삽입/삭제가 일어나며, 배열로 구현하면 O(1)의 시간복잡도 (addLast, addFirst)

---

## **💡 Queue - ArrayList로 구현**

```java
public class Implementation_Queue {
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
}
```

------

### **배열로 큐 구현**

- addLast, removeLast -> O(1)의 시간복잡도
- addFirst, removeFirst -> O(n)의 시간복잡도
- First In First Out (FIFO, 선입선출, 먼저 들어온 원소가 먼저 나간다.)
- 삽입은 rear에서 삭제는 front에서 일어나므로 삽입은 O(1), 삭제는 O(n)의 시간복잡도
- front에서 배열 원소를 삭제할 때도 상수 시간을 보장하려면? 원형 배열
  (head와 tail의 위치가 고정적이지 않고, 배열의 시작과 끝이 연결되어 있는 구조)



### **스택 & 큐 를 배열로 구현했을 때**

배열은 순서가 있고 첫 부분을 제거하거나 추가하려면 요소들을 하나씩 뒤로 옮겨야 하며 시간복잡도는 O(n) 임
스택과 큐의 과정이 비효율적이기 때문에 스택과 큐에서는 **기본적인 배열**을 사용하지 않음

그래서 첫 부분을 제거하거나 추가하는 과정의 시간복잡도가 상수인 연결 리스트를 스택 & 큐에 적용하는게 좋음