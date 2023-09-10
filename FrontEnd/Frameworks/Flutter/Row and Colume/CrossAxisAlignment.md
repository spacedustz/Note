## Row & Column (CrossAxisAlignment)

이번엔 CrossAxisAlignment에 대해 학습합니다.

저번에 MainAxisAlignment에 대해 배웠는데, 이 기능은 주축 정렬이었습니다.

반대로 CrossAxisAlignment는 반대축 정렬의 기능을 가집니다.

<br>

MainAxisAlignment 같은 경우 Row일때는 가로 정렬, Column일때는 세로정렬입니다.

CrossAxisAlignment는 정확히 그 반대입니다. Row는 세로 Column일때는 가로입니다.

<br>

여기서 문제점은 반대축을 정렬하기 위해 상위 Container의 가로축인 검정색 배경 부분을 늘려야 합니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/splash6.png)

<br>

상위 Container의 검은색 배경을 늘리기 위해 위젯 코드를 변경해 보겠습니다.

```dart
import 'package:flutter/material.dart';  
  
class HomeScreen extends StatelessWidget {  
  const HomeScreen({Key? key}) : super(key: key);  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      body: SafeArea(  
        bottom: false,  
        child: Container(  
          color: Colors.black,  
          width: MediaQuery.of(context).size.width, // 이 부분
          child: Column(  
            mainAxisAlignment: MainAxisAlignment.spaceAround,  
            crossAxisAlignment: CrossAxisAlignment.center,  
            children: [  
              Container(  
                color: Colors.red,  
                width: 50.0,  
                height: 50.0,  
              ),  
              Container(  
                color: Colors.orange,  
                width: 50.0,  
                height: 50.0,  
              ),  
              Container(  
                color: Colors.yellow,  
                width: 50.0,  
                height: 50.0,  
              ),  
              Container(  
                color: Colors.green,  
                width: 50.0,  
                height: 50.0,  
              ),  
            ],  
          ),  
        ),  
      ),  
    );  
  }  
}
```

코드의 맨 처음 Container에 width로 MediaQuery.of()를 사용해 검정 배경을 늘려주었습니다.

<br>

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/splash7.png)

<br>

MediaQuery.of(context).size에 대해서는 나중에 배울것이며 지금은 그냥 시뮬레이터의 화면 사이즈를 가져오는 것 정도만 알아둡시다.

<br>

이제 다시 CrossAxisAlignment로 돌아와서 본격적으로 적용을 해보겠습니다.

CrossAxisAlingment의 속성은 다음과 같습니다.

- values
- center
- start
- stretch
- baseline
- end

<br>

start를 하면 MainAxis와 마찬가지로 화면의 좌측 상단 시작 지점으로 컨테이너들이 이동합니다.

end를 주면 상위 Container의 가로 끝 부분인 우측 상단으로 정렬이 됩니다.

center로 주면 상단 중앙에 위치하게 되며 **CrossAxis의 기본값**입니다.

start, end, center는 굳이 사진을 첨부 안하더라도 알 것입니다.

<br>

이제 stretch 옵션을 적용해 보겠습니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/splash8.png)

<br>

이 stretch 옵션을 적용하면 기존 하위 Container에 줬던 width 값인 50.0이 무시되고,

상위 Container의 CrossAxis의 width가 우선 적용되어 하위 Container의 width값이 무시되고

저렇게 나오는 것입니다.

즉, **하위 속성을 무시하고 화면의 최대한까지 늘린다**가 stretch 옵션의 기능입니다.