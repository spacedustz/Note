## 이미지 업로드

이미지를 업로드 하는 방식들에 대한 설명

- Front 단에서의 업로드
- Back 단에서의 업로드

---

## Front 단에서의 업로드

- Front 단에서 AWS 같은 클라우드 서비스에 직접 전송
  - 보안상 권장 X

---

## Back 단에서의 업로드

- 업로드 파일에 대한 검증 가능



### Multi-Part-Form 전송을 통한 파일 업로드 방식

- 가장 기본적인 방식
- MultipartFile 데이터를 입력으로 받는다,

<br>

### 파일의 바이너리 데이터를 Base64 인코딩해서 전송

- 아주 작은 사이즈의 파일에 사용 가능
- 파일 검증 시, base64를 다시 인코딩 해야 함
- Json 형태로 Request Body를 보내기에 용이하다.
- Smile Data Format 같은 Binary Json Format을 이용하면, 전송 사이즈 및 속도를 향상 시킬 수 있다.

<br>

### Web Socket 이나 Web RTC 같은 양방향 프로토콜을 이용하 전송

- 채팅 서비스 같은 양방향 통신 서비스에서 사용하기 용이하다.

---

## 업로드 된 파일의 저장 유형

1. 싱글 백엔드 서버의 로컬 디렉터리에 저장
2. Backend -> Remote Storage에 저장
3. Backend -> Cloud Service에 저장 (S3 등)

---

## 그 외

- 파일 자체를 바이너리 형태로 DB에 저장할 수도 있다.
  - BLOB, CLOB 타입
- 일반적을 물리적인 파일은 스토리지 서버에 저장
- 블록체인의 경우, IPFS(블록체인 전용 스토리지) 사용
- **파일의 메타 정보(파일명, 저장경로, 사이즈 등) 저장 방식**
  - 일반적으로 DB에 저장
  - 파일의 소유권이 중요하다면 블록체인에 저장

---

## Multi-Part-Form Data 파일 업로드

- https://github.com/codestates-seb/be-reference-file-upload

---

for (file in files) {

1. val tempFile = File.createTempFile(System.getProperty("java.io.tmpdir") + System.getProperty("file.separator") + files[0].originalFilename, "")

2. file.transferTo(tempFile)

3. var bufferedStream = BufferedInputStream(tempFile.inputStream())
파일의 내용을 읽기 위해 버퍼링된 입력 스트림 생성

4. var extension = FileTypeDetector.detectFileType(bufferedStream) , 타입 검증
파일의 MIME타입 식별, 파일에 실제 유형에 대한 정보를 얻을 수 있음

5. var fileName = UUID + extension.commonExtention
파일 확장자를 파일 이름에 추가

6. var metaData = ObjectMetadata = ObjectMetadata()
ObjectMetadata 객체 생성, 이 객체는 S3에 업로드되는 파일의 메타데이터를 나타냄

7. metaData.contentLength = tempFile.length()
metaData 객체의 contentLength 속성에 tempFile의 길이를 할당함, 업로드되는 파일의 크기를 나타낸다

8. metaData.contentType = extension.mimeType
metaData 객체의 contentType 속성에 extension의 MIME 타입을 할당함, 업로드되는 파일의 컨텐츠 타입을 나타냄

}