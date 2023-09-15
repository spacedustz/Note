## Row and Colume (Expanded & Flexible Widget)

Expanded와 Flexible 위젯은 무조건 **Colume이나 Row 위젯의 Children 에만 사용이 가능합니다.**

이전에 만들었던 HomeScreen의 하위 컨테이너에 Expanded를 적용해 보겠습니다.

```dart
Expanded(  
  child: Container(  
    color: Colors.red,  
    width: 50.0,  
    height: 50.0,  
  ),
```

<br>

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/splash9.png)

<br>

4개의 하위 컨테이너 중 맨위의 컨테이너에 적용해보니, 남은 여백을 전부 채워주는것을 볼 수 있습니다.

이번엔 2번째 컨테이너도 적용해 보겠습니다.

```dart
Expanded(  
  child: Container(  
    color: Colors.red,  
    width: 50.0,  
    height: 50.0,  
  ),  
),  
Expanded(  
  child: Container(  
    color: Colors.orange,  
    width: 50.0,  
    height: 50.0,  
  ),  
),
```

<br>

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/splash10.png)

<br>

4개의 컨테이너 중 2개를 적용하니 남은 여백을 서로 절반씩 나눠 차지합니다.

그리고 Expanded의 파라미터 중 flex가 있습니다.

이 flex의 기본값은 1이며 만약 맨위 빨간 컨테이너에 flex 값을 2를 준다면

빨강 2 : 주황 1 의 비율로 여백을 차지합니다.

<br>

이제 4개의 컨테이너를 모두 Expanded로 바꾸고나서 맨위의 1개만 Flexible로 바꿔 봅시다.

Flexible은 1 만큼의 flex를 차지하되, Container의 width, height의 값만큼 차지하고 남는 부분은 여백으로 두는 기능이 있습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/splash11.png)

<br>

위 사진을 보면 원래 컨테이너의 width, height 값인 50.0 만 차지하고,

남는 부분은 검은색 여백으로 버리는 것을 볼 수 있습니다.

Flexible의 flex 파라미터는 위와 동일하지만 flex 값이 커질수록 여백의 크기가 커진다는 차이점이 있습니다.

**그리고 큰 특징 중 하나는, Expanded가 아무리 커도 Flexible의 여백을 차지할 수 없습니다.**