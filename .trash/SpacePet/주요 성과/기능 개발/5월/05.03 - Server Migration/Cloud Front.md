## CloudFront 설정

CloudFront의 주요설정은 다음과 같다.

<br>

### Delivery Method 

RTMP와 WEB이 있다. 

HLS는 WEB 방식의 Delivery를 사용하기 때문에 값을 WEB으로 선택한다. 

<br>

### Origin Domain Name

CloudFront로 서비스 하고자 하는 S3 Bucket이름이다.

 클릭하면 select box가 나타난다.

<br>

### Origin Path 

S3 Bucket내의 DocumentRoot. S3 Bucket 내의 디렉토리 중 어느 위치를 해당 CloudFront의 /로 사용할 것인지를 나타낸다.

<br>

### Restricted Bucket Access 

S3에서 자체적으로 서비스를 하지 않고 CloudFront를 통해서만 서비스가 가능하도록 한다.

설정값은 Yes.

<br>

### Origin Access Identity 

S3 접근에 사용할 접근 정보. 

이미 기존에 만들어진 것이 있다면 기존 내용을 사용하면 된다.

 CloudFront의 좌측 하단 메뉴에서도 관리가 가능하다. 

설정 값은 Use Existing Identity.

<br>

### Grant Read Permissions on Bucket

Origin Access Identity가 S3에 접근 가능하도록 하기 위해서는 S3의 Policy를 업데이트 해야 한다. 

이것을 자동으로 해준다. 설정값은 Yes.

<br>

### Forward Header 

CORS가 정상적으로 적용되도록 하기 위해서는 Origin을 Forward해줘야 한다. 

설정 값은 WhiteList.

<br>

### Restricted Viewer Access 

Signed Cookie, Signed URL이 필요하도록 할 경우 Yes. 

Signed Cookie, Signed URL을 통해서만 접근이 가능하도록 할 경우 설정한다.