## **💡 자료 구조**

여러 데이터들의 묶음을 저장하고 사용하는 방법을 정의한 것

자료의 집합, 각 원소들 사이의 관계가 논리적 정의된 일정한 규칙에 의하여 나열되며,
자료처리의 효율성을 위해 조직&체계적으로 구분하여 표현한 것
(알고리즘 테스트 시 자주 등장하는 Stack,Queue,Tree,Graph 등)

------

### **자료구조의 경계 조건**

1. 자료 구조가 비어있는 경우
2. 자료 구조에 단 하나의 요소가 들어있을 때
3. 자료 구조의 첫 번째 요소를 제거하거나 추가할 때
4. 자료 구조의 마지막 요소를 제거하거나 추가할 때
5. 자료 구조의 중간 부분을 처리할 때

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DataStructure_BasicTree.png) 

<br>

### 학습 포인트

- 각 자료구조가 가진 특징
- 각 자료구조를 사용하기 적합한 상황 판단
- 다른 구조와의 차이점을 이해하기 위해 자료구조 내부 직접구현
- 구현 시, 동작원리 이해하기

### 자료구조를 배워야 하는 이유

- 상황에 맞는 가장 적합한 자료구조를 이용하여 문제를 빠르고 정확하게 해결
- 자료구조의 내부를 이해하면 엉뚱한 라이브러리를 선택하는 일을 피할수 있다
- 알고리즘이 데이터를 효율적으로 사용할 수 있게 도와주는 핵심 부품 역할

------

### **구조**

- 단순 자료구조
  - 프로그래밍 언어에서 통상적으로 제공하는 기본 데이터 형식
- 복합 자료구조
  - 선형 자료구조
    - 데이터 요소를 순차적으로 연결, 구현 & 사용이 쉽다
    - Array, LinkedList, Stack, Queue 등이 해당됨
  - 비선형 자료구조
    - 데이터 요스를 비순차적으로 연결
    - 한 요소에서 여러 요소로 연결되기도 하고, 여러 요소가 하나의 요소로 연결되기도 함
    - Tree, Gragh가 해당됨

------

## **ADT란? (Abstract Data Types)**

- 자료구조의 동작방법을 표현하는 데이터 형식, 즉 자료구조가 갖춰야할 일련의 연산이다.
- ADT는 개념을 제시하고 자료구조는 구현을 포함함

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DataStructure_ADT.png)  

------

## **자료구조의 형태**

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DataStructure_Chain_Hash.png) 

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DataStructure_Stack_Queue.png) 

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DataStructure_LinkedList.png) 

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/DataStructure_Tree_Sort.png) 

