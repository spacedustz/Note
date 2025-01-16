## 환경별 Helm 설치


### 스크립트

이제 헬름은 헬름 최신 버전을 자동으로 가져와서 [로컬에 설치](https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3)하는 인스톨러 스크립트를 제공한다.

이 스크립트를 받아서 로컬에서 실행할 수 있다. 문서화가 잘 되어 있으므로 실행 전에 문서를 읽어보면 무엇을 하는 것인지 이해할 수 있을 것이다.

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh

./get_helm.sh

# 최신
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

---

### Mac (HomeBrew)

헬름 커뮤니티 멤버들은 Homebrew용 헬름 포뮬러 빌드에 기여해왔다. 이 포뮬러는 보통 최신이다.

```console
brew install helm
```

---

### Chocolatey

헬름 커뮤니티 멤버들은 [Chocolatey](https://chocolatey.org/)용 [헬름 패키지](https://chocolatey.org/packages/kubernetes-helm) 빌드에 기여해왔다. 이 패키지는 보통 최신이다.

```console
choco install kubernetes-helm
```

---

### Scoop (Windows)

헬름 커뮤니티 멤버들은 [Scoop](https://scoop.sh/)용 [헬름 패키지](https://github.com/ScoopInstaller/Main/blob/master/bucket/helm.json) 빌드에 기여해왔다. 이 패키지는 보통 최신이다.

```console
scoop install helm
```

---

### APT (Debian/Ubuntu)

헬름 커뮤니티 멤버들은 Apt용 [헬름 패키지](https://helm.baltorepo.com/stable/debian/)에 기여해왔다. 이 패키지는 보통 최신이다.

```bash
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

sudo apt-get install apt-transport-https --yes

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update

sudo apt-get install helm

```

---

### Dnf/Fedora/Yum

Fedora 35부터, 공식 저장소에서 헬름을 사용할 수 있다. 헬름을 호출하여 설치할 수 있다.

```bash
sudo dnf install helm
```

---

### Git

필요시에는 의존성을 Fetch하고 Cache하며 설정 유효성 검사를 하게된다.
그러고 나서 helm을 컴파일하여 /bin/helm에 둔다.

```bash
git clone https://github.com/helm/helm.git

cd helm

make
```

---
