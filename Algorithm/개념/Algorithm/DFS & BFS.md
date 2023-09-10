## **💡 DFS**

Depth-First Search의 약자이며 깊이 우선 탐색을 하는 알고리즘이다.

<br>

**동작방식**

- 스택을 이용하므로 재귀를 이용했을때 간결한 구현이 가능하며 시간복잡도는 O(N)이다.
- 탐색 시작 노드에 스택일 삽입하고 방문 처리한다.
- 스택의 최상단 노드에 방문하지 않은 인접 노드가 있으면 그 인접 노드를 스택에 넣어 방문 처리하고,
  방문하지 않은 인접 노드가 없으면 스택에서 최상단 노드를 꺼낸다.
- 위의 과정을 더 이상 수행할 수 없을 때까지 반복한다.

<br>

방문처리란?

스택에 한번 삽입되어 처리된 노드가 다시 삽입되지 않게 체크하는 것을 의미한다.

이를 통해 각 노드를 한 번씩만 처리할 수 있다.

<br>

### **재귀 함수를 이용한 DFS 구현**

노드들은 호출을 받으면 하위의 노드를 재귀 호출 하기 전, 자기 자신을 출력한다

- 노드에 방문하면 데이터 출력하고 하위 노드들을 순서대로 재귀 호출
- 재귀 호출된 하위노드도 밑에 있는 하위노드들을 다시 재귀 호출
- 하위 노드의 재귀 호출은 연결관계를 어떻게 입력했는지에 따라 그 노드를 방문한다.

```java
public class DFSExamRecursion {
    //각 노드가 방문된 정보를 1차원 배열 자료형으로 표현
    public static boolean [] visited = {false, false, false ,false ,false ,false ,false ,false, false};
    // 각 노드가 연결된 정보를 2차원 배열 자료형으로 표현
    public static int[][] graph = {{},
        {2, 3, 8},
        {1, 7},
        {1, 4, 5},
        {3, 5},
        {3, 4},
        {7},
        {2, 6, 8},
        {1, 7}};

    public static void main(String[] args){
        int start = 1; // 시작 노드
        dfs(start);
    }

    /*
     * dfs 알고리즘을 수행하는 함수
     * @param v 탐색할 노드
    */
    public static void dfs(int v){
        // 현재 노드 방문 처리
        visited[v] = true;
        // 방문 노드 출력
        System.out.print(v + "");

        // 인접 노드 탐색
        for (int i : graph[v]){
            // 방문하지 않은 인접 노드 중 가장 작은 노드를 스택에 넣기
            if (visited[i]==false){
                dfs(i);
            }
        }
    }
}
```

------

### **스택을 이용한 DFS 구현**

- 스택에 시작 노드를 넣는다. (push)
- 스택에 있는 시작 노드를 꺼내서 하위 노드를 다시 스택에 넣고 꺼낸 노드는 출력한다.
- 이때, 한번 스택에 넣은 노드는 다시 넣지 않는다.
- 꺼낸 노드의 하위 노드가 없으면 그냥 출력한다.
- 즉, 스택이 전부 빌때까지 위 작업을 반복한다.

```java
public class DFS_Stack {
    public static void main(String[] args){

        // 각 노드가 연결된 정보를 2차원 배열 자료형으로 표현
        int [][]graph = {{},
                {2, 3, 8},
                {1, 7},
                {1, 4, 5},
                {3, 5},
                {3, 4},
                {7},
                {2, 6, 8},
                {1, 7}};

        // 각 노드가 방문된 정보를 1차원 배열 자료형으로 표현
        boolean [] visited = {false, false, false ,false ,false ,false ,false ,false, false};

        // 정의된 DFS 함수 호출
        DFS_Stack dfsExam = new DFS_Stack();
        dfsExam.dfs(graph, 1, visited);
    }

    /*
     * dfs 메서드
     *  @param graph 노드 연결 정보를 저장
     *  @param v 방문을 시작하는 최상단 노드의 위치
     *  @param visited 노드 방문 정보를 저장
     */
    void dfs(int [][]graph,int start, boolean [] visited){
        // 시작 노드를 방문 처리
        visited[start] = true;
        System.out.print(start + " ");// 방문 노드 출력

        Deque<Integer> stack = new LinkedList<>();
        stack.push(start); //시작 노드를 스택에 입력

        while(!stack.isEmpty()){
            int now = stack.peek();

            // 방문하지 않은 인접 노드가 있는지 확인
            boolean hasNearNode = false;

            // 인접한 노드를 방문하지 않았을 경우 스택에 넣고 방문처리
            for (int i: graph[now]){
                if (!visited[i]) {
                    hasNearNode = true;
                    stack.push(i);
                    visited[i] = true;
                    System.out.print(i + " ");//방문 노드 출력
                    break;
                }
            }
            // 방문하지 않은 인접 노드가 없는 경우 해당 노드 꺼내기
            if(hasNearNode==false)
                stack.pop();
        }
    }
}
```

------

## **💡 BFS**

Breadth-First Search의 약자이며 깊이 우선 탐색을 하는 알고리즘이다.

<br>

**동작방식**

- 큐를 이용한다. (add)
- 탐색 시작 노드에 스택일 삽입하고 방문 처리한다.
- 스택의 최상단 노드에 방문하지 않은 인접 노드가 있으면 그 인접 노드를 스택에 넣어 방문 처리하고,
  방문하지 않은 인접 노드가 없으면 스택에서 최상단 노드를 꺼낸다.
- 위의 과정을 더 이상 수행할 수 없을 때까지 반복한다.

<br>

### **큐를 이용한 BFS 구현**

- 큐에 시작 노드를 넣는다.
- 큐에 넣은 노드를 꺼내서 해당 노드의 하위 노드를 전부 큐에 넣고 꺼낸 노드는 출력한다.
- 한번 큐에 들어간 노드는 다시 넣지 않는다.
- 큐에 새로 넣은 노드를 다시 꺼내서 그 노드의 하위 노드를 큐에 넣고 꺼낸 노드는 출력한다.
- DFS와 마찬가지로 큐가 빌때까지 반복한다.

```java
public class BFS_Queue<T> {
}

class Graph {
    class Node {
        int data;
        LinkedList<Node> adjacent;
        boolean flag;

        public Node(int data, LinkedList<Node> adjacent, boolean flag) {
            this.data = data;
            adjacent = new LinkedList<Node>();
            this.flag = false;
        }
    }

    // 노드들을 저장할 배열
    Node[] nodes;

    Graph(int size) {
        // 간단현 구현을 위해 그래프의 노드 개수를 고정
        nodes = new Node[size];
        for (int i=0; i<size; i++) {
//            nodes[i] = new Node(i);
        }
    }

    // 두 노드의 관계를 저장하는 함수
    void addEdge(int i1, int i2) {
        Node n1 = nodes[i1];
        Node n2 = nodes[i2];

        // LinkedList에 서로 상대가 있는지 확인하고 없으면 추가
        if (!n1.adjacent.contains(n2)) {
            n1.adjacent.add(n2);
        }

        if (!n2.adjacent.contains(n1)) {
            n2.adjacent.add(n1);
        }
    }

    // 첫 시작은 0번으로
    void dfs() {
        dfs(0);
    }

    // 시작 인덱스를 받아서 DFS순의 결과를 출력하는 DFS람수
    void dfs(int index) {
        Node root = nodes[index];
        Stack<Node> stack = new Stack<Node>();
        stack.push(root);
        root.flag = true;

        while (!stack.isEmpty()) {
            Node r = stack.pop();

            for (Node n : r.adjacent) {
                if (n.flag == false) {
                    n.flag = true;
                    stack.push(n);
                }
            }
            visit(r);
        }
    }

    // 노드 출력 함수
//    void bfs() { bfs(0);}
//    void bfs(int index) {
//        Node root = nodes[index];
//        Queue<Node> queue = new Queue<Node>() {
//
//        }
//    }
    void visit(Node n) {
        System.out.println(n.data + " ");
    }
}

class Test {
    public static void main(String[] args) {

    }
}
```