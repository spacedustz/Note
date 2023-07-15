## Board Entity

```kotlin
/** @desc 돌봄 SOS 글 수정 */
fun modifyingCareTakeBoard(data: CareTakeDTO.Post) {
    this.requestContent = data.content
    this.preMeeting = data.take.preMeeting ?: false
    this.requestGender = data.take.neighborGender ?: ""
    this.requestAnimalUser = data.take.neighborAnimal ?: ""
    this.requestedAt = data.take.takeStartDate
    this.requestedAt02 = data.take.takeEndDate
    this.reword = data.take.reword
    this.modifiedAt = LocalDateTime.now()
}

/** @desc 품앗이 글 수정 */
fun modifyingCareGiveBoard(data: CareGiveDTO.Post) {
    this.requestContent = data.content
    this.requestSecondContent = data.give.requestHelpTime ?: ""
    this.preMeeting = data.give.preMeeting ?: false
    this.requestAnimalUser = data.give.animalKind ?: ""
    this.animalSize = data.give.animalSize
    this.animalNetralization = data.give.neutralization
    this.timeHelp = data.give.timeHelp?.toMutableList()
    this.modifiedAt = LocalDateTime.now()
}

/** 투데이펫 글 수정 */
fun modifyingTodayPetBoard(data: TodayPetDTO.Post) {
    this.requestContent = data.content
    this.modifiedAt = LocalDateTime.now()
}

/** 함께해요 글 수정 */
fun modifyingTogetherBoard(data: TogetherDTO.Post) {
    this.requestContent = data.content
    this.modifiedAt = LocalDateTime.now()
}

/** 돌봄 SOS 글 수정 */
fun modifyingAlertBoard(data: AlertDTO.Post) {
    /** @desc 실종 정보 */
    this.requestedAt = data.missingDate
    this.requestedAt02 = data.missingTime
    this.requestedLocation = data.missingLocation
    this.phoneNumber = data.userPhone ?: ""

    /** 반려동물 정보 */
    this.animalName = data.user.animalName
    this.requestAnimalUser = data.missingAnimalKind
    this.breed = data.missingAnimalBreed
    this.requestGender = data.user.animalGender ?: ""
    this.animalNetralization = data.user.animalNeutralization
    this.animalSize = data.user.animalSize
    this.animalBirth = data.missingAnimalBirth

    /** @desc 글 정보 */
    this.requestContent = data.detail.content ?: ""
    this.pics = data.detail.images
    this.modifiedAt = LocalDateTime.now()
}
```