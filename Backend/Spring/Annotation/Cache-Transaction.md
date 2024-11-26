## @Cacheable의 주요 옵션

### cacheNames (또는 value)

- 설명: 캐시 이름을 지정합니다. 메서드의 결과가 저장될 캐시를 정의합니다.
- 사용 상황: 데이터베이스에서 책 정보를 조회할 때, books라는 캐시에 저장하여 동일한 ISBN으로 조회할 때 캐시된 데이터를 반환합니다.

```java
@Cacheable(cacheNames = "books")
public Book findBook(ISBN isbn) {}
```

<br>

### key

- 설명: 캐시 항목의 키를 지정합니다. 기본적으로 메서드의 모든 인자가 키로 사용되지만, SpEL(Spring Expression Language)을 사용하여 커스터마이즈할 수 있습니다.
- 사용 상황: 특정 필드를 키로 사용하여 캐싱할 때 유용합니다.

```java
@Cacheable(cacheNames = "books", key = "#isbn")
public Book findBook(ISBN isbn) {}
```
   
### condition
- 설명: 조건에 따라 캐싱 여부를 결정합니다. SpEL을 사용하여 조건을 정의할 수 있습니다.
- 사용 상황: 특정 조건을 만족하는 경우에만 캐싱하고 싶을 때 사용합니다.

```java
@Cacheable(cacheNames = "books", condition = "#isbn != null")
public Book findBook(ISBN isbn) {}
```

<br>
   
### unless

- 설명: 조건에 따라 캐싱을 방지합니다. condition과 반대로 동작하며, 결과가 특정 조건을 만족하면 캐싱하지 않습니다.
- 사용 상황: 결과가 null인 경우에만 캐싱하지 않도록 설정할 수 있습니다.

```java
@Cacheable(cacheNames = "books", unless = "#result == null")
public Book findBook(ISBN isbn) {}
```

<br>
   
### keyGenerator

- 설명: 사용자 정의 키 생성기를 지정할 수 있습니다.
- 사용 상황: 기본 키 생성 방식이 충돌을 일으킬 가능성이 있을 때 사용자 정의 키 생성기를 사용합니다.

```java
@Cacheable(cacheNames = "books", keyGenerator = "customKeyGenerator")
public Book findBook(ISBN isbn) {}
```
   
<br>

### cacheManager

- 설명: 사용할 CacheManager를 명시적으로 지정할 수 있습니다.
- 사용 상황: 여러 CacheManager를 사용하는 환경에서 특정 CacheManager를 사용하고자 할 때 유용합니다.

```java
@Cacheable(cacheNames = "books", cacheManager = "customCacheManager")
public Book findBook(ISBN isbn) {}
```
   
<br>

### 가상의 시나리오

도서 검색 앱

- findBook 메서드는 ISBN으로 책 정보를 검색합니다. 검색 결과는 books라는 캐시에 저장되어 동일한 ISBN으로 검색 시 빠르게 결과를 반환합니다.


**사용자 프로필 조회 서비스**
- getUserProfile 메서드는 사용자 ID로 프로필 정보를 조회하며, userProfiles라는 캐시에 저장됩니다. 만약 사용자 ID가 null이면 캐싱하지 않습니다.

**상품 목록 조회 서비스**

- getProductList 메서드는 페이지 번호와 정렬 방향에 따라 상품 목록을 반환합니다. products라는 캐시에 저장되며, 페이지 번호와 정렬 방향이 키로 사용됩니다.
- 이러한 설정은 애플리케이션의 성능을 향상시키고 불필요한 데이터베이스 호출을 줄이는 데 도움이 됩니다.

---

## @Transactional Propagation 옵션

### REQUIRED (기본값)

상황: 일반적인 주문 생성 과정. 새 트랜잭션이 시작되거나 기존 트랜잭션에 참여합니다.

```java
@Service
public class OrderService {
    @Transactional
    public void createOrder(Order order) {
    // 주문 생성 로직
    }
}
```

<br>

### REQUIRES_NEW

상황: 주문 처리 중 결제 과정. 결제는 주문과 독립적으로 처리되어야 하므로 새로운 트랜잭션에서 실행됩니다.

```java
@Service
public class PaymentService {
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void processPayment(Payment payment) {
    // 결제 처리 로직
    }
}
```

<br>

### MANDATORY

상황: 재고 업데이트. 이 메서드는 반드시 상위의 트랜잭션 내에서 호출되어야 합니다.

```java
@Service
public class InventoryService {
    @Transactional(propagation = Propagation.MANDATORY)
    public void updateInventory(String productId, int quantity) {
    // 재고 업데이트 로직
    }
}
```

<br>

### SUPPORTS

상황: 제품 정보 조회. 트랜잭션이 있으면 사용하고, 없어도 실행됩니다.

```java
@Service
public class ProductService {
    @Transactional(propagation = Propagation.SUPPORTS)
    public Product getProductDetails(String productId) {
    // 제품 정보 조회 로직
    }
}
```

---

## @Transactional Isolation 옵션

### READ_COMMITTED

상황: 일일 매출 보고서 생성. 다른 트랜잭션의 커밋된 데이터만 읽습니다.

```java
@Service
public class ReportService {
   @Transactional(isolation = Isolation.READ_COMMITTED)
   public List<SalesReport> generateDailySalesReport() {
   // 일일 매출 보고서 생성 로직
   }
}
```

<br>

### SERIALIZABLE

상황: 은행 계좌 간 송금. 높은 수준의 데이터 일관성이 요구됩니다.

```java
@Service
public class BankAccountService {
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public void transferMoney(String fromAccount, String toAccount, BigDecimal amount) {
    // 계좌 이체 로직
    }
}
```

<br>

### Timeout

상황: 일일 배치 작업. 5분(300초) 이내에 완료되어야 하며, 초과 시 롤백됩니다.

```java
@Service
public class BatchJobService {
   @Transactional(timeout = 300)
   public void runDailyBatchJob() {
   // 일일 배치 작업 로직
   }
}
```

<br>

### ReadOnly

상황: 전체 고객 목록 조회. 데이터 변경이 없는 읽기 전용 작업으로, 성능 최적화를 위해 사용됩니다.

```java
@Service
public class CustomerService {
   @Transactional(readOnly = true)
   public List<Customer> getAllCustomers() {
   // 모든 고객 정보 조회 로직
   }
}
```

<br>

### RollbackFor 및 NoRollbackFor

```java
@Service
public class EmailService {
   @Transactional(rollbackFor = MailSendException.class)
   public void sendWelcomeEmail(String email) {
   // 환영 이메일 발송 로직
   }


   @Transactional(noRollbackFor = TemporaryNetworkIssueException.class)
   public void sendNewsletterBatch() {
   // 뉴스레터 일괄 발송 로직
   }
}
```

<br>

### 가상 시나리오

- 상황 1: 환영 이메일 발송. 메일 발송 실패 시 전체 트랜잭션을 롤백합니다.
- 상황 2: 뉴스레터 일괄 발송. 일시적인 네트워크 문제로 인한 예외 발생 시에도 롤백하지 않고 계속 진행합니다.