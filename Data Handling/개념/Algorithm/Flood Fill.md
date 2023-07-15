## **💡 Flood Fill 알고리즘**

다차원 배열의 어떤 칸과 연결된 영약을 찾는 알고리즘이다.

바둑이나 지뢰찾기 같은 게임에서 어떤 비어 있는 칸을 표시할 지 를 결정할 때도 사용된다.

DFS와 Stack을 이용하여 구현하기도 하고, BFS와 Queue를 이용해 구현하기도 한다.

<br>

### **DFS & Stack을 이용한 Flood Fill 구현**

```java
import java.util.Scanner;
import java.util.Stack;

public class DFS_FloodFill {
    // 상하좌우를 의미하는 델타 배열 생성
    static int[][] deltaArray = {{-1,0}, {1,0}, {0,-1}, {0,1}};
    static final int max = 10;
    static int n;
    static int[][] graph = new int[max][max];

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        n = sc.nextInt();

        for (int i=0; i<n; ++i) {
            for (int j=0; j<n; ++n) {
                graph[i][j] = sc.nextInt();
            }
        }

        int sRow = sc.nextInt();
        int sCol = sc.nextInt();
        int color = sc.nextInt();

        dfs(sRow,sCol,color);

        for (int i=0; i<n; ++i) {
            for (int j=0; j<n; ++j) {
                System.out.println(graph[i][j] + " ");
            }
            System.out.println();
        }
    }

    // DFS 알고리즘
    public static void dfs(int r, int c, int color) {
        boolean[][] flag = new boolean[n][n];
        Stack<Point> stack = new Stack<>();
        stack.push(new Point(r,c));

        while (!stack.empty()) {
            Point cur = stack.pop();
            if (flag[cur.row][cur.col]) continue;

            flag[cur.row][cur.col] = true;
            graph[cur.row][cur.col] = color;

            for (int i=0; i<4; ++i) {
                int nr = cur.row + deltaArray[i][0];
                int nc = cur.col + deltaArray[i][1];

                if (flag[nr][nc]) continue;
                if (graph[nr][nc] == 1) continue;
                stack.push(new Point(nr, nc));
            }
        }
    }

    // 행 & 열 좌표 클래스
    public static class Point {
        int row;
        int col;
        Point(int r, int c) {
            row = r;
            col = c;
        }
    }
}
```