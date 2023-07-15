## 💡 JPQL vs QueryDsl

EntityManafer와 JPAQueryFactoru를 클래스의 생성자로 준다.

---

## 테스트 코드 작성

<br>

JPQL과 QueryDSL의 차이점

- JPQL(문자)은 실행 시점에 오류가 나고 QueryDsl(코드)은 컴파일 타임에 오류가 난다.
- JPQL은 파라미터 바인딩을 직접하지만, QueryDsl은 동적으로 처리된다.

Q-Type에 별칭을 지정할 수 있다.

<br>

실행되는 JPQL을 보고 싶으면 application.yml에 다음을 추가한다.

```yaml
spring.jpa.properties.hibernate.use_sql_comments: true
```

<br>

```kotlin
@SpringBootTest  
@Transactional  
class QueryDslBasicTest @Autowired constructor(  
    @PersistenceContext  
    val em: EntityManager,  
    val emf: EntityManagerFactory,  
    val queryFactory: JPAQueryFactory  
) {  
  
    @BeforeEach  
    fun before() {  
        val teamA = Team("teamA")  
        val teamB = Team("teamB")  
        em.persist(teamA)  
        em.persist(teamB)  
        val member1 = Member("member1", 10, teamA)  
        val member2 = Member("member2", 20, teamA)  
        val member3 = Member("member3", 30, teamB)  
        val member4 = Member("member4", 40, teamB)  
        em.persist(member1)  
        em.persist(member2)  
        em.persist(member3)  
        em.persist(member4)  
    }  
  
    @Test fun startJPQL() {  
  
        val qlString: String = """  
            select m from Member m  
            where m.name =: name  
        """.trimIndent()  
  
        val findMember = em.createQuery(qlString, Member::class.java)  
            .setParameter("name", "member1")  
            .singleResult  
  
        assertThat(findMember.name).isEqualTo("member1")  
    }  
  
    @Test  
    fun startQuerydsl() {  
  
        // Q Type 별칭 지정  
        val m = QMember("m")  
  
        val findMember = queryFactory  
            .select(m)  
            .from(m)  
            .where(m.name.eq("member1"))  
            .fetchOne()  
  
        assertThat(findMember?.name).isEqualTo("member1")  
    }  
}
```
