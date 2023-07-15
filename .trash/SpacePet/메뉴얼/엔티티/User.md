## User

**1:1**
- Geometry
- GradeAuth
- UserDate
- UserDetail
- UserCert
- UserToken

**1:N**
- Animal
- Comment
- UserLike

Functions
- 이웃 댓글 추가
- animal 추가
- 유저 디테일 추가
- 위치 추가
- 유저 date 추가
- 유저 등급 수정
- gradeAuth 추가
- 유저 정보 수정
- 차단유저 수정
- give & take Count 수정
- 스페셜노트 수정
- 유저 삭제
- 유저 복구
- 반려동물 정보 수정
- 프로필 이미지 수정
- give & take 수정
- 신뢰지수 수정
- 유저 하드웨어 정보 수정
- 유저 인증정보 수정
- 유저 기기 수정
- 성별 조회
- chat answer rate 수정

---

```kotlin
@Entity  
@JsonIdentityInfo(generator = ObjectIdGenerators.IntSequenceGenerator::class, property = "emit")  
@DynamicUpdate  
class User(  
    @Id  
    var id: String,  
    var name: String,  
    var email: String = "",  
    var userProfile: String = "",  
    var gender: String = "",  
    var birthday: String = "",  
    var ageRange: String = "",  
    var give: Int = 0,  
    var take: Int = 0,  
    var grade: String = "준회원",  
    var deleted: Boolean = false,  
    var specialNote: String = "",  
  
    var animal : String? = null,  
  
    var os: String? = null,  
    var sns: String? = null,  
    var ip : String? = null,  
    var version : String? = null,  
  
    var trustPoint : Int = 0,  
    var chatAnswerRate : String? = null,  
  
    @OneToOne(cascade = [CascadeType.ALL])  
    @JoinColumn(name = "geometryId")  
    var geometry: Geometry? = null,  
  
    @Basic(fetch = FetchType.LAZY)  
    @Formula("(SELECT count(1) FROM user_like AS ul WHERE ul.like_taker_id = id)")  
    var likeCount: Int? = 0,  
  
    @OneToOne(fetch = FetchType.LAZY, cascade = [CascadeType.ALL])  
    @JoinColumn(name = "gradeAuthId")  
    var gradeAuth: GradeAuth? = null,  
  
    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL])  
    var animals: MutableList<Animal> = mutableListOf(),  
  
    @OneToOne(fetch = FetchType.LAZY, cascade = [CascadeType.ALL])  
    @JoinColumn(name = "userDateId")  
    var userDate: UserDate? = null,  
  
    @OneToOne(fetch = FetchType.LAZY, cascade = [CascadeType.ALL])  
    @JoinColumn(name = "userDetailId")  
    var userDetail: UserDetail? = null,  
  
    @OneToOne(fetch = FetchType.LAZY, cascade = [CascadeType.ALL])  
    @JoinColumn(name = "userCertId")  
    var userCert: UserCert? = null,  
  
    @OneToOne(fetch = FetchType.LAZY, cascade = [CascadeType.ALL])  
    @JoinColumn(name = "tokenId")  
    var userToken: Token? = null,  
  
    @Convert(converter = JsonConverter::class)  
    @Column(columnDefinition = "json")  
    var blockedUsers: MutableList<String>? = null,  
  
    @OneToMany(mappedBy = "targetUser", cascade = [CascadeType.ALL])  
    var comments: MutableList<NeighborComment> = mutableListOf(),  
  
    @OneToMany(mappedBy = "taker", cascade = [CascadeType.ALL])  
    var likes : MutableList<UserLike> = mutableListOf()  
  
)
```