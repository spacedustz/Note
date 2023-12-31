## **💡 삽입 정렬 (Insertion Sort)**

이미 정렬된 데이터 범위에 정렬되지 않은 데이터를 적절한 위치에 삽입시켜 정렬하는 방식이다.

평균 시간 복잡도는 O(n2)로 비효율적이지만 구현이 쉽다.

<br>

### **과정**

1. 현재 index에 있는 데이터 값을 선택한다.
2. 현재 선택한 데이터가 정렬된 데이터 범위에 삽입될 위치를 탐색한다.
3. 삽입 위치부터 index에 있는 위치까지 shift 연산을 수행한다.
4. 삽입 위치에 현재 선택한 데이터를 삽입하고 index++ 연산을 수행한다.
5. 전체 데이터의 크기만큼 index가 커질때까지, 즉 선택할 데이터가 없을 때까지 반복한다.

적절한 삽입 위치를 탐색하는 부분에서 이진 탐색등과 같은 탐색 알고리즘을 사용하면 시간복잡도를 줄일 수 있다.

<br>

### **구현**

ATM의 인출 시간을 계산한다.

ATM은 1대 있으며 ATM 앞에 N명의 사람들이 줄을 서 있다.

사람은 1번에서 N번까지 번호가 매겨져 있고, i번 사람이 돈을 인출하는데 걸리는 시간은 P분이다.

사람들이 줄을 서는 순서에 따라서 돈을 인출하는데 필요한 시간의 합이 달라진다.

예를 들어, 총 5명이 있고 P1=3, P2=1, P3=4, P4=3, P5=2일 때를 생각해보자.

<br>

[1,2,3,4,5] 순서로 줄을 선다면

1번 사람은 3분만에 돈을 뽑을 수 있다.

2번 사람은 1번 사람이 돈을 뽑을 때까지 기다려야 하므로 3+1=4 분이 걸린다.

3번 사람은 3+1+4=8분, 4번 사람은 4+1+4+3=11분이 걸린다.

즉, 각 사람이 돈을 인출하는데 필요한 시간의 합은 3+4+8+11+13 = 39분이다.

<br>

[2,5,1,4,3] 순서로 줄을 선다면,

2번은 1분, 5번은 1+2=3분, 1번은 1+2+3=6분, 4번은 1+2+3+3=9분, 3번은 1+2+3+3+4=13분이 걸린다.

즉 각 사람이 돈을 인출하는데 필요한 시간의 합은 1+3+6+9+13=32분이다.

모든 사람이 돈을 인출하는데 이 순서보다 시간이 짧을 순 없다.

줄을 서 있는 사람의 수 N, 각 사람이 인출하는데 걸리는 시간 P가 주어졌을 때,

각 사람이 돈을 인출하는데 필요한 시간의 최소값을 구하는 프로그램을 구현한다.

```java
public class InsertionSort {

    static int testA = 5;
    static int[] testB = {3, 1, 4, 3, 2};

    public static void main(String[] args) {
        insertionSort(testA, testB);
    }

    public static int insertionSort(int a, int[] b) {
        // 자릿수별로 구분해 저장한 배열
        int[] A = new int[a];
        // A의 합 배열, 각 사람이 인출을 완료하는데 필요한 시간을 저장할 배열
        int[] B = new int[a];

        for (int i=0; i<a; i++) {
            A[i] = b[i];
        }

        for (int i=1; i<a; i++) {
            int point = i;
            int value = A[i];

            for (int j=i-1; j>=0; j--) {
                if (A[j] <A[i]) {
                    point = j+1;
                    break;
                }
                if (j == 0) point = 0;
            }

            for (int j=i; j>point; j--) {
                A[j] = A[j-1];
            }
            A[point] = value;
        }

        // 합 배열
        B[0] = A[0];
        for (int i=1; i<a; i++) {
            B[i] = B[i-1] + A[i];
        }

        int sum = 0;
        for (int i=0; i<a; i++) {
            sum += B[i];
        }

        System.out.println(sum);
        return sum;
    }
}
```