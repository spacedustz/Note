## Windows Terminal 꾸미기

- Oh-My-Posh 다운로드
- 테마 파일 위치 : `$HOME > Appdata > Local > Programs > oh-my-posh > themes`
- 테마 구경 :  [https://ohmyposh.dev/docs/themes](https://ohmyposh.dev/docs/themes)

```shell
winget install oh-my-posh
winget install JanDeDobbeleer.OhMyPosh
```

<br>

> **테마 변경**

- 개인적으로 `1_shell`을 선택함

```shell
cd C:\Users\root\AppData\Local\Programs\oh-my-posh\themes
notepad 1_shell.omp.json
oh-my-posh init powershell --config 
```