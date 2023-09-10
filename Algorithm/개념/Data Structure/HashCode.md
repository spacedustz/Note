## 💡 HashCode

객체의 주소값을 변환하여 생성된 객체의 고유한 정수값이다.

두 객체가 동일한 객체인지 동일성을 체크할 때 사용한다.

<br>

아래 예시의 person1과 person2의 hashCode는 당연히 다르다.

hashCode는 주소값을 기반으로 생성된 정수 값이기 때문에 2,3의 hashCode는 동일하다.

```java
public class HashCode {
    public static void main(String[] args) {
        Person person1 = new Person("Kim");
        Person person2 = new Person(new String("Kim"));
        Person person3 = person2;

        System.out.println(person1.hashCode());
        System.out.println(person2.hashCode());
        System.out.println(person3.hashCode());
    }
}

class Person {
    String name;

    public Person(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object obj) {
        Person anotherObj = (Person) obj;
        return (this.name.equals(anotherObj.name));
    }
}

// 결과값
// 3565735997
// 1735600054
// 1735600054
```

<br>

### String 클래스의 hashCode()

String은 재정의한 equals()에서 각 문자열에서 한 글자씩 비교하는 방식이다.

아래 코드는 문자열에서 한글자씩 가져와서 정수값으로 변경하고 정수와 더하면
해당 글자의 아스키 코드의 값을 사용한다.

31을 곱하는 이유는 홀수이기 때문이다.

짝수를 곱했을 때 오버플로우 되면 정보 손실이 발생할 수 있기 때문이다.

이진수에서 2를 곱하면 비트가 왼쪽으로 1칸씩 이동한다.

홀수 중 31의 장점은 **31 * i가 (i << 5) - i** 와 같기 때문에 곱셈 대신 비트 이동 및 뺄셈으로 처리하여
성능상 이점이 있기 떄문이며, 요즘은 VM에서 자동으로 최적화를 해준다.

결론적으로 주소값을 기준으로 정수값의 hashCode를 생성하는 것이 아닌, 서로 다른 String 객체도
문자열이 같으면 hashCode가 같은 것이다.

```java
public int hashCode() {
    int h = hash;
    if (h == 0 && value.length > 0) {
        char val[] = value;
        
        for (int i=0; i<value.length; i++) {
            h = 31 * h + val[i];
        }
        hash = h;
    }
    return h;
}
```
