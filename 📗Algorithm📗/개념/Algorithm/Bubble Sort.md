## **💡 버블 정렬 (Bubble Sort)**

데이터의 인접 요소의 크기를 비교하고, swap 연산을 수행하며 정렬하는 방식

**시간복잡도는 O(n2)**으로 굉장히 느린편이다.

보통 loop를 돌면서 인접한 데이터 간의 swap 연산으로 정렬한다.

<br>

## **과정**

1. 비교 연산이 필요한 경우 loop 범위를 설정한다.
2. 인접한 데이터 값을 비교한다.
3. swap 조건에 부합하면 swap 연산을 수행한다.
4. loop가 끝날때까지 2~3을 반복한다
5. 정렬 영역을 설정한다, 다음 loop를 실행할 때는 이 영역을 제외한다.
6. 비교 대상이 없을 때까지 1~5를 반복한다.

만약 특정 loop의 전체 영역에서 swap이 발생하지 않으면, 정렬이 됬다는 의미이므로 프로세스를 종료해도 된다.

<br>

### **버블정렬을 이용한 N개의 수 오름차순 정렬**

sort()를 이용하면 간단하지만, 예시를 위해 정렬을 직접 구현한다.

```java
public class BubbleSort {

    static int testA = 5;
    static int[] testB = {5, 2, 3, 4, 1};

    public static void main(String[] args) {
        bubbleSort(testA, testB);
    }

    public static int bubbleSort(int a, int[] b) {
        // 정렬할 배열 생성
        int[] A = new int[a];

        // 정렬할 배열에 파라미터로 넘어온 정렬되지 않은 숫자를 담는다
        for (int i=0; i<a; i++) {
            A[i] = b[i];
        }

        for (int i=0; i<a-1; i++) {
            for (int j=0; j<a-1-i; j++) {
                if (A[j] > A[j+1]) {
                    // 현재 A 배열의 값보다 1칸 오른쪽 배열의 값이 더 작으면 두 수를 바꾼다.
                    int temp = A[j];
                    A[j] = A[j+1];
                    A[j+1] = temp;
                }
            }
        }

        // 값 출력
        int answer = 0;
        for (int i=0; i<a; i++) {
            answer = A[i];
            System.out.println(answer);
        }
        re
```