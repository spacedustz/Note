## UserSearchService 로직 변경

---

## getReviewCheck()

### 기존

```kotlin
/**  
 * @author 고범석  
 * @param uid : 유저 아이디  
 * @desc 유저 프로미스 검색  
 */  
fun getReviewCheck(uid: String): Boolean {  
  
    var result = false;  
  
    var promises = try {  
        promiseRepository.findByUserTakeList(uid);  
    } catch (e: Exception) {  
        log.error("USER-099 : 유저 프로미스 검색 실패 - $e")  
        throw CommonException("USER-099 : 유저 프로미스 검색 실패 : ${e}", HttpStatus.NOT_FOUND);  
    }  
  
    for (item in promises) {  
        if (item.review == null && item.checkCareFinish) {  
            result = true;  
            break;  
        }  
    }  
  
    log.info("유저 프로미스 검색 성공 - 유저 아이디 : $uid")  
  
    return result;  
}
```

<br>

### 변경 후

result 변수 제거 + loop 제거 -> any를 돌려서 조건 일치 시 true 반환

```kotlin
/**  
 * @author 고범석  
 * @param uid : 유저 아이디  
 * @desc 유저 프로미스 검색  
 */  
fun getReviewCheck(uid: String): Boolean {  
    val promise = try {  
        promiseRepository.findByUserTakeList(uid)  
    } catch (e: Exception) {  
        log.error("USER-099 : 유저 ㄹ프로미스 검색 실패 - $e")  
            throw CommonException("USER-099 : 유저 프로미스 검색 실패 : $e", HttpStatus.NOT_FOUND)  
    }  
  
    val hasIncompletePromise = promise.any { it.review == null && it.checkCareFinish }  
  
    log.info("유저 프로미스 검색 성공 - 유저 아이디 : $uid")  
  
    return hasIncompletePromise  
}
```

---

## getUserAnimal()

### 기존

```kotlin
/**  
 * @author 고범석  
 * @param id : 유저 아이디  
 * @desc 유저 돌봄 관련 정보 조회  
 */  
fun getUserAnimal(id: String): UserAnimalDTO {  
  
  
    fun getUserGiveTake(): Array<String> {  
        return promiseRepository.getUserGiveTake(id)  
    }  
  
    val anUser = userRecycleFn.checkActiveUser(id)  
  
    /** 돌봄관련 전부 조회*/  
    var promiseReviewCount = 0  
    try {  
        val promiseData = promiseRepository.findByUserPromiseList(id)  
  
        for (item in promiseData) {  
            var index = if (item.promiseItem[0].user.id == id) 0 else 1  
  
            if (item.reviewPoint != null && item.reviewPoint!!.size == 5 && item.promiseItem[index].role == "give") {  
                promiseReviewCount += 1  
            }  
        }  
    } catch (e: Exception) {  
        log.error("NEIGHBOR-007 : Give Take 계산 실패 [userId : $id ] : $e")
    }  
  
    /**  유저 한마디 전체 댓글 갯수 조회 */    
    val neighborCommentCount: Long = try {  
        commentService.getNeighborCommentCount(id)  
    } catch (e: Exception) {  
        0  
    }  
  
    /** Give Take 조회 및 업데이트*/  
    var give = 0  
    var take = 0  
  
    try {  
        val giveTakeData = getUserGiveTake()  
        val giveTake = giveTakeData[0].split(",")  
  
        if (giveTake.size == 2) {  
            give = Integer.parseInt(giveTake[0])  
            take = Integer.parseInt(giveTake[1])  
  
            anUser.updateGiveTake(give, take)  
        } else {  
            //log.error("NEIGHBOR-007 : Give Take 계산 실패 [userId : $targetId ]")        }  
    } catch (e: Exception) {  
        //NeighborService.log.error("NEIGHBOR-007 : Give Take 계산 실패 [userId : $targetId ] : $e")    }  
  
    /** 신뢰지수 계산 */    
    var trustPoint = trustPointService.getTrustPoint(anUser, anUser.id)  
  
    val result = try {  
        UserAnimalDTO.ModelMapper.entityToDto(anUser, trustPoint.toString())  
    } catch (e: Exception) {  
        log.error("USER-005 : userAnimalDTO mapping 실패 : $e")  
        throw CommonException("USER-005", HttpStatus.BAD_REQUEST)  
    }  
    log.info("유저/동물 상세정보 조회 : [유저uid : $id , 유저 이름 : ${result.name}, 동물 이름: ${result.animalName} ]")  
  
    // 여기까지 정상작동  
  
    return result  
}
```

<br>

### 변경 후

primiseReviewCount의 Loop를 Count 함수로 대체


```kotlin
/**  
 * @author 고범석  
 * @param id : 유저 아이디  
 * @desc 유저 돌봄 관련 정보 조회  
 */  
fun getUserAnimal(id: String): UserAnimalDTO {  
    fun getUserGiveTake(): Array<String> {  
        return promiseRepository.getUserGiveTake(id)  
    }  
  
    val anUser = userRecycleFn.checkActiveUser(id)

		/** 돌봄관련 전부 조회*/
    var promiseReviewCount = 0  
  
    try {  
        val promiseData = promiseRepository.findByUserPromiseList(id)  
  
        promiseReviewCount = promiseData.count { item ->  
            val index = if (item.promiseItem[0].user.id == id) 0 else 1  
            item.reviewPoint?.size == 5 && item.promiseItem[index].role == "give"  
        }  
    } catch (e: Exception) {  
        log.error("NEIGHBOR-007 : Give Take 계산 실패 [ 유저 아이디 : $id ] : $e")  
    }  

		/**  유저 한마디 전체 댓글 갯수 조회 */
    val neighborCommentCount: Long = try {  
        commentService.getNeighborCommentCount(id)  
    } catch (e: Exception) {  
        0  
    }  

		/** Give Take 조회 및 업데이트*/
    var give = 0  
    var take = 0  
    val giveTakeData = getUserGiveTake()  
  
    try {  
        val giveTake = giveTakeData[0].split(",")  
  
        if (giveTake.size == 2) {  
            give = giveTake[0].toInt()  
            take = giveTake[1].toInt()  
            anUser.updateGiveTake(give, take)  
        }  
        else {  
            // log.error("NEIGHBOR-007: Give Take 계산 실패 [userId: $targetId]")        
        }  
    } catch (e: Exception) {  
        // NeighborService.log.error("NEIGHBOR-007: Give Take 계산 실패 [userId: $targetId]: $e")    
    }  

		/** 신뢰지수 계산 */
    val trustPoint = trustPointService.getTrustPoint(anUser, anUser.id)  
  
    val result = try {  
        UserAnimalDTO.ModelMapper.entityToDto(anUser, trustPoint.toString())  
    } catch (e: Exception) {  
        log.error("USER-005 : UserAnimalDTO Mapping 실패 - $e")  
        throw CommonException("USER-005", HttpStatus.BAD_REQUEST)  
    }  
  
    log.info("유저 / 동물 상세정보 조회 : [ 유저 아이디 : $id, 유저 이름 : ${result.name}, 동물 이름 : ${result.animalName} ]")  
    // 여기까지 정상작동
      
    return result  
}
```