## Windows PowerShell 꾸미기

- Oh-My-Posh 다운로드
- 테마 파일 위치 : `$HOME > Appdata > Local > Programs > oh-my-posh > themes`
- 테마 구경 :  [https://ohmyposh.dev/docs/themes](https://ohmyposh.dev/docs/themes)

```shell
winget install oh-my-posh
winget install JanDeDobbeleer.OhMyPosh
```

<br>

> **테마 변경**

- 개인적으로 `di4am0nd` 테마를 선택함


**Power Shell (관리자 권한)에서 진행**
```shell
New-Item -Path $PROFILE -Type File -Force
notepad $PROFILE

# 이 명령어 삽입
oh-my-posh init powershell --config C:\Users\root\AppData\Local\Programs\oh-my-posh\themes\di4am0nd.omp.json | invoke-Expression

# 에러 뜰경우 아래 커맨드 실행
Set-ExecutionPolicy RemoteSigned
```

<br>

## CMD 꾸미기

터미널 -> 설정 -> Json 파일 열기

```json
    "profiles":
    {
        "defaults": {
          "colorScheme": "One Half Dark",
          "fontSize": 11,
          "useAcrylic": true, // 투명한 배경 사용 여부
          "acrylicOpacity": 0.6 // 불투명도(1에 가까워질수록 불투명함)
        },
```