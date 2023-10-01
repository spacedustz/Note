## 📘 Serialization vs JSON 비교

직렬화란 자바 Object & Data를 다른 컴퓨터의 자바 시스템에서 사용 하도록 **바이트 스트림(streams of byte)** 형태로,

**연속적인(Serial)** 데이터로 변환하는 **포맷 변환 기술**입니다.

반대로 역직렬화는 바이트로 변환된 데이터를 원래대로 자바 시스템의 Object & Data로 변환하는 기술입니다.

<br>

이를 시스템적으로 보면 JVM의 Heap or Stack 메모리에 상주하는 객체를 직렬화