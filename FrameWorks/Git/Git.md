## Git

---

### Git Pull

```bash
git remote remove origin
git remote add origin https://{Github-Name}:{Access-Key}@github.com/{Repo-Name}/{Project-Name}.git

git pull origin master
```

---

### Git Stash

Git Stash Rename

- git config --global alias.stash-rename '!_() { rev=$(git rev-parse $1) && git stash drop $1 || exit 1 ; git stash store -m "$2" $rev; }; _'
- Git stash-rename stash@{바꿀 stash 번호} 바꿀 이름
- git stash pop stash@{숫자}
- git stash save "지정할 이름"

---

### Branch

```bash
# 로컬 브랜치 생성
git branch -b 브랜치명

# 원격 브랜치 생성
git push origin 브랜치명

# 브랜치 삭제
git branch -d 브랜치명
# 브랜치 강제 삭제
git branch -D 브랜치명
# 원격 브랜치 삭제
git push origin :브랜치명
```

---

### Rebase

메인 브랜치의 변경사항을 다른 브랜치에 적용 시킬때 사용

Remote → Remote 일때만 사용함

Remote → Local 변경사항 적용은 Pull 사용

```bash
git checkout {현재 작업중인 브랜치 이름}
git rebase master
```

---

### Commit Author 일괄 변경

변경 전 user.name, user.email 전역 설정 하고 아래 명령어 입력

- 한번에 변경

```bash
git filter-branch --env-filter '

OLD_EMAIL="replicaset01@github.com"
OLD_EMAIL2="replicaset02@github.com"
CORRECT_NAME="spacedustz"
CORRECT_EMAIL="cyberspecterr@github.com"

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL2"]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
```

기록 삭제

```bash
git update-ref -d refs/original/refs/heads/master

git log --pretty=format:"[%h] %cd - Committer: %cn (%ce), Author: %an (%ae)"
```

수정된 커밋 내역 Push

```bash
git push --force --tags origin 'refs/heads/*'
```

만약 특정 브랜치만 적용하고 싶으면 아래와 같이 푸시

```bash
git push --force --tags origin 'refs/heads/develop'
```

---

### Conflict

```
<<<<<<< Updated Upstream

이 사이에 있는 코드는 업데이트된 Main 브랜치의 코드

=======

이 사이에 있는 건 내가 Stash Pop한 코드

>> Stashed Changes
```

