## Hello World 앱 만들기

**runApp()** : 플러터의 진입 포인트

**MaterialApp()** : 어플리케이션의 시작

**Scaffold()** : 화면 정의, backgorundColor : 화면의 배경색 정의

**Center()** : 컨텐츠의 중앙 위치

**Text()** : 텍스트, TextStyle : 말그대로 텍스트 스타일

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    /* Scaffold - 페이지 작성, 어플리케이션 화면 - Body */
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Text(
        'Hello World',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      )),
    ),
  ));
}
```

<img src="https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/helloworld.png" alt="image-20230507180809962" style="zoom: 67%;" /> 

---

### **안드로이드 스튜디오에는 여러가지 버튼들이 있다.**

- **핫 리로드**는 가상 머신에 변경된 코드를 불러오고 위젯 트리를 재빌드한다. 이때 앱의 상태를 보존하기 때문에 `main()`이나 `initState()`를 재실행하지 않는다. (Intellij와 Android Studio에서는 ⌘\, VSCode에서는 ⌃F5)
- **핫 리스타트** 는 가상 머신에 변경된 코드를 불러오고 Flutter 앱을 재시작한다. 이때 앱의 상태는 잃어버린다. (Intellij와 Android Studio에서는 ⇧⌘\, VSCode에서는 ⇧⌘F5)
- **풀 리스타트**는 iOS, Android, Web 어플을 재시작한다. 이는 앞선 두가지보다 더 많은 시간을 필요로하는데 Java / Kotlin / ObjC / Swift 코드를 재 컴파일링 해야하기 때문이다. Web의 경우에는 Dart Development Compiler를 재시작하기까지 한다. 풀 리스타트에는 단축키는 따로 없어서 직접 앱을 멈췄다가 시작해야한다.

---

### Widget Tree

Widget이란 클래스의 일종이며, 위에서 봤던 Material, Scaffold, Center, Text 전부 위젯이다.

위젯 트리를 그려보면 아래와 같다.

![image-20230507180655798](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/widget.png) 

---