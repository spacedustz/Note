## 💡 QueryDSL

컴파일 단계에서 디버깅이 용이하다.

JPAQueryFactory를 이용하여 동적 쿼리 작성이 간편하다.

JPQL 빌더 역할을 한다.

문자가 아닌 자바코드로 JPQL을 작성 가능하다.

```java
public class Temp implements CustomRepository {
    private final JPAQueryFactory queryFactory;
    
    public Temp(EntityManager em) {
        queryFactory = new JPAQueryFactory(em);
    }
    
    QMember m = Qmember.member;
    List<Member> result = queryFactory
        .select(m)
        .from(m)
        .where(m.name.like("kim"))
        .orderBy(m.id.desc())
        .fetch();
}
```

