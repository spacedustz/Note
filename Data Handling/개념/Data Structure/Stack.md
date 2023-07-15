## **💡 스택 **

- 데이터를 순서대로 쌓는 자료구조
- 먼저 들어간 데이터는 제일 나중에 나오는 LIFO 구조
- 데이터 삽입은 Push, 데이터 추출은 Pop이다.
- 데이터를 하나씩 넣고 뺄수 있다.
- 입출력 방향이 한곳이다.

---

### **구현**

- push(): 스택에 데이터를 추가할 수 있어야 합니다.
- pop(): 가장 나중에 추가된 데이터를 스택에서 삭제하고 삭제한 데이터를 리턴해야 합니다.
- size(): 스택에 추가된 데이터의 크기를 리턴해야 합니다.
- peek(): 가장 나중에 추가된 데이터를 리턴해야 합니다.
- show(): 현재 스택에 포함되어 있는 모든 데이터를 String 타입으로 변환하여 리턴합니다.
- clear(): 현재 스택에 포함되어 있는 모든 데이터 삭제합니다.
- remove(): 삭제와 삭제된 요소 반환이 동시에 됩니다.

```java
Stack<Integer> stack = new Stack<>();

stack.push(1);
stack.push(2);
stack.push(3);
stack.push(4);

stack.pop();
stack.pop();
stack.pop();
stack.pop();

// 4, 3, 2, 1 순으로 데이터가 빠져나감
```

<br>

**브라우저의 앞으로가기&뒤로가기를 생각해보자**

- 새 페이지 접속 시, 현재 페이지는 Prev Stack에 보관
- 뒤로 가기 버튼을 누르면 현재 페이지를 Next Stack에 보관하고 Prev Stack에 가장 끝에 보관된 페이지 = 현재페이지
- 앞으로 가기 버튼을 누르면 Next Stack의 가장 처음 페이지를 가져오고 현재 페이지는 다시 Prev Stack 으로 넘김

---

### **ArrayList로 스택 구현**

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

---

### **스택을 배열로 구현했을 때**

배열은 순서가 있고 첫 부분을 제거하거나 추가하려면 요소들을 하나씩 뒤로 옮겨야 하며 시간복잡도는 O(n) 임
스택과 큐의 과정이 비효율적이기 때문에 스택과 큐에서는 **기본적인 배열**을 사용하지 않음

그래서 첫 부분을 제거하거나 추가하는 과정의 시간복잡도가 상수인 연결 리스트를 스택 & 큐에 적용하는게 좋음

<br>

**배열로 스택 구현**

- addLast, removeLast -> O(1)의 시간복잡도
- addFirst, removeFirst -> 배열의 원소들은 메모리 상에서 순차적으로 저장되기 때문에 맨 앞에서 삽입/삭제 연산이 일어나면 뒤로 한칸씩 미루거나 앞으로 한칸씩 당겨야 하므로 O(n)의 시간복잡도
- Last In First Out (LIFO, 후입선출, 나중에 들어온 원소가 제일 먼저 나간다.)
- top에서만 삽입/삭제가 일어나며, 배열로 구현하면 O(1)의 시간복잡도 (addLast, addFirst)

---

## 💡 스택으로 오름차순 수열 구현

임의의 수열을 스택에 넣었다가 출력하는 방식으로 오름차순 수열을 출력할 수 있는지 확인.

출력할 수 있다면 push와 pop 연산을 어떤 순서로 수행해야 하는지 알아내는 프로그램 작성

push 연산은 +, pop 연산은 -, 불가능 할 때는 NO 출력

```java
 static int AA = 5;
 static int[] BB = {3,4,5,6,7};

    public static void main(String[] args) {
//        average(A, B);
        stack(AA, BB);
    }
    
    // Stack의 오름차순 수열 구현
    // 수열의 개수 a, 수열[] b
    public static String stack(int a, int[] b) {
        int[] A = new int[a];

        for (int i=0; i<a; i++) {
            A[i] = b[i];
        }

        Stack<Integer> stack = new Stack<>();
        StringBuffer bf = new StringBuffer();

        // 오름차순의 수
        int num = 1;
        boolean flag = true;

        for (int i=0; i<A.length; i++) {
            // 현재 수열의 수
            int su = A[i];
            System.out.println("su = " + su);
            // 현재 수열 값 >= 오름차순의 자연수
            // pop()을 수행해 수열을 꺼낸다
            if (su >= num) {
                // push
                while (su >= num) {
                    stack.push(num++);
                    bf.append("+\n");
                }
                stack.pop();
                bf.append("-\n");
                // 현재 수열값 < 오름자순의 자연수
                // pop()을수행해 수열을 꺼낸다
            } else {
                int n = stack.pop();
                // 스택의 가장 위의 수가 만들어야 하는 수열의 수보다 크면 수열 출력 불가
                if (n > su) {
                    System.out.println("NO");
                    flag = false;
                    break;

                } else {
                    bf.append("-\n");
                }
            }
        }
        if (flag) {
            System.out.println(bf.toString());
        }
        return bf.toString();
    }
```

---

## 💡 Stack을 이용한 오큰수 구현

for문으로 오큰수를 찾으면 시간복잡도가 높아 제한시간을 초과할 우려가 있으므로,

스택을 이용하여 오큰수를 구현한다.

<br>

## 입출력 예시

**입력**

int N = 수열의 크기

int[] M = 수열

<br>

**출력**

5 7 7 -1

<br>

### 풀이

스택에 새로 들어오는 수가 top에 존재하는 수보다 크면 그 수는 오큰수가 된다.

오큰수를 구한 후, 수열에서 오큰수가 존재하지 않는 숫자에 -1을 출력해야 한다.

<br>

**풀이 순서**

- 스택에 채워져 있거나 A[index] > A[top]인 경우 pop한 인덱스를 이용해 정답 수열에 오큰수 저장.
  (pop은 조건을 만족하는 동안 계속 반복)
- 현재 인덱스를 스택에 push하고 다음 인덱스로 넘어간다.
- 위의 과정을 수열의 길이만큼 반복하고 현재 스택에 남아있는 인덱스에 -1을 저장한다.

```java
    public int O(int a, int[] b, String[] c) {
        // 수열 배열 생성
        int[] A = new int[a];
        // 정답 배열 생성
        int[] B = new int[a];

        for (int i = 0; i < a; i++) {
            A[i] = Integer.parseInt(c[i]);
        }

        // 스택의 최초값을 0 으로 초기화
        Stack<Integer> stack = new Stack<>();
        stack.push(0);

        for (int i = 0; i < a; i++) {
            // 스택이 비어있지 않고 현재 수열이 스택의 top이 가리키는 수열보다 클 경우
            while (!stack.isEmpty() && A[stack.peek()] < A[i]) {
                // 정답 배열에 오큰수를 현재 수열로 저장
                B[stack.pop()] = A[i];
            }
            // 신규 데이터 push
            stack.push(i);
        }

        while (!stack.isEmpty()) {
            // 반복문을 다 돌았는데 스택이 비어 있지 않다면 빌때까지
            // 스택에 쌓인 인덱스에 -1을 넣는다
            B[stack.pop()] = -1;
        }

        int temp = 0;
        for (int i = 0; i < a; i++) {
            temp = B[i];
            System.out.println(temp + " ");
        }

        return temp;
    }
```
