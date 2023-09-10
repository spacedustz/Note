## 💡 Array와 LinkedList의 차이

##### Array

- 메모리상에 순서대로 데이터를 저장
- 데이터를 인덱스로 조회할 수 있기 떄문에 조회 성능이 높고
  데이터가 메모리에 순서대로 저장되기 떄문에 캐시의 지역성으로 인하여
  비교적 빠르게 탐색 가능

##### LinkedList

- 다음 데이터에 위치에 대한 포인터를 가지고 있다
   (head, tail, previous)
- 중간에 데이터를 삽입하거나 삭제 시 용이하다
- previous 포인터는 이중 연결 리스트에 존재한다
- 이중연결 리스트, 원형연결 리스트 등이 있다

---

## 💡 List와 Set의 차이점

##### List

- 중복된 데이터를 저장하고 순서를 유지하는 선형 자료구조

##### Set

- 중복되지 않은 데이터를 저장하며, 순서를 유지하지 않는 선형 자료구조
  (Set은 집합이며, TreeSet과 같이 순서를 유지하는 Set도 존재함)

---

## 💡 Stack & Queue

##### Stack

- 선형 자료구조의 일종으로 마지막에 저장한 데이터를 가장 먼저 꺼내는 LIFO 방식
- 사용 예시로는 웹브라우저의 방문기록(뒤로가기), 실행취소(Undo) 등이 있다

##### Queue

- 선형 자료구조의 일종으로 처음에 저장한 데이터를 가정 먼저 꺼내게 되는 FIFO 방식
- 사용 예시로는 프린터의 인쇄대기, 콜센터 고객 대기 시간 등이 있다

---

## 💡 BST의 최악의 경우와 시간복잡도

- BST가 아닌 Self-Balanced Tree를 사용하는 이유에 대해서 생각해보면 쉽다
- ex)
  - 1부터 10까지 순차적으로 BST에 저장했다면, BST의 형태는 리스트와 같아짐
  - 이 경우를 최악의 경우라고 하며 시간복잡도는 O(n)이 됨

---

## 💡 Fibonazzi 수열을 코드로 구현하는 방법

> **질문의 의도**
>
> * 코드로 구현할수 있는지?
> * 재귀를 사용했다면 어떤 문제가 있는지?
> * DP를 사용할 수 있는지?

- 보통 재귀정도로 구현할 수 있지만, 중복된 연산이 계속 발생하게 됨
- 이런 중복된 연산을 메모리 등에 저장해두고 해당 결과가 존재하지 않을때만 연산을 수행하도록 하면 보다 빠른 동작을 구현할 수 있게 됨

---

## 💡 DFS & BFS

- DFS (Depth-First Search) 깊이 우선탐색
  - 최대한 깊이 내려간 뒤, 더이상 내려갈 곳이 없으면 옆으로 이동
- BFS (Breadth-First Searcr) 너비 우선 탐색
  - 최대한 넓게 이동한 뒤, 더이상 갈수 없으면 밑으로 이동



### DFS

루트 노드(혹은 다른 임의 노드)에서 시작해 다음 분기(Branch)로 넘어가기 전에
해당 분기를 완벽하게 탐색하는 방식



- 모든 노드를 방문하고자 하는 경우 이 방법을 선택한다.
- 깊이 우선 탐색(DFS)이 너비 우선 탐색(BFS)보다 더 간단하다.
- 검색 속도 자체는 BFS에 비해서 느리다.



### BFS

루트 노드(혹은 다른 임의 노드)에서 시작해 인접한 노드를 먼저 탐색하는 방식



- 주로 두 노드 사이의 최단 경로를 찾고 싶을 때 이 방법을 선택한다.
- 시작으로부터 가까운 정점을 먼저 방문하고 멀리 떨어져 있는 정점을 나중에 방문하는 순회 방식

---

## 시간복잡도

두 방식 모두 조건 내의 모든 노드를 검색한다는 점에서 시간복잡도는 동일하다.

DFS와 BFS 둘 다 다음 노드가 방문했는지를 확인하는 시간과 각 노드를 방문하는 시간을 합하면 된다.



N은 노드 / E는 간선일 때

```
인접 리스트 : O(N+E)
인접 행렬 : O(N²)
```

일반적으로 E(간선)의 크기가 N²에 비해 상대적으로 적기 때문에 인접 리스트 방식이 효율적이다.

---

## DFS와 BFS를 활용한 유형 / 응용



#### 그래프의 모든 정점을 방문하는 것이 중요한 문제

단순히 모든 정점을 방문하는것이 중요한 경우 DFS, BFS 둘 중 어느것을 사용해도 무방하다.



#### 경로의 특징을 저장해둬야 하는 문제

예를 들면 각 정점에 숫자가 적혀있고 a -> b 까지 가는 경로를 구하는데
경로에 같은 숫자가 있으면 안되는 등 각각의 경로마다 특징을 저장해줘야 할 때 DFS를 사용한다.
(BFS는 경로의 특징을 가지지 못함)



#### 최단거리를 구해야 하는 문제

미로 찾기 등 최단거리를 구해야 할 경우, BFS가 유리하다.

왜냐하면 너비우선 탐색으로 현재 노드에서 가까운 곳부터 찾기 때문에
경로 탐색 시 먼저 찾아지는 해답이 곧 최단거리이기 때문이다.



#### 검색 대상 그래프의 규모가 큰 문제

DFS 고려



#### 검색 대상의 규모가 작고, 시작 지점으로부터 목표 대상이 멀지 않은 문제

BFS 고려



---

## DFS와 BFS를 사용한 Java 코드



DFS 알고리즘의 경우 두 가지 방법으로 풀 수 있다.

- Stack을 이용하는 것
- Recursive를 이용하는 것 (보편적이고 짧은 코드로 작성 가능)



```java
/* 인접 리스트 이용 */
class Graph {
    
  private int V;
  private LinkedList<Integer> adj[];
 
  Graph(int v) {
      V = v;
      adj = new LinkedList[v];
      // 인접 리스트 초기화
      for (int i=0; i<v; ++i)
          adj[i] = new LinkedList();
  }
  void addEdge(int v, int w) { 
      adj[v].add(w); 
  }
   
  /* DFS */
  void DFS(int v) {
      boolean visited[] = new boolean[V];
 
      // v를 시작 노드로 DFSUtil 재귀 호출
      DFSUtil(v, visited);
  }
  
  /* DFS에 의해 사용되는 함수 */
  void DFSUtil(int v, boolean visited[]) {
      // 현재 노드를 방문한 것으로 표시하고 값을 출력
      visited[v] = true;
      System.out.print(v + " ");
 
      // 방문한 노드와 인접한 모든 노드를 가져온다.
      Iterator<Integer> it = adj[v].listIterator();
      while (it.hasNext()) {
          int n = it.next();
          // 방문하지 않은 노드면 해당 노드를 시작 노드로 다시 DFSUtil 호출
          if (!visited[n])
              DFSUtil(n, visited);
      }
   }
}
```



### BFS 알고리즘은 Queue를 사용해서 문제를 해결한다.

```java
class Graph {
    
  private int V;
  private LinkedList<Integer> adj[];
 
  Graph(int v) {
    V = v;
    adj = new LinkedList[v];
    for (int i=0; i<v; ++i)
      adj[i] = new LinkedList();
  }
 
  void addEdge(int v, int w) { adj[v].add(w); }
 
  /* BFS */
  void BFS(int s) {
    boolean visited[] = new boolean[V]; //방문여부 확인용 변수
    LinkedList<Integer> queue = new LinkedList<Integer>(); //연결리스트 생성
 
    visited[s] = true;
    queue.add(s);
 
    while (queue.size() != 0) {
      // 방문한 노드를 큐에서 추출(dequeue)하고 값을 출력
      s = queue.poll();
      System.out.print(s + " ");
 
      // 방문한 노드와 인접한 모든 노드를 가져온다.
      Iterator<Integer> i = adj[s].listIterator();
      while (i.hasNext()) {
        int n = i.next();
        
        // 방문하지 않은 노드면 방문한 것으로 표시하고 큐에 삽입(enqueue)
        if (!visited[n]) {
          visited[n] = true;
          queue.add(n);
        }
      }
    }
  }
}
```

