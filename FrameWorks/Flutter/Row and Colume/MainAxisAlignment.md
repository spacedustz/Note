## Row & Column (MainAxisAlignment)

저번에 Column Widght에 mainAxisAlignment의 Center 속성을 사용했었습니다.

ManAxisAlignment는 주축 정렬을 하는데 사용하는 위젯이었습니다.

이번엔 MainAxisAlignment의 모든 속성을 전부 사용해 보겠습니다.

<br>

저번에 만들었던 HomeScreen의 SafeArea코드에 적용해보겠습니다.

MainAxisAlignment의 속성을 Start로 두면 하위의 위젯들의 변동이 없습니다.

왜냐하면, 이미 주축이 시작부분으로 되어 있으니까요.

<br>

end로 하면 위젯들이 아래부터 채워질겁니다.

당연히 center로 설정을 하면 위젯들이 가운데로 올거고,

<br>

spaceBetween으로 설정한다면 1개의 Container마다 일정 간격을 두고 끝과 끝으로 배치됩니다.

이때의 간격은 모든 위젯들 사이의 간격이 동일하게 배치됩니다.

즉, 여백은 3곳 입니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/splash3.png)

<br>

spaceEvenly로 설정을 하면 끝과 끝을 여백으로 두고 컨테이너들이 일정한 간격을 유지합니다.

즉, 여백이 5곳 입니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/splash4.png)


<br>

이제 마지막으로 spaceAround로 설정을 하면 특이하게 변경이 됩니다.

spaceEvenly + 끝과 끝의 간격이 1/2로 줄어들게 됩니다.

![img](https://raw.githubusercontent.com/spacedustz/Obsidian-Image-Server/main/img/splash5.png)

---

## 정리

MainAxisAlignment의 모든 속성을 정리해 보겠습니다.

**start** : 주축을 시작지점으로 둔다.

**end** : 주축을 끝으로 둔다.

**center** : 주축을 가운데로 둔다.

**spaceBetween** : 위젯 사이의 간격이 동일하게 배치되며, 끝지점에서 위젯이 시작한다.

**spaceEvenly** : 위젯 사이의 간격이 동일하게 배치되며, 양 끝 지점이 여백으로 시작한다.

**spaceAround** : 위젯 사이의 간격이 동일하게 배치되며, 양 끝 지점이 여백으로 시작하되 그 공간이 Evenly의 1/2수준이다.

<br>

이 예시에서는 Column 위젯에 적용해봤지만, Row 위젯도 동일하게 적용됩니다.

<br>

### MainAxisSize

주축의 사이즈를 조절하는 기능입니다.

너무 간단해서 설명은 생략합니다 ㅋㅋ

