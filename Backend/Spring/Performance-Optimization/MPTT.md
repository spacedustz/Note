## 조회 성능 최적화를 위한 테이블 설계 (트리 순회 방식)

지금까지 어떤 Entity와 연관된 다른 Entity를 불러올때 계층적 쿼리 방식을 많이 사용했었습니다.

아래 Entity 클래스처럼 한 테이블에 Parent를 둬서 Children이 Parent를 참조하는 일반적인 방식입니다.

<br>

이 방법은 설계가 쉽고 직관적이라는 장점이 있는 반면,

계층의 층위가 깊어질수록 쿼리의 복잡도와 읽기 시간이 점점 증가합니다.

특히, SQL 재귀 쿼리를 사용해야 할 때는 성능 저하까지 발생할 수 있습니다.

```java
@Entity
@Getter  
@NoArgsConstructor(access = AccessLevel.PROTECTED)  
public class Box extends BaseEntity {
    @Id  
    @GeneratedValue(strategy = GenerationType.IDENTITY)  
    @Column(name = "box_id", nullable = false)
    private Integer boxId;  
    
    @Column(name = "box_name", nullable = false)
    private String boxName;  
    
    @ManyToOne(fetch = FetchType.LAZY)  
    @JoinColumn(name = "parent_box_id", referencedColumnName = "box_id", foreignKey = @ForeignKey(name = "FK_SVC_box_01"))
    private Box parentBox;  
    
    @Column(name = "box_ext_name", length = 100)
    private String boxExtName;  
    
    @Column(name = "call_id", length = 20)
    private String callId;  

    @OneToMany(mappedBy = "parent_box", cascade = CascadeType.ALL, orphanRemoval = true)  
    private List<Box> subBox = new ArrayList<>();  

    @OneToMany(mappedBy = "Box", cascade = CascadeType.ALL, orphanRemoval = true)  
    private List<BoxPoint> boxPointList = new ArrayList<>();  
    
    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder = 0;  
    
    @Column(name = "data_status", nullable = false)
    private DataStatus dataStatus;
}
```

---

## MPTT(Modified Preorder Tree Traversal) 방식

위 방식과 다르게 이번에 써 볼 **트리 순회 방식**은 계층의 층위가 깊고, 읽기 성능이 중요한 시스템을 설계해야 하는 경우 적용 가능한 방법입니다.

> **장점**

-   대규모 데이터와 복잡한 층위의 계층 구조를 효율적으로 관리할 수 있게 됩니다.
-   이 방식은 각 하위 요소의 위치를 나타내는 **left, right**값을 사용하여 트리 구조를 효율적으로 저장합니다.

> **단점**

-   하위 요소의 추가, 삭제, 이동 등의 작업이 많을 경우 **left, right** 값 관리가 복잡하게 됩니다.

<br>

### 테이블 구조 변경 - Box

저는 하위 요소의 추가, 삭제, 이동 등 작업이 빈번하지 않고 조회 작업이 제일 많으므로 이 방식을 사용합니다.

위 Entity와 다르게 Parent를 제거하고 Left, Right 컬럼을 추가하였습니다.

```java
@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Box extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "box_id", nullable = false)
    private Integer boxId;

    @Column(name = "box_name", nullable = false)
    private String boxName;

    @Column(name = "box_ext_name", length = 100)
    private String boxExtName;

    @Column(name = "call_id", length = 20)
    private String callId;

    @OneToMany(mappedBy = "box", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<BoxPoint> boxPointList = new ArrayList<>();

    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder = 0;

    @Column(name = "data_status", nullable = false)
    private DataStatus dataStatus;

    // MPTT를 위한 left 및 right 컬럼 추가
    @Column(name = "left_val", nullable = false)
    private Integer leftVal;

    @Column(name = "right_val", nullable = false)
    private Integer rightVal;
}
```

<br>

### 예시

예를 들어서 이런 구조의 트리가 있다고 가정해 보겠습니다.

```javascript
     A
    / \
   B   C
  / \
 D   E
```

트리를 순회하면서 각 노드에 대해 `left`와 `right` 값을 설정합니다.

항상 Root부터 시작하며, Root Node의 경우 트리의 가장 왼쪽에 있기 떄문에 leftVal 값은 1로 시작합니다.

각 노드를 처음 방문할때 `Left` 값을, 해당 노드의 모든 자식 노드를 방문한 후 `Right` 값을 할당 해줍니다.

<br>

이 과정을 **Pre-Order 순회**라고 합니다.

1.  **A 방문** (A의 `left` = 1)
    -   B 방문 (B의 `left` = 2)
        -   D 방문 (D의 `left` = 3), D가 리프 노드이므로 바로 `right` 값 할당 (D의 `right` = 4)
    -   B의 모든 자식을 방문했으므로 B의 `right` 값을 할당 (B의 `right` = 5)
        -   E 방문 (E의 `left` = 6), E가 리프 노드이므로 바로 `right` 값 할당 (E의 `right` = 7)
    -   C 방문 (C의 `left` = 8), C가 리프 노드이므로 바로 `right` 값 할당 (C의 `right` = 9)

<br>

위 과정을 거치고 나면 최종적인 `Left`, `Right` 값은 아래와 같습니다.

이 방식을 이용해 Left, Right 값을 이용해 각 노드가 트리 내에서 어디에 위치하는지 나타낼 수 있으며,

특정 노드의 모든 자식 노드를 쉽게 조회할 수 있습니다.

```javascript
     A(1,10)
    /     \
  B(2,5)   C(8,9)
  /   \
D(3,4) E(6,7)
```

<br>

### 조회 - BoxRepository

위 트리 구조를 기반으로 `Left`, `Right`값을 기준으로 특정 노드를 조회하거나, 특정 노드의 자식 노드들을 조회합니다.

-   특정 노드의 모든 자식 노드 조회 -> findAllChidren
-   특정 노드를 포함한 모든 자식 노드 조회 -> findAllChildrenIncludingParent

```java
public interface BoxRepository extends JpaRepository<Box, Integer> {
    @Query("SELECT b FROM Box b WHERE b.leftVal > :parentLeft AND b.rightVal < :parentRight ORDER BY b.leftVal ASC")
    List<Box> findAllChildren(@Param("parentLeft") Integer parentLeft, @Param("parentRight") Integer parentRight);

    @Query("SELECT b FROM Box b WHERE b.leftVal >= :parentLeft AND b.rightVal <= :parentRight ORDER BY b.leftVal ASC")
    List<Box> findAllChildrenIncludingParent(@Param("parentLeft") Integer parentLeft, @Param("parentRight") Integer parentRight);
```