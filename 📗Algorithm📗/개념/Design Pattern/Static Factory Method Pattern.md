## **💡 Static Factory Method Pattern**  

**Static Factory Method Pattern의 장점**

- Constructor Chaning으로 발생될 문제 방지
- 이름 설정 가능 **->** 반환될 객체의 특성을 더 자세하게 묘사
- 불필요한 객체 생성 방지 **->** 만들어놓거나 새로 만든 객체를 캐싱하여 재활용하는 방식 사용
- 서브 클래스 반환 **->** 반환할 객체의 클래스를 유연하게 선택
- 파라미터에 따라 매번 다른 타입의 객체 반환
- 반환할 객체 클래스(구현체)가 없어도 됨

<br>

**Static Factory Method Pattern의 단점**

- Sub Classing의 어려움
- Documentation
- 불명확한 API로 인해 개발자가 일일이 인스턴스화 할 방법을 찾아야함

<br>

**Static Factory Method Pattern의 명명 방식**

- **of()**
  - **여러 파라미터를 받아** 적절한 타입의 객체 반환하는 **집계 메서드**
  - **ex:** set<Number> numbers = EnumSet.of(One,Two,Three);
- **from()**
  - **하나의 파라미터**를 받아서 타입의 객체를 반환하는 **형변환 메서드**
  - **ex:** Date date = Date.from(instance);
- **valueOf()**
  - of & from의 구체화 버전
  - **ex:** BigInteget num = BigInteger.valueOf(Integer.MAX_VALUE);
- **instance() & getInstance()**
  - 파라미터로 명시한 객체를 반환하지만 같은 객체임을 보장하지는 않음
  - **ex:** StockOption stock = StockOption.getInstance(option);
- **create() & newInstance()**
  - 매번 새로운 객체 반환 == 객체 생성
- **getType()**
  - getInstance와 같지만, 생성할 클래스가 아닌 다른 클래스의 팩토리 메서드를 정의할 때 사용
  - 자신의 타입이 아닌 다른 타입 반환
  - **ex:** Storage st = Disk.getStorage(path);
- **newType()**
  - newInstanc와 같지만, 생성할 클래스가 아닌 팩토리 메서드를 정의할 때 사용
  - 자신의 타입이 아닌 다른 타입 반환
  - **ex:** BufferedWriter bw = Disk.newBufferedWriter(path);
- **type()**
  - getType & newType의 간결화 버전
  - **ex:** List<Comment> comment = Collections.List(list);