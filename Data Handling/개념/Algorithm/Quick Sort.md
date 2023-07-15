## **💡 퀵 정렬 (Quick Sort)**

기준값을 선정해 해당 값보다 작은 데이터와 큰 데이터로 분류하는 것을 반복해 정렬하는 알고리즘이다.

기준값이 어떻게 선정되는지에 따라 시간 복잡도에 많은 영향을 미치고 평균 시간복잡도는 O(nlogn)이다.

<br>

### **과정**

1. 데이터를 분할하는 pivot을 설정한다.

<br>

2. pivot을 기준으로 다음 A ~ E 과정을 거쳐 데이터를 2개의 집합으로 분리한다.


  A. start가 가리키는 데이터가 pivot이 가리키는 데이터보다 작으면 start를 오른쪽으로 1칸 이동한다.

  B. end가 가리키는 데이터가 pivot이 가리키는 데이터보다 크면 end를 왼쪽으로 1칸 이동한다.

  C. start가 가리키는 데이터가 pivot이 가리키는 데이터보다 크고, 
    end가 가리키는 데이터가 pivot이 가리키는 데이터보다 작으면,
    start, end가 가리키는 데이터를 swap 연산하고 start는 오른쪽 end는 왼쪽으로 1칸씩 이동한다.

  D. start와 end가 만날때까지 A~C를 반복한다.

  E. start와 end가 만나면 만난 지점에서 가리키는 데이터와 pivot이 가리키는 데이터를 비교하여
    pivot이 가리키는 데이터가 크면 만난 지점의 오른쪽, 작으면 만난 지점의 왼쪽에
    pivot이 가리키는 데이터를 삽입한다.

<br>

3. 분리 집합에서 각각 다시 pivot을 선정한다.

<br>

4. 분리 집합이 1개 이하가 될때까지 1~3의 과정을 반복한다.

<br>

### **구현**

```java
public class QuickSort {
    static String testA = "5 2";
    static int[] testB = {4,1,2,3,5};

    public static void main(String[] args) {
        function(testA, testB);
    }

    static int function(String a, int[] b) {
        StringTokenizer st = new StringTokenizer(a);
        // 파라미터로 들어온 문자열안에 담긴 숫자를 나눠서 저장
        // A = 숫자의 개수
        // B = K번째 수
        int A = Integer.parseInt(st.nextToken());
        int B = Integer.parseInt(st.nextToken());

        // 숫자의 데이터를 저장할 새 배열
        int[] C = new int[A];


        for (int i=0; i<A; i++) {
            C[i] = b[i];
        }
        quickSort(C, 0, A-1, B-1);
        System.out.println(C[B-1]);

        return 1;
    }

    static void quickSort(int[] a, int b, int c, int k) {
        if (b < c) {
            int pivot = partition(a,b,c);
            if (pivot == k) {
                return;
            } else if (k < pivot) {
                quickSort(a,b,pivot-1,k);
            } else {
                quickSort(a,pivot+1,c,k);
            }
        }
    }

    static int partition(int[] a, int b, int c) {
        if (b+1 == c) {
            if (a[b] > a[c]) {
                swap(a, b, c);
            }
            return c;
        }
        int m = (b+c) / 2;
        swap(a,b,m);
        int pivot = a[b];
        int i = b+1;
        int j = c;

        while (i <= j) {
            while (pivot < a[j] && j > 0) {
                j--;
            }
            while (pivot > a[i] && i < a.length -1) {
                i++;
            }

            if (i <= j) {
                swap(a, i++, j++);
            }
        }
        a[b] = a[j];
        a[j] = pivot;
        return j;
    }

    static void swap(int[] a, int b, int c) {
        int temp = a[b];
        a[b] = a[c];
        a[c] = temp;
    }
}
```