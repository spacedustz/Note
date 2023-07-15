## UserControlService 로직 변경

---

## createUser()

### 기존

```kotlin
/**  
 * @author 고범석  
 * @param userDto : 유저 정보  
 * @desc 유저 생성, 준회원으로 등급 상승, 테스트 유저 생성  
 */  
fun createUser(userDto: UserCommonDTO): UserCommonDTO {  
    var anUser = try {  
        userRepository.findById(userDto.id).orElse(null)  
    } catch (e: Exception) {  
        log.error("USER-004 : SQL 유저정보 조회 에러  [ userId :  ${userDto.id} ] : $e")  
        throw CommonException("USER-004", HttpStatus.NOT_FOUND)  
    }  
  
    if (anUser == null) {  
        val userEntity = modelMapper.map(userDto, User::class.java);  
        userEntity.updateUserGrade("준회원")  
        val userDate = UserDate().apply {  
            /** @desc 테스트 계정 고정 가입/등록일 설정 */            
            if (userDto.email.contains("spacepet")) {  
                profileAt = LocalDateTime.of(2020, 10, 10, 10, 10)  
                createdAt = LocalDateTime.of(2020, 10, 10, 10, 10)  
            }  
        }  
        userEntity.addDate(userDate)  
  
        anUser = userRepository.save(userEntity);  
    }  
  
    val result = try {  
        UserCommonDTO.ModelMapper.entityToDto(anUser)  
    } catch (e: Exception) {  
        log.error("USER-012 : 반려동물 UserDTO 매칭 안됨 : $e")  
        throw CommonException("USER-012", HttpStatus.BAD_REQUEST)  
    }  
  
    log.info("유저 정보 저장 : [ 유저 아이디 : ${result.id} ]")  
  
    return result  
}
```

<br>

### 변경 후

- anUser를 생성할 때 orElse() 대신 orElseGet()을 사용하여 람다 함수 제공
  그럼 findById의 결과가 Null인 경우에만 람다 함수가 실행되어 새로운 유저 생성 후 저장함

```kotlin
/**  
 * @author 고범석  
 * @param userDto : 유저 정보  
 * @desc 유저 생성, 준회원으로 등급 상승, 테스트 유저 생성  
 */  
fun createUser(userDto: UserCommonDTO): UserCommonDTO {  
    val anUser = userRepository.findById(userDto.id).orElseGet {  
        val userEntity = modelMapper.map(userDto, User::class.java)  
        userEntity.updateUserGrade("준회원")  
        
        val userDate = UserDate().apply {  
            if (userDto.email.contains("spacepet")) {  
                profileAt = LocalDateTime.of(2020, 10, 10, 10, 10)  
                createdAt = LocalDateTime.of(2020, 10, 10, 10, 10)  
            }  
        }  
        userEntity.addDate(userDate)  
        userRepository.save(userEntity)  
    }  
  
    val result = try {  
        UserCommonDTO.ModelMapper.entityToDto(anUser)  
    } catch (e: Exception) {  
        log.error("USER-012 : 반려동물 UserDTO 매칭 안됨 : $e")  
        throw CommonException("USER-012", HttpStatus.BAD_REQUEST)  
    }  
  
    log.info("유저 정보 저장 : [ 유저 아이디 : ${result.id} ]")  
  
    return result  
}
```

---

## registerUserLocation()

### 기존

```kotlin
/**  
 * @author 고범석  
 * @param locationDto : 위치 정보  
 * @param userId : 유저 아이디  
 * @desc 유저 지역 설정  
 */  
fun registerUserLocation(locationDto: LocationDTO, userId: String): UserCommonDTO {  
    fun insertDefaultValuesInErrorLocation() {  
        try {  
            locationDto.lat = if (locationDto.lat.isNullOrBlank()) "128" else locationDto.lat  
            locationDto.lon = if (locationDto.lon.isNullOrBlank()) "36" else locationDto.lon  
        } catch (e: Exception) {  
            log.error("GEO-004 :  좌표 설정 에러 [ userId : $userId, lat : ${locationDto.lat}, lon : ${locationDto.lon} ] : $e")  
            throw CommonException("GEO-004", HttpStatus.BAD_REQUEST)  
        }  
    }  
  
    fun storeLocationPoint(aGeometry: Geometry) {  
        try {  
            geometryRepository.insertPosLoc(locationDto.lat!!, locationDto.lon!!, aGeometry.id!!)  
        } catch (e: Exception) {  
            log.error("GEO-003 : SQL 위치정보 포인트(point) 실패 : $e")  
            throw CommonException("GEO-003", HttpStatus.BAD_REQUEST)  
        }  
    }  
  
    val anUser = userRecycleFn.checkActiveUser(userId)  
  
    insertDefaultValuesInErrorLocation()  
  
    if (anUser.geometry != null) {  
        try {  
            anUser.geometry!!.updateGeometry(locationDto)  
        } catch (e: Exception) {  
            log.error("GEO-001 : SQL 유저 위치정보 재저장 실패  [ userId : $userId ] : $e")  
            throw CommonException("GEO-001", HttpStatus.BAD_REQUEST)  
        }  
        storeLocationPoint(anUser.geometry!!)  
    } else {  
        val aGeometry = try {  
            geometryRepository.save(modelMapper.map(locationDto, Geometry::class.java))  
        } catch (e: Exception) {  
            log.error("GEO-001 : SQL 유저 위치정보 저장 실패  [ userId : $userId ] : $e")  
            throw CommonException("GEO-001", HttpStatus.BAD_REQUEST)  
        }  
  
        storeLocationPoint(aGeometry)  
  
        try {  
            anUser.addGeometry(aGeometry)  
        } catch (e: Exception) {  
            log.error("USER-013 : SQL 유저 지역정보 저장 실패 : $e")  
            throw CommonException("USER-013", HttpStatus.BAD_REQUEST)  
        }  
    }  
  
    val result = try {  
        UserCommonDTO.ModelMapper.entityToDto(anUser)  
    } catch (e: Exception) {  
        log.error("USER-005 : UserCommonDTO mapping 실패  :$e")  
        throw CommonException("USER-005", HttpStatus.BAD_REQUEST)  
    }  
  
    log.info("유저 위치 저장 : [ 유저uid : ${result.id} , 시/도 : ${locationDto.sido}, 시/군/구 : ${locationDto.sigungu}, 동 : ${locationDto.dong}]")  
  
    return result  
}
```

<br>

### 변경 후

```kotlin
fun registerUserLocation(locationDto: LocationDTO, userId: String): UserCommonDTO {  
    val anUser = userRecycleFn.checkActiveUser(userId)  
  
    insertDefaultValuesInErrorLocation(locationDto)  
  
    if (anUser.geometry != null) {  
        updateGeometryAndStoreLocationPoint(anUser.geometry!!, locationDto, userId)  
    } else {  
        val aGeometry = saveGeometryAndStoreLocationPoint(locationDto, userId)  
        addGeometryToUser(anUser, aGeometry, userId)  
    }  
  
    val result = mapUserToUserCommonDTO(anUser)  
    log.info("유저 위치 저장 : [ 유저uid : ${result.id} , 시/도 : ${locationDto.sido}, 시/군/구 : ${locationDto.sigungu}, 동 : ${locationDto.dong}]")  
  
    return result  
}  
  
private fun insertDefaultValuesInErrorLocation(locationDto: LocationDTO) {  
    try {  
        locationDto.lat = locationDto.lat?.takeIf { it.isNotBlank() } ?: "128"  
        locationDto.lon = locationDto.lon?.takeIf { it.isNotBlank() } ?: "36"  
    } catch (e: Exception) {  
        log.error("GEO-004 : 좌표 설정 에러 [ userId : ${locationDto.userId}, lat : ${locationDto.lat}, lon : ${locationDto.lon} ] : $e")  
        throw CommonException("GEO-004", HttpStatus.BAD_REQUEST)  
    }  
}  

private fun storeLocationPoint(aGeometry: Geometry) {  
    try {  
        geometryRepository.insertPosLoc(locationDto.lat!!, locationDto.lon!!, aGeometry.id!!)  
    } catch (e: Exception) {  
        log.error("GEO-003 : SQL 위치정보 포인트(point) 실패 : $e")  
        throw CommonException("GEO-003", HttpStatus.BAD_REQUEST)  
    }
  
private fun updateGeometryAndStoreLocationPoint(geometry: Geometry, locationDto: LocationDTO, userId: String) {  
    try {  
        geometry.updateGeometry(locationDto)  
    } catch (e: Exception) {  
        log.error("GEO-001 : SQL 유저 위치정보 재저장 실패  [ userId : $userId ] : $e")  
        throw CommonException("GEO-001", HttpStatus.BAD_REQUEST)  
    }  
    storeLocationPoint(geometry)  
}  
  
private fun saveGeometryAndStoreLocationPoint(locationDto: LocationDTO, userId: String): Geometry {  
    val aGeometry = try {  
        geometryRepository.save(modelMapper.map(locationDto, Geometry::class.java))  
    } catch (e: Exception) {  
        log.error("GEO-001 : SQL 유저 위치정보 저장 실패  [ userId : $userId ] : $e")  
        throw CommonException("GEO-001", HttpStatus.BAD_REQUEST)  
    }  
  
    storeLocationPoint(aGeometry)  
    return aGeometry  
}  
  
private fun addGeometryToUser(user: User, geometry: Geometry, userId: String) {  
    try {  
        user.addGeometry(geometry)  
    } catch (e: Exception) {  
        log.error("USER-013 : SQL 유저 지역정보 저장 실패 : $e")  
        throw CommonException("USER-013", HttpStatus.BAD_REQUEST)  
    }  
}  
  
private fun mapUserToUserCommonDTO(user: User): UserCommonDTO {  
    return try {  
        UserCommonDTO.ModelMapper.entityToDto(user)  
    } catch (e: Exception) {  
        log.error("USER-005 : UserCommonDTO mapping 실패  :$e")  
        throw CommonException("USER-005", HttpStatus.BAD_REQUEST)  
    }  
}
```
