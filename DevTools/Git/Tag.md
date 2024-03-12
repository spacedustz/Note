## Git Tag

Git의 태그는 Lightweight, Annotated 2가지가 있습니다.

Lightweight 태그는 브랜치와 비슷하지만, 브랜치처럼 가리키는 지점을 최신 커밋으로 이동시키지 않습니다.

단순히 특정 커밋에 대한 포인터일 뿐입니다.

<br>

Annotated 태그는 Git DB에 태그를 만든 사람의 이름, 이메일와 태그 생성 날짜, 태그 메시지도 저장합니다.

GPG 서명도 가능하며, 일반적으로 이 모든 정보를 사용할 수 있도록 하는것이 좋습니다.

즉, 이런 정보나 임시 생성 태그로 사용하려면 Lightweight 태그를 사용하는것을 권장합니다.

---
## Annotated Tag

Annotated Tag를 생성하는 법은 간단합니다.

`-a` 옵션을 사용해서 생성하고 이름을 적어둡니다.
`
`-m` 옵션을 사용해서 메시지도 함께 저장합니다.

```bash
git tag -a v1.0.0 -m "version 1.0.0"
```

<br>

태그의 정보를 보려면 `git show {태그명}`을 입력하면 됩니다.

---
## Lightweight Tag

Lightweight Tag는 기본적으로 파일에 커밋 Checksum을 저장하는 것 뿐입니다.

다른 정보는 저장하지 않습니다.

생성하는 방법은 `-a`나 `-m`  옵션 없이 그냥 `git tag 태그이름`으로 생성합니다.

---
## 나중에 태그하기

만약 특정 커밋에 태그를 못 달았다고 할 때, 나중에 태그를 붙일 수 있습니다.

사용법은 `git tag -a {tag-name} {checksum}` 으로 지정하면 됩니다.

`git tag -a v1.0.5 2f3t4`

---
## 태그 공유하기

git push를 할 때 Remote에 자동으로 태그 푸시를 전송하지 않습니다.

그러므로, 태그를 만들었으면 서버에 별도로 Push를 해야 합니다.

브랜치를 공유하는 것과 같은 방법으로 `git push origin {tag-name}` 으로 실행합니다.

<br>

한번에 태그를 여러개 Push 하고 싶으면 `git push origin --tags`를 사용하면,

remote에 없는 태그들이 전부 Push 됩니다.

---
## 태그 체크아웃하기

예를 들어 태그가 특정 버전을 가리키고 있고, 특정 버전의 파일을 체크아웃 + 확인하고 싶으면 다음과 같이 실행합니다.

단, 태그를 체크아웃하면 "detached HEAD (떨어져나온 HEAD)" 상태가 되며,

일부 Git 관련 작업이 브랜치에서 작업하는것과 다르게 동작할 수 있습니다.

```bash
git checkout v2.0.0
```

<br>

"detached HEAD (떨어져나온 HEAD)" 상태에서 작업 후 커밋을 만들면,

태그는 그대로 있고 새로운 커밋이 하나 쌓인 상태가 되며, 새 커밋에 도달할 방법이 없습니다.

물론 커밋의 해시 값을 정확히 기억하고 있으면 가능하겠지만, 특정 태그의 상태에서 새로 작성한 커밋이 Bug FIx와 같이

의미 있도록 하려면 브랜치를 만들어서 작업하는 것이 좋습니다.

```bash
git checkout -b version2 v2.0.0
```

이렇게 브랜치를 만든 후에 version2 브랜치에 커밋하면 브랜치는 업데이트 됩니다.

하지만, v2.0.0 태그는 가리키는 커밋이 변하지 않았으므로 두 내용이 가리키는 커밋이 다르게 됩니다.

---
## 사용법

```bash
# 브랜치에셔 변경사항을 발생시키고 커밋
git add .
git commit -m "메시지"

# 최근 커밋에 tag를 생성하면서 붙이기
git tag testtag HEAD -m "메시지"

# 태그 푸시
git push origin <tag-name>

# 로컬 브랜치 푸시
git push origin <branch-name>

# origin tag 지우기
git push origin :<tag-name>
```