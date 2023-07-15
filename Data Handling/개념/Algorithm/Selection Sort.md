## **💡 선택 정렬 (Selection Sort)**

대상 **데이터의 최소값과 최대값을 찾아서 데이터가 나열된 순**으로 찾아가며 선택하는 방법이다.

구현 방법이 복잡하고 **시간복잡도도 버블 정렬과 같이 O(n2)**으로 비효율적이다.

선택 정렬의 원리만 간단히 알아보자.

<br>

### **과정**

1. 남은 정렬부분에서 최대값 & 최소값을 찾는다.
2. 남은 정렬 부분에서 가장 앞에 있는 데이터와 선택된 데이터를 swap 한다.
3. 가장 앞에 있는 데이터의 위치를 변경해(index++) 남은 정렬 부분의 범위를 축소한다.
4. 전체 데이터 크기만큼 index가 커질 때 까지 즉, 남은 정렬 부분이 없을 때까지 반복한다.

<br>

### **구현**

선택 정렬을 이용해 **내림차순 정렬**을 구현한다.

```java
public class SelectionSort {

    static String testA = "2143";

    public static void main(String[] args) {
        selectionSort(testA);
    }

    public static int selectionSort(String a) {
        // 새 배열의 크기를 파라미터로 넘어온 String의 길이만큼 생성
        int A[] = new int[a.length()];

        // String의 1글자씩 나눠서 배열에 저장
        for (int i=0; i<a.length(); i++) {
            A[i] = Integer.parseInt(a.substring(i, i+1));
        }

        for (int i=0; i<a.length(); i++) {
            int max = i;
            for (int j=i+1; j<a.length(); j++) {
                // 현재 범위에서 Max값 찾기
                if (A[j] > A[max]) {
                    max = j;
                }
            }
            // 현재 i의 값과 Max의 값중 Max값이 더 크면 Swap 수행
            if (A[i] < A[max]) {
                int temp = A[i];
                A[i] = A[max];
                A[max] = temp;
            }
        }

        // 출력
        int result = 0;
        for (int i=0; i<a.length(); i++) {
            result = A[i];
            System.out.println(result);
        }
        return result;
    }
}
```