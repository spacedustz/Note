## Mac Settings

설치 프로그램
- Karabiner - 키보드 매핑
- Aldente - 배터리 충전 제한
- Macs fan control - CPU 온도 조절
- Docker
- MySQL & WorkBench
- XCode
- Android Studio
- IntelliJ
- VSCode
- Obsidian
- Discord
- Postman
- Github DeskTop
- JDK, Flutter SDK, Dart SDK
- Git

---

## **맥 키보드 설정**

control -> 지구본
option -> option
command -> control
지구본 -> command

---

## **jdk & Git 설치**

brew search idk

sudo softwareupdate --install-rosetta

brew install adoptopenjdk/openjdk/adoptopenjdk11

<br>

brew install Git

---

## Home Brew 설치

- /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
- (echo; echo 'eval "$(/opt/homebrew/bin/brewshellenv)"' >> /Users/{유저네임}/.zprofile)
- eval "$(/opt/homebrew/bin/brew shellenv)"
- brew --version

---

## Terminal 꾸미기

iTerm2 설치
- brew install iterm2

<br>

ob-my-zsh 설치
- sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

<br>

### iTerm 꾸미기

iTerm Status Bar 설정
- iTerm - Setting - Profiles - Session - Status Bar Enabled 체크 - Configure Status Bar 진입 - 원하는 상태바 아래로 드래그 - Appearance 탭에서 상태바 위치 선택

<br>

테마 설정
- https://iterm2colorschemes.com/ 원하는 테마 선택
- 선택해서 나온 텍스트 저장 -> 확장자 .itermcolors 로 변경
- iTerm - Profiles - Color - Import - 다운받은거 선택 - 적용

<br>

### Oh-My-Zsh 꾸미기

테마 설정
- vi ~/.zshrc
- ZSH-THEME= 부분 찾아서 "agnoster" 입력 후 저장
- source ~/.zshrc
- (폰트 변경) git clone https://github.com/powerline/fonts.git
- cd fonts
- ./install.sh
- iTerm - Profile - Text - Font -> Ubuntu Mono derivative PowerlineRegular로 변경

<br>

### Terminal Prompt 꾸미기

```bash
echo export TERM="xterm-color" >> ~/.zshrc
echo export CLICOLOR=1 >> ~/.zshrc
echo export LSCOLORS=ExFxCxDxBxegedabagacad >> ~/.zshrc
echo export PROMPT="%F{cyan}%n%f@%F{green}%m:%F{yellow}%~$%f" >> ~/.zshrc
source ~/.zshrc
```
<br>

**이모지를 활용한 프롬프트**
```
prompt_context() { emojis=("🌙" "🚀" "🔥" "🚦" "⚡️" "😎" "👑" "🌈" "🐵" "🦄" "🐸" "🍻" "💡" "🎉" "🔑") RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} + 1)) prompt_segment black default "{사용자이름} ${emojis[$RAND_EMOJI_N]} " }
```

<br>

**터미널 컴퓨터 이름 안나오게 하기**
```
prompt_context() {
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
      prompt_segment black default "%(!.%{%F{yellow}%}.)$USER" 
    fi 
}
```

---

## Jenkins 설치

```bash
# Jenkins 설치
brew install jenkins

# 초기 비밀번호 확인
cd && cat .jenkins/secrets/initialAdminPassword

# Jenkins 디렉터리 위치 학인
ls -l `which jenkins`

# Jenkins 외부 IP 접근 허용 - httpListenAddress 값을 127.0.0.1 -> 0.0.0.0 으로 변경
# httpPort 부분도 원하는 포트로 변경해줍니다.
vi /opt/homebrew/Cellar/jenkins/2.407/homebrew.mxcl.jenkins.plist

#macOS 포트 오픈
sudo chmod 777 /etc/pf.conf

pass in proto tcp from any to any port 18080 /etc/pf.conf
pass in proto tcp from any to any port 22 /etc/pf.conf
pass in proto tcp from any to any port 8080 /etc/pf.conf
pass in proto tcp from any to any port 443 /etc/pf.conf
pass in proto tcp from any to any port 50000 /etc/pf.conf
pass in proto tcp from any to any port 5000 /etc/pf.conf
pass in proto tcp from any to any port 4444 /etc/pf.conf
pass in proto tcp from any to any port 80 /etc/pf.conf

sudo chmod 644 /etc/pf.conf

# JDK 전역 변수 등록
echo export JAVA_HOME=/opt/homebrew/Cellar/openjdk@11/11.0.19/libexec/openjdk.jdk/Contents/Home >> ~/.zshrc

# 포트 적용 확인
sudo pfctl -vnf /etc/pf.conf

# Jenkins 시작
brew services start jenkins

```